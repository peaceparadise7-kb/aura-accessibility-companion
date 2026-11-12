from datetime import datetime, timezone

from backend.app.core.config import settings
from fastapi import APIRouter

router = APIRouter()


@router.get("/health", summary="Health check")
def get_health():
    return {
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "version": settings.VERSION,
        "service": settings.PROJECT_NAME,
    }
