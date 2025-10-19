# Data-Fundamentals-Final-project

# 📖 Data Fundamentals Final Project — Taste Hub

This project is a secure database system for managing Taste Hub’s internal operations, built on Supabase (PostgreSQL). It demonstrates the use of Row Level Security (RLS) and Role-Based Access Control (RBAC) to protect user data and enforce least privilege principles.

The project models a project and task management system where users can manage their own projects and tasks, while administrators have full visibility and control.

# 📗 Table of Contents

📖 About the Project

🛠 Built With

💻 Getting Started

📊 Database Structure

🔐 Security Implementation

👥 Authors

🔭 Future Features

🤝 Contributing

⭐️ Show your support

🙏 Acknowledgements

📝 License

📖 About the Project

The Taste Hub Database Project is part of the Data Fundamentals final assignment, focusing on secure data design. It features:

Multiple tables with relational links

Admin and regular user roles

Row Level Security (RLS) policies

Admin-only functions for maintenance and reporting

This setup represents a real-world implementation of secure, multi-user database systems.

🛠 Built With
Tech Stack

Backend as a Service: Supabase

Database: PostgreSQL

Security: Row Level Security (RLS), Role-Based Access Control (RBAC)

Key Features

🔐 Row Level Security (RLS) – ensures users can only access their own records

👥 Role-Based Access Control – separate permissions for admins and regular users

🧩 Three-Table Structure – Profiles, Projects, and Tasks

⚙️ Admin-Only SQL Functions – for system-level management

🛡️ Least Privilege Principle – strict access enforcement at the row level

💻 Getting Started

This project runs on Supabase. Follow these steps to replicate it:

Prerequisites

A Supabase account (free plan works)

Basic understanding of SQL and relational databases

Setup

Create a new project in Supabase

Open the SQL Editor

Copy and execute your schema file:

Taste_Hub_Schema.sql


Confirm that three tables are created:

profiles

projects

tasks

Usage

Regular Users:

Can only view, insert, and update their own projects/tasks

Cannot modify or view others’ data

Admins:

Have full access across all tables

Can execute special functions such as:

SELECT delete_project('project_uuid');
SELECT * FROM get_user_statistics();
SELECT * FROM archive_old_projects();

📊 Database Structure
Profiles Table
Column	Type	Description
id	UUID	Primary key (linked to auth.users)
full_name	TEXT	User's full name
email	TEXT	User email
role	TEXT	'admin' or 'user'
created_at	TIMESTAMPTZ	Record creation time
Projects Table
Column	Type	Description
id	UUID	Primary key
owner_id	UUID	References profiles(id)
title	TEXT	Project title
description	TEXT	Project details
status	TEXT	'active', 'on hold', or 'completed'
created_at	TIMESTAMPTZ	Creation timestamp
Tasks Table
Column	Type	Description
id	UUID	Primary key
project_id	UUID	References projects(id)
owner_id	UUID	Task creator
assignee_id	UUID	Assigned user
title	TEXT	Task title
done	BOOLEAN	Completion status
created_at	TIMESTAMPTZ	Creation timestamp
🔐 Security Implementation
User Roles

Admin:

Full CRUD access to all tables

Can execute admin functions

Can view all users’ data

User:

Can only access rows they own

Cannot elevate role

Restricted by RLS to their own data

Row Level Security Policies

✅ RLS enabled on profiles, projects, and tasks
✅ Users can view/modify their own data only
✅ Admins have unrestricted access
✅ Ownership enforced with auth.uid()

Admin-Only Functions

delete_project(project_id UUID) – removes any project

get_user_statistics() – summarizes user data

archive_old_projects() – archives completed projects older than 90 days

👥 Authors

Cate (Taste Hub Project Developer)
📧 [cate@example.com
]
GitHub: @yourGitHubUsername

🔭 Future Features

📜 Audit logs for admin actions

🔔 Email alerts for project updates

📈 Analytics dashboards

🔑 Two-factor authentication for admins

🤝 Contributing

Contributions, issues, and feature requests are welcome!
Check out the Issues section or submit a pull request.

⭐️ Show your support

If you learned something about Supabase and RLS, please ⭐️ the repo!

🙏 Acknowledgements

Supabase documentation and community

PostgreSQL RLS reference

Data Fundamentals course guidance

📝 License

This project is MIT Licensed.
