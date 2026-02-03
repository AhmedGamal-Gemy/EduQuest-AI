"""
Tool execution callbacks.
"""
from typing import Optional
from inspect_web.handlers.logger import logger
from inspect_web.session.scan_session import ScanSession
from inspect_web.handlers.log_utils import format_tool_result, FULL_LOG_TOOLS

def before_tool_callback(
    tool,
    args: dict,
    tool_context,
) -> Optional[dict]:
    """
    Validate tool calls before execution to catch LLM hallucinations.
    Uses agent_kit for hallucination detection.
    Also tracks start time for execution timing.
    """
    import time
    
    try:
        tool_name = getattr(tool, 'name', str(tool)) if tool else 'unknown'
        
        # Store start time for timing (use tool_context state if available)
        try:
            if hasattr(tool_context, 'state') and tool_context.state is not None:
                tool_context.state['_tool_start_time'] = time.time()
                tool_context.state['_tool_name'] = tool_name
        except Exception:
            pass
        
        # Use agent_kit's hallucination detection via our wrapper
        from inspect_web.handlers.hallucination_buster import (
            correct_hallucination, 
            extract_tool_call_from_json, 
            get_valid_tools
        )
        from agent_kit.hallucination import is_hallucinated_name
        
        # Check if tool name is valid or looks hallucinated
        valid_tools = get_valid_tools()
        if tool_name not in valid_tools and is_hallucinated_name(tool_name):
            # Try to extract/correct the tool name
            corrected_name = None
            extracted_args = {}
            
            # First try JSON extraction (preserves args)
            extracted_name, extracted_args = extract_tool_call_from_json(tool_name)
            if extracted_name and extracted_name in valid_tools:
                corrected_name = extracted_name
            else:
                # Fall back to agent_kit correction
                corrected_name = correct_hallucination(tool_name)
                if corrected_name not in valid_tools:
                    corrected_name = None
            
            # Build helpful error message
            if corrected_name:
                error_msg = (
                    f"❌ INVALID TOOL NAME. You called '{tool_name[:50]}...' "
                    f"Did you mean: `{corrected_name}`? Retry with the correct name."
                )
                if extracted_args:
                    import json
                    error_msg += f" Args: {json.dumps(extracted_args)}"
            else:
                error_msg = (
                    f"❌ INVALID TOOL NAME. '{tool_name[:50]}...' is not a valid tool. "
                    f"Available: {', '.join(list(valid_tools)[:8])}..."
                )
            
            logger.bind(author="system").error(f"🚫 Tool Hallucination: {error_msg}")
            return {"error": error_msg, "status": "rejected", "hallucination_detected": True, "suggested_tool": corrected_name}
        
        # Log tool call with args
        agent_name = "system"
        try:
            if hasattr(tool_context, 'agent_name'):
                agent_name = tool_context.agent_name or "system"
        except Exception:
            pass
        
        # Valid tool call - allow it to proceed
        return None
        
    except Exception as e:
        logger.bind(author="system").warning(f"Error in before_tool_callback: {e}")
        return None  # Allow on error to not block valid calls


def after_tool_callback(
    tool,
    args: dict,
    tool_context,
    tool_response,
) -> Optional[dict]:
    """
    Log tool results and execution timing after tool completion.
    """
    import time
    
    try:
        tool_name = getattr(tool, 'name', str(tool)) if tool else 'unknown'
        
        # Calculate execution time
        execution_time = None
        try:
            if hasattr(tool_context, 'state') and tool_context.state is not None:
                start_time = tool_context.state.get('_tool_start_time')
                if start_time:
                    execution_time = time.time() - start_time
        except Exception:
            pass
        
        # Get agent name
        agent_name = "system"
        try:
            if hasattr(tool_context, 'agent_name'):
                agent_name = tool_context.agent_name or "system"
        except Exception:
            pass
        
        agent_log = logger.bind(author=agent_name)
        
        # Log timing
        if execution_time is not None:
            agent_log.debug(f"⏱️ {tool_name} completed in {execution_time:.2f}s")
        
        # =========================================================================
        # TOOL RESPONSE TRUNCATION
        # =========================================================================
        MAX_RESPONSE_CHARS = 50000 
        VERBOSE_TOOLS = {'browser_snapshot', 'browser_network_requests', 'browser_console_messages', 'fuzz_directories'}
        
        truncated_response = tool_response
        try:
            if tool_name in VERBOSE_TOOLS and tool_response:
                response_str = str(tool_response)
                if len(response_str) > MAX_RESPONSE_CHARS:
                    # Truncate and add indicator
                    if isinstance(tool_response, dict):
                        truncated_response = {
                            **tool_response,
                            '_truncated': True,
                            '_original_length': len(response_str),
                            'content': str(tool_response.get('content', ''))[:MAX_RESPONSE_CHARS] + '... [TRUNCATED]'
                        }
                    elif isinstance(tool_response, str):
                        truncated_response = response_str[:MAX_RESPONSE_CHARS] + '... [TRUNCATED]'
                    
                    agent_log.debug(
                        f"📉 Tool response truncated: {len(response_str)} → {MAX_RESPONSE_CHARS} chars"
                    )
        except Exception as e:
            agent_log.debug(f"Response truncation error (non-blocking): {e}")
        
        # Log result based on tool type
        if tool_name in FULL_LOG_TOOLS:
            try:
                result_lines = format_tool_result(tool_name, tool_response, args)
                for line in result_lines:
                    agent_log.debug(line)
            except Exception as e:
                agent_log.debug(f"📋 {tool_name} result: (format error: {e})")
        
        # Check for errors in response
        if isinstance(tool_response, dict):
            if 'error' in tool_response:
                error = tool_response.get('error', 'Unknown error')
                agent_log.warning(f"⚠️ {tool_name} error: {error}")
                
                # Log to session
                session = ScanSession.get_current()
                if session:
                    session.log_error(f"{tool_name}: {error}", agent_name)
        
        # EVIDENCE CAPTURE
        # =========================================================================
        if tool_name == 'browser_take_screenshot':
            _handle_screenshot_capture(tool_response, agent_log)
        
        # Return truncated response if we modified it
        if truncated_response is not tool_response:
            return truncated_response
        return None
        
    except Exception as e:
        logger.bind(author="system").warning(f"Error in after_tool_callback: {e}")
        return None

def _handle_screenshot_capture(tool_response, agent_log):
    """Refactored screenshot handling logic."""
    try:
        session = ScanSession.get_current()
        if session:
            # Try to extract file path from response
            screenshot_path = None
            base64_data = None
            
            if isinstance(tool_response, dict):
                # Check common response formats
                screenshot_path = tool_response.get('path') or tool_response.get('file')
                
                # Check in content array (MCP format)
                content = tool_response.get('content', [])
                if isinstance(content, list):
                    for item in content:
                        if isinstance(item, dict):
                            # Check for text path
                            text = item.get('text', '')
                            if text:
                                import re
                                # Improved regex to find paths ending in .png
                                path_match = re.search(r'(?:^|[\s"\'=])([a-zA-Z]:[\\/][a-zA-Z0-9_\-\.\\]+\.png|/[a-zA-Z0-9_\-\./]+\.png)', text, re.I)
                                
                                if path_match:
                                    screenshot_path = path_match.group(1).strip()
                                    agent_log.debug(f"🔍 Found screenshot path via regex 1: {screenshot_path}")
                                    break
                                    
                                # Fallback
                                match = re.search(r'(?:saved to|path|as)[:\s]+([^\s\n"\'`)]+\.png)', text, re.I)
                                if match:
                                    screenshot_path = match.group(1).strip()
                                    agent_log.debug(f"🔍 Found screenshot path via regex 2: {screenshot_path}")
                                    break
                            
                            # Check for base64 image data
                            if item.get('type') == 'image' and item.get('data'):
                                base64_data = item.get('data')
                                agent_log.debug(f"🔍 Found base64 screenshot data")
                                break
                
                # Debug log if we couldn't find a path
                if not screenshot_path and not base64_data:
                    agent_log.debug(f"🔍 Could not extract screenshot path from response: {str(tool_response)[:200]}...")
            
            if screenshot_path:
                saved_path = session.save_evidence(screenshot_path)
                if saved_path:
                    agent_log.info(f"📸 Evidence saved: {saved_path.name}")
                else:
                    agent_log.error(f"❌ Failed to save evidence from path: {screenshot_path} (File may not exist)")
            elif base64_data:
                # Handle base64 data
                import base64
                import tempfile
                import os
                
                try:
                    with tempfile.NamedTemporaryFile(delete=False, suffix=".png", mode="wb") as tmp:
                        tmp.write(base64.b64decode(base64_data))
                        temp_path = tmp.name
                    
                    saved_path = session.save_evidence(temp_path)
                    
                    try:
                        os.unlink(temp_path)
                    except Exception:
                        pass
                        
                    if saved_path:
                        agent_log.info(f"📸 Evidence saved from base64: {saved_path.name}")
                except Exception as e:
                    agent_log.error(f"Failed to process base64 screenshot: {e}")
                    
            elif session.pending_evidence:
                agent_log.debug("📸 Screenshot captured (path not in response, check .playwright-mcp/)")
                session.pending_evidence = None
    except Exception as e:
        agent_log.debug(f"Evidence capture error: {e}")
