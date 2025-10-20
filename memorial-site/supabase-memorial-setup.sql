-- ============================================
-- Memorial Site - Database Setup
-- ============================================
-- Run this in Supabase SQL Editor
-- ============================================

-- Create memorial submissions table
create table if not exists memorial_submissions (
  id bigserial primary key,
  name text not null,
  email text not null,
  notify_when_ready boolean default true,
  memory text not null,
  tags text,
  file_path text,
  recaptcha_token text,
  submitted_at timestamp with time zone default now()
);

-- Create index for faster queries
create index if not exists idx_memorial_submissions_submitted_at
  on memorial_submissions(submitted_at desc);

create index if not exists idx_memorial_submissions_email
  on memorial_submissions(email);

-- Enable RLS (but allow public inserts for memorial form)
alter table memorial_submissions enable row level security;

-- Allow anyone to insert (public memorial submission)
create policy "Anyone can submit memories"
  on memorial_submissions for insert
  to anon
  with check (true);

-- Only authenticated admins can view
create policy "Admins can view all submissions"
  on memorial_submissions for select
  using (
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );

-- Create storage bucket for memorial submissions
insert into storage.buckets (id, name, public)
values ('memorial-submissions', 'memorial-submissions', false)
on conflict (id) do nothing;

-- Allow anyone to upload (anonymous submissions)
create policy "Anyone can upload memorial files"
  on storage.objects for insert
  to anon
  with check (bucket_id = 'memorial-submissions');

-- Only admins can view uploaded files
create policy "Admins can view memorial files"
  on storage.objects for select
  using (
    bucket_id = 'memorial-submissions' and
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );

-- ============================================
-- Verification Queries
-- ============================================

-- Check table created
select * from memorial_submissions limit 1;

-- Check storage bucket
select * from storage.buckets where id = 'memorial-submissions';

-- ============================================
-- Done!
-- ============================================
