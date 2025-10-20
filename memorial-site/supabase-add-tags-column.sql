-- ============================================
-- Memorial Site - Add Tags Column Migration
-- ============================================
-- Run this in Supabase SQL Editor if you already created the memorial_submissions table
-- If you haven't created the table yet, just use supabase-memorial-setup.sql instead
-- ============================================

-- Add tags column to existing memorial_submissions table
alter table memorial_submissions add column if not exists tags text;

-- ============================================
-- Verification
-- ============================================

-- Check column was added
select column_name, data_type
from information_schema.columns
where table_name = 'memorial_submissions' and column_name = 'tags';

-- ============================================
-- Done!
-- ============================================
