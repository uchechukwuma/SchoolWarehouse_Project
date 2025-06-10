📚 School Data Warehouse for Management Analytics
Personal Data Engineering Portfolio Project
Author: Uchechukwu Obi
Disclaimer: Educational/portfolio use only. Not a real-world system.

🚀 Project Overview
This project designs and implements a Data Warehouse for a fictional secondary school to demonstrate dimensional modeling, data engineering concepts, and analytical query capabilities. The warehouse is structured to enable analysis of key school operations including:

Student performance across subjects and terms

Attendance monitoring and trends

Payment tracking per term

Employee management including teaching and non-teaching staff

Grading systems for GPA and CGPA computation

The project is part of my personal learning journey and portfolio as I pursue a career in Data Engineering.

🏗️ Current Phase (Conceptual & Logical Design)
✅ Deliverables so far:
Entity Relationship Diagram (ERD) — Designed using Draw.io / Diagrams.net

Relational Model Diagram — Created via DBdiagram.io

SQL Data Warehouse Schema — Developed for PostgreSQL, including dimensions, facts, constraints, and indexes

Dimensional Modeling Approach: Kimball Star Schema

Core Components:
Dimensions: Students, Classes, Subjects, Terms, Employees, Grading Scale

Facts: Performance, Attendance, Payments

Bridge Table: To handle many-to-many teaching assignments (TaughtBy)

Employee Hierarchy: Recursive relationship modeled via supervisor field

📦 Planned Next Steps
Deploy the schema into a local PostgreSQL Data Warehouse

Introduce dbt (Data Build Tool) for transformations and derived metrics (GPA, CGPA, Attendance Rates, Payment Status)

Create analytics-ready views for BI tools or reporting

Optional: Build sample dashboards (e.g., Power BI / Metabase)

🎯 Project Goals
Apply dimensional modeling for a school context

Build and transform data pipelines using SQL and dbt

Generate insights such as:

Average attendance per class/term

Outstanding payments per student

GPA & CGPA computation

Subject-wise performance breakdown

📂 Repository Structure (Current & Future)
bash
Copy
Edit
/school_data_warehouse_project/
│
├── ERD_Diagrams/
│   ├── ERD.jpeg
│   └── Relational_Model.jpeg
│
├── SQL_Schema/
│   └── data_warehouse_schema.sql
│
├── README.md
│
└── (future) /dbt_project/
⚠️ Disclaimer
This is a personal, educational project. The data model, schema, and assumptions are not representative of any real institution. Use for portfolio and learning purposes only.

🛠️ Tools & Technologies
PostgreSQL

SQL (DDL & DML)

dbt (planned)

Draw.io / Diagrams.net

DBdiagram.io

Git & GitHub (version control)

🔗 Follow My Learning Journey
More updates — including dbt transformations and data marts — will be posted on my LinkedIn profile.
Stay tuned!

