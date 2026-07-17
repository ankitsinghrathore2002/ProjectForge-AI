from google import genai
from dotenv import load_dotenv
import os

load_dotenv()

client = genai.Client(
    api_key=os.getenv("GEMINI_API_KEY")
)


def estimate_project(project_name, project_description):

    prompt = f"""
You are a Senior Software Project Manager.

Analyze this project.

Project Name:
{project_name}

Project Description:
{project_description}

Generate Markdown with these sections:
Generate Markdown with these sections:
Generate the report dynamically based on the given project.

Do NOT assume any specific domain such as School, Hospital or E-commerce.

Analyze the project requirements and estimate realistic values.

# 👥 User Roles

Identify all end users of the software.

For each role provide:

- Role Name
- Approximate Quantity
- Responsibilities

The quantity should be a realistic estimate based on the project type and expected scale.

# 👨‍💻 Recommended Development Team

List only the technical team required to build this project.

For each member provide:

- Role
- Number Required
- Estimated Monthly Salary (India)
- Responsibilities

# 💰 Development Cost Estimation

Provide an estimated cost breakdown including:

- Development Cost
- UI/UX Design
- Testing
- Cloud Infrastructure
- Deployment
- Maintenance (First Year)

Also provide:

- Total Estimated Cost

# ⏱ Timeline

Mention:

- MVP Development Time
- Full Product Development Time

# ⚠ Risk Analysis

Mention technical and business risks.

# 💡 Recommendations

Give 8 practical recommendations.

Return everything in professional Markdown.

Return the output in professional Markdown format.

Keep the answer concise and professional.
"""

    response = client.models.generate_content(
        model="gemini-3-flash-preview",
        contents=prompt
    )

    return response.text