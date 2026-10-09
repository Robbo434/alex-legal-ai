from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from anthropic_service import AnthropicService
from models import ChatRequest, ChatResponse

app = FastAPI()

claude = AnthropicService()

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
    answer = claude.ask_claude(
        request.message
    )

    return ChatResponse(
        response=answer
    )