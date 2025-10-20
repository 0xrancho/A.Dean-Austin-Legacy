"""
Authentication utilities - JWT verification and user management
"""

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from services.database import get_db
from supabase import Client
from typing import Optional, Dict


security = HTTPBearer()


async def verify_token(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Client = Depends(get_db)
) -> Dict:
    """
    Verify Supabase JWT token and return user info
    """
    token = credentials.credentials

    try:
        # Verify token with Supabase
        user = db.auth.get_user(token)

        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials"
            )

        return user.user

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Could not validate credentials: {str(e)}"
        )


async def get_current_user(user: Dict = Depends(verify_token)) -> Dict:
    """
    Dependency to get current authenticated user
    """
    return user


async def require_admin(
    user: Dict = Depends(get_current_user),
    db: Client = Depends(get_db)
) -> Dict:
    """
    Dependency to require admin role
    """
    try:
        # Query user profile to check role
        result = db.table("user_profiles").select("role").eq("id", user["id"]).execute()

        if not result.data or result.data[0]["role"] != "admin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Admin access required"
            )

        return user

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error checking admin status: {str(e)}"
        )
