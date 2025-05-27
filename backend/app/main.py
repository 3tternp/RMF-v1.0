from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import risks, rmf

app = FastAPI(title="AI RMF Attestation API")

# Enable CORS for frontend access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(risks.router, prefix="/api/risks", tags=["Risks"])
app.include_router(rmf.router, prefix="/api/rmf", tags=["RMF Functions"])

@app.get("/")
def root():
    return {"message": "AI RMF Backend is Running"}
