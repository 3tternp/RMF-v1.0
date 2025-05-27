#!/bin/bash

echo "📁 Creating RMF Attestation Project..."

# Root project folder
mkdir -p ai-rmf-attestation-app/{backend/app/routers,frontend/src/pages,devops,docs,database}

cd ai-rmf-attestation-app

# === BACKEND FILES ===
cat <<EOF > backend/app/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import risks, rmf

app = FastAPI(title="AI RMF Attestation API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(risks.router, prefix="/api/risks", tags=["Risks"])
app.include_router(rmf.router, prefix="/api/rmf", tags=["RMF Functions"])

@app.get("/")
def root():
    return {"message": "AI RMF Backend is Running"}
EOF

cat <<EOF > backend/app/routers/risks.py
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

risks_db: List[Risk] = []

@router.get("/", response_model=List[Risk])
def get_risks():
    return risks_db

@router.post("/", response_model=Risk)
def add_risk(risk: Risk):
    risks_db.append(risk)
    return risk
EOF

cat <<EOF > backend/app/routers/rmf.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/govern")
def govern_status():
    return {"status": "Govern function documented and mapped"}

@router.get("/map")
def map_status():
    return {"status": "Use case and context mapped"}

@router.get("/measure")
def measure_status():
    return {"status": "Trustworthiness metrics in place"}

@router.get("/manage")
def manage_status():
    return {"status": "Risks monitored and mitigation tracked"}
EOF

touch backend/app/__init__.py

cat <<EOF > backend/requirements.txt
fastapi
uvicorn
pydantic
python-multipart
EOF

cat <<EOF > backend/.env.template
DATABASE_URL=postgresql://user:password@localhost:5432/ai_rmf_db
EOF

cat <<EOF > backend/Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app ./app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
EOF

# === FRONTEND FILES ===
cat <<EOF > frontend/package.json
{
  "name": "ai-rmf-frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "axios": "^1.4.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.0.0",
    "typescript": "^5.1.3",
    "vite": "^4.4.0"
  }
}
EOF

cat <<EOF > frontend/vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000
  }
});
EOF

cat <<EOF > frontend/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>AI RMF Attestation</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

cat <<EOF > frontend/tsconfig.json
{
  "compilerOptions": {
    "target": "esnext",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": false,
    "strict": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "esModuleInterop": true,
    "jsx": "react-jsx"
  },
  "include": ["src"]
}
EOF

cat <<EOF > frontend/src/main.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './pages/App';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

cat <<EOF > frontend/src/pages/App.tsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';

const apiBase = "http://localhost:8000/api";

const App = () => {
  const [rmfStatus, setRmfStatus] = useState<any>({});
  const [risks, setRisks] = useState<any[]>([]);

  useEffect(() => {
    Promise.all([
      axios.get(\`\${apiBase}/rmf/govern\`),
      axios.get(\`\${apiBase}/rmf/map\`),
      axios.get(\`\${apiBase}/rmf/measure\`),
      axios.get(\`\${apiBase}/rmf/manage\`),
      axios.get(\`\${apiBase}/risks/\`)
    ]).then(([govern, map, measure, manage, riskData]) => {
      setRmfStatus({
        govern: govern.data.status,
        map: map.data.status,
        measure: measure.data.status,
        manage: manage.data.status,
      });
      setRisks(riskData.data);
    });
  }, []);

  return (
    <div style={{ padding: "2rem", fontFamily: "Arial" }}>
      <h1>🧠 AI RMF Attestation Dashboard</h1>

      <h2>📊 RMF Status</h2>
      <ul>
        {Object.entries(rmfStatus).map(([key, value]) => (
          <li key={key}><strong>{key.toUpperCase()}</strong>: {value}</li>
        ))}
      </ul>

      <h2>⚠️ Risk Register</h2>
      {risks.length === 0 ? <p>No risks yet.</p> :
        <ul>
          {risks.map((risk, idx) => (
            <li key={idx}>
              <strong>{risk.name}</strong>: {risk.description} (Impact: {risk.impact}, Likelihood: {risk.likelihood})
            </li>
          ))}
        </ul>
      }
    </div>
  );
};

export default App;
EOF

# === DOCKER COMPOSE ===
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  backend:
    build:
      context: ./backend
    ports:
      - "8000:8000"
    volumes:
      - ./backend:/app
    command: uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

  frontend:
    build:
      context: ./frontend
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
    command: npm run dev
EOF

# === README ===
cat <<EOF > README.md
# 🧠 AI RMF Attestation Management App

A web-based AI risk and compliance platform aligned with the NIST AI RMF for IT systems.

## 🚀 Quick Start

\`\`\`bash
cp backend/.env.template backend/.env
docker-compose up --build
\`\`\`

## 🌐 App URLs

- Frontend: http://localhost:3000
- API Docs: http://localhost:8000/docs
EOF

echo "✅ Setup complete. Your project is ready in ./ai-rmf-attestation-app/"
