from google import genai
from dotenv import load_dotenv
import os

load_dotenv()

client = genai.Client(
    api_key=os.getenv("GEMINI_API_KEY")
)


def review_blueprint(project_name, blueprint):

    prompt = f"""
You are a Principal Software Architect performing a design review.

Review the following software blueprint.

Project Name:
{project_name}

Blueprint:
{blueprint}

Generate a professional review in Markdown.

Include:

# 🔍 Blueprint Review

## Overall Score (out of 10)

## Architecture Score

## Security Score

## Scalability Score

## Maintainability Score

## Strengths

## Weaknesses

## Missing Components

## Recommendations

Be critical.

Do NOT simply praise the blueprint.

Explain WHY every score was given.
"""

    response = client.models.generate_content(
        model="gemini-3-flash-preview",
        contents=prompt
    )

    return response.text