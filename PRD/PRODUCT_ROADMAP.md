# Story Engine: Product Roadmap
**From Static Archive to AI-Powered Story Generation**

---

## Overview

This roadmap breaks down the ambitious Story Engine vision into practical, incremental product versions. Each version delivers standalone value while building toward the ultimate goal of AI-generated multimedia storytelling.

**End Vision:** Natural language → narrated video stories with automatic source citation
**Starting Point:** Conversational RAG-enabled archive with contribution workflow

---

## Version 1: Conversational Archive (MVP)
**Timeline:** 4-6 weeks
**Goal:** Prove RAG value with minimal viable interface

### Core Features

#### 1. Homepage Layout
```
┌─────────────────────────────────────────┐
│                                         │
│        [Hero Portrait of Dean]          │
│        archive/hero_portrait.png        │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│     [3 Pre-Curated Story Cards]         │
│   "Try: Tell me about Dean's career"    │
│   "Try: What did Dean do at DPMA?"      │
│   "Try: Tell me about Dean & Wanda"     │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│    [Chat Window - OpenAI API]           │
│     Q: "Tell me about Dean's career"    │
│     A: [RAG-generated response with     │
│         citations to archive docs]      │
│                                         │
└─────────────────────────────────────────┘

Sidebar (vertical):
├─ Archive Index
│  ├─ Data Processing Management Assoc
│  ├─ Austin Family
│  ├─ Austin & Associates
│  ├─ Central Management Services
│  ├─ National Guard
│  └─ ...
```

#### 2. Conversational RAG
- **OpenAI API Integration** (GPT-4 or GPT-4-turbo)
- **Vector Database** (ChromaDB or Pinecone)
  - Embed all README.md content
  - Embed key document metadata
  - Semantic search across archive
- **Response Format:**
  ```
  [Narrative answer based on documents]

  Sources:
  - Central Management Services/AI_CERTIFICATION_1985_CONTEXT.md
  - Data Processing Management Association/DPMA Overview/README.md
  - Austin & Associates/README.md
  ```

#### 3. Pre-Curated Stories (Helper Text)
Three clickable story prompts that demonstrate capability:

**Story 1: "The Career Journey"**
- Pulls from: National Guard discharge → DPMA leadership → AI certification
- Demonstrates: Timeline construction, multi-source synthesis
- Length: 3-4 paragraph response

**Story 2: "Technology Pioneer"**
- Pulls from: CDP certification → AIEC work → AI training 1985
- Demonstrates: Technical context, historical significance
- Length: 3-4 paragraph response

**Story 3: "Dean & Wanda"**
- Pulls from: Wedding ring receipt → marriage timeline → family materials
- Demonstrates: Personal story, emotional resonance
- Length: 2-3 paragraph response

#### 4. Archive Index (Vertical Sidebar)
- **Browsable folder structure** matching repo organization
- Click folder → shows documents within
- Click document → displays README content
- Click image → full-size view with context

#### 5. Memory Submission Workflow

**User Side:**
```
[+ Submit a Memory] button

Form:
├─ Type: [Story/Photo/Document/Fact]
├─ Upload: [File picker - optional]
├─ Title: [Text input]
├─ Description: [Textarea]
├─ Date (if known): [Date picker]
├─ People mentioned: [Text input]
└─ [Submit for Review]

Confirmation:
"Thank you! Your submission will be reviewed and
 added to the archive if approved."
```

**Admin Side (Backend):**
- Submissions stored in database (SQLite initially)
- Admin dashboard to review submissions
- Approve/Reject with notes
- Approved → auto-added to appropriate archive folder
- Auto-generates basic README for new submissions
- Triggers vector DB re-indexing

#### 6. Timeline View (Read-Only V1)
- Horizontal timeline of major events
- Pulled from existing archive dates
- Clickable events → shows related documents
- Visual markers for different categories (career/family/military)

### Technical Stack - V1

**Frontend:**
- React + TypeScript (Vite)
- TailwindCSS for styling
- Supabase JS Client
- Simple chat UI component
- File upload component

**Backend:**
- **Supabase** (all-in-one backend):
  - PostgreSQL with pgvector extension (vector search)
  - Built-in Authentication (email/password, magic links)
  - Built-in Storage (file uploads)
  - Row-Level Security (RLS) for permissions
  - Auto-generated REST API
- **Python FastAPI** (lightweight middleware):
  - RAG orchestration (LangChain)
  - OpenAI API integration (GPT-4 + embeddings)
  - Chat endpoint
- **OpenAI API:**
  - text-embedding-3-small (embeddings)
  - gpt-4-turbo-preview (chat)

**Infrastructure:**
- Vercel (frontend)
- Supabase Cloud (free tier: 500MB DB, 1GB storage)
- Railway/Render (FastAPI middleware)
- GitHub (content versioning)

**Why Supabase?**
- ✅ One backend instead of SQLite + ChromaDB
- ✅ Auth built-in (no custom JWT)
- ✅ File storage built-in
- ✅ pgvector good enough for <100K vectors
- ✅ Production-ready from day 1
- ✅ Real-time subscriptions (admin dashboard)
- ✅ Free tier is generous

---

## V1 MVP Requirements

**Core Functionality:**
1. ✅ Archive + Retrieval Mechanism (RAG)
2. ✅ Basic User Auth/Login
3. ✅ Conversational Retrieval (Chat Interface)
4. ✅ Submit Memory Function (Users)
5. ✅ Admin Approval UI

---

### V1 Detailed Milestones

### **Milestone 1: Project Foundation** (Week 1)
**Goal:** Set up development environment and repo structure

**Tasks:**
- [ ] Refactor repo structure: separate `/app` from `/archive` content
  ```
  ArthurDean/
  ├── archive/          # Original archive content (unchanged)
  ├── app/             # New application code
  │   ├── frontend/    # React app
  │   └── backend/     # FastAPI app
  ├── PRD/             # Product docs
  └── README.md
  ```
- [ ] Initialize React + TypeScript project (Vite)
- [ ] Initialize FastAPI project with proper structure
- [ ] Set up development Docker compose (optional but recommended)
- [ ] Create .env templates for API keys
- [ ] Git branch strategy (main, develop, feature/*)

**Deliverable:** Clean dev environment, can run frontend + backend locally

---

### **Milestone 2: RAG Foundation** (Week 1-2)
**Goal:** Archive retrieval mechanism working end-to-end

**Supabase Setup:**
- [ ] Create Supabase project
- [ ] Enable pgvector extension in SQL editor:
  ```sql
  create extension if not exists vector;
  ```
- [ ] Create `archive_documents` table:
  ```sql
  create table archive_documents (
    id bigserial primary key,
    content text not null,
    metadata jsonb,
    embedding vector(1536), -- OpenAI embedding dimension
    created_at timestamp with time zone default now()
  );

  -- Create vector similarity search index
  create index on archive_documents
  using ivfflat (embedding vector_cosine_ops);
  ```

**Ingestion Script:**
- [ ] Write Python script to ingest archive:
  - [ ] Recursively read all `/archive` README.md files
  - [ ] Extract metadata (folder name, dates, people, categories)
  - [ ] Chunk content appropriately (500-1000 tokens)
  - [ ] Generate embeddings (OpenAI text-embedding-3-small)
  - [ ] Insert into Supabase `archive_documents` table
- [ ] Run ingestion script on existing archive

**Retrieval API:**
- [ ] FastAPI endpoint `POST /api/search`
  - [ ] Input: query string
  - [ ] Generate query embedding
  - [ ] Supabase vector similarity search:
    ```sql
    select content, metadata,
           1 - (embedding <=> query_embedding) as similarity
    from archive_documents
    order by embedding <=> query_embedding
    limit 5;
    ```
  - [ ] Output: top-k relevant document chunks with metadata

**Testing:**
- [ ] Test retrieval accuracy:
  - [ ] Query: "Tell me about DPMA" → returns DPMA folder docs
  - [ ] Query: "AI certification" → returns 1985 cert context
  - [ ] Query: "wedding" → returns wedding ring receipt story
- [ ] Write 3 pre-curated story responses manually (save as JSON)

**Deliverable:** Vector search working in Supabase, API endpoint returns relevant docs

---

### **Milestone 3: User Authentication** (Week 2)
**Goal:** Basic login system for users and admin

**Supabase Auth Setup:**
Supabase handles auth automatically! We just need to configure it.

**Database Schema:**
```sql
-- Extend Supabase's built-in auth.users table with profile
create table user_profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  role text default 'user' check (role in ('user', 'admin')),
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Row-Level Security (RLS) policies
alter table user_profiles enable row level security;

-- Users can read their own profile
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

-- Auto-create profile on signup (trigger)
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

**Frontend Tasks:**
- [ ] Install `@supabase/supabase-js`
- [ ] Configure Supabase client with project URL + anon key
- [ ] Create auth context/state management:
  - [ ] `useAuth()` hook
  - [ ] `user` state
  - [ ] `signUp()`, `signIn()`, `signOut()` functions
  - [ ] `isAdmin()` helper
- [ ] Build Login/Signup UI components:
  - [ ] Email + password fields
  - [ ] Full name field (signup only)
  - [ ] "Sign Up" / "Log In" / "Log Out" buttons
  - [ ] Error handling (email exists, wrong password, etc.)
- [ ] Protected routes (redirect to login if not authenticated)
- [ ] Conditionally show admin dashboard if `role === 'admin'`

**Backend Tasks:**
- [ ] FastAPI middleware to verify Supabase JWT
  - [ ] Extract token from `Authorization: Bearer <token>` header
  - [ ] Verify with Supabase (or validate JWT locally)
  - [ ] Attach user info to request context
- [ ] Helper functions:
  - [ ] `get_current_user()` - from Supabase JWT
  - [ ] `require_admin()` - check role

**Admin Account:**
- [ ] Manually create first admin in Supabase dashboard
- [ ] Or: Add via SQL:
  ```sql
  -- After first user signs up, promote to admin
  update user_profiles
  set role = 'admin'
  where id = '<your-user-id>';
  ```

**User Types:**
- **Regular Users:** Can browse, chat, submit memories
- **Admin:** All user permissions + approve/reject submissions

**Deliverable:** Users can sign up, log in using Supabase Auth, admins identified by role

---

### **Milestone 4: Conversational Interface** (Week 2-3)
**Goal:** Chat UI with RAG-powered responses

**Tasks:**
- [ ] Build chat UI component
  - [ ] Message list (user + AI messages)
  - [ ] Input field with send button
  - [ ] Loading state while AI responds
  - [ ] Citation links in AI responses
- [ ] Create conversational endpoint `POST /api/chat`
  - [ ] Input: user message, conversation history
  - [ ] Retrieval: Query vector DB for relevant docs
  - [ ] Generation: Call OpenAI GPT-4 with context
  - [ ] Response format: Answer + citations
  - [ ] Output: AI response with source links
- [ ] Implement conversation memory (last 5-10 messages)
- [ ] Display 3 pre-curated story cards (clickable)
  - [ ] Click card → auto-fills chat with that query
  - [ ] Shows pre-written response (from M2)
- [ ] Add "Clear conversation" button
- [ ] Format citations as clickable links

**LLM Prompt Template:**
```
You are a helpful assistant that tells stories about Arthur Dean Austin
based on his digital archive. Use the provided context to answer questions
accurately and cite your sources.

Context from archive:
{retrieved_documents}

User question: {user_query}

Provide a narrative answer and cite sources at the end like:

Sources:
- folder/subfolder/README.md
- folder/document.pdf
```

**Deliverable:** Working chat interface with RAG responses

---

### **Milestone 5: Archive Index Sidebar** (Week 3)
**Goal:** Browsable archive structure

**Tasks:**
- [ ] Build recursive folder tree component
  - [ ] Reads `/archive` structure from API
  - [ ] Expandable/collapsible folders
  - [ ] Click folder → shows contents
- [ ] Create archive browse endpoints:
  - [ ] `GET /api/archive/structure` - Returns folder tree
  - [ ] `GET /api/archive/folder/{path}` - Returns files in folder
  - [ ] `GET /api/archive/document/{path}` - Returns README content
  - [ ] `GET /api/archive/image/{path}` - Serves image files
- [ ] Document viewer modal
  - [ ] Click README → shows formatted markdown
  - [ ] Click image → shows full-size with context
- [ ] Sidebar toggle (mobile responsive)

**Deliverable:** Users can browse entire archive structure

---

### **Milestone 6: Memory Submission** (Week 3-4)
**Goal:** Users can submit memories for admin approval

**Supabase Storage Setup:**
```sql
-- Create storage bucket for submissions
insert into storage.buckets (id, name, public)
values ('submissions', 'submissions', false);

-- RLS: Users can upload to submissions bucket
create policy "Users can upload submissions"
  on storage.objects for insert
  with check (
    bucket_id = 'submissions' and
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- RLS: Users can view their own uploads
create policy "Users can view own submissions"
  on storage.objects for select
  using (
    bucket_id = 'submissions' and
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- RLS: Admins can view all
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

**Database Schema:**
```sql
create table submissions (
  id bigserial primary key,
  user_id uuid references auth.users not null,
  submission_type text not null check (submission_type in ('story', 'photo', 'document', 'fact')),
  title text not null,
  description text,
  file_path text, -- path in Supabase Storage
  date_mentioned date,
  people_mentioned text,
  status text default 'pending' check (status in ('pending', 'approved', 'rejected')),
  admin_notes text,
  submitted_at timestamp with time zone default now(),
  reviewed_at timestamp with time zone,
  reviewed_by uuid references auth.users
);

-- RLS policies
alter table submissions enable row level security;

-- Users can insert their own submissions
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
```

**Frontend Tasks:**
- [ ] Build submission form UI:
  - [ ] Type selector (Story/Photo/Document/Fact)
  - [ ] Title input (required)
  - [ ] Description textarea (required)
  - [ ] File upload (optional, max 10MB)
  - [ ] Date picker (optional)
  - [ ] People mentioned (optional)
  - [ ] Submit button
- [ ] File upload with Supabase Storage:
  ```javascript
  // Upload to: submissions/{user_id}/{filename}
  const { data, error } = await supabase.storage
    .from('submissions')
    .upload(`${user.id}/${file.name}`, file);
  ```
- [ ] Submit form data to Supabase:
  ```javascript
  const { data, error } = await supabase
    .from('submissions')
    .insert({
      user_id: user.id,
      submission_type: type,
      title: title,
      description: description,
      file_path: filePath, // from upload
      date_mentioned: date,
      people_mentioned: people
    });
  ```
- [ ] Confirmation message after submission
- [ ] Show user's past submissions (optional)

**Backend Tasks (Optional):**
- [ ] Email notification to admin via Supabase Edge Function (optional for V1)

**Deliverable:** Users can submit memories with file uploads, saved to Supabase

---

### **Milestone 7: Admin Approval Dashboard** (Week 4-5)
**Goal:** Admin UI to review and approve submissions

**Admin Dashboard Layout:**
```
┌─────────────────────────────────────────┐
│  Admin Dashboard - Pending Submissions  │
├─────────────────────────────────────────┤
│                                         │
│  [Pending: 3] [Approved: 12] [Rejected: 1]
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Submission #15                   │   │
│  │ Type: Photo                      │   │
│  │ Title: "Dean at DPMA Conference" │   │
│  │ Submitted by: Sarah Austin       │   │
│  │ Date: Oct 15, 2025              │   │
│  │                                  │   │
│  │ [View Full Details]              │   │
│  │                                  │   │
│  │ Admin Actions:                   │   │
│  │ Category: [Dropdown]             │   │
│  │ Archive Path: [Auto-suggested]   │   │
│  │ Notes: [Textarea]                │   │
│  │                                  │   │
│  │ [✓ Approve] [✗ Reject]          │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

**Tasks:**
- [ ] Build admin dashboard page (protected, admin-only route)
- [ ] Query Supabase directly from frontend:
  ```javascript
  // List all submissions (admins only, RLS enforces this)
  const { data: submissions } = await supabase
    .from('submissions')
    .select('*, user_profiles(full_name)')
    .order('submitted_at', { ascending: false });

  // Filter by status
  const { data: pending } = await supabase
    .from('submissions')
    .select('*')
    .eq('status', 'pending');
  ```
- [ ] Submission detail view:
  - [ ] Show all submitted data
  - [ ] Preview uploaded file (download from Supabase Storage):
    ```javascript
    const { data } = supabase.storage
      .from('submissions')
      .getPublicUrl(filePath);
    ```
  - [ ] Show submitter info (joined from `user_profiles`)
- [ ] Approval workflow UI:
  - [ ] Admin selects archive category/folder (dropdown)
  - [ ] System suggests appropriate path based on type
  - [ ] Admin can add notes (textarea)
  - [ ] "Approve" button
- [ ] Approval backend logic (FastAPI endpoint):
  - [ ] `POST /api/admin/approve/{submission_id}`
  - [ ] Steps:
    1. Download file from Supabase Storage `submissions` bucket
    2. Save to local `/archive/{selected_path}/` directory
    3. Auto-generate README.md for new submission
    4. Commit to Git (optional but recommended)
    5. Upload README to Supabase (for re-indexing)
    6. Embed README content into `archive_documents` table
    7. Update submission record:
       ```javascript
       await supabase
         .from('submissions')
         .update({
           status: 'approved',
           reviewed_at: new Date(),
           reviewed_by: adminUserId,
           admin_notes: notes
         })
         .eq('id', submissionId);
       ```
    8. (Optional) Move file in Storage from `submissions` to `archive` bucket
    9. (Optional) Delete from `submissions` bucket
- [ ] Rejection workflow:
  - [ ] "Reject" button in UI
  - [ ] Admin adds rejection reason (required)
  - [ ] `POST /api/admin/reject/{submission_id}`:
    ```javascript
    await supabase
      .from('submissions')
      .update({
        status: 'rejected',
        reviewed_at: new Date(),
        reviewed_by: adminUserId,
        admin_notes: rejectionReason
      })
      .eq('id', submissionId);

    // Delete file from storage
    await supabase.storage
      .from('submissions')
      .remove([filePath]);
    ```
  - [ ] (Optional) Notify user via email
- [ ] Filter submissions by status (pending/approved/rejected)
- [ ] Real-time updates (optional but cool):
  ```javascript
  // Admin dashboard live-updates when new submission arrives
  supabase
    .channel('submissions')
    .on('postgres_changes',
      { event: 'INSERT', schema: 'public', table: 'submissions' },
      payload => {
        // Update UI with new submission
      }
    )
    .subscribe();
  ```

**Auto-README Generation:**
```markdown
# {Submission Title}

**Submitted by:** {User Full Name}
**Date Submitted:** {Timestamp}
**Date of Memory:** {Date Mentioned}

## Description

{User Description}

## People Mentioned

{People Mentioned}

## Metadata

- **Submission Type:** {Type}
- **Original Filename:** {Original File Name}
- **Added to Archive:** {Approval Date}
```

**Deliverable:** Admin can review, approve, reject submissions from UI

---

### **Milestone 8: Integration & Testing** (Week 5)
**Goal:** All pieces work together seamlessly

**Tasks:**
- [ ] End-to-end testing:
  - [ ] User signup → login → browse archive → ask question → get response
  - [ ] User submits memory → admin sees it → approves → appears in archive
  - [ ] New approved content is searchable via RAG
- [ ] Vector DB re-indexing on approval:
  - [ ] When admin approves submission, backend:
    1. Generates embeddings for new README content
    2. Inserts into `archive_documents` table:
       ```python
       embedding = openai.embeddings.create(
         input=readme_content,
         model="text-embedding-3-small"
       )

       supabase.table('archive_documents').insert({
         'content': readme_content,
         'metadata': {...},
         'embedding': embedding.data[0].embedding
       }).execute()
       ```
  - [ ] Test that new content is immediately retrievable in chat
- [ ] Basic timeline view (read-only):
  - [ ] Extract dates from all archive READMEs
  - [ ] Display horizontal timeline
  - [ ] Click event → shows related docs
- [ ] Error handling:
  - [ ] API errors show user-friendly messages
  - [ ] Form validation
  - [ ] Network error handling
  - [ ] Loading states everywhere
- [ ] Responsive design testing (mobile, tablet, desktop)
- [ ] Browser testing (Chrome, Firefox, Safari)

**Deliverable:** Fully functional MVP, tested end-to-end

---

### **Milestone 9: Polish & Deploy** (Week 5-6)
**Goal:** Production-ready deployment

**Tasks:**
- [ ] Frontend polish:
  - [ ] Consistent styling (TailwindCSS)
  - [ ] Smooth transitions/animations
  - [ ] Accessibility (a11y) basics
  - [ ] SEO meta tags
  - [ ] Favicon, app icons
- [ ] Backend polish:
  - [ ] API rate limiting
  - [ ] CORS configuration
  - [ ] Environment variable validation
  - [ ] Logging (structured logs)
  - [ ] Health check endpoint
- [ ] Security review:
  - [ ] SQL injection protection (use ORMs)
  - [ ] XSS protection
  - [ ] CSRF tokens (if needed)
  - [ ] File upload validation
  - [ ] JWT secret in env vars
- [ ] Deploy backend to Railway/Render:
  - [ ] FastAPI middleware only (lightweight)
  - [ ] Configure environment variables (Supabase URL/keys, OpenAI key)
  - [ ] Connect to Supabase (already in cloud)
  - [ ] Test deployment
- [ ] Supabase already deployed (cloud):
  - [ ] Verify RLS policies are enabled
  - [ ] Check storage bucket permissions
  - [ ] Review database indexes
- [ ] Deploy frontend to Vercel:
  - [ ] Connect to backend API
  - [ ] Configure environment variables
  - [ ] Set up custom domain (optional)
- [ ] Documentation:
  - [ ] README for app setup
  - [ ] API documentation (Swagger/OpenAPI)
  - [ ] Admin guide for reviewing submissions
- [ ] Family beta test:
  - [ ] Invite 3-5 family members
  - [ ] Gather feedback
  - [ ] Fix critical bugs
  - [ ] Iterate on UX

**Deliverable:** Live production app, family using it

---

### V1 MVP Feature Checklist

**Authentication & Users:**
- [ ] User signup/login
- [ ] JWT authentication
- [ ] Admin role vs regular user
- [ ] Protected routes

**Archive & Retrieval:**
- [ ] Vector database with all archive content
- [ ] Semantic search API
- [ ] Archive browsing (folder tree)
- [ ] Document viewer (README, images)

**Conversational Interface:**
- [ ] Chat UI with message history
- [ ] RAG-powered responses
- [ ] 3 pre-curated story prompts
- [ ] Citations in responses
- [ ] Click citation → view source

**Memory Submission:**
- [ ] Submission form (type, title, description, file, date, people)
- [ ] File upload (images, PDFs, text)
- [ ] Save to database as 'pending'
- [ ] Confirmation message

**Admin Approval:**
- [ ] Admin dashboard (submissions list)
- [ ] Submission detail view
- [ ] Approve → adds to archive + generates README
- [ ] Reject → deletes temp file
- [ ] Trigger RAG re-indexing on approval
- [ ] Filter by status

**Polish:**
- [ ] Responsive design
- [ ] Error handling
- [ ] Loading states
- [ ] Basic timeline view
- [ ] Deployed to production

### Success Metrics - V1
- **Usage:** 10+ family members actively ask questions
- **Quality:** 80%+ response accuracy (human evaluated)
- **Engagement:** Average session >5 minutes
- **Contributions:** 5+ memory submissions in first month
- **Feedback:** "This made me feel closer to Dean" reactions

---

## Version 2: Enhanced Stories
**Timeline:** 6-8 weeks after V1
**Goal:** Richer storytelling with multimedia

### New Features

#### 1. Story Gallery
- Grid of generated story cards
- Filter by: Topic, Length, Date Created
- Each story is a saved RAG conversation
- Shareable story links

#### 2. Enhanced Story Responses
- **Image Integration:** Automatically include relevant photos in responses
- **Quote Extraction:** Pull direct quotes from documents
- **Timeline Visualization:** Inline timelines within story responses
- **Related Documents:** "Explore more" section with similar content

#### 3. Story Templates
Pre-built prompts with custom formatting:
- "5 Things About Arthur" → bullet list format
- "Day in the Life: DPMA President" → narrative format
- "Technology Then vs Now" → comparison format
- "The Love Story" → romantic narrative format

#### 4. Story Customization
Users can tune:
- Length: Brief (2 para) / Standard (4 para) / Deep Dive (8+ para)
- Tone: Academic / Personal / Inspirational
- Audience: Kids / Adults / Researchers

#### 5. Timeline Editor (Admin)
- Add/edit timeline events
- Link events to documents
- Visual timeline builder
- Public timeline view

### V2 Milestones
- [ ] Story persistence & gallery
- [ ] Image integration in responses
- [ ] Story templates system
- [ ] Customization controls
- [ ] Timeline editing tools

### Success Metrics - V2
- 50+ unique stories generated
- Stories shared on social media
- Non-technical family members creating custom stories
- 20+ timeline events documented

---

## Version 3: Audio Stories
**Timeline:** 8-10 weeks after V2
**Goal:** Text-to-speech narrated stories

### New Features

#### 1. Audio Narration
- **Text-to-Speech:** ElevenLabs or OpenAI TTS
- **Story → Audio:** Convert any story to narrated audio
- **Voice Selection:** Choose narrator voice
- **Background Music:** Optional period-appropriate music

#### 2. Podcast-Style Stories
- 5-10 minute audio narratives
- Chapter markers for long stories
- Download as MP3
- Podcast RSS feed (family-only)

#### 3. Story Player
- Audio player with transcript
- Highlight text as it's narrated
- Pause/resume/scrub
- Speed controls

#### 4. Voice Contributions
- Family members record memories
- Audio submissions in memory workflow
- Voice clips integrated into stories

### V3 Milestones
- [ ] TTS integration
- [ ] Audio player component
- [ ] Story → audio pipeline
- [ ] Voice recording for submissions
- [ ] Background music library

### Success Metrics - V3
- 20+ audio stories created
- 100+ audio story plays
- 5+ voice contributions from family
- Stories downloaded and shared

---

## Version 4: Video Stories (Pre-Full Engine)
**Timeline:** 10-12 weeks after V3
**Goal:** Simple video generation

### New Features

#### 1. Basic Video Generation
- **Ken Burns Effect:** Pan/zoom on photos
- **Document Animations:** Fade in/out, subtle movements
- **Text Overlays:** Key quotes, dates, names
- **Auto-Assembly:** FFmpeg pipeline
- **Audio Track:** Narration + music

#### 2. Video Templates
- "Photo Slideshow" → images with narration
- "Document Story" → focus on key documents
- "Timeline Journey" → chronological visual flow

#### 3. Video Customization
- Select which images to include
- Adjust timing/pacing
- Choose music
- Add custom title cards

#### 4. Export & Sharing
- MP4 download (720p/1080p)
- YouTube upload integration
- Social media optimized versions
- Embed code for sharing

### V4 Milestones
- [ ] FFmpeg video pipeline
- [ ] Ken Burns effects on images
- [ ] Text overlay system
- [ ] Audio + video sync
- [ ] Export in multiple formats
- [ ] YouTube integration

### Success Metrics - V4
- 10+ video stories created
- Videos shared on social media
- Family reactions: "This is amazing!"
- External interest from other families

---

## Version 5: Full Story Engine
**Timeline:** 12-16 weeks after V4
**Goal:** Natural language → polished video (the vision!)

### New Features

#### 1. Natural Language Video Generation
```
Input: "Create a 3-minute video about Dean's
        technology leadership, inspirational tone,
        with photos and his DPMA materials"

Output: [Polished narrated video, auto-generated]
```

#### 2. Advanced Story Intelligence
- **Multi-Document Synthesis:** Weave together 10+ sources
- **Narrative Arc Detection:** Automatically structure beginning/middle/end
- **Emotional Tone Matching:** Match requested mood
- **Historical Context Injection:** Add relevant period context

#### 3. Remix Culture
- "Make a kid-friendly version"
- "Add more technical details"
- "Focus on family, not career"
- "Create a 30-second teaser"

#### 4. Story Analytics
- Which stories resonate most?
- What topics are most queried?
- Who's watching what?
- Engagement heatmaps

#### 5. Collaborative Stories
- Multiple family members contribute
- Community fact-checking
- Shared story collections
- Family story contests

### V5 Milestones
- [ ] Full RAG → video pipeline
- [ ] Narrative structure AI
- [ ] Automatic story arc generation
- [ ] Remix/variation system
- [ ] Analytics dashboard
- [ ] Collaboration features

### Success Metrics - V5
- 100+ generated stories
- <5 min query → video time
- Stories go viral (100k+ views)
- Media coverage
- Other families want to use it

---

## Version 6: Platform
**Timeline:** 6+ months after V5
**Goal:** Multi-archive platform for all families

### New Features

#### 1. Multi-Tenant Architecture
- Any family can create an archive
- Archive upload wizard
- Automatic README generation from uploads
- Custom branding per archive

#### 2. Archive Creation Tools
- Bulk upload with auto-organization
- OCR for document text extraction
- Auto-tagging and categorization
- Suggested timeline events

#### 3. Community Features
- Cross-archive connections
- "Similar stories" recommendations
- Public archive directory
- Story competitions/challenges

#### 4. Business Model
- Freemium: 3 stories/month free
- Pro: $9/mo unlimited stories
- Family: $19/mo multi-archive
- Archive creation service: $500-2000

### V6 Milestones
- [ ] Multi-tenant system
- [ ] Archive setup wizard
- [ ] White-label branding
- [ ] Payment integration
- [ ] Marketing site
- [ ] Customer support system

### Success Metrics - V6
- 100+ family archives
- 10+ paying customers
- Profitable unit economics
- Press coverage
- Partnerships with genealogy platforms

---

## Development Principles

### Progressive Enhancement
Each version should be:
- **Independently Valuable:** V1 alone should delight users
- **Additive:** New versions don't break old features
- **Tested:** Real family usage before moving forward

### Quality Over Speed
- Ship when ready, not by arbitrary deadlines
- Family feedback is the compass
- Technical debt is okay in V1, clean up in V2

### Focus on Dean First
- Arthur Dean Austin's archive is the flagship
- Perfect the experience here before platforming
- Family satisfaction > external validation

---

## Decision Points

### After V1 Launch
**Decision:** Does RAG actually provide value?
- **If Yes:** Continue to V2
- **If No:** Iterate on V1 until it does

### After V2 Launch
**Decision:** Do people want audio/video or is text enough?
- **If Audio Interest High:** → V3
- **If Text Sufficient:** Skip to enhanced features

### After V4 Launch
**Decision:** Build full automation or platform first?
- **If Family Still Primary User:** → V5 (full automation)
- **If External Interest High:** → V6 (platform)

---

## Resource Requirements

### V1 (MVP)
- **Time:** 4-6 weeks (1 developer)
- **Cost:** $50-100/mo (OpenAI API, hosting)
- **Skills:** React, Python, RAG/LangChain

### V2-V3 (Enhanced Stories + Audio)
- **Time:** 12-16 weeks
- **Cost:** $150-250/mo (TTS, storage, hosting)
- **Skills:** + Audio processing, TTS integration

### V4-V5 (Video Generation)
- **Time:** 20-30 weeks
- **Cost:** $300-500/mo (compute for video, storage)
- **Skills:** + FFmpeg, video editing, ML pipelines

### V6 (Platform)
- **Time:** 6-12 months
- **Cost:** $1000+/mo (infrastructure, support)
- **Skills:** + DevOps, payment systems, customer success

---

## Current Status & Next Steps

### ✅ Completed
- Archive created (93+ images, 15 folders, detailed READMEs)
- Vision document written
- Product roadmap defined

### 🔄 Current Focus: V1 Foundation

**This Week:**
1. Refactor repo structure (separate app from archive)
2. Set up vector database
3. Embed README content
4. Test RAG retrieval accuracy
5. Design V1 interface mockup

**Next Week:**
1. Build React frontend scaffold
2. Create FastAPI backend
3. Implement chat interface
4. Write 3 pre-curated stories
5. Test with 2-3 family members

**Week 3-4:**
1. Build submission workflow
2. Admin review dashboard
3. Timeline view
4. Polish & bug fixes
5. Family beta launch

---

## The Path Forward

```
V1: Conversational Archive
    ↓ (Proves RAG value)
V2: Enhanced Stories
    ↓ (Proves story formats work)
V3: Audio Stories
    ↓ (Proves multimedia value)
V4: Video Stories
    ↓ (Proves automation is possible)
V5: Full Story Engine
    ↓ (Proves the complete vision)
V6: Platform
    ↓ (Shares the gift with the world)
```

**Starting Point:** This week, we build V1 foundation
**End Goal:** Natural language → beautiful video stories
**North Star:** Keep Arthur Dean Austin's legacy alive for generations

---

*Roadmap v1.0 - Created October 2025*
