import os
from dotenv import load_dotenv
from google import genai

load_dotenv()

client = genai.Client(
    api_key=os.getenv("GEMINI_API_KEY")
)

def generate_sql_schema(project_name, project_description):

    prompt = f"""
You are a Senior Database Architect.

Project Name:
{project_name}

Project Description:
{project_description}

Generate a complete MySQL database schema.

Requirements:

- Use CREATE TABLE statements.
- Include Primary Keys.
- Include Foreign Keys.
- Use proper data types.
- Use AUTO_INCREMENT where needed.
- Add NOT NULL constraints where appropriate.
- Make the schema production-ready.

Return ONLY SQL code.
"""

    response = client.models.generate_content(
        model="gemini-3-flash-preview",
        contents=prompt
    )

    return response.text