# Arthur Dean Austin Archive - Setup Guide

## 🔒 Security First

**IMPORTANT:** You shared your database password in our conversation. Please:
1. ✅ Complete this setup
2. ✅ Go to Supabase Dashboard → Settings → Database → Reset Password
3. ✅ Update your local `.env` file with the new password
4. ✅ Never share credentials in plain text again

---

## Prerequisites

- Node.js 18+ (for frontend)
- Python 3.11+ (for backend)
- Git
- Supabase account (already created)
- OpenAI API key

---

## Step 1: Get Supabase Credentials

### Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/settings/api

You'll find:

1. **Project URL:** `https://pfhmxffrczflqqaqjqgr.supabase.co`
2. **anon/public key:** Starts with `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
   - Safe to use in frontend
   - Has limited permissions (Row-Level Security enforced)
3. **service_role key:** Longer key, also starts with `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
   - BACKEND ONLY
   - Full database access (bypasses RLS)
   - NEVER expose to frontend

### Database Password:
- Current password: `ZSRKRebZv9c5ouND`
- **⚠️ ROTATE THIS IMMEDIATELY after setup**
- Go to: Settings → Database → Reset Password

---

## Step 2: Create Local Environment File

```bash
# Copy the example file
cp .env.example .env

# Edit .env with your actual values
nano .env  # or use your preferred editor
```

Fill in:
```bash
# Supabase (get from dashboard)
VITE_SUPABASE_URL=https://pfhmxffrczflqqaqjqgr.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ... (paste your anon key)
SUPABASE_SERVICE_ROLE_KEY=eyJ... (paste your service role key)

# Database (use for migrations only)
DATABASE_URL=postgresql://postgres:YOUR_NEW_PASSWORD@db.pfhmxffrczflqqaqjqgr.supabase.co:5432/postgres

# OpenAI
OPENAI_API_KEY=sk-... (paste your OpenAI key)
```

---

## Step 3: Project Structure

We'll create this structure:

```
ArthurDean/
├── archive/              # Original archive content (unchanged)
│   ├── Data Processing Management Association/
│   ├── Austin Family/
│   └── ...
├── app/                 # New application code
│   ├── frontend/        # React + TypeScript + Vite
│   │   ├── src/
│   │   ├── package.json
│   │   └── vite.config.ts
│   └── backend/         # Python FastAPI
│       ├── main.py
│       ├── requirements.txt
│       └── ...
├── PRD/                 # Product docs
├── tools/               # Utility scripts
├── .env                 # Your secrets (git-ignored)
├── .env.example         # Template (committed to git)
└── .gitignore           # Security
```

---

## Step 4: Initialize Supabase Database

### 4.1 Enable pgvector

Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/editor

Run this SQL:

```sql
-- Enable vector extension
create extension if not exists vector;
```

### 4.2 Create Tables

```sql
-- User profiles (extends Supabase auth.users)
create table user_profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  role text default 'user' check (role in ('user', 'admin')),
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Archive documents with vector embeddings
create table archive_documents (
  id bigserial primary key,
  content text not null,
  metadata jsonb,
  embedding vector(1536), -- OpenAI embedding dimension
  created_at timestamp with time zone default now()
);

-- Memory submissions
create table submissions (
  id bigserial primary key,
  user_id uuid references auth.users not null,
  submission_type text not null check (submission_type in ('story', 'photo', 'document', 'fact')),
  title text not null,
  description text,
  file_path text,
  date_mentioned date,
  people_mentioned text,
  status text default 'pending' check (status in ('pending', 'approved', 'rejected')),
  admin_notes text,
  submitted_at timestamp with time zone default now(),
  reviewed_at timestamp with time zone,
  reviewed_by uuid references auth.users
);

-- Create vector similarity search index
create index on archive_documents
using ivfflat (embedding vector_cosine_ops)
with (lists = 100);

-- Create indexes for performance
create index idx_submissions_user_id on submissions(user_id);
create index idx_submissions_status on submissions(status);
create index idx_archive_metadata on archive_documents using gin(metadata);
```

### 4.3 Set up Row-Level Security (RLS)

```sql
-- Enable RLS
alter table user_profiles enable row level security;
alter table archive_documents enable row level security;
alter table submissions enable row level security;

-- User profiles policies
create policy "Users can view own profile"
  on user_profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on user_profiles for update
  using (auth.uid() = id);

create policy "Admins can view all profiles"
  on user_profiles for select
  using (
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );

-- Archive documents policies (public read)
create policy "Anyone can view archive documents"
  on archive_documents for select
  to authenticated
  using (true);

-- Submissions policies
create policy "Users can create submissions"
  on submissions for insert
  with check (auth.uid() = user_id);

create policy "Users can view own submissions"
  on submissions for select
  using (auth.uid() = user_id);

create policy "Admins can view all submissions"
  on submissions for select
  using (
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );

create policy "Admins can update submissions"
  on submissions for update
  using (
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );
```

### 4.4 Auto-create user profile on signup (trigger)

```sql
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.user_profiles (id, full_name)
  values (new.id, new.raw_user_meta_data->>'full_name');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
```

### 4.5 Create Storage Buckets

Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/storage/buckets

Create two buckets:
1. **submissions** (private)
2. **archive** (public or private, depending on preference)

Or via SQL:

```sql
-- Create storage buckets
insert into storage.buckets (id, name, public)
values
  ('submissions', 'submissions', false),
  ('archive', 'archive', false);

-- RLS for submissions bucket
create policy "Users can upload submissions"
  on storage.objects for insert
  with check (
    bucket_id = 'submissions' and
    auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "Users can view own submissions"
  on storage.objects for select
  using (
    bucket_id = 'submissions' and
    auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "Admins can view all submissions"
  on storage.objects for select
  using (
    bucket_id = 'submissions' and
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );
```

---

## Step 5: Create Your Admin Account

### 5.1 Sign up via Supabase Dashboard

Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/auth/users

Click "Add User" → Create your admin account

### 5.2 Promote to Admin

In SQL Editor:

```sql
-- Find your user ID
select id, email from auth.users;

-- Promote to admin (replace <your-user-id>)
update user_profiles
set role = 'admin'
where id = '<your-user-id>';
```

---

## Step 6: Verify Setup

### Check that everything is created:

```sql
-- Check tables
select table_name from information_schema.tables
where table_schema = 'public'
order by table_name;

-- Should see: archive_documents, submissions, user_profiles

-- Check pgvector extension
select * from pg_extension where extname = 'vector';

-- Check storage buckets
select * from storage.buckets;

-- Check your admin account
select id, email, role from user_profiles
join auth.users on user_profiles.id = auth.users.id;
```

---

## Step 7: Test Connection

Create a simple test script:

```python
# test_supabase.py
from supabase import create_client, Client
import os
from dotenv import load_dotenv

load_dotenv()

url = os.getenv("VITE_SUPABASE_URL")
key = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

supabase: Client = create_client(url, key)

# Test query
response = supabase.table("user_profiles").select("*").execute()
print(f"Connected! Found {len(response.data)} user profiles")
```

Run:
```bash
pip install supabase python-dotenv
python test_supabase.py
```

---

## ✅ Checklist

- [ ] Created `.env` file with actual credentials
- [ ] Enabled pgvector extension
- [ ] Created all database tables
- [ ] Set up RLS policies
- [ ] Created storage buckets
- [ ] Created admin account
- [ ] Promoted admin account to 'admin' role
- [ ] Tested connection with test script
- [ ] **ROTATED database password** (security!)

---

## 🔐 Security Reminders

1. ✅ `.env` is in `.gitignore` (never commit!)
2. ✅ Use `anon_key` in frontend (safe)
3. ✅ Use `service_role_key` in backend only (never expose!)
4. ✅ Database password rotated after sharing in chat
5. ✅ RLS policies enabled (database enforces permissions)

---

## Next Steps

Once setup is complete:
1. Start building frontend (M1: Project Foundation)
2. Ingest archive content (M2: RAG Foundation)
3. Build conversational interface (M4)

See `PRD/PRODUCT_ROADMAP.md` for detailed milestones.

---

*Setup guide created: October 19, 2025*
