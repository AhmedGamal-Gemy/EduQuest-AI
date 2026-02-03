"""
Agent Factory - Creates agents with consistent configuration and logging.
"""

from typing import Callable
from typing import Union
from google.adk.agents import LlmAgent, BaseAgent, LoopAgent, SequentialAgent, ParallelAgent
from google.adk.planners import BuiltInPlanner, PlanReActPlanner
from google.adk.models.lite_llm import LiteLlm
from google.adk.tools import BaseTool

from google.genai import types
from typing import List, Type, Any
from pydantic import BaseModel

from ..constants import AgentTypes
from .callbacks import (
    before_agent_callback,
    after_agent_callback,
    before_model_callback,
    after_model_callback,
    before_tool_callback,
    after_tool_callback,
)

ToolType = Union[BaseTool, Callable]

def create_agent(
    agent_type: AgentTypes, 
    name: str,
    description: str,
    instruction: str,
    # Model config (only for LlmAgent)
    model: str = None,
    provider: str = None,
    # Schema config
    input_schema: Type[BaseModel] = None,
    output_schema: Type[BaseModel] = None,
    output_key: str = None,
    # Thinking/Planning
    thinking: bool = False,
    thinking_budget: int = 1024,
    # Sub-agents and tools
    sub_agents: List[BaseAgent] = None,
    tools: List[ToolType] = None,
    # Agent delegation control
    disallow_transfer_to_peers: bool = False,  # Prevent peer-to-peer delegation
    # Optional: custom callbacks (defaults to our logging callbacks)
    use_logging_callbacks: bool = True,
    custom_before_agent_callback = None,
    custom_after_agent_callback = None,
    custom_before_model_callback = None,
    custom_after_model_callback = None,
) -> BaseAgent:
    """
    Factory function to create agents with consistent configuration.
    
    Args:
        agent_type: Type of agent (LLM, PARALLEL, SEQUENTIAL, LOOP)
        name: Agent name
        description: Agent description
        instruction: Agent instruction/prompt
        model: Model name (e.g., 'gemini-2.5-flash', 'gpt-4o')
        provider: Provider name (e.g., 'google', 'openai') - optional for Google models
        input_schema: Pydantic model for input validation
        output_schema: Pydantic model for output validation
        output_key: Key to store output in state
        thinking: Enable thinking/reasoning mode
        thinking_budget: Token budget for thinking
        sub_agents: List of sub-agents
        tools: List of tools/functions
        use_logging_callbacks: Whether to use default logging callbacks
        custom_*_callback: Custom callback functions (override defaults)
    
    Returns:
        Configured agent instance
    """

    # -------------------------------------------------------------------------
    # Build model string
    # -------------------------------------------------------------------------
    model_string = None
    model_instance = None
    planner = None
    if model:
        if provider and provider.lower() not in ['google', 'gemini']:
            # For non-Google providers, use provider/model format
            model_string = f"{provider}/{model}"
            
            # Configure LiteLLM with retry logic for empty responses
            model_instance = LiteLlm(
                model=model_string,
                # Retry configuration for resilience
                num_retries=3,  # Retry up to 3 times on failure
                request_timeout=120,  # 2 minute timeout
            )
            
            # Use PlanReActPlanner for thinking mode with Mistral/other providers
            # NOTE: ReAct planner may output tool calls as text, but our
            # after_model_callback now has injection logic to parse and convert
            # text-based tool calls into actual FunctionCall objects.
            if thinking:
                planner = PlanReActPlanner()

        else:
            # For Google/Gemini, just use model name
            model_instance = model

            # -------------------------------------------------------------------------
            # Build planner if thinking is enabled
            # -------------------------------------------------------------------------

            if thinking:
                thinking_config = types.ThinkingConfig(
                    include_thoughts=False,   # Ask the model to include its thoughts in the response
                    thinking_budget=1024      # Limit the 'thinking' to 256 tokens (adjust as needed)
                )

                planner = BuiltInPlanner(
                    thinking_config=thinking_config
                )

        
        
    
    # -------------------------------------------------------------------------
    # Determine callbacks
    # -------------------------------------------------------------------------
    ba_callback = custom_before_agent_callback
    aa_callback = custom_after_agent_callback
    bm_callback = custom_before_model_callback
    am_callback = custom_after_model_callback
    
    if use_logging_callbacks:
        ba_callback = ba_callback or before_agent_callback
        aa_callback = aa_callback or after_agent_callback
        bm_callback = bm_callback or before_model_callback
        am_callback = am_callback or after_model_callback
    
    # -------------------------------------------------------------------------
    # Create agent based on type
    # -------------------------------------------------------------------------
    
    if agent_type == AgentTypes.LLM:
        if not model_instance:
            raise ValueError("LlmAgent requires a model")
        
        return LlmAgent(
            model=model_instance,
            name=name,
            description=description,
            instruction=instruction,
            input_schema=input_schema,
            output_schema=output_schema,
            output_key=output_key,
            planner=planner,
            sub_agents=sub_agents or [],
            tools=tools or [],
            disallow_transfer_to_peers=disallow_transfer_to_peers,
            # Callbacks
            before_agent_callback=ba_callback,
            after_agent_callback=aa_callback,
            before_model_callback=bm_callback,
            after_model_callback=am_callback,
            before_tool_callback=before_tool_callback,  # Anti-hallucination validation
            after_tool_callback=after_tool_callback,  # Timing and result logging
        )
    
    elif agent_type == AgentTypes.SEQUENTIAL:
        if not sub_agents:
            raise ValueError("SequentialAgent requires sub_agents")
        
        return SequentialAgent(
            name=name,
            description=description,
            sub_agents=sub_agents,
            # SequentialAgent callbacks (no model callbacks)
            before_agent_callback=ba_callback,
            after_agent_callback=aa_callback,
        )
    
    elif agent_type == AgentTypes.PARALLEL:
        if not sub_agents:
            raise ValueError("ParallelAgent requires sub_agents")
        
        return ParallelAgent(
            name=name,
            description=description,
            sub_agents=sub_agents,
            # ParallelAgent callbacks (no model callbacks)
            before_agent_callback=ba_callback,
            after_agent_callback=aa_callback,
        )
    
    elif agent_type == AgentTypes.LOOP:
        if not sub_agents:
            raise ValueError("LoopAgent requires sub_agents")
        
        return LoopAgent(
            name=name,
            description=description,
            sub_agents=sub_agents,
            # LoopAgent callbacks (no model callbacks)
            before_agent_callback=ba_callback,
            after_agent_callback=aa_callback,
        )
    
    else:
        raise ValueError(f"Invalid agent type: {agent_type}")


def create_llm_agent(
    name: str,
    description: str,
    instruction: str,
    model: str = "gemini-2.5-flash",
    provider: str = None,
    input_schema: Type[BaseModel] = None,
    output_schema: Type[BaseModel] = None,
    output_key: str = None,
    thinking: bool = False,
    thinking_budget: int = 1024,
    sub_agents: List[BaseAgent] = None,
    tools: List[Any] = None,
    disallow_transfer_to_peers: bool = False,
    use_logging_callbacks: bool = True,
) -> LlmAgent:
    """
    Convenience function to create an LlmAgent with logging.
    """
    return create_agent(
        agent_type=AgentTypes.LLM,
        name=name,
        description=description,
        instruction=instruction,
        model=model,
        provider=provider,
        input_schema=input_schema,
        output_schema=output_schema,
        output_key=output_key,
        thinking=thinking,
        thinking_budget=thinking_budget,
        sub_agents=sub_agents,
        tools=tools,
        disallow_transfer_to_peers=disallow_transfer_to_peers,
        use_logging_callbacks=use_logging_callbacks,
    )


def create_sequential_agent(
    name: str,
    description: str,
    sub_agents: List[BaseAgent],
    use_logging_callbacks: bool = True,
) -> SequentialAgent:
    """
    Convenience function to create a SequentialAgent with logging.
    """
    return create_agent(
        agent_type=AgentTypes.SEQUENTIAL,
        name=name,
        description=description,
        instruction="",  # Not used for SequentialAgent
        sub_agents=sub_agents,
        use_logging_callbacks=use_logging_callbacks,
    )


def create_parallel_agent(
    name: str,
    description: str,
    sub_agents: List[BaseAgent],
    max_iterations: int = 10,
    use_logging_callbacks: bool = True,
) -> ParallelAgent:
    """
    Convenience function to create a ParallelAgent with logging.
    """
    return create_agent(
        agent_type=AgentTypes.PARALLEL,
        name=name,
        description=description,
        instruction="",  # Not used for ParallelAgent,
        max_iterations=max_iterations,
        sub_agents=sub_agents,
        use_logging_callbacks=use_logging_callbacks,
    )


def create_loop_agent(
    name: str,
    description: str,
    sub_agents: List[BaseAgent],
    max_iterations: int = 10,
    use_logging_callbacks: bool = True,
) -> LoopAgent:
    """
    Convenience function to create a LoopAgent with logging.
    """
    return create_agent(
        agent_type=AgentTypes.LOOP,
        name=name,
        description=description,
        instruction="",  # Not used for LoopAgent
        sub_agents=sub_agents,
        use_logging_callbacks=use_logging_callbacks,
    )