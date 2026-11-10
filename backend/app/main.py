from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .api.routes.automatic_thought import router as automatic_thought_router
from .api.routes.situation import router as situation_router
from .config import get_settings

settings = get_settings()

app = FastAPI(title="Mind Builder Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,
    allow_credentials=False,
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}


app.include_router(situation_router)
app.include_router(automatic_thought_router)
