-- ============================================
-- Arthur Dean Austin Archive - Supabase Database Schema
-- ============================================
-- Run this in Supabase SQL Editor:
-- https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/editor
-- ============================================

-- ============================================
-- 1. Enable Extensions
-- ============================================

-- Enable pgvector for vector similarity search
create extension if not exists vector;


-- ============================================
-- 2. Create Tables
-- ============================================

-- User profiles (extends Supabase auth.users)
create table if not exists user_profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  role text default 'user' check (role in ('user', 'admin')),
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Archive documents with vector embeddings
create table if not exists archive_documents (
  id bigserial primary key,
  content text not null,
  metadata jsonb,
  embedding vector(1536), -- OpenAI text-embedding-3-small dimension
  created_at timestamp with time zone default now()
);

-- Memory submissions from users
create table if not exists submissions (
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


-- ============================================
-- 3. Create Indexes
-- ============================================

-- Vector similarity search index (IVFFlat)
create index if not exists idx_archive_documents_embedding
  on archive_documents
  using ivfflat (embedding vector_cosine_ops)
  with (lists = 100);

-- Performance indexes
create index if not exists idx_submissions_user_id on submissions(user_id);
create index if not exists idx_submissions_status on submissions(status);
create index if not exists idx_archive_metadata on archive_documents using gin(metadata);


-- ============================================
-- 4. Enable Row-Level Security (RLS)
-- ============================================

alter table user_profiles enable row level security;
alter table archive_documents enable row level security;
alter table submissions enable row level security;


-- ============================================
-- 5. RLS Policies - User Profiles
-- ============================================

-- Users can view their own profile
create policy "Users can view own profile"
  on user_profiles for select
  using (auth.uid() = id);

-- Users can update their own profile
create policy "Users can update own profile"
  on user_profiles for update
  using (auth.uid() = id);

-- Admins can view all profiles
create policy "Admins can view all profiles"
  on user_profiles for select
  using (
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );


-- ============================================
-- 6. RLS Policies - Archive Documents
-- ============================================

-- Anyone authenticated can view archive documents
create policy "Authenticated users can view archive documents"
  on archive_documents for select
  to authenticated
  using (true);

-- Only service role can insert (via backend)
-- This is handled by not creating an insert policy for regular users


-- ============================================
-- 7. RLS Policies - Submissions
-- ============================================

-- Users can create their own submissions
create policy "Users can create submissions"
  on submissions for insert
  with check (auth.uid() = user_id);

-- Users can view their own submissions
create policy "Users can view own submissions"
  on submissions for select
  using (auth.uid() = user_id);

-- Admins can view all submissions
create policy "Admins can view all submissions"
  on submissions for select
  using (
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );

-- Admins can update submissions (approve/reject)
create policy "Admins can update submissions"
  on submissions for update
  using (
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );


-- ============================================
-- 8. Functions & Triggers
-- ============================================

-- Function: Auto-create user profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.user_profiles (id, full_name)
  values (new.id, new.raw_user_meta_data->>'full_name');
  return new;
end;
$$ language plpgsql security definer;

-- Trigger: Create profile when user signs up
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- ============================================
-- 9. Storage Buckets
-- ============================================

-- Create submissions bucket (private)
insert into storage.buckets (id, name, public)
values ('submissions', 'submissions', false)
on conflict (id) do nothing;

-- Create archive bucket (private)
insert into storage.buckets (id, name, public)
values ('archive', 'archive', false)
on conflict (id) do nothing;


-- ============================================
-- 10. Storage RLS Policies
-- ============================================

-- Submissions bucket: Users can upload to their own folder
create policy "Users can upload submissions"
  on storage.objects for insert
  with check (
    bucket_id = 'submissions' and
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Submissions bucket: Users can view their own uploads
create policy "Users can view own submissions"
  on storage.objects for select
  using (
    bucket_id = 'submissions' and
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Submissions bucket: Admins can view all
create policy "Admins can view all submissions"
  on storage.objects for select
  using (
    bucket_id = 'submissions' and
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );

-- Archive bucket: Authenticated users can view
create policy "Authenticated users can view archive"
  on storage.objects for select
  to authenticated
  using (bucket_id = 'archive');


-- ============================================
-- 11. Verification Queries
-- ============================================

-- Check tables created
select table_name from information_schema.tables
where table_schema = 'public'
order by table_name;

-- Check extensions
select * from pg_extension where extname = 'vector';

-- Check storage buckets
select * from storage.buckets;

-- ============================================
-- Setup Complete!
-- ============================================
-- Next steps:
-- 1. Create your admin account via Supabase Auth UI
-- 2. Run: update user_profiles set role = 'admin' where id = '<your-user-id>';
-- 3. Verify: select * from user_profiles;
-- ============================================
