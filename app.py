import streamlit as st
from modules.gemini import generate_blueprint
from modules.pdf_generator import create_pdf
from modules.diagram_generator import generate_architecture
from modules.docx_generator import create_docx
from modules.estimator import estimate_project
from modules.reviewer import review_blueprint
from modules.sql_generator import generate_sql_schema
st.set_page_config(
    page_title="ProjectForge AI",
    page_icon="⚒️",
    layout="wide"
)
with open("assets/style.css") as f:
    st.markdown(
        f"<style>{f.read()}</style>",
        unsafe_allow_html=True
    )

# ---------------- Sidebar ---------------- #

with st.sidebar:

    st.image("assets/logo.png", width=120)

    st.markdown("## ProjectForge AI")

    st.success("Production Ready")

    st.write("AI-Powered Software Solution Architect")

    st.markdown("---")

    st.info(
        "Transform software ideas into blueprints, architecture, SQL schemas and technical documentation."
    )

# ---------------- Main UI ---------------- #

col1, col2 = st.columns([3, 1])

with col1:

    st.markdown("""
    <div class="hero">

    <h1>⚒️ ProjectForge AI</h1>

    <p>AI-Powered Software Solution Architect</p>

    <span>
    Transform software ideas into complete blueprints,
    architecture, SQL schemas and technical documentation
    using Generative AI.
    </span>

    </div>
    """, unsafe_allow_html=True)

with col2:

    st.image("assets/logo.png", width=280)
 

st.divider()

with st.container(border=True):

    st.markdown("## 🚀 Start Your Project")

    st.caption(
        "Describe your software idea and let ProjectForge AI generate a complete technical blueprint."
    )

    project_name = st.text_input(
    "📌 Project Name",
    placeholder="Example: Hospital Management System"
)

    project_description = st.text_area(
    "📝 Project Description",
    height=260,
    placeholder="Describe your project in detail. Mention users, features, objectives and any special requirements."
)

    generate = st.button(
        "⚒️ Forge Project",
        use_container_width=True,
        type="primary"
    )


if generate:

    if project_name.strip() == "" or project_description.strip() == "":
        st.warning("Please enter project details.")
    else:
        try:
            progress = st.progress(0)
            status = st.empty()
            status.info("⚒️ Forging your project...")

            blueprint = generate_blueprint(project_name, project_description)
            progress.progress(20)

            sql_schema = generate_sql_schema(project_name, project_description)
            progress.progress(40)

            review = review_blueprint(project_name, blueprint)
            progress.progress(60)

            analysis = estimate_project(project_name, project_description)
            progress.progress(80)

            architecture = generate_architecture(project_name, project_description)
            progress.progress(100)
            status.success("🎉 Project successfully forged!")

            progress.empty()
            status.empty()

            st.success("🎉 ProjectForge AI successfully forged your project!")
            st.divider()

            tab1, tab2, tab3, tab4, tab5 = st.tabs([
                "📄 Blueprint","🏗 Architecture","📊 Analysis","🔍 Review","🗄 SQL"
            ])

            with tab1:
                st.subheader("📄 Software Blueprint")
                st.markdown(blueprint)

            with tab2:
                st.subheader("🏗 System Architecture")
                st.code(architecture, language="text")

            with tab3:
                st.subheader("📊 AI Project Analysis")
                st.markdown(analysis)

            with tab4:
                st.subheader("🔍 AI Blueprint Review")
                st.markdown(review)

            with tab5:
                st.subheader("🗄 SQL Database Schema")
                st.code(sql_schema, language="sql")

            pdf_file = create_pdf(blueprint, f"{project_name}_blueprint.pdf")
            docx_file = create_docx(blueprint, f"{project_name}_blueprint.docx")
            sql_filename = f"{project_name}_schema.sql"
            with open(sql_filename,"w",encoding="utf-8") as f:
                f.write(sql_schema)

            st.divider()
            st.subheader("📥 Export Project")
            st.caption("Download the generated project files in your preferred format.")

            col1,col2,col3,col4=st.columns(4)
            with col1:
                st.download_button("⬇️ Download Markdown", blueprint, f"{project_name}_blueprint.md","text/markdown", use_container_width=True)
            with col2:
                with open(pdf_file,"rb") as f:
                    st.download_button("⬇️ Download PDF", f, f"{project_name}.pdf","application/pdf", use_container_width=True)
            with col3:
                with open(docx_file,"rb") as f:
                    st.download_button("⬇️ Download Word", f, f"{project_name}.docx","application/vnd.openxmlformats-officedocument.wordprocessingml.document", use_container_width=True)
            with col4:
                with open(sql_filename,"rb") as f:
                    st.download_button("⬇️ Download SQL", f, sql_filename,"application/sql", use_container_width=True)
        except Exception as e:
            st.error(f"❌ Error: {e}")

st.divider()
st.caption("⚒️ ProjectForge AI • Version 1.0 • Powered by Google Gemini")
