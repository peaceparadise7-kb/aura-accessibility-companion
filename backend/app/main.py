from backend.app.api.v1.endpoints import health, profiles
from backend.app.core.config import settings
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    docs_url=f"{settings.API_V1_STR}/docs",
)

if settings.BACKEND_CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.BACKEND_CORS_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

app.include_router(health.router, prefix=settings.API_V1_STR, tags=["Health"])
app.include_router(profiles.router, prefix=settings.API_V1_STR, tags=["Appliance Profiles"])


@app.get("/")
def root():
    return {
        "message": "Welcome to AURA API",
        "health": f"{settings.API_V1_STR}/health",
        "docs": f"{settings.API_V1_STR}/docs",
    }
