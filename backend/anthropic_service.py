import os

from anthropic import Anthropic
from dotenv import load_dotenv

load_dotenv()


class AnthropicService:
    def __init__(self):
        self.client = Anthropic(
            api_key=os.getenv("ANTHROPIC_API_KEY")
        )

    def ask_claude(self, message: str) -> str:
        response = self.client.messages.create(
            model="claude-sonnet-4-5",
            max_tokens=2000,
            messages=[
                {
                    "role": "user",
                    "content": message,
                }
            ],
        )

        return response.content[0].text