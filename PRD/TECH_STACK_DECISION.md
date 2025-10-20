# Technical Stack Decision: Supabase

**Date:** October 19, 2025
**Decision:** Use Supabase as all-in-one backend instead of SQLite + ChromaDB

---

## The Choice

### ❌ Original Stack
- SQLite (users, submissions)
- ChromaDB (vector search)
- Custom JWT auth
- Local file uploads
- Multiple databases to manage

### ✅ New Stack: Supabase
- PostgreSQL with pgvector (everything in one DB)
- Built-in Auth (no custom JWT)
- Built-in Storage (file uploads handled)
- Row-Level Security (permissions)
- Real-time subscriptions
- Auto-generated REST API

---

## Why Supabase Wins

### 1. Simplicity
**Before:** Manage 2 separate databases (SQLite + ChromaDB)
**After:** One Supabase project, everything integrated

### 2. Built-in Auth
**Before:** Build JWT system from scratch (hashing, tokens, middleware)
**After:** `supabase.auth.signUp()` - done!

```javascript
// That's it!
const { user, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password',
  options: {
    data: { full_name: 'John Doe' }
  }
})
```

### 3. Built-in Storage
**Before:** Local filesystem uploads, manual file handling
**After:** `supabase.storage.upload()` - done!

```javascript
const { data, error } = await supabase.storage
  .from('submissions')
  .upload('path/to/file', file)
```

### 4. Production-Ready
**Before:** SQLite doesn't handle concurrent writes well (not scalable)
**After:** PostgreSQL is enterprise-grade, handles concurrency perfectly

### 5. pgvector is Good Enough
**ChromaDB:** Purpose-built for vectors, amazing at scale (millions of vectors)
**pgvector:** PostgreSQL extension, great for <100K vectors

**Arthur's Archive:** ~100 documents, maybe 1000 after years of contributions
**Verdict:** pgvector is perfect for this use case

### 6. Row-Level Security (RLS)
**Before:** Manual permission checks in code
**After:** Database enforces permissions automatically

```sql
-- Users can only see their own submissions
create policy "Users can view own submissions"
  on submissions for select
  using (auth.uid() = user_id);

-- Admins can see everything
create policy "Admins can view all"
  on submissions for select
  using (
    exists (
      select 1 from user_profiles
      where id = auth.uid() and role = 'admin'
    )
  );
```

### 7. Real-time Subscriptions
**Bonus Feature:** Admin dashboard can live-update when new submissions arrive

```javascript
supabase
  .channel('submissions')
  .on('postgres_changes',
    { event: 'INSERT', schema: 'public', table: 'submissions' },
    payload => {
      // Admin sees new submission instantly
    }
  )
  .subscribe()
```

### 8. Free Tier is Generous
- 500MB database (plenty for archive)
- 1GB file storage (room for hundreds of photos)
- 50MB max file upload
- Unlimited API requests (within rate limits)
- 2GB bandwidth/month

### 9. Development Speed
**Time saved:**
- M3 (Auth): ~2 days saved (no custom JWT implementation)
- M6 (Storage): ~1 day saved (no file upload boilerplate)
- M7 (Admin): ~1 day saved (RLS instead of manual checks)
- **Total: ~4 days saved** on a 5-6 week project (13% faster!)

### 10. One Backend to Deploy
**Before:** Deploy ChromaDB somewhere, deploy SQLite with FastAPI
**After:** Supabase is already in the cloud, just deploy lightweight FastAPI

---

## What We Keep: FastAPI

**Why not Supabase only?**

We still need FastAPI middleware for:
1. **RAG Orchestration:** LangChain pipeline (retrieve → generate → respond)
2. **OpenAI Integration:** Chat completions with context
3. **Complex Business Logic:** Approval workflow (download file, generate README, commit to Git, re-embed)

**What FastAPI Does:**
```
Frontend → Supabase (auth, data, storage)
         → FastAPI (chat, RAG, approvals)
         → OpenAI (embeddings, completions)
```

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────┐
│                    Frontend (React)                 │
│              Hosted on Vercel                       │
└───────────────────┬─────────────────────────────────┘
                    │
        ┌───────────┴──────────┐
        │                      │
        ▼                      ▼
┌──────────────┐      ┌──────────────────┐
│   Supabase   │      │  FastAPI (RAG)   │
│              │      │  Railway/Render  │
│ - Auth       │      │                  │
│ - PostgreSQL │      │ - LangChain      │
│ - pgvector   │      │ - OpenAI API     │
│ - Storage    │      │ - Chat endpoint  │
│ - RLS        │      └────────┬─────────┘
└──────────────┘               │
                               ▼
                      ┌─────────────────┐
                      │   OpenAI API    │
                      │ - Embeddings    │
                      │ - GPT-4         │
                      └─────────────────┘
```

---

## Migration Impact on Milestones

### M1: Project Foundation
- No change (still set up React + FastAPI)
- Add: Create Supabase project

### M2: RAG Foundation
- **Before:** Set up ChromaDB
- **After:** Enable pgvector, create `archive_documents` table
- Simpler: SQL instead of Python vector DB client

### M3: User Authentication
- **Before:** Build JWT system from scratch (5-7 tasks)
- **After:** Configure Supabase Auth (2-3 tasks)
- **Time saved:** ~2 days

### M4: Conversational Interface
- No major change (FastAPI still handles chat endpoint)
- Easier: User context from Supabase JWT

### M5: Archive Index Sidebar
- No change (still browse `/archive` folder structure)

### M6: Memory Submission
- **Before:** Local file uploads to `/temp_uploads`
- **After:** Supabase Storage with RLS
- **Time saved:** ~1 day

### M7: Admin Approval Dashboard
- **Before:** Manual permission checks in backend
- **After:** RLS policies enforce automatically
- **Bonus:** Real-time dashboard updates
- **Time saved:** ~1 day

### M8: Integration & Testing
- Simpler: Less infrastructure to test
- Re-indexing easier: Just insert into `archive_documents`

### M9: Deploy
- Simpler: Supabase already in cloud
- Just deploy: Frontend (Vercel) + FastAPI (Railway)

---

## Potential Concerns & Responses

### Concern: "Vendor lock-in with Supabase?"
**Response:** Supabase is open source! Can self-host if needed. Plus, it's just PostgreSQL + standard libraries. Migration path exists.

### Concern: "pgvector as good as ChromaDB?"
**Response:** For <100K vectors, yes. ChromaDB shines at millions of vectors with advanced features. We don't need that scale.

**Benchmarks for small archives:**
- pgvector: ~10ms query time for 10K vectors
- ChromaDB: ~8ms query time for 10K vectors
- Difference: Negligible for our use case

### Concern: "Free tier limitations?"
**Response:**
- 500MB DB → Enough for ~50K documents (we have ~100)
- 1GB storage → ~500 high-res photos (we have ~100)
- 2GB bandwidth → ~10K page loads/month
- Can upgrade to $25/mo if needed (still cheap!)

### Concern: "Learning curve?"
**Response:** Supabase has excellent docs, and we're using it in a simple way. The auth/storage APIs are very intuitive. Net time saved > learning time.

---

## Decision: Confirmed ✅

**Use Supabase as the all-in-one backend for V1 MVP**

**Benefits:**
- 13% faster development (~4 days saved)
- Production-ready from day 1
- Less infrastructure complexity
- Better developer experience
- Built-in features (auth, storage, RLS)
- Free tier covers our needs
- Real-time capabilities as bonus

**Trade-offs:**
- External dependency (mitigated: open source, self-hostable)
- Not as specialized as ChromaDB (mitigated: pgvector good enough)

**Next Steps:**
1. Create Supabase project
2. Update PRODUCT_ROADMAP.md milestones ✅
3. Start M1: Project Foundation

---

*Stack decision finalized: October 19, 2025*
