# 📗 Table of Contents

- [📖 About the Project](#about-project)
  - [🛠 Built With](#built-with)
    - [Tech Stack](#tech-stack)
    - [Key Features](#key-features)
- [💻 Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Install](#install)
  - [Usage](#usage)
  - [Database Structure](#database-structure)
- [🔐 Security Implementation](#security)
  - [User Roles](#user-roles)
  - [Row Level Security Policies](#row-level-security-policies)
  - [Admin-Only Functions](#admin-only-functions)
- [👥 Authors](#authors)
- [🔭 Future Features](#future-features)
- [🤝 Contributing](#contributing)
- [⭐️ Show your support](#support)
- [🙏 Acknowledgements](#acknowledgements)
- [❓ FAQ](#faq)
- [📝 License](#license)

---

# 📖 TasteHub Library Management System <a name="about-project"></a>

**TasteHub Library Management System** is a database-driven project built on **Supabase (PostgreSQL)** that demonstrates secure role-based access, admin-only operations, and Row Level Security (RLS).  
It showcases how to design and protect a modern data system with real-world access control and multi-user functionality.

---

## 🛠 Built With <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

<details>
  <summary>Backend as a Service</summary>
  <ul>
    <li><a href="https://supabase.com/">Supabase</a></li>
  </ul>
</details>

<details>
  <summary>Database</summary>
  <ul>
    <li><a href="https://www.postgresql.org/">PostgreSQL 15+</a></li>
  </ul>
</details>

<details>
  <summary>Security</summary>
  <ul>
    <li>Row Level Security (RLS)</li>
    <li>Role-Based Access Control (RBAC)</li>
    <li>Supabase Auth</li>
  </ul>
</details>

---

### Key Features <a name="key-features"></a>

- 🔐 **Row Level Security (RLS)** — ensures users only access their own data  
- 👥 **Role-Based Access Control** — Admin and Regular user roles  
- 🧩 **Admin-Only Functions** — secure PostgreSQL functions for elevated tasks  
- 🗃️ **Multi-Table Schema** — includes `profiles`, `projects`, and `tasks`  
- 🛡️ **Least Privilege Principle** — follows best security practices  

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 💻 Getting Started <a name="getting-started"></a>

This project runs entirely on **Supabase**. Follow these steps to set it up.

### Prerequisites

You’ll need:
- A free [Supabase account](https://supabase.com/)
- Basic SQL/PostgreSQL knowledge
- Access to the **Supabase SQL Editor**

### Setup

1. **Create a Supabase Project**
   - Go to [Supabase Dashboard](https://app.supabase.com/)
   - Click “New Project” and enter project details
   - Once created, open the SQL Editor

2. **Clone this repository (optional)**  
   ```bash
   git clone https://github.com/<your-username>/tastehub-library-management-system.git
   cd tastehub-library-management-system
### Install
1.**Run the Database Schema**
   - Open your Supabase project
   - Navigate to the SQL Editor
   - Copy the entire contents of `schema.sql`
   - Paste and execute the SQL commands
   - 
2.**Verify Table Creation**
   - Go to Table Editor in Supabase
   -Verify creation of tables: profiles, projects, and tasks
   - Check that sample data is populated (5+ rows per table)

3.**Enable Authentication**
-Go to Authentication → Settings in Supabase
-Enable Email/Password or Magic Link login
-Configure your app email templates if needed

### Usage

 ####  For Regular Users;
-Register via Supabase Auth → role automatically set to 'user'
-Can view, create, update, and delete their own projects and tasks
-Cannot access or modify others’ data

 #### For Admins
-Users with role = 'admin' can view and manage all records
-Can perform elevated tasks through secure SQL functions:
```sql
-- Delete any project
SELECT delete_project('project_uuid_here');

-- View usage stats
SELECT * FROM get_user_statistics();

-- Archive old completed projects
SELECT * FROM archive_old_projects();

### Database Structure

 ### Profiles Table
Column	Type	Description
id	UUID	Primary key (linked to auth.users)
full_name	TEXT	User’s full name
email	TEXT	Unique user email
role	TEXT	admin or user
created_at	TIMESTAMPTZ	Account creation timestamp

Projects Table
Column	Type	Description
id	UUID	Primary key
owner_id	UUID	References profiles(id)
title	TEXT	Project title
description	TEXT	Description of the project
status	TEXT	active, on hold, or completed
created_at	TIMESTAMPTZ	Creation timestamp

Tasks Table
Column	Type	Description
id	UUID	Primary key
project_id	UUID	References projects(id)
owner_id	UUID	References profiles(id)
assignee_id	UUID	References profiles(id)
title	TEXT	Task title
done	BOOLEAN	Task completion status
created_at	TIMESTAMPTZ	Task creation date

<p align="right">(<a href="#readme-top">back to top</a>)</p>
## 🔐 Security Implementation <a name="security"></a>

### User Roles

### Admin Role
-Full access to all tables
-Can create, update, or delete any data
-Can execute admin-only PostgreSQL functions

### User Role
-Restricted to their own records only
-Cannot view or alter other users’ projects/tasks
-Cannot change their own role

### Row Level Security (RLS) Policies

All tables have RLS enabled with specific policies:

### Profiles Table
-✅ Users can view & update their own profile
-✅ Admins can manage all users

### Projects Table
-✅ Users can view/create/update/delete their own projects
-✅ Admins have unrestricted access

### Tasks Table
-✅ Users can view/create/update/delete their own tasks
-✅ Admins can access all tasks

### Admin-Only Functions

1. delete_project(project_id UUID)
Deletes any project (regardless of owner)
Uses SECURITY DEFINER for safe elevated privilege

2. get_user_statistics()
Returns aggregated user and project stats — perfect for admin dashboards

3. archive_old_projects()
Automatically archives projects older than 90 days marked as completed

👥 Authors <a name="authors"></a>
👤 **Cateshee** (TasteHub Project Owner)

GitHub: @your-github-username

<p align="right">(<a href="#readme-top">back to top</a>)</p>
🔭 Future Features <a name="future-features"></a>
 Add audit logs for admin actions

 Add 2FA for admins

 Build a web dashboard UI for managing data

 Enable email notifications for updates

🤝 Contributing <a name="contributing"></a>
Contributions and suggestions are welcome!
You can open an issue or pull request to propose improvements.

⭐️ Show your support <a name="support"></a>
If this project helped you learn about database security, please star the repository 🌟

🙏 Acknowledgements <a name="acknowledgements"></a>
Supabase team for great documentation

PostgreSQL community for its advanced RLS features

Data Fundamentals instructors for guidance

❓ FAQ <a name="faq"></a>
How do I make a user an admin?

sql
Copy code
UPDATE profiles SET role = 'admin' WHERE email = 'user@example.com';
Why can’t users see others’ data?
RLS ensures each user only accesses their own records — by design.

How can I test RLS policies?
Login as different users and verify isolation of projects and tasks.

📝 License <a name="license"></a>
This project is licensed under the MIT License.

<p align="right">(<a href="#readme-top">back to top</a>)</p> ```
