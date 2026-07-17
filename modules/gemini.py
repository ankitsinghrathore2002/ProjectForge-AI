import os
from dotenv import load_dotenv
from google import genai

load_dotenv()

client = genai.Client(
    api_key=os.getenv("GEMINI_API_KEY")
)

def generate_blueprint(project_name, project_description):

    prompt = f"""
You are a Principal Software Architect working at Google.

Generate an enterprise-grade Software Development Blueprint.

Project Name:
{project_name}

Project Description:
{project_description}

Generate the output in Markdown format.

Include these sections:

# 📌 Project Overview
Explain the project in detail.

# 🎯 Business Objective

# 👥 User Roles

# ⚙ Functional Requirements
Use bullet points.

# 🔒 Non Functional Requirements

# 🛠 Suggested Technology Stack
Mention Frontend, Backend, Database, Cloud, DevOps, Authentication.

# 🗂 Suggested Folder Structure

# 🌐 REST API Endpoints
Mention Method, Endpoint, Purpose.

# 🗄 Database Design
Mention tables with columns.

# 🚀 Deployment Architecture

# 📅 Development Roadmap
Split into Week 1 to Week 6.

Write professionally like a Software Architect.
"""

    response = client.models.generate_content(
        model="gemini-3-flash-preview",
        contents=prompt
    )

    return response.text