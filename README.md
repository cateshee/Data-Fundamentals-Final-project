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

# 📖 TasteHub Database System <a name="about-project"></a>

**TasteHub** is a restaurant management system built for the **Data Fundamentals** project.  
It demonstrates how to design and secure a relational database using **Supabase (PostgreSQL)** with **Row Level Security (RLS)** and **Role-Based Access Control (RBAC)**.

The project models restaurant operations — from managing menu items to customer orders — and enforces access control between **Admins** and **Regular Users**.

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

- **🍽️ Menu Management:** Manage all available dishes, prices, and categories.  
- **🧾 Order Tracking:** View and manage customer orders in real time.  
- **👥 Role-Based Access:** Separate Admin and Regular User functionalities.  
- **🔐 RLS Security:** Ensures data privacy and ownership across all tables.  
- **📊 Clean Database Schema:** Organized relational structure with references.  

---

## 💻 Getting Started <a name="getting-started"></a>

### Prerequisites

You’ll need:

- A [Supabase](https://supabase.com/) account (free tier available)  
- Basic SQL knowledge  
- Supabase SQL Editor or any PostgreSQL client  

---

### Setup

1. Go to [Supabase Dashboard](https://app.supabase.com/)  
2. Click **“New Project”**  
3. Fill in your project name (e.g., `TasteHub Database`)  
4. Once created, go to **SQL Editor**  

---

### Install

1. Copy and run your schema script in the SQL editor (tables, data, and RLS policies).  
2. Verify that the following tables are created:  
   - `users`  
   - `menu_items`  
   - `orders`  
   - `order_items`  
3. Add at least 5 rows of sample data per table.  

---

### Usage

#### For Regular Users:
- Register via Supabase Auth  
- Browse menu items  
- Place and view their own orders  
- Cannot modify or see other users’ orders  

#### For Admins:
- Can manage menu items and prices  
- Can view and manage all orders and users  
- Can perform admin-only SQL functions  
```
-- Delete any project
SELECT delete_project('project_uuid_here');

-- View usage stats
SELECT * FROM get_user_statistics();

-- Archive old completed projects
SELECT * FROM archive_old_projects();
```
---

## 🧱 Database Structure <a name="database-structure"></a>

### Users Table
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| email | TEXT | User email (unique) |
| full_name | TEXT | User full name |
| role | TEXT | 'admin' or 'user' |
| created_at | TIMESTAMP | Record creation date |

### Menu Items Table
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| item_name | TEXT | Name of the dish |
| category | TEXT | Category (e.g., Drinks, Main, Dessert) |
| price | DECIMAL | Price of the menu item |
| available | BOOLEAN | Whether item is available |
| created_at | TIMESTAMP | Record creation date |

### Orders Table
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Foreign key → users.id |
| total_price | DECIMAL | Total amount of the order |
| status | TEXT | 'pending', 'completed', or 'cancelled' |
| order_date | TIMESTAMP | Date of the order |

### Order Items Table
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| order_id | UUID | Foreign key → orders.id |
| item_id | UUID | Foreign key → menu_items.id |
| quantity | INTEGER | Number of items ordered |

---

## 🔐 Security Implementation <a name="security"></a>

### User Roles <a name="user-roles"></a>

#### Admin Role
- Full access to all tables  
- Can view and edit all data  
- Can manage users, orders, and menu items  

#### Regular User Role
- Can view available menu items  
- Can only view and modify their own orders  
- Cannot see or edit other users’ data  

---

### Row Level Security Policies <a name="row-level-security-policies"></a>

#### Users Table policies
- Users can only view or edit their own profile  
- Admins can view and manage all users  

#### Orders Table policies
- Users can only view their own orders  
- Admins can view and manage all orders  

#### Order Items Table policies
- Users can view order items related to their own orders  
- Admins can access all records  

#### Menu Items Table policies
- Admins can insert, update, or delete items  
- Users can only view available items  

---

### Admin-Only Functions <a name="admin-only-functions"></a>

1. **delete_project(project_id UUID)**
    Deletes any project (regardless of owner)
    Uses SECURITY DEFINER for safe elevated privilege

2. **get_user_statistics()**
   Returns aggregated user and project stats — perfect for admin dashboards

4. **archive_old_projects()**
   Automatically archives projects older than 90 days marked as completed
---

## 👥 Authors <a name="authors"></a>

👤 **Cate**  
- GitHub: [@cateshee](https://github.com/cateshee)

---
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🔭 Future Features <a name="future-features"></a>

- [ ] Dashboard for order analytics  
- [ ] Notification system for new orders  
- [ ] Advanced filtering for menu categories  
- [ ] Admin statistics reports  

---

## 🤝 Contributing <a name="contributing"></a>

Contributions and feature requests are welcome!  
Feel free to open a pull request or issue.

---

## ⭐️ Show your support <a name="support"></a>

If you found this project useful, please give it a ⭐️ to show support!

---

## 🙏 Acknowledgements <a name="acknowledgements"></a>

- Thanks to the Supabase documentation and Data Fundamentals instructors.  
- PostgreSQL community for security and RLS examples.  

---

## ❓ FAQ <a name="faq"></a>

**How do I make a user an admin?**
```sql
UPDATE users SET role = 'admin' WHERE email = 'user@example.com';
```
**Why can't I see other users' data?**

This is by design! Row Level Security ensures users can only access their own data. Only admin users can see all data.

**How do I test the security policies?**

Sign in as different users (admin and regular user) and try to access various data. Regular users should only see their own projects and tasks.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## 📝 License <a name="license"></a>

This project is [MIT](./LICENSE) licensed.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


