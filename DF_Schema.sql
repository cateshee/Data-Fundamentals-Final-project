-- Taste Hub Database Schema and Sample Data

-- 1. Profiles Table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  full_name TEXT,
  email TEXT,
  role TEXT DEFAULT 'user',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Projects Table
CREATE TABLE IF NOT EXISTS projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID REFERENCES profiles(id),
  title TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Tasks Table
CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  owner_id UUID REFERENCES profiles(id),
  assignee_id UUID REFERENCES profiles(id),
  title TEXT NOT NULL,
  done BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert sample profiles
INSERT INTO profiles (id, full_name, email, role)
VALUES
  (gen_random_uuid(), 'Alice Admin', 'alice@example.com', 'admin'),
  (gen_random_uuid(), 'Bob User', 'bob@example.com', 'user'),
  (gen_random_uuid(), 'Carol User', 'carol@example.com', 'user'),
  (gen_random_uuid(), 'Dave User', 'dave@example.com', 'user'),
  (gen_random_uuid(), 'Eve User', 'eve@example.com', 'user');

-- Insert sample projects
INSERT INTO projects (id, owner_id, title, description, status)
VALUES
  (gen_random_uuid(), (SELECT id FROM profiles LIMIT 1 OFFSET 0), 'Taste Hub Website', 'Main company website redesign', 'active'),
  (gen_random_uuid(), (SELECT id FROM profiles LIMIT 1 OFFSET 1), 'Inventory Tracker', 'Stock tracking app for Taste Hub', 'active'),
  (gen_random_uuid(), (SELECT id FROM profiles LIMIT 1 OFFSET 2), 'Marketing Dashboard', 'Internal analytics dashboard', 'active'),
  (gen_random_uuid(), (SELECT id FROM profiles LIMIT 1 OFFSET 3), 'Customer App', 'Client-facing mobile app', 'on hold'),
  (gen_random_uuid(), (SELECT id FROM profiles LIMIT 1 OFFSET 4), 'Delivery API', 'API for third-party delivery partners', 'completed');

-- Insert sample tasks
INSERT INTO tasks (id, project_id, owner_id, assignee_id, title, done)
VALUES
  (gen_random_uuid(), (SELECT id FROM projects LIMIT 1 OFFSET 0), (SELECT id FROM profiles LIMIT 1 OFFSET 0), (SELECT id FROM profiles LIMIT 1 OFFSET 1), 'Design homepage layout', FALSE),
  (gen_random_uuid(), (SELECT id FROM projects LIMIT 1 OFFSET 1), (SELECT id FROM profiles LIMIT 1 OFFSET 1), (SELECT id FROM profiles LIMIT 1 OFFSET 2), 'Add product search feature', TRUE),
  (gen_random_uuid(), (SELECT id FROM projects LIMIT 1 OFFSET 2), (SELECT id FROM profiles LIMIT 1 OFFSET 2), (SELECT id FROM profiles LIMIT 1 OFFSET 3), 'Integrate Google Analytics', FALSE),
  (gen_random_uuid(), (SELECT id FROM projects LIMIT 1 OFFSET 3), (SELECT id FROM profiles LIMIT 1 OFFSET 3), (SELECT id FROM profiles LIMIT 1 OFFSET 4), 'Fix login bug', TRUE);
