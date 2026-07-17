from google import genai
from dotenv import load_dotenv
import os

load_dotenv()

client = genai.Client(
    api_key=os.getenv("GEMINI_API_KEY")
)


def generate_architecture(project_name, project_description):

    prompt = f"""
You are a Senior Software Solution Architect.

Project Name:
{project_name}

Project Description:
{project_description}

Generate ONLY an ASCII system architecture diagram.

Rules:
- Output only the diagram.
- No explanations.
- Use boxes and arrows.
- Keep it professional.

Example:

                User
                  │
                  ▼
        React Frontend
                  │
                  ▼
        FastAPI Backend
           │         │
           ▼         ▼
      PostgreSQL   Redis
                  │
                  ▼
             Cloud Storage
"""

    response = client.models.generate_content(
        model="gemini-3-flash-preview",
        contents=prompt
    )

    return response.text