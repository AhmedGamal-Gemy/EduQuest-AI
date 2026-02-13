"""
Schema definitions for chat endpoints.
"""

from pydantic import BaseModel, Field


class ChatRequest(BaseModel):
    """Request schema for chat interactions with the AI agent."""
    message: str = Field(
        ...,
        min_length=1,
        max_length=10000,
        description="The message to send to the AI agent"
    )
    session_id: str | None = Field(
        None,
        max_length=50,
        description="Optional session ID for conversation continuity"
    )


class ChatResponse(BaseModel):
    """Response schema for chat interactions."""
    response: str = Field(..., description="The AI agent's response")
    session_id: str = Field(..., description="Session ID for this conversation")

