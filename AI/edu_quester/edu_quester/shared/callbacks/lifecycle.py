"""
Lifecycle callbacks for Agent execution (Start/End).
"""
from google.adk.agents.callback_context import CallbackContext
from inspect_web.handlers.log_utils import get_emoji
from inspect_web.handlers.logger import logger
from inspect_web.handlers.model_utils import (
    _safe_get_attr,
    default_model_info,
    extract_model_from_context,
    extract_thinking_config,
    model_tracker,
    parse_model_string,
)
from inspect_web.session.scan_session import ScanSession


def before_agent_callback(callback_context: CallbackContext) -> None:
    """Called before agent starts processing."""
    agent_name = "Unknown"

    try:
        agent_name = _safe_get_attr(callback_context, 'agent_name', 'Unknown') or 'Unknown'
        emoji = get_emoji(agent_name)

        # Try to extract model from context (might not be available yet)
        model_string = extract_model_from_context(callback_context)
        thinking_info = extract_thinking_config(callback_context)

        if model_string:
            model_info = parse_model_string(model_string)
        else:
            model_info = default_model_info()

        model_info.update(thinking_info)
        model_tracker.set(agent_name, model_info)

        # Get or create session
        session = ScanSession.get_current()

        if not session:
            try:
                state = _safe_get_attr(callback_context, 'state', {}) or {}
                target_url = state.get("target_url", "unknown") if isinstance(state, dict) else "unknown"
                scan_type = state.get("scan_type", "pentest") if isinstance(state, dict) else "pentest"

                session = ScanSession(target_url=target_url, scan_type=scan_type)

                if hasattr(callback_context, 'state') and isinstance(callback_context.state, dict):
                    callback_context.state["log_session_id"] = session.trace_id

                try:
                    logger.start_scan_logging(session.log_file)
                except Exception:
                    pass

                logger.bind(author="system").debug(f"📁 Scan logging started: {session.log_file}")
                logger.bind(author="system").info(f"🆕 Session started: {session.trace_id[:8]}")
                logger.bind(author="system").info(f"📂 Session dir: {session.session_dir}")
            except Exception as e:
                logger.bind(author="system").warning(f"Could not create session: {e}")

        # DON'T write header yet - wait for model detection
        # Just register agent with session
        if session:
            session.register_agent_model(agent_name, model_info)

        # Detailed log
        agent_log = logger.bind(author=agent_name)
        session_id = session.trace_id[:8] if session else "no-session"
        agent_log.info(f"{emoji} Agent starting | Session: {session_id}")

        if model_tracker.is_detected(agent_name):
            agent_log.info(f"   🤖 Provider: {model_info.get('provider_display', 'Unknown')}")
            agent_log.info(f"   📦 Model: {model_info.get('model', 'unknown')} ({model_info.get('model_display', 'Unknown')})")
        else:
            agent_log.debug("   🤖 Model: Pending detection...")

        if model_info.get('thinking_enabled'):
            agent_log.info(f"   🧠 Thinking: Enabled (budget: {model_info.get('thinking_budget', 0)} tokens)")

    except Exception as e:
        try:
            logger.bind(author="system").error(f"Error in before_agent_callback: {e}")
        except Exception:
            pass

    return None


def after_agent_callback(callback_context: CallbackContext) -> None:
    """Called after agent completes."""
    try:
        agent_name = _safe_get_attr(callback_context, 'agent_name', 'Unknown') or 'Unknown'
        emoji = get_emoji(agent_name)

        session = ScanSession.get_current()
        session_id = session.trace_id[:8] if session else "no-session"

        model_info = model_tracker.get(agent_name)
        model_display = model_info.get('model_display', 'Unknown')

        logger.bind(author=agent_name).info(
            f"{emoji} Agent completed | Session: {session_id} | Model: {model_display}"
        )

        if session:
            session.log_agent_complete(agent_name)

    except Exception as e:
        try:
            logger.bind(author="system").error(f"Error in after_agent_callback: {e}")
        except Exception:
            pass

    return None
