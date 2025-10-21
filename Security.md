# Security Notes - Taste Hub Management System

## Overview
This document outlines the  SECURITY implementation and Row Level Security (RLS) implementation for the Taste Hub Management System, built on Supabase PostgreSQL.  
The system enforces strict access control between Admins and Regular Users, ensuring data protection, integrity, and privacy across all operations.

---

##  Authentication & Authorization

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

##  Row Level Security (RLS)

### What is RLS?
RLS (Row Level Security) restricts which rows users can access in a PostgreSQL table based on policies.  
Every query is automatically filtered to enforce these access rules.

### RLS Status
RLS is **Enabled** on all main tables:
- ✅ `menu_items` table
- ✅ `orders` table  
- ✅ `order_items` table

  
---

##  Table Security Policies

###  Users Table
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

### Orders Table Policies

| Policy Name | Operation | Who | Description |
|--------------|------------|------|--------------|
| Users can view their own orders | SELECT | Regular Users | Users can only view orders they created |
| Users can place their own orders | INSERT | Regular Users | Users can create new orders linked to their account |
| Users can update their own orders | UPDATE | Regular Users | Users can modify their active orders (e.g., change item quantity) |
| Users can cancel their own orders | DELETE | Regular Users | Users can delete their own orders |
| Admins have full access to orders | ALL | Admins | Admins can view, modify, and delete any order for management or moderation |

**Security Consideration:**  
All user operations are scoped using `auth.uid() = user_id` to ensure that each customer can only interact with their own orders.

---

### Menu Items Table Policies

| Policy Name | Operation | Who | Description |
|--------------|------------|------|--------------|
| All users can view menu items | SELECT | Regular Users | Logged-in users can browse available menu items |
| Admins can add new menu items | INSERT | Admins | Admins can add dishes to the restaurant menu |
| Admins can update menu items | UPDATE | Admins | Admins can modify prices, categories, or availability |
| Admins can delete menu items | DELETE | Admins | Admins can remove outdated or unavailable items |

**Security Consideration:**  
Regular users cannot modify or delete menu items. Only admins manage the restaurant’s menu through validated privileges.

---

### Order Items Table Policies

| Policy Name | Operation | Who | Description |
|--------------|------------|------|--------------|
| Users can view their order items | SELECT | Regular Users | Users can view items that belong to their own orders |
| Users can add to their orders | INSERT | Regular Users | Users can only add menu items to orders they own |
| Users can update order quantities | UPDATE | Regular Users | Users can modify quantities within their own orders |
| Users can delete order items | DELETE | Regular Users | Users can remove items from their orders |
| Admins have full access to all order items | ALL | Admins | Admins can manage order items globally |

**Security Consideration:**  
All policies use `EXISTS` checks with `auth.uid()` to ensure ownership. For example:
```sql
USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()));
```
---
## Admin-Only Custom Functions

### 1. delete_menu_item(item_id UUID)
**Purpose**: Allows admins to delete any menu item regardless of who created it.

**Security Features**:
- Uses `SECURITY DEFINER` to run with admin privileges
- Can only be called by admin users (enforced at app level)
- Useful for moderating the menu and removing outdated dishes

**Usage Example**:
```sql
SELECT delete_menu_item('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa');
```
## 2. get_sales_statistics()
 **Purpose: Returns aggregated statistics about orders, menu items, and customer activity.

 **Security Features**:
  -Uses SECURITY DEFINER to read data across all users
  -Excludes sensitive customer info
  -Supports admin dashboards and analytics

**Returns**:
  -Total number of orders
  -Total revenue
  -Most popular menu item
  -Top 5 customers by order count

**Usage Example**:
```sql
SELECT * FROM get_sales_statistics();
```
### 3. archive_old_orders()
**Purpose**: Automatically archives completed orders older than 6 months.

**Security Features**:
-Uses SECURITY DEFINER for controlled batch updates
-Affects only completed orders
-Returns number of orders archived

 **Usage Example**:
```sql
SELECT * FROM archive_old_orders();
```

---


## Least Privilege Principle

TasteHub enforces the principle of least privilege to protect customer and business data.

1. **Default Deny** – All tables deny access unless an explicit RLS policy grants it.
2. **Explicit Grants** – Access rights are clearly defined by role.
3. **Ownership-Based Access** – Regular users see only their data.
4. **Role Separation** – Admins, Chefs, and Customers each have unique privileges.
5. **Immutable Roles** – Roles cannot be changed by users themselves.

---

## Security Best Practices Implemented

### ✅ Row Level Security (RLS) Enabled
All main tables (users, menu_items, orders, order_items) have RLS turned on.

### ✅ Authentication Required
All database access depends on auth.uid() from Supabase Auth — users must be logged in.

### ✅ Role-Based Access Control (RBAC)
Three levels of access:
Admin: Full control
Chef: Manage menu items
Customer: Place and view their own orders

### ✅ Ownership Validation
Customers can only view or edit their own orders (WHERE user_id = auth.uid()).

### ✅ Secure Functions
All admin functions use SECURITY DEFINER and app-level role validation.

### ✅ Cascade Deletions
ON DELETE CASCADE on foreign keys maintains data consistency.

### ✅ Data Validation
 CHECK constraints restrict invalid entries (e.g., price > 0, role IN ('admin','chef','customer').
 
---
##  Supabase Auth Integration

### Setup Requirements
1.Enable Supabase Auth (Email/Password or Magic Link).
2.Ensure each authenticated user appears in the users table with a default customer role.
3.Admins can manually upgrade user roles (chef or admin).
4.All queries depend on auth.uid() to enforce ownership.

### Authentication Flow
1.User signs in via Supabase Auth.
2.Supabase issues JWT → PostgreSQL reads auth.uid().
3.RLS policies verify access permissions.
4.Unauthorized queries are automatically blocked.

---
## Testing Security

### Test Scenarios

1.**Test Customer Access**
 -Log in as a customer.
 -Can view and edit only own orders.
 -Cannot view other customers’ data (❌ Access Denied).

2.**Test Chef Access**
 -Log in as a chef.
 -Can create and edit menu items.
 -Cannot delete other chefs’ dishes.

3.**Test Admin Access**
 -Log in as admin.
 -Can view all users, orders, and menu items.
 -Can use admin-only SQL functions.

4.**Privilege Escalation Prevention**
 -Log in as a customer.
 -Try updating role to admin (❌ should fail).
 
---
##  Potential Improvements

1. **Audit Logging** – Track admin and chef actions for transparency.
2. **2FA for Admins** – Add two-factor authentication for higher privilege roles.
3. **Rate Limiting** – Prevent brute-force login attempts.
4. **IP Restrictions** – Limit admin panel access to whitelisted IPs.
5. **Column**-Level Encryption – Encrypt sensitive user info (emails, addresses).
6. **Auto-Backups** – Schedule RLS-aware database backups.
7. **Session Expiration** – Shorten JWT lifetimes for better security.

---
## Troubleshooting

**Issue**: “permission denied for table orders”
-**Cause**: RLS enabled but policy missing
-**Fix**: Add policy for role or auth.uid().

**Issue**: Customers see other users’ orders
-**Cause**: Missing ownership filter
-**Fix**: Include WHERE user_id = auth.uid() in SELECT policy.

**Issue**: Admin access fails
-**Cause**: Role mismatch or missing admin policy
-**Fix**: Ensure role = 'admin' policies exist.

---
##  References

-Supabase RLS Documentation
-PostgreSQL Row-Level Security

---
## Conclusion

The TasteHub Food Ordering System is built on a strong foundation of database-level security.
With RLS, RBAC, and Supabase Auth, TasteHub ensures that:

-Each user accesses only their own data
-Admins and chefs manage the system securely
-The principle of least privilege is strictly applied
-Security policies are transparent and maintainable

---

