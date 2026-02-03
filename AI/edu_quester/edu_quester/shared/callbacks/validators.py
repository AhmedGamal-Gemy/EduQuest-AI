"""
Validators for tool calls and names.
Uses agent_kit for hallucination detection.
"""

from inspect_web.handlers.hallucination_buster import get_valid_tools
from agent_kit.hallucination import is_hallucinated_name

# Re-use the VALID_TOOLS from hallucination_buster as the source of truth
def get_valid_tool_names():
    return get_valid_tools().union({
        'get_state', 'set_state',  # Internal state tools not always exposed to LLM
    })


def _is_valid_tool_name(name: str) -> bool:
    """Check if a tool name is valid (exists in our known tools)."""
    if not name or not isinstance(name, str):
        return False
    
    # Check against known tools
    if name in get_valid_tool_names():
        return True
    
    # Allow any tool that starts with known prefixes (for flexibility)
    valid_prefixes = ('browser_', 'save_', 'search_', 'get_', 'set_', 'test_')
    if any(name.startswith(p) for p in valid_prefixes):
        return True
    
    return False


def _is_hallucinated_tool(name: str) -> bool:
    """Check if a tool name is clearly a hallucination using agent_kit."""
    if not name or not isinstance(name, str):
        return True
    
    # If it's a known valid tool, it's not hallucinated
    if name in get_valid_tool_names():
        return False
    
    # Use agent_kit's detection
    return is_hallucinated_name(name)
