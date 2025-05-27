# RMF-v1.0

# 🧠 RMF Attestation Management App

A web-based AI risk and compliance platform aligned with the NIST AI Risk Management Framework (RMF), tailored for the IT industry.

---

## 🚀 Features
- FastAPI backend with RMF core functions (Govern, Map, Measure, Manage)
- Risk register (CRUD)
- React dashboard UI
- Dockerized local deployment

---

## 🛠 Requirements
- Docker & Docker Compose

---

## 🧪 Quick Start

```bash
# Step 1: Clone this project
git clone https://github.com/your-org/ai-rmf-attestation-app.git
cd ai-rmf-attestation-app

# Step 2: Create env file
cp backend/.env.template backend/.env

# Step 3: Start full stack
docker-compose up --build
