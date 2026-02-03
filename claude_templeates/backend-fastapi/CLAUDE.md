# Project: [PROJECT_NAME]

## Stack
- FastAPI (Python 3.12+)
- [Database: PostgreSQL / MongoDB / etc.]
- [ORM: SQLAlchemy 2.0 / SQLModel / etc.]
- Pydantic v2 for validation
- uv for dependency management

## Environment Setup

This project uses **uv** for fast, reliable Python dependency management with a local virtual environment.

```bash
# Install uv (if not installed)
command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh

# Create local virtual environment
uv venv

# Activate the environment
source .venv/bin/activate  # Linux/macOS
# .venv\Scripts\activate   # Windows

# Install dependencies
uv pip install -r requirements.txt
# Or if using pyproject.toml:
uv pip install -e ".[dev]"

# Add new dependencies
uv pip install <package>
uv pip freeze > requirements.txt
```

## Project Structure

```
.
├── .venv/                # Local virtual environment (git-ignored)
├── pyproject.toml        # Project metadata & dependencies
├── requirements.txt      # Pinned dependencies (alternative)
├── .python-version       # Python version (e.g., 3.12)
│
├── src/
│   ├── __init__.py
│   ├── main.py           # Entry point, app factory
│   ├── config.py         # Settings (pydantic-settings)
│   │
│   ├── api/              # API layer
│   │   ├── __init__.py
│   │   ├── deps.py       # Dependencies (get_db, get_current_user)
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── router.py # Route aggregator
│   │       ├── auth.py   # Auth endpoints
│   │       └── users.py  # User endpoints
│   │
│   ├── services/         # Business logic
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   └── users.py
│   │
│   ├── repositories/     # Data access layer
│   │   ├── __init__.py
│   │   └── users.py
│   │
│   ├── models/           # SQLAlchemy/DB models
│   │   ├── __init__.py
│   │   └── user.py
│   │
│   ├── schemas/          # Pydantic schemas (DTOs)
│   │   ├── __init__.py
│   │   └── user.py
│   │
│   ├── core/             # Core utilities
│   │   ├── __init__.py
│   │   ├── db.py         # Database connection
│   │   ├── security.py   # Auth utilities
│   │   └── exceptions.py # Custom exceptions
│   │
│   └── middleware/       # Custom middleware
│       ├── __init__.py
│       └── logging.py    # Request logging
│
├── alembic/              # Database migrations
│   ├── versions/
│   └── env.py
│
└── tests/
    ├── conftest.py       # Fixtures
    ├── test_api/
    └── test_services/
```

## Code Conventions

### Layers
- **API (routers)**: Define endpoints, validate input, call services
- **Services**: Business logic, orchestrate repositories
- **Repositories**: Database operations only
- **Schemas**: Request/Response validation (Pydantic)
- **Models**: Database models (SQLAlchemy)

### Naming
- Routers: `api/v1/*.py`
- Services: `services/*.py`
- Repositories: `repositories/*.py`
- Schemas: `schemas/*.py`
- Models: `models/*.py`

### Type Hints
- Always use type hints
- Use Pydantic models for request/response

## Project Documentation

- `docs/00_scope.md` - Scope and objectives
- `docs/01_task_list.md` - Task list
- `docs/tasks/` - Individual tasks with execution plans

## Useful Commands

```bash
# Environment (uv)
uv venv                           # Create local .venv
source .venv/bin/activate         # Activate
uv pip install -e ".[dev]"        # Install with dev deps
uv pip install <package>          # Add dependency

# Development
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

# Database migrations (Alembic)
alembic upgrade head              # Apply migrations
alembic revision --autogenerate -m "description"  # Create migration

# Tests
pytest                            # Run all tests
pytest -v --cov=src               # With coverage

# Linting & Formatting
ruff check .                      # Lint
ruff check . --fix                # Lint with autofix
ruff format .                     # Format

# Type checking
mypy src/
```

## Important Notes

- Virtual environment stored locally in `.venv/` (add to `.gitignore`)
- Use `pydantic-settings` for configuration management
- [Add project-specific considerations here]
