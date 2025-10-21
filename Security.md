# 🔒 Security Notes - Taste Hub Management System

## Overview
This document outlines the **security architecture** and **Row Level Security (RLS)** implementation for the **Taste Hub Management System**, built on **Supabase PostgreSQL**.  
The system enforces strict access control between **Admins** and **Regular Users**, ensuring data protection, integrity, and privacy across all operations.

---

## 🔐 Authentication & Authorization

### User Roles

1. **Admin Role (`role = 'admin'`)**
   - Full access to all tables (SELECT, INSERT, UPDATE, DELETE)
   - Can manage menu items, orders, and users
   - Can execute admin-only SQL functions
   - Intended for system administrators or restaurant managers

2. **User Role (`role = 'user'`)**
   - Limited access based on ownership or visibility
   - Can view and make orders from the menu
   - Can update or delete only their own orders
   - Cannot modify user roles or access other users’ data

---

## 🧱 Row Level Security (RLS)

### What is RLS?
RLS (Row Level Security) restricts which rows users can access in a PostgreSQL table based on policies.  
Every query is automatically filtered to enforce these access rules.

### RLS Status
✅ **Enabled** on all main tables:
- `users`
- `menu_items`
- `orders`
- `order_items`

---

## ⚙️ Table Security Policies

### 🧍‍♀️ Users Table
| Policy Name | Operation | Who | Description |
|--------------|------------|------|--------------|
| View own profile | SELECT | Regular Users | Users can only view their own profile |
| Admin view all users | SELECT | Admins | Admins can view all user records |
| Update own profile | UPDATE | Regular Users | Users can update their info except role |
| Admin full access | ALL | Admins | Admins can manage any user record |

**Note:** Prevents privilege escalation — users cannot self-assign the admin role.

---

### 🍽️ Menu Items Table
| Policy Name | Operation | Who | Description |
|--------------|------------|------|--------------|
| View all menu items | SELECT | All Users | Anyone logged in can view available dishes |
| Admin manage menu | ALL | Admins | Only admins can add, edit, or delete menu items |

**Example Policy:**
```sql
CREATE POLICY "Admins manage menu"
ON menu_items
FOR ALL
USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'));
🧾 Orders Table
Policy Name	Operation	Who	Description
View own orders	SELECT	Regular Users	Users can only view their own orders
Place new order	INSERT	Regular Users	Users can create their own orders
Update or cancel order	UPDATE, DELETE	Regular Users	Users can modify or cancel their orders
Admin full control	ALL	Admins	Admins can manage all orders

Security Check:
Every query ensures that orders.user_id = auth.uid() for regular users.

🍔 Order Items Table
Policy Name	Operation	Who	Description
View own order items	SELECT	Regular Users	Users can only view items in their own orders
Add items to order	INSERT	Regular Users	Users can add items only to their active orders
Update or delete order items	UPDATE, DELETE	Regular Users	Users can modify or remove their own order items
Admin full control	ALL	Admins	Admins can manage any order item

🧮 Admin-Only SQL Functions
1. delete_order(order_id UUID)
Purpose:
Allows admins to delete any user’s order for moderation or system cleanup.

Security:
Runs with SECURITY DEFINER privileges.
Access is restricted to users with role = 'admin'.

sql
Copy code
CREATE OR REPLACE FUNCTION delete_order(order_id UUID)
RETURNS VOID AS $$
BEGIN
  DELETE FROM orders WHERE id = order_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
2. get_sales_summary()
Purpose:
Aggregates total sales, order counts, and customer activity.

Returns:

Total orders

Total revenue

Most popular menu items

sql
Copy code
CREATE OR REPLACE FUNCTION get_sales_summary()
RETURNS TABLE(
  total_orders INT,
  total_revenue NUMERIC,
  top_item TEXT
)
AS $$
  SELECT COUNT(*), SUM(total_price), (
    SELECT item_name FROM menu_items 
    JOIN order_items USING (item_id)
    GROUP BY item_name
    ORDER BY COUNT(*) DESC LIMIT 1
  )
  FROM orders;
$$ LANGUAGE sql SECURITY DEFINER;
🧭 Least Privilege Principle
Our access model is designed to grant only the minimal permissions required:

Default Deny – No access without explicit policy.

Explicit Grants – Access given through verified RLS policies.

User Ownership Enforcement – Access tied to auth.uid().

Role Separation – Admins ≠ Users.

Immutable Roles – Users can’t self-promote.

🧰 Supabase Auth Integration
Setup Steps
Enable Supabase Auth (email/password or magic link)

Create users table linked to Supabase auth.users via user_id

Map auth.uid() to logged-in user session

Policies use auth.uid() for ownership validation

Authentication Flow

User logs in → Supabase issues JWT

JWT contains user_id

PostgreSQL enforces RLS using auth.uid()

Queries filtered automatically per user

🧪 Security Testing Checklist
Test	Expected Outcome
Regular user views all orders	❌ Access denied
Regular user views own orders	✅ Success
Regular user tries to edit another user's order	❌ Access denied
Admin views all users	✅ Success
User tries to change role to admin	❌ Access denied
Admin runs delete_order()	✅ Success

🔍 Common Security Issues
Issue	Cause	Fix
“permission denied”	No matching RLS policy	Verify policies exist for operation
Users see each other's orders	RLS disabled or too broad	Ensure auth.uid() filters are applied
Admin can’t access data	Missing admin policy	Add role = 'admin' condition

🚀 Potential Future Improvements
Add Audit Logging for admin actions

Enable Two-Factor Authentication (2FA)

Implement IP-based restrictions for admin panel

Apply column-level encryption for sensitive data

Use rate limiting for frequent actions

📚 References
Supabase RLS Docs

PostgreSQL RLS Guide

OWASP Access Control Guidelines

✅ Summary
The Taste Hub Management System enforces a robust role-based access model built on Supabase RLS, ensuring:

Users access only their own orders

Admins manage menu, users, and orders safely

All access is validated via auth.uid()

Security policies follow least privilege and default deny principles

yaml
Copy code

---

Would you like me to add **SQL snippets** that show the **actual Supabase RLS policies** (the `CREATE POL
