# Arthur Dean Austin Archive - Backend API

FastAPI backend for the Arthur Dean Austin Digital Archive.

## Setup

### 1. Create Python Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Environment Variables

Ensure you have a `.env` file in the project root (`/home/rancho/ArthurDean/.env`) with:

```bash
VITE_SUPABASE_URL=your_supabase_url
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
OPENAI_API_KEY=your_openai_api_key
```

### 4. Run Development Server

```bash
python main.py
```

Or with uvicorn directly:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## API Documentation

Once running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Project Structure

```
backend/
├── main.py              # FastAPI application entry point
├── config.py            # Configuration management
├── requirements.txt     # Python dependencies
├── api/                 # API route handlers
│   ├── search.py       # Vector search endpoints
│   ├── chat.py         # Conversational RAG endpoints
│   ├── archive.py      # Archive browsing endpoints
│   ├── submissions.py  # Memory submission endpoints
│   └── admin.py        # Admin approval endpoints
├── models/              # Pydantic models for request/response
├── services/            # Business logic and external services
│   ├── database.py     # Supabase client
│   ├── openai_service.py  # OpenAI API integration
│   └── rag_service.py  # RAG orchestration
└── utils/               # Utility functions
    └── auth.py         # JWT verification, role checks
```

## Development Milestones

- [x] M1.3: Basic FastAPI setup
- [ ] M2.3: Vector search endpoint
- [ ] M3.4: JWT verification middleware
- [ ] M4.2: Conversational RAG endpoint
- [ ] M5.2: Archive browse endpoints
- [ ] M6.3: Submission endpoints
- [ ] M7.2-M7.3: Admin approval/rejection workflows
