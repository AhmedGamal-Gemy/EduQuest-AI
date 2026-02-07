# 🎓 EduQuest AI - Backend & Agent System

[![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)](https://fastapi.tiangolo.com/)
[![Google ADK](https://img.shields.io/badge/Google%20ADK-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://github.com/google/adk)
[![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white)](https://redis.io/)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

EduQuest AI is a modern, high-performance learning management ecosystem designed for AI-driven education. This repository contains the core API services, authentication layer, and the **AI Agentic System** powered by the Google Agent Development Kit (ADK).

---

## 📖 Table of Contents
- [Overview](#-overview)
- [Key Features](#-key-features)
- [🤖 AI Agentic System](#-ai-agentic-system)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Getting Started](#-getting-started)
- [Detailed Setup](#-detailed-setup)
- [Testing & Quality](#-testing--quality)
- [Folder Structure](#-folder-structure)

---

## 🚀 Overview
EduQuest AI acts as the central intelligence hub for the EduQuest platform. It provides a secure environment for user data, real-time caching for speed, and a robust framework for autonomous **AI Agents** to interact with students and educational materials.

## ✨ Key Features
- **Instant Productivity**: Registration returns a JWT token immediately—no separate login step required.
- **Educational CRUD**: Full lifecycle management for **Courses** (instructors only) and **Students** (integrated via `fastapi-users`).
- **Autonomous Agents**: Built-in support for Multi-Agent systems using Google ADK.
- **Developer-First Tooling**: One-command setup using `uv` and `make`, plus automated **OpenAPI & Postman** collection exports.
- **Advanced Security**: Integrated `fastapi-users` with JWT strategies and Redis-backed rate limiting.
- **Enterprise Logging**: Unified structured logging for deep observability.

---

## 🤖 AI Agentic System
The "Brain" of EduQuest is built on the **Google Agent Development Kit (ADK)**. 

### Core Capabilities:
1.  **Context-Aware Tutoring**: Agents analyze student progress and adapt content in real-time.
2.  **Tool-Use**: Agents can interact with external APIs, databases, and educational tools.
3.  **Collaborative Reasoning**: Multiple agents work together to solve complex student queries (e.g., a "Teacher Agent" collaborating with a "Research Agent").
4.  **Extensible Framework**: Easy to add new skills, personalities, and domain expertise to agents.

---

## 🛠️ Tech Stack
- **Framework**: FastAPI (Python 3.11+)
- **AI Core**: [Google ADK](https://github.com/google/adk)
- **Database**: MongoDB (Beanie ODM)
- **Cache**: Redis (Rate Limiting & Session caching)
- **Security**: JWT Authentication, Argon2 password hashing.
- **Tooling**: [uv](https://astral.sh/uv) (Manager), Docker, Ruff (Linter/Formatter), Pytest.

## 🏗️ Architecture
The project follows a modular core architecture:
- **API Layer**: RESTful endpoints with versioned routing.
- **Agent Layer**: Google ADK-powered agents for educational logic.
- **Service Layer**: Business logic decoupled from protocols.
- **Database Layer**: Asynchronous document-oriented storage.

---

## 🏁 Getting Started (Quick Run)

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [uv](https://astral.sh/uv/install.sh) (The fast Python package manager)

### Local Setup
1. **Initialize Environment**:
   ```bash
   cp .env.example .env
   uv sync
   ```

2. **Start Infrastructure**:
   ```bash
   make up
   ```

3. **Launch API & Agents**:
   ```bash
   make run
   ```
   *Dashboard available at: http://localhost:8001/docs*

---

## 🛠️ Detailed Setup

### 🪟 Windows (Recommended: WSL2)
1. Install **WSL2** (`wsl --install`) and restart.
2. Inside WSL, install `uv`: `curl -LsSf https://astral.sh/uv/install.sh | sh`
3. Install `make`: `sudo apt update && sudo apt install make`.

### 🐧 Linux / 🍎 macOS
1. Install `uv`: `curl -LsSf https://astral.sh/uv/install.sh | sh`
2. Install `make`: `sudo apt install make` (Linux) or `brew install make` (Mac).

### ❓ Why `make`?
We use `make` to simplify complex developer workflows. 
- `make up`: Spins up Docker containers.
- `make run`: Starts the FastAPI server and AI Agent system.
- `make test`: Runs the full integration test suite.
- `make lint`: Automatically cleans and formats your code using Ruff.

---

## 🧪 Testing & Quality
We maintain high standards with automated verification.
```bash
make test
```
The integration tests simulate real user flows (Registration, JWT Login, Database persistence) and basic Agent connectivity.

## 📂 Folder Structure
```text
.
├── app/                # Application source code
│   ├── api/            # API Endpoints & Routers (Auth, Chat)
│   ├── core/           # Config, Security, Constants
│   ├── db/             # Database initialization & Models
│   └── schemas/        # Pydantic data validation models
├── edu_quester/        # Shared core utilities (Logger, AI Agent config)
├── tests/              # Integration and unit tests
├── docker-compose.yml  # MongoDB/Redis services
└── pyproject.toml      # Dependency management (uv)
```

---
*Built with ❤️ for EduQuest AI*
