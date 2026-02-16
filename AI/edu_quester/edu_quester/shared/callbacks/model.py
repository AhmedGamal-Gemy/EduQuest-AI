"""
Model execution callbacks (LLM Request/Response).
"""

from google.adk.agents.callback_context import CallbackContext
from google.adk.models import LlmRequest, LlmResponse

# Import Hallucination Buster
from inspect_web.handlers.hallucination_buster import (
    correct_hallucination,
    extract_tool_call_from_json,
    get_valid_tools,
)
from inspect_web.handlers.log_utils import (
    _debug_log,
    extract_parts_safe,
    get_emoji,
    log_part_safe,
)
from inspect_web.handlers.logger import logger
from inspect_web.handlers.model_utils import (
    _safe_get_attr,
    extract_model_from_request,
    model_tracker,
)
from inspect_web.session.scan_session import ScanSession
from inspect_web.utils.rate_limiter import rate_limiter


def before_model_callback(
    callback_context: CallbackContext,
    llm_request: LlmRequest
) -> LlmResponse | None:
    """Called before LLM request - detect model and enforce rate limiting."""
    agent_name = "Unknown"

    try:
        agent_name = _safe_get_attr(callback_context, 'agent_name', 'Unknown') or 'Unknown'
        agent_log = logger.bind(author=agent_name)
        session = ScanSession.get_current()


        # RATE LIMITING
        try:
            wait_time = rate_limiter.wait_if_needed()
            if wait_time > 0.1:
                agent_log.debug(f"⏳ Rate limit: waited {wait_time:.2f}s before LLM request")
        except Exception as e:
            agent_log.debug(f"Rate limiter error (non-blocking): {e}")

        # CONTEXT TRUNCATION (with Mistral message ordering awareness)
        try:
            contents = _safe_get_attr(llm_request, 'contents')
            if contents and isinstance(contents, list):
                # Configuration from settings
                from inspect_web.config import settings as Config
                MAX_MESSAGES = Config.MAX_CONTEXT_MESSAGES
                MIN_MESSAGES_TO_TRUNCATE = Config.MIN_MESSAGES_TO_TRUNCATE

                num_messages = len(contents)

                if num_messages > MIN_MESSAGES_TO_TRUNCATE:
                    first_message = contents[0]

                    # Calculate the cut point
                    cut_index = num_messages - (MAX_MESSAGES - 1)

                    # Mistral requires: user → assistant → tool sequence
                    # We need to find a safe cut point that doesn't leave orphaned tool results
                    # A safe cut point is right before a 'user' message

                    # Scan forward from cut_index to find a 'user' message
                    safe_cut_index = cut_index
                    for i in range(cut_index, min(cut_index + 5, num_messages)):
                        msg = contents[i]
                        msg_role = None
                        if hasattr(msg, 'role'):
                            msg_role = str(msg.role).lower() if msg.role else None
                        elif isinstance(msg, dict):
                            msg_role = msg.get('role', '').lower()

                        if msg_role == 'user':
                            safe_cut_index = i
                            break

                    recent_messages = contents[safe_cut_index:]

                    # Mutate the list in place
                    llm_request.contents = [first_message] + recent_messages

                    final_count = len(llm_request.contents)
                    removed_count = num_messages - final_count
                    agent_log.warning(
                        f"📉 Context truncated: {num_messages} → {final_count} messages "
                        f"(removed {removed_count} old messages, cut at safe 'user' boundary)"
                    )
        except Exception as e:
            agent_log.debug(f"Context truncation error (non-blocking): {e}")

        # =====================================================================
        # MISTRAL MESSAGE ORDERING FIX (ALWAYS runs)
        # Mistral requires: user → assistant(tool_call) → tool(result)
        # It cannot handle user → tool directly.
        #
        # ROOT CAUSE (confirmed via research):
        # When ADK's AgentTool invokes a sub-agent, the parent's conversation
        # history gets passed down. Tool results from the PARENT appear after
        # the "user" message (the AgentTool invocation) in the CHILD's context.
        #
        # Solution: Skip these orphaned tool results. They're from the parent's
        # context and not relevant to the child agent's execution.
        # =====================================================================
        try:
            contents = _safe_get_attr(llm_request, 'contents')
            if contents and isinstance(contents, list) and len(contents) > 1:
                fixed_contents = []
                skipped_count = 0
                skipped_tools = []
                prev_role = None

                for msg in contents:
                    # Get role from message
                    msg_role = None
                    if hasattr(msg, 'role'):
                        msg_role = str(msg.role).lower() if msg.role else None
                    elif isinstance(msg, dict):
                        msg_role = msg.get('role', '').lower()

                    # Check if this message contains tool/function responses
                    is_tool_result = False
                    tool_name = None
                    parts = _safe_get_attr(msg, 'parts', []) or []
                    if not parts and isinstance(msg, dict):
                        parts = msg.get('parts', [])
                    for part in parts:
                        func_resp = None
                        if hasattr(part, 'function_response'):
                            func_resp = part.function_response
                        elif isinstance(part, dict) and 'function_response' in part:
                            func_resp = part.get('function_response')
                        if func_resp:
                            is_tool_result = True
                            # Get tool name for logging
                            if hasattr(func_resp, 'name'):
                                tool_name = func_resp.name
                            elif isinstance(func_resp, dict):
                                tool_name = func_resp.get('name', 'unknown')
                            break

                    # Mistral error: "Unexpected role 'tool' after role 'user'"
                    # Skip tool messages that come directly after user messages
                    if is_tool_result and prev_role == 'user':
                        skipped_count += 1
                        if tool_name:
                            skipped_tools.append(tool_name)
                        continue  # Skip this message

                    fixed_contents.append(msg)
                    # Track role for next iteration
                    if msg_role:
                        prev_role = msg_role
                    elif is_tool_result:
                        prev_role = 'tool'

                if skipped_count > 0:
                    llm_request.contents = fixed_contents
                    tools_info = f" ({', '.join(skipped_tools[:3])}{'...' if len(skipped_tools) > 3 else ''})" if skipped_tools else ""
                    agent_log.warning(
                        f"🔧 Mistral fix: Skipped {skipped_count} parent-context tool result(s){tools_info}"
                    )
        except Exception as e:
            agent_log.debug(f"Message ordering fix error (non-blocking): {e}")

        # =====================================================================
        # MISTRAL FUNCTION CALL/RESPONSE PAIRING FIX (AGGRESSIVE)
        # Error: "Not the same number of function calls and responses"
        #
        # ROOT CAUSE (discovered via debugging):
        # When Commander calls SQLiAgent multiple times, each AgentTool invocation
        # returns a function_response. But the NEXT LLM call sees all previous
        # function_calls from earlier turns without their responses in immediate
        # adjacent messages. Mistral requires strict 1:1 pairing.
        #
        # SOLUTION: For each function_call, we must either:
        # 1. Have a function_response in the IMMEDIATELY following message, OR
        # 2. Remove the orphaned function_call message entirely
        #
        # This is aggressive but necessary for Mistral compatibility.
        # =====================================================================
        try:
            contents = _safe_get_attr(llm_request, 'contents')
            if contents and isinstance(contents, list) and len(contents) > 2:
                # Pass 1: Build a map of function calls and their responses
                # Function calls are in assistant messages, responses in tool messages
                call_to_response = {}  # call_idx -> response_idx
                response_to_call = {}  # response_idx -> call_idx

                # Track function calls by their index and name
                call_info = {}  # idx -> {names: [...], ids: [...]}
                response_info = {}  # idx -> {names: [...], ids: [...]}

                for idx, msg in enumerate(contents):
                    parts = _safe_get_attr(msg, 'parts', []) or []
                    if not parts and isinstance(msg, dict):
                        parts = msg.get('parts', [])

                    call_names = []
                    call_ids = []
                    resp_names = []
                    resp_ids = []

                    for part in parts:
                        # Check for function_call in assistant messages
                        func_call = None
                        if hasattr(part, 'function_call'):
                            func_call = part.function_call
                        elif isinstance(part, dict) and 'function_call' in part:
                            func_call = part.get('function_call')

                        if func_call:
                            name = getattr(func_call, 'name', None)
                            if not name and isinstance(func_call, dict):
                                name = func_call.get('name')
                            call_id = getattr(func_call, 'id', None)
                            if not call_id and isinstance(func_call, dict):
                                call_id = func_call.get('id')
                            if name:
                                call_names.append(name)
                            if call_id:
                                call_ids.append(call_id)

                        # Check for function_response in tool messages
                        func_resp = None
                        if hasattr(part, 'function_response'):
                            func_resp = part.function_response
                        elif isinstance(part, dict) and 'function_response' in part:
                            func_resp = part.get('function_response')

                        if func_resp:
                            name = getattr(func_resp, 'name', None)
                            if not name and isinstance(func_resp, dict):
                                name = func_resp.get('name')
                            resp_id = getattr(func_resp, 'id', None)
                            if not resp_id and isinstance(func_resp, dict):
                                resp_id = func_resp.get('id')
                            if name:
                                resp_names.append(name)
                            if resp_id:
                                resp_ids.append(resp_id)

                    if call_names or call_ids:
                        call_info[idx] = {'names': call_names, 'ids': call_ids}
                    if resp_names or resp_ids:
                        response_info[idx] = {'names': resp_names, 'ids': resp_ids}

                # Pass 2: Match calls to responses (response should be at idx+1 ideally, or nearby)
                for call_idx, ci in call_info.items():
                    # Look for response in next few messages
                    found_response = False
                    for offset in range(1, 3):  # Check next 2 messages
                        resp_idx = call_idx + offset
                        if resp_idx in response_info:
                            ri = response_info[resp_idx]
                            # Match by ID first, then by name
                            if ci['ids'] and ri['ids']:
                                if set(ci['ids']) & set(ri['ids']):  # Any overlap
                                    found_response = True
                                    call_to_response[call_idx] = resp_idx
                                    response_to_call[resp_idx] = call_idx
                                    break
                            elif ci['names'] and ri['names']:
                                if set(ci['names']) & set(ri['names']):  # Any overlap
                                    # found_response = True

                                    call_to_response[call_idx] = resp_idx
                                    response_to_call[resp_idx] = call_idx
                                    break

                # Pass 3: Remove orphaned calls and their responses (except the most recent pair)
                # Keep only messages that are:
                # - Not function calls without responses
                # - Not function responses without calls
                # - Or are the most recent pending call (we're about to respond to it)

                indices_to_remove = set()

                # Find orphaned calls (no response found)
                orphaned_calls = [idx for idx in call_info.keys() if idx not in call_to_response]
                # Find orphaned responses (no call found)
                orphaned_responses = [idx for idx in response_info.keys() if idx not in response_to_call]

                # Keep the LAST orphaned call (it's the one we're responding to now)
                if orphaned_calls:
                    last_orphan_call = max(orphaned_calls)
                    for oc in orphaned_calls:
                        if oc != last_orphan_call:
                            indices_to_remove.add(oc)

                # Remove all orphaned responses
                indices_to_remove.update(orphaned_responses)

                if indices_to_remove:
                    new_contents = [msg for idx, msg in enumerate(contents) if idx not in indices_to_remove]
                    llm_request.contents = new_contents
                    agent_log.warning(
                        f"🔧 Mistral aggressive fix: Removed {len(indices_to_remove)} orphaned messages "
                        f"(calls: {len([i for i in indices_to_remove if i in call_info])}, "
                        f"responses: {len([i for i in indices_to_remove if i in response_info])})"
                    )
        except Exception as e:
            agent_log.debug(f"Function call pairing fix error (non-blocking): {e}")

        # =====================================================================
        # MISTRAL TOOL_CALL ID GENERATION
        # Error: "Tool call id has to be defined" / "Input should be a valid string"
        #
        # Mistral requires ALL function_calls to have a valid ID:
        # - Exactly 9 characters (per Mistral spec)
        # - Alphanumeric only (a-z, A-Z, 0-9)
        #
        # ADK's google.genai types DON'T have ID fields - they're only added
        # during LiteLLM's conversion. But LiteLLM isn't generating them properly.
        #
        # Solution: Generate compliant 9-char alphanumeric IDs for any function_call
        # missing an ID. This matches LiteLLM's MistralWrapper pattern.
        # =====================================================================
        try:
            import random
            import string

            contents = _safe_get_attr(llm_request, 'contents')
            if contents and isinstance(contents, list):

                def generate_mistral_id():
                    """Generate a Mistral-compliant 9-character alphanumeric ID"""
                    chars = string.ascii_letters + string.digits  # a-z, A-Z, 0-9
                    return ''.join(random.choices(chars, k=9))

                def is_valid_mistral_id(call_id):
                    """Check if ID meets Mistral's requirements"""
                    if not call_id or not isinstance(call_id, str):
                        return False
                    import re
                    return bool(re.match(r'^[a-zA-Z0-9]{9}$', call_id))

                fixed_count = 0

                for msg in contents:
                    parts = _safe_get_attr(msg, 'parts', []) or []
                    if not parts and isinstance(msg, dict):
                        parts = msg.get('parts', [])

                    for part in parts:
                        func_call = None
                        if hasattr(part, 'function_call'):
                            func_call = part.function_call
                        elif isinstance(part, dict) and 'function_call' in part:
                            func_call = part.get('function_call')

                        if func_call:
                            # Check current ID
                            call_id = None
                            if hasattr(func_call, 'id'):
                                call_id = func_call.id
                            elif isinstance(func_call, dict):
                                call_id = func_call.get('id')

                            if not is_valid_mistral_id(call_id):
                                new_id = generate_mistral_id()
                                try:
                                    # Try to set ID on the object
                                    if isinstance(func_call, dict):
                                        func_call['id'] = new_id
                                        fixed_count += 1
                                    elif hasattr(func_call, '__dict__'):
                                        func_call.__dict__['id'] = new_id
                                        fixed_count += 1
                                    elif hasattr(func_call, 'id'):
                                        # Some frozen objects allow attribute setting
                                        object.__setattr__(func_call, 'id', new_id)
                                        fixed_count += 1
                                except (AttributeError, TypeError):
                                    # Object is truly immutable, log and continue
                                    agent_log.debug("Cannot set ID on immutable function_call object")

                if fixed_count > 0:
                    agent_log.warning(
                        f"🔧 Mistral fix: Generated {fixed_count} compliant 9-char tool_call ID(s)"
                    )
        except Exception as e:
            agent_log.debug(f"Tool call ID generation error (non-blocking): {e}")

        # =====================================================================
        # MISTRAL FUNCTION_RESPONSE ID SYNCHRONIZATION
        # Error: "Unexpected tool call id None in tool results"
        #
        # When function_responses have None IDs, we need to match them to their
        # corresponding function_calls and copy the ID. We match by name since
        # the ID is generated after the original call was made.
        # =====================================================================
        try:
            contents = _safe_get_attr(llm_request, 'contents')
            if contents and isinstance(contents, list):
                # Phase 1: Build maps for ID tracking
                # - call_name_to_id: for syncing responses that have None ID
                # - all_call_ids: for detecting orphaned responses with unknown IDs
                call_name_to_id = {}
                all_call_ids = set()  # Track ALL function_call IDs in the context

                for msg in contents:
                    parts = _safe_get_attr(msg, 'parts', []) or []
                    if not parts and isinstance(msg, dict):
                        parts = msg.get('parts', [])

                    for part in parts:
                        func_call = None
                        if hasattr(part, 'function_call'):
                            func_call = part.function_call
                        elif isinstance(part, dict) and 'function_call' in part:
                            func_call = part.get('function_call')

                        if func_call:
                            call_name = getattr(func_call, 'name', None)
                            if not call_name and isinstance(func_call, dict):
                                call_name = func_call.get('name')

                            call_id = getattr(func_call, 'id', None)
                            if not call_id and isinstance(func_call, dict):
                                call_id = func_call.get('id')

                            if call_id:
                                all_call_ids.add(call_id)  # Track ALL IDs
                            if call_name and call_id:
                                call_name_to_id[call_name] = call_id  # For response sync

                # Also collect all response IDs for diagnostic
                all_response_ids = set()
                for msg in contents:
                    parts = _safe_get_attr(msg, 'parts', []) or []
                    if not parts and isinstance(msg, dict):
                        parts = msg.get('parts', [])
                    for part in parts:
                        func_resp = None
                        if hasattr(part, 'function_response'):
                            func_resp = part.function_response
                        elif isinstance(part, dict) and 'function_response' in part:
                            func_resp = part.get('function_response')
                        if func_resp:
                            resp_id = getattr(func_resp, 'id', None)
                            if not resp_id and isinstance(func_resp, dict):
                                resp_id = func_resp.get('id')
                            if resp_id:
                                all_response_ids.add(resp_id)

                # Find orphaned response IDs (IDs in responses but not in calls)
                orphaned_ids = all_response_ids - all_call_ids
                if orphaned_ids:
                    agent_log.error("� MISTRAL ID MISMATCH DETECTED!")
                    agent_log.error(f"   Call IDs:     {sorted(all_call_ids)[:5]}... ({len(all_call_ids)} total)")
                    agent_log.error(f"   Response IDs: {sorted(all_response_ids)[:5]}... ({len(all_response_ids)} total)")
                    agent_log.error(f"   Orphaned:     {orphaned_ids}")
                else:
                    agent_log.debug(f"📋 IDs OK: {len(all_call_ids)} calls, {len(all_response_ids)} responses, no orphans")

                # Phase 2: Fix function_responses with None IDs
                fixed_response_count = 0
                for msg in contents:
                    parts = _safe_get_attr(msg, 'parts', []) or []
                    if not parts and isinstance(msg, dict):
                        parts = msg.get('parts', [])

                    for part in parts:
                        func_resp = None
                        if hasattr(part, 'function_response'):
                            func_resp = part.function_response
                        elif isinstance(part, dict) and 'function_response' in part:
                            func_resp = part.get('function_response')

                        if func_resp:
                            resp_id = getattr(func_resp, 'id', None)
                            if not resp_id and isinstance(func_resp, dict):
                                resp_id = func_resp.get('id')

                            # If ID is None, try to find matching call by name
                            if not resp_id:
                                resp_name = getattr(func_resp, 'name', None)
                                if not resp_name and isinstance(func_resp, dict):
                                    resp_name = func_resp.get('name')

                                if resp_name and resp_name in call_name_to_id:
                                    new_id = call_name_to_id[resp_name]
                                    try:
                                        if isinstance(func_resp, dict):
                                            func_resp['id'] = new_id
                                            fixed_response_count += 1
                                        elif hasattr(func_resp, '__dict__'):
                                            func_resp.__dict__['id'] = new_id
                                            fixed_response_count += 1
                                    except (AttributeError, TypeError):
                                        pass

                if fixed_response_count > 0:
                    agent_log.warning(
                        f"🔧 Mistral fix: Synchronized {fixed_response_count} function_response ID(s)"
                    )

                # Phase 3: REPAIR orphaned responses (IDs not in any function_call)
                # Strategy: Try to find a function_call with the SAME NAME and use its ID
                # Only remove if we can't find ANY matching call (truly orphaned)
                # This preserves context while fixing "Unexpected tool call id X" errors
                repaired_count = 0
                removed_count = 0

                for msg in contents:
                    parts = _safe_get_attr(msg, 'parts', []) or []
                    if not parts and isinstance(msg, dict):
                        parts = msg.get('parts', [])

                    parts_to_remove = []
                    for i, part in enumerate(parts):
                        func_resp = None
                        if hasattr(part, 'function_response'):
                            func_resp = part.function_response
                        elif isinstance(part, dict) and 'function_response' in part:
                            func_resp = part.get('function_response')

                        if func_resp:
                            resp_id = getattr(func_resp, 'id', None)
                            if not resp_id and isinstance(func_resp, dict):
                                resp_id = func_resp.get('id')

                            resp_name = getattr(func_resp, 'name', None)
                            if not resp_name and isinstance(func_resp, dict):
                                resp_name = func_resp.get('name')

                            # If response has an ID that's not in known calls
                            if resp_id and resp_id not in all_call_ids:
                                # Try to REPAIR by finding a call with the same name
                                if resp_name and resp_name in call_name_to_id:
                                    # Found a matching call - update the response ID
                                    new_id = call_name_to_id[resp_name]
                                    try:
                                        if isinstance(func_resp, dict):
                                            func_resp['id'] = new_id
                                            repaired_count += 1
                                            agent_log.info(f"🔧 Repaired response ID: {resp_name} ({resp_id} → {new_id})")
                                        elif hasattr(func_resp, '__dict__'):
                                            func_resp.__dict__['id'] = new_id
                                            repaired_count += 1
                                            agent_log.info(f"🔧 Repaired response ID: {resp_name} ({resp_id} → {new_id})")
                                    except (AttributeError, TypeError):
                                        # Can't repair, mark for removal
                                        parts_to_remove.append(i)
                                        agent_log.warning(f"🗑️ Orphan (can't repair): {resp_name} with ID {resp_id}")
                                else:
                                    # No matching call found - truly orphaned, remove
                                    parts_to_remove.append(i)
                                    agent_log.warning(f"🗑️ Orphan (no matching call): {resp_name} with ID {resp_id}")

                    # Remove truly orphaned parts (in reverse order to preserve indices)
                    if parts_to_remove:
                        if isinstance(parts, list):
                            for idx in sorted(parts_to_remove, reverse=True):
                                try:
                                    parts.pop(idx)
                                    removed_count += 1
                                except Exception:
                                    pass

                if repaired_count > 0:
                    agent_log.success(f"🔧 Mistral fix: Repaired {repaired_count} orphaned response ID(s) (context preserved)")
                if removed_count > 0:
                    agent_log.warning(f"�️ Mistral fix: Removed {removed_count} truly orphaned response(s) (no matching call)")
        except Exception as e:
            agent_log.debug(f"Function response ID sync error (non-blocking): {e}")

        # Try to detect model from request
        model_string = extract_model_from_request(llm_request)

        if model_string and model_tracker.update_if_better(agent_name, model_string):
            model_info = model_tracker.get(agent_name)

            # Update session with detected model
            if session:
                session.register_agent_model(agent_name, model_info)

            agent_log.info(f"   🔍 Model detected: {model_info.get('provider_display', 'Unknown')} / {model_info.get('model_display', 'Unknown')}")

        # NOW write the agent header to markdown (with model info)
        if session and not model_tracker.is_header_written(agent_name):
            model_info = model_tracker.get(agent_name)
            session.log_agent_start_with_model(agent_name, model_info)
            model_tracker.mark_header_written(agent_name)

        # Log request info
        model_info = model_tracker.get(agent_name)
        num_messages = len(llm_request.contents) if _safe_get_attr(llm_request, 'contents') else 0

        agent_log.info(
            f"   📤 LLM Request going out | Messages: {num_messages}"
        )

    except Exception as e:
        try:
            logger.bind(author="system").error(f"Error in before_model_callback: {e}")
        except Exception:
            pass

    return None


def after_model_callback(
    callback_context: CallbackContext,
    llm_response: LlmResponse
) -> LlmResponse:
    """Called after LLM response - validate function calls and log content."""

    agent_name = "Unknown"
    # Try multiple ways to get agent name from context
    try:
        if hasattr(callback_context, 'agent_name') and callback_context.agent_name:
            agent_name = callback_context.agent_name
        elif hasattr(callback_context, 'agent') and callback_context.agent:
            agent_name = getattr(callback_context.agent, 'name', None) or "Unknown"
        elif hasattr(callback_context, 'state') and callback_context.state:
            state = callback_context.state
            if isinstance(state, dict):
                agent_name = state.get('_current_agent', state.get('agent_name', 'Unknown'))
    except Exception:
        pass

    agent_log = logger.bind(author=agent_name)

    # =====================================================================
    # SET AGENT CONTEXT for per-agent tool validation
    # This allows the hallucination buster to validate against the CURRENT
    # agent's tools, not just the global list.
    # =====================================================================
    try:
        from agent_kit.hallucination import clear_agent_context, set_agent_context

        # Try to get the agent's actual tools
        agent_tools_names = set()
        if hasattr(callback_context, 'agent') and callback_context.agent:
            agent = callback_context.agent
            # Get tools from agent
            if hasattr(agent, 'tools') and agent.tools:
                for tool in agent.tools:
                    if hasattr(tool, 'name'):
                        agent_tools_names.add(tool.name)
                    elif callable(tool) and hasattr(tool, '__name__'):
                        agent_tools_names.add(tool.__name__)
            # Also get sub-agents as tools
            if hasattr(agent, 'sub_agents') and agent.sub_agents:
                for sub_agent in agent.sub_agents:
                    if hasattr(sub_agent, 'name'):
                        agent_tools_names.add(sub_agent.name)

        if agent_tools_names:
            set_agent_context(agent_name, agent_tools_names)
            agent_log.debug(f"🎯 Agent context set: {len(agent_tools_names)} tools for {agent_name}")
    except Exception as e:
        agent_log.debug(f"Agent context setup failed (using global tools): {e}")

    # Log the raw text response (thinking)
    text_content = _safe_get_attr(llm_response, 'text')
    if text_content:
        agent_log.info(f"🧠 {agent_name} Thinking:\n{text_content[:500]}...")

    # =====================================================================
    # EMPTY RESPONSE DETECTION AND RECOVERY
    # Error: "model output must contain either output text or tool calls"
    # This happens when the LLM returns nothing (often after confusion/rejection)
    # Solution: Inject a helpful message to prompt the model to try again
    # =====================================================================
    try:
        content = _safe_get_attr(llm_response, 'content')
        has_text = False
        has_function_call = False

        if content:
            parts = _safe_get_attr(content, 'parts', []) or []
            for part in parts:
                if _safe_get_attr(part, 'text'):
                    has_text = True
                if _safe_get_attr(part, 'function_call'):
                    has_function_call = True

        if not has_text and not has_function_call:
            agent_log.warning("⚠️ EMPTY RESPONSE DETECTED - injecting recovery message")

            # Get available tools for this agent
            valid_tools = get_valid_tools()
            tools_preview = ', '.join(list(valid_tools)[:8])

            # Inject a helpful text response
            from google.genai import types as genai_types
            recovery_text = (
                f"I need to take an action. Let me review my available tools: {tools_preview}... "
                f"I will call one of these tools to proceed with the task."
            )

            new_part = genai_types.Part(text=recovery_text)
            new_content = genai_types.Content(
                role='model',
                parts=[new_part]
            )
            llm_response.content = new_content

            agent_log.info("🔧 Injected recovery message to prevent empty response error")
    except Exception as e:
        agent_log.debug(f"Empty response detection error (non-blocking): {e}")

    # =====================================================================
    # TEXT TOOL CALL DETECTION
    # Detect when the LLM writes tool calls as text instead of executing them
    # =====================================================================
    try:
        content = _safe_get_attr(llm_response, 'content')
        if content:
            parts = _safe_get_attr(content, 'parts', []) or []
            has_actual_function_call = False
            text_tool_calls_detected = []

            for part in parts:
                # Check if there's an actual function call
                if _safe_get_attr(part, 'function_call'):
                    has_actual_function_call = True

                # Check text content for tool call patterns
                text = _safe_get_attr(part, 'text', '')
                if text:
                    import re

                    # AUTO-DETECT: Build patterns from all valid tools
                    valid_tools = get_valid_tools()

                    # Match any valid tool name followed by parentheses
                    # Pattern: tool_name( ... ) - handles multi-line args and nested parens
                    for tool_name in valid_tools:
                        # Escape any special regex chars in tool name
                        escaped_name = re.escape(tool_name)
                        # Match tool_name followed by ( and anything until closing )
                        # Use non-greedy match and allow for nested content
                        pattern = rf'{escaped_name}\s*\([^)]*\)'
                        matches = re.findall(pattern, text)
                        if matches:
                            text_tool_calls_detected.extend(matches[:2])  # Limit to 2 per tool

            # If we detected text tool calls but no actual function calls, TRY TO INJECT THEM
            if text_tool_calls_detected and not has_actual_function_call:
                preview = ', '.join(text_tool_calls_detected[:3])
                agent_log.warning(
                    f"⚠️ TEXT TOOL CALLS DETECTED (attempting injection): {preview}"
                )

                # Try to parse and inject function calls
                injected_calls = []
                from google.genai import types as genai_types

                for text_call in text_tool_calls_detected[:3]:  # Limit to first 3
                    try:
                        # Parse tool_name(args)
                        match = re.match(r'(\w+)\s*\(([^)]*)\)', text_call)
                        if match:
                            tool_name = match.group(1)
                            args_str = match.group(2)

                            # Parse arguments - handle key=value format
                            args_dict = {}
                            if args_str.strip():
                                # Handle keyword arguments like key="value" or key='value'
                                arg_pattern = r'(\w+)\s*=\s*(?:"([^"]*)"|\'([^\']*)\'|(\[[^\]]*\])|(\{[^}]*\})|([^,\s]+))'
                                for arg_match in re.finditer(arg_pattern, args_str):
                                    key = arg_match.group(1)
                                    # Get the captured value (one of the groups will match)
                                    value = arg_match.group(2) or arg_match.group(3) or arg_match.group(4) or arg_match.group(5) or arg_match.group(6)
                                    if value:
                                        # Try to parse as JSON for lists/dicts
                                        try:
                                            import json
                                            args_dict[key] = json.loads(value)
                                        except (json.JSONDecodeError, TypeError):
                                            args_dict[key] = value

                            # Check if this is a valid tool
                            valid_tools = get_valid_tools()
                            if tool_name in valid_tools:
                                # Create a FunctionCall and inject it
                                func_call = genai_types.FunctionCall(
                                    name=tool_name,
                                    args=args_dict
                                )
                                injected_calls.append(func_call)
                                agent_log.success(f"✅ INJECTED: {tool_name}({list(args_dict.keys())})")
                            else:
                                agent_log.warning(f"⚠️ Tool '{tool_name}' not in valid tools, skipping injection")
                    except Exception as parse_error:
                        agent_log.debug(f"Failed to parse text call '{text_call[:50]}': {parse_error}")

                # If we successfully parsed any calls, inject them into the response
                if injected_calls:
                    try:
                        # Get or create content parts
                        content = _safe_get_attr(llm_response, 'content')
                        if content:
                            existing_parts = list(_safe_get_attr(content, 'parts', []) or [])

                            # Add new FunctionCall parts
                            for func_call in injected_calls:
                                new_part = genai_types.Part(function_call=func_call)
                                existing_parts.append(new_part)

                            # Create new content with injected calls
                            new_content = genai_types.Content(
                                role=content.role if hasattr(content, 'role') else 'model',
                                parts=existing_parts
                            )
                            llm_response.content = new_content

                            agent_log.success(
                                f"🛡️ HALLUCINATION BUSTER: Injected {len(injected_calls)} function call(s) from text"
                            )
                    except Exception as inject_error:
                        agent_log.error(f"Failed to inject function calls: {inject_error}")
                else:
                    # Log to session for tracking
                    session = ScanSession.get_current()
                    if session:
                        session.log_error(
                            f"Text tool calls detected but injection failed: {preview}",
                            agent_name
                        )
    except Exception as e:
        logger.bind(author="system").debug(f"Text tool detection error: {e}")

    # =========================================================================
    # HALLUCINATION BUSTER - Fix invalid tool calls using agent_kit
    # FunctionCall objects are IMMUTABLE (frozen Pydantic models), so we must
    # create NEW objects and rebuild the entire Content.
    # =========================================================================
    content = _safe_get_attr(llm_response, 'content')

    if content:
        parts = list(_safe_get_attr(content, 'parts', []) or [])
        corrections_needed = []  # Track which parts need replacement

        for idx, part in enumerate(parts):
            function_call = _safe_get_attr(part, 'function_call')
            if function_call:
                original_name = _safe_get_attr(function_call, 'name', '')
                original_args = dict(function_call.args) if hasattr(function_call, 'args') and function_call.args else {}

                # Check if tool name is valid
                if original_name and original_name not in get_valid_tools():
                    agent_log.warning(f"⚠️ DETECTED INVALID TOOL: '{original_name[:100]}...'")

                    # Try to extract from JSON first (preserves args)
                    extracted_name, extracted_args = extract_tool_call_from_json(original_name)

                    if extracted_name and extracted_name in get_valid_tools():
                        corrected_name = extracted_name
                        corrected_args = extracted_args
                        agent_log.info(f"✅ EXTRACTED FROM JSON: '{original_name[:50]}...' -> '{corrected_name}' with args: {list(corrected_args.keys())}")
                    else:
                        # Fall back to heuristic/LLM correction via agent_kit
                        corrected_name = correct_hallucination(original_name)
                        corrected_args = original_args

                        if corrected_name == original_name or corrected_name not in get_valid_tools():
                            agent_log.error(f"❌ Could not correct hallucinated tool: '{original_name[:50]}...'")
                            continue

                        agent_log.info(f"✅ CORRECTED via agent_kit: '{original_name[:50]}...' -> '{corrected_name}'")

                    # Store correction info for later
                    corrections_needed.append({
                        'part_idx': idx,
                        'corrected_name': corrected_name,
                        'corrected_args': corrected_args,
                        'original_id': getattr(function_call, 'id', None),
                    })

        # Apply corrections by creating NEW FunctionCall objects (immutable-safe)
        if corrections_needed:
            from google.genai import types as genai_types

            new_parts = []
            corrections_applied = 0
            correction_map = {c['part_idx']: c for c in corrections_needed}

            for idx, part in enumerate(parts):
                if idx in correction_map:
                    # Create NEW FunctionCall with corrected name
                    # NOTE: google.genai.types.FunctionCall doesn't support 'id' parameter
                    # The ID will be generated/synchronized by before_model_callback
                    correction = correction_map[idx]
                    try:
                        new_func_call = genai_types.FunctionCall(
                            name=correction['corrected_name'],
                            args=correction['corrected_args'] or {},
                        )
                        # CRITICAL: Preserve the original ID to avoid Mistral ID mismatch
                        # "Unexpected tool call id X in tool results" error
                        orig_id = correction.get('original_id')
                        if orig_id:
                            try:
                                new_func_call.__dict__['id'] = orig_id
                                agent_log.debug(f"Preserved ID {orig_id} on corrected FunctionCall")
                            except (AttributeError, TypeError):
                                pass
                        # Create new Part with the corrected FunctionCall
                        new_part = genai_types.Part(function_call=new_func_call)
                        new_parts.append(new_part)
                        corrections_applied += 1
                        agent_log.debug(f"Created corrected FunctionCall: {correction['corrected_name']} (id={orig_id})")
                    except Exception as e:
                        agent_log.error(f"Failed to create corrected FunctionCall: {e}")
                        new_parts.append(part)  # Keep original on error
                else:
                    new_parts.append(part)

            # Rebuild Content with corrected parts
            if corrections_applied > 0:
                try:
                    new_content = genai_types.Content(
                        role=content.role if hasattr(content, 'role') else 'model',
                        parts=new_parts
                    )
                    llm_response.content = new_content
                    agent_log.success(f"🛡️ HALLUCINATION BUSTER: Replaced {corrections_applied} function call(s) with corrected versions")
                except Exception as e:
                    agent_log.error(f"Failed to rebuild Content: {e}")

    try:
        emoji = get_emoji(agent_name)
        session = ScanSession.get_current()

        # Ensure header is written (fallback)
        if session and not model_tracker.is_header_written(agent_name):
            model_info = model_tracker.get(agent_name)
            session.log_agent_start_with_model(agent_name, model_info)
            model_tracker.mark_header_written(agent_name)

        # Log token usage
        try:
            usage = _safe_get_attr(llm_response, 'usage_metadata')
            if usage:
                prompt_tokens = _safe_get_attr(usage, 'prompt_token_count', 0) or 0
                response_tokens = _safe_get_attr(usage, 'candidates_token_count', 0) or 0
                total_tokens = _safe_get_attr(usage, 'total_token_count', 0) or 0
                agent_log.debug(f"📊 Token Usage | Prompt: {prompt_tokens} | Response: {response_tokens} | Total: {total_tokens}")

                if session:
                    session.track_token_usage(prompt_tokens, response_tokens, total_tokens)
        except Exception:
            pass

        # Extract and log parts
        parts = extract_parts_safe(llm_response)

        for part in parts:
            try:
                log_part_safe(part, agent_log, emoji, session, agent_name)
            except Exception as e:
                _debug_log(agent_log, f"Error logging part: {e}")

    except Exception as e:
        try:
            logger.bind(author="system").error(f"Error in after_model_callback: {e}")
        except Exception:
            pass

    # Clean up agent context
    try:
        from agent_kit.hallucination import clear_agent_context
        clear_agent_context()
    except Exception:
        pass

    return llm_response

