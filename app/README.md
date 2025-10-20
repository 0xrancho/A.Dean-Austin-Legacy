# Arthur Dean Austin Archive - Application

This directory contains the full-stack application for the Arthur Dean Austin Digital Archive.

## Project Structure

```
app/
├── frontend/           # React + TypeScript + Vite
│   ├── src/
│   │   ├── components/ # React components
│   │   ├── lib/       # Supabase client, utilities
│   │   ├── types/     # TypeScript type definitions
│   │   ├── App.tsx
│   │   └── main.tsx
│   ├── package.json
│   └── vite.config.ts
│
└── backend/            # Python FastAPI
    ├── api/           # API route handlers
    ├── models/        # Pydantic models
    ├── services/      # Business logic
    ├── utils/         # Helper functions
    ├── main.py        # FastAPI app
    ├── config.py      # Configuration
    └── requirements.txt
```

## Prerequisites

- Node.js 18+ (for frontend)
- Python 3.11+ (for backend)
- Git
- Supabase account (already configured)
- OpenAI API key

## Quick Start

### 1. Environment Setup

Ensure you have a `.env` file in the project root (`/home/rancho/ArthurDean/.env`):

```bash
# Supabase
VITE_SUPABASE_URL=https://pfhmxffrczflqqaqjqgr.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# OpenAI
OPENAI_API_KEY=sk-your_key_here

# API
VITE_API_URL=http://localhost:8000
```

**Get your Supabase keys from:**
https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/settings/api

### 2. Database Setup

Run the database initialization script in Supabase SQL Editor:

1. Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/editor
2. Copy the contents of `/tools/init_supabase.sql`
3. Paste and run in SQL Editor
4. Verify tables were created successfully

### 3. Frontend Setup

```bash
cd app/frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

Frontend will be available at: **http://localhost:5173**

### 4. Backend Setup

```bash
cd app/backend

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Start development server
python main.py
```

Backend API will be available at: **http://localhost:8000**

API documentation: **http://localhost:8000/docs**

## Development Workflow

### Running Both Frontend and Backend

Open two terminal windows:

**Terminal 1 (Frontend):**
```bash
cd app/frontend
npm run dev
```

**Terminal 2 (Backend):**
```bash
cd app/backend
source venv/bin/activate
python main.py
```

### Common Commands

**Frontend:**
```bash
npm run dev          # Start dev server
npm run build        # Build for production
npm run preview      # Preview production build
npm run lint         # Run ESLint
```

**Backend:**
```bash
python main.py                    # Start server
uvicorn main:app --reload         # Alternative start command
pip freeze > requirements.txt     # Update dependencies
```

## Technology Stack

### Frontend
- **React 18** - UI library
- **TypeScript** - Type safety
- **Vite** - Build tool and dev server
- **TailwindCSS** - Utility-first CSS framework
- **Supabase JS** - Database and auth client

### Backend
- **FastAPI** - Modern Python web framework
- **Uvicorn** - ASGI server
- **Supabase Python** - Database client
- **OpenAI** - LLM and embeddings API
- **LangChain** - RAG orchestration

### Infrastructure
- **Supabase** - Backend-as-a-Service
  - PostgreSQL database with pgvector
  - Authentication
  - File storage
  - Row-Level Security (RLS)

## Project Milestones

### ✅ M1: Project Foundation (COMPLETED)
- [x] Directory structure created
- [x] Frontend initialized (Vite + React + TypeScript + TailwindCSS)
- [x] Backend initialized (FastAPI + dependencies)
- [x] Supabase client configurations
- [x] Development README

### 🔄 M2: RAG Foundation (IN PROGRESS)
- [ ] Run database initialization script
- [ ] Create archive ingestion script
- [ ] Implement vector search endpoint
- [ ] Test retrieval accuracy

### ⏳ M3: User Authentication
- [ ] Install and configure Supabase auth in frontend
- [ ] Create auth context and hooks
- [ ] Build login/signup UI
- [ ] Implement JWT verification in backend

### ⏳ M4: Conversational Interface
- [ ] Build chat UI component
- [ ] Create conversational RAG endpoint
- [ ] Implement conversation memory
- [ ] Create pre-curated story cards

### ⏳ M5: Archive Index Sidebar
- [ ] Build folder tree component
- [ ] Create archive browse endpoints
- [ ] Build document viewer modal

### ⏳ M6: Memory Submission
- [ ] Build submission form UI
- [ ] Implement file upload
- [ ] Create submission endpoints

### ⏳ M7: Admin Approval Dashboard
- [ ] Build admin dashboard UI
- [ ] Implement approval workflow
- [ ] Implement rejection workflow
- [ ] Auto-generate READMEs

### ⏳ M8: Integration & Testing
- [ ] End-to-end testing
- [ ] Vector DB re-indexing
- [ ] Basic timeline view
- [ ] Error handling and responsive design

### ⏳ M9: Polish & Deploy
- [ ] Frontend polish
- [ ] Backend polish
- [ ] Security review
- [ ] Deploy to production

## Troubleshooting

### Frontend Issues

**"Missing Supabase environment variables"**
- Check that `.env` file exists in project root
- Verify `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` are set
- Restart dev server after changing .env

**Port 5173 already in use**
```bash
# Kill process on port 5173
lsof -ti:5173 | xargs kill -9
```

### Backend Issues

**"Could not load .env file"**
- Ensure `.env` file is in project root (`/home/rancho/ArthurDean/.env`)
- Check file permissions: `chmod 600 .env`

**"Missing required environment variable"**
- Verify all required vars are set in `.env`
- Check for typos in variable names

**Port 8000 already in use**
```bash
# Kill process on port 8000
lsof -ti:8000 | xargs kill -9
```

### Database Issues

**"Row-level security policy violation"**
- Run the init_supabase.sql script to create RLS policies
- Ensure user is authenticated when making requests

**"pgvector extension not found"**
- Run `create extension if not exists vector;` in Supabase SQL Editor

## Next Steps

1. **Complete M2 (RAG Foundation)**
   - Run database initialization
   - Create ingestion script
   - Implement vector search

2. **Develop Authentication (M3)**
   - Set up auth context
   - Build login/signup UI

3. **Build Chat Interface (M4)**
   - Implement conversational RAG
   - Create story cards

## Resources

- **Product Roadmap:** `/PRD/PRODUCT_ROADMAP.md`
- **Setup Guide:** `/SETUP_GUIDE.md`
- **Supabase Reference:** `/PRD/SUPABASE_REFERENCE.md`
- **Database Schema:** `/tools/init_supabase.sql`

## Support

For issues or questions:
1. Check troubleshooting section above
2. Review product documentation in `/PRD`
3. Check Supabase dashboard for database issues

---

**Development started:** October 19, 2025
**Current milestone:** M1 (Completed) → M2 (In Progress)
