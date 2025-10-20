# Arthur Dean Austin Legacy - Project Structure

## Overview

This repository contains both the **archive content** (documents, photos, READMEs) and the **application code** (Story Engine platform).

## Directory Structure

```
ArthurDean/
├── README.md                          # Main project overview
├── PROJECT_STRUCTURE.md               # This file
│
├── PRD/                               # Product Requirements & Vision
│   ├── STORY_ENGINE_VISION.md        # Core product vision
│   └── ROADMAP.md                    # Development roadmap (TBD)
│
├── archive/                           # ARCHIVE CONTENT (historical documents)
│   ├── README.md                     # Archive guide
│   ├── Data Processing Management Association/
│   ├── Austin Family/
│   ├── Austin & Associates/
│   ├── Association of Illinois Electric Cooperatives/
│   ├── Central Management Services/
│   ├── National Guard/
│   └── Association of Internet Technology Professionals/
│
├── app/                              # APPLICATION CODE (Story Engine)
│   ├── README.md                    # App-specific docs
│   ├── backend/                     # Python FastAPI backend
│   │   ├── api/                    # API routes
│   │   ├── services/               # Business logic
│   │   │   ├── rag/               # RAG document retrieval
│   │   │   ├── story/             # Story generation
│   │   │   └── video/             # Video rendering
│   │   ├── models/                # Data models
│   │   ├── utils/                 # Utilities
│   │   └── main.py                # App entry point
│   │
│   ├── frontend/                   # React TypeScript frontend
│   │   ├── src/
│   │   │   ├── components/       # React components
│   │   │   ├── pages/            # Page components
│   │   │   ├── hooks/            # Custom hooks
│   │   │   ├── services/         # API clients
│   │   │   └── App.tsx
│   │   ├── public/
│   │   └── package.json
│   │
│   └── scripts/                    # Utility scripts
│       ├── ingest_archive.py      # Load archive into vector DB
│       ├── generate_story.py      # CLI story generation
│       └── manual_story_helper.py # Helper for manual stories
│
├── stories/                         # GENERATED STORIES
│   ├── manual/                     # Hand-crafted stories
│   │   ├── arthur-in-3-minutes/
│   │   │   ├── script.md
│   │   │   ├── storyboard.md
│   │   │   └── video.mp4
│   │   └── professional-journey/
│   │
│   └── generated/                  # AI-generated stories
│       └── [auto-generated]/
│
├── docs/                           # PROJECT DOCUMENTATION
│   ├── SETUP.md                   # Development setup
│   ├── ARCHITECTURE.md            # Technical architecture
│   ├── API.md                     # API documentation
│   └── CONTRIBUTING.md            # Contribution guidelines
│
└── tools/                          # DEVELOPMENT TOOLS
    ├── create_pdf.py              # PDF compilation script
    └── requirements.txt           # Python dependencies
```

## Key Principles

### 1. Separation of Concerns
- **`archive/`** = Content (historical documents, photos, metadata)
- **`app/`** = Code (application that processes and presents archive)
- **`stories/`** = Output (generated story artifacts)
- **`PRD/`** = Vision (product direction and planning)

### 2. Archive Integrity
- Archive content remains pure and unmodified
- All generated content goes in `stories/`
- Application reads from `archive/`, never writes to it
- Original documents are sacred

### 3. Modular Architecture
- Backend and frontend are independent
- Services are loosely coupled
- Easy to swap components (different LLM, different video renderer, etc.)
- Can deploy pieces separately

### 4. Future-Proof Design
- Archive structure works without the app
- App can work with other archives
- Stories are portable (standard MP4, JSON metadata)
- Platform-ready architecture

## Content vs. Code

### Archive Content (`archive/`)
**Purpose:** Historical preservation
**Contents:**
- Original scanned documents
- Photographs
- Compiled PDFs
- READMEs with analysis
- Transcriptions
- Context documents

**Characteristics:**
- Manually curated
- Historically accurate
- Well-documented
- Version controlled for provenance
- Family-editable (can add photos, docs)

### Application Code (`app/`)
**Purpose:** Story Engine platform
**Contents:**
- RAG document retrieval
- Story generation logic
- Video rendering pipeline
- Web interface
- API endpoints

**Characteristics:**
- Automated/programmatic
- Iteratively developed
- Technically complex
- Separate version control strategy
- Developer-maintained

### Generated Stories (`stories/`)
**Purpose:** Narrative artifacts
**Contents:**
- Video files (MP4)
- Scripts and storyboards
- Metadata (sources, timestamps)
- Thumbnail images

**Characteristics:**
- Ephemeral (can be regenerated)
- Shareable/downloadable
- Multiple variants
- Not version controlled (too large)

## Development Workflow

### Adding to Archive
```bash
# Navigate to archive
cd archive/

# Add documents to appropriate folder
cp ~/new-photos/* "Austin Family/"

# Update README
vim "Austin Family/README.md"

# Commit changes
git add .
git commit -m "Add family photos from 1982"
```

### Developing the App
```bash
# Navigate to app
cd app/backend/

# Make changes
vim services/story/generator.py

# Test
pytest

# Commit
git add .
git commit -m "Improve story arc generation"
```

### Generating Stories
```bash
# Use CLI tool
python app/scripts/generate_story.py \
  --query "Tell me about Dean's professional journey" \
  --output stories/generated/

# Or use web interface (once built)
npm run dev
# Open http://localhost:3000
```

## Next Steps for Refactoring

1. **Move archive content**
   ```bash
   mkdir archive
   mv "Data Processing Management Association" archive/
   mv "Austin Family" archive/
   mv "Austin & Associates" archive/
   # ... etc for all folders
   ```

2. **Create app structure**
   ```bash
   mkdir -p app/{backend,frontend,scripts}
   ```

3. **Move helper scripts**
   ```bash
   mv create_pdf.py tools/
   ```

4. **Create stories directory**
   ```bash
   mkdir -p stories/{manual,generated}
   ```

5. **Update root README**
   - Point to archive/ for content
   - Point to app/ for development
   - Explain project structure

6. **Set up .gitignore**
   ```
   # Generated stories (too large for git)
   stories/generated/

   # Python
   __pycache__/
   *.pyc
   .venv/

   # Node
   node_modules/

   # Environment
   .env
   ```

## Benefits of This Structure

✅ **Clear separation** of archive content and application code
✅ **Easy navigation** - know where everything lives
✅ **Scalable** - can grow archive or app independently
✅ **Maintainable** - different people can work on different parts
✅ **Portable** - archive works standalone, app can be reused
✅ **Professional** - standard software project structure
✅ **Future-proof** - ready for platform expansion

---

*This structure balances preservation (archive integrity) with innovation (story engine development).*
