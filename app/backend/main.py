"""
Arthur Dean Austin Archive - FastAPI Backend
Main application entry point
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

# Initialize FastAPI app
app = FastAPI(
    title="Arthur Dean Austin Archive API",
    description="Backend API for the Arthur Dean Austin Digital Archive",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",  # Vite dev server
        "http://localhost:3000",  # Alternative dev port
        os.getenv("FRONTEND_URL", ""),  # Production frontend
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    """Root endpoint - health check"""
    return {
        "message": "Arthur Dean Austin Archive API",
        "version": "1.0.0",
        "status": "healthy"
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}


# Import routers (will be created in subsequent milestones)
# from api import search, chat, archive, submissions, admin
# app.include_router(search.router, prefix="/api/search", tags=["search"])
# app.include_router(chat.router, prefix="/api/chat", tags=["chat"])
# app.include_router(archive.router, prefix="/api/archive", tags=["archive"])
# app.include_router(submissions.router, prefix="/api/submissions", tags=["submissions"])
# app.include_router(admin.router, prefix="/api/admin", tags=["admin"])


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
