from fastapi import APIRouter, Depends

from app.core.users import current_active_user
from app.db.models import User
from app.schemas.chat import ChatRequest, ChatResponse

# from edu_quester.agent import root_agent # Uncomment when ready

router = APIRouter()

@router.post("/", response_model=ChatResponse)
async def chat(
    request: ChatRequest,
    user: User = Depends(current_active_user)
):
    """
    Interact with the EduQuest AI Agent.
    Requires authentication.
    """
    # response = root_agent.invoke(request.message)

    return ChatResponse(
        response=f"Hello {user.email}! Echo from agent: {request.message}",
        session_id=request.session_id or "new_session"
    )
