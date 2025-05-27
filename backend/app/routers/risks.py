from fastapi import APIRouter
from pydantic import BaseModel
from typing import List

router = APIRouter()

class Risk(BaseModel):
    id: int
    name: str
    description: str
    impact: str
    likelihood: str
    mitigation: str

# Sample in-memory list (replace with DB later)
risks_db: List[Risk] = []

@router.get("/", response_model=List[Risk])
def get_risks():
    return risks_db

@router.post("/", response_model=Risk)
def add_risk(risk: Risk):
    risks_db.append(risk)
    return risk
