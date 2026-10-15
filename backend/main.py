from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from anthropic_service import AnthropicService
from models import ChatRequest, ChatResponse

app = FastAPI()

claude = AnthropicService()

conversation_history = []

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def health_check():
    return {
        "status": "online",
        "service": "Alex Backend",
    }


@app.post("/chat", response_model=ChatResponse)
def chat(request: ChatRequest):
    conversation_history.append(
        {
            "role": "user",
            "content": request.message,
        }
    )

    if len(conversation_history) > 20:
        conversation_history[:] = (
            conversation_history[-20:]
        )

    answer = claude.ask_claude(
        conversation_history
    )

    conversation_history.append(
        {
            "role": "assistant",
            "content": answer,
        }
    )

    return ChatResponse(
        response=answer
    )