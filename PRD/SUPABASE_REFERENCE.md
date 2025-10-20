# Supabase Project Reference

**Project:** Arthur Dean Austin Archive
**Project ID:** pfhmxffrczflqqaqjqgr
**Region:** US East

---

## 🔗 Quick Links

### Dashboard URLs

- **Main Dashboard:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr
- **SQL Editor:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/editor
- **Table Editor:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/editor
- **Auth Users:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/auth/users
- **Storage:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/storage/buckets
- **API Settings:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/settings/api
- **Database Settings:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/settings/database

---

## 🔑 Credentials (stored in .env)

**Project URL:**
```
https://pfhmxffrczflqqaqjqgr.supabase.co
```

**Database Connection:**
```
postgresql://postgres:[PASSWORD]@db.pfhmxffrczflqqaqjqgr.supabase.co:5432/postgres
```

**API Keys:**
- Get from: Dashboard → Settings → API
- `anon` key: Use in frontend (public)
- `service_role` key: Use in backend only (secret!)

---

## 📊 Database Schema

### Tables

1. **user_profiles**
   - Extends Supabase `auth.users`
   - Fields: id, full_name, role, created_at, updated_at
   - RLS enabled

2. **archive_documents**
   - Stores archive content with vector embeddings
   - Fields: id, content, metadata (jsonb), embedding (vector), created_at
   - RLS enabled (public read for authenticated users)

3. **submissions**
   - User-submitted memories awaiting approval
   - Fields: id, user_id, submission_type, title, description, file_path, date_mentioned, people_mentioned, status, admin_notes, timestamps
   - RLS enabled (users see own, admins see all)

### Storage Buckets

1. **submissions** (private)
   - User uploads pending admin approval
   - Path structure: `{user_id}/{filename}`

2. **archive** (private/public)
   - Approved archive content

---

## 🛠️ Common Operations

### Connect from Python

```python
from supabase import create_client, Client
import os

url = os.getenv("VITE_SUPABASE_URL")
key = os.getenv("SUPABASE_SERVICE_ROLE_KEY")
supabase: Client = create_client(url, key)
```

### Connect from JavaScript/TypeScript

```typescript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)
```

### Vector Similarity Search

```sql
-- Find similar documents
select
  content,
  metadata,
  1 - (embedding <=> query_embedding) as similarity
from archive_documents
order by embedding <=> query_embedding
limit 5;
```

### Query with Python

```python
# Insert document with embedding
supabase.table('archive_documents').insert({
    'content': 'Document content...',
    'metadata': {'source': 'DPMA', 'year': 1975},
    'embedding': embedding_vector  # list of 1536 floats
}).execute()

# Query documents
response = supabase.table('archive_documents') \
    .select('*') \
    .execute()
```

### Upload to Storage

```python
# Upload file
with open('photo.jpg', 'rb') as f:
    supabase.storage.from_('submissions').upload(
        f'{user_id}/photo.jpg',
        f
    )

# Get public URL
url = supabase.storage.from_('archive').get_public_url('path/to/file.jpg')
```

---

## 🔐 Row-Level Security (RLS)

**How it works:**
- Policies are enforced at the database level
- Even with `service_role_key`, you can choose to respect or bypass RLS
- Frontend always respects RLS (uses `anon_key`)

**Check which user is authenticated:**
```sql
select auth.uid(); -- Returns current user's UUID
```

**Example policy:**
```sql
create policy "Users can view own submissions"
  on submissions for select
  using (auth.uid() = user_id);
```

---

## 📈 Useful Queries

### Check user roles
```sql
select
  auth.users.email,
  user_profiles.role,
  user_profiles.full_name
from auth.users
join user_profiles on auth.users.id = user_profiles.id;
```

### Count submissions by status
```sql
select status, count(*)
from submissions
group by status;
```

### List all archive documents
```sql
select
  id,
  substring(content, 1, 100) as preview,
  metadata->>'source' as source,
  created_at
from archive_documents
order by created_at desc;
```

### Recent submissions
```sql
select
  submissions.*,
  auth.users.email,
  user_profiles.full_name
from submissions
join auth.users on submissions.user_id = auth.users.id
join user_profiles on submissions.user_id = user_profiles.id
order by submitted_at desc
limit 10;
```

---

## 🚨 Troubleshooting

### "Row-level security policy violation"
- Check that RLS policies are created
- Verify user is authenticated: `select auth.uid();`
- Check policy conditions match your use case

### "permission denied for table"
- RLS might be enabled but no policies exist
- Create policies or disable RLS: `alter table xyz disable row level security;`

### Vector search not working
- Check pgvector extension: `select * from pg_extension where extname = 'vector';`
- Verify embedding dimension matches (1536 for OpenAI)
- Check index exists: `\d archive_documents`

### Can't upload to storage
- Check storage policies in Supabase dashboard
- Verify bucket exists
- Check file size limits (default 50MB)

---

## 📚 Resources

- **Supabase Docs:** https://supabase.com/docs
- **pgvector Docs:** https://github.com/pgvector/pgvector
- **Python Client:** https://github.com/supabase-community/supabase-py
- **JS Client:** https://github.com/supabase/supabase-js

---

*Reference created: October 19, 2025*
