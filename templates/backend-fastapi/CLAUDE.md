# Project: [PROJECT_NAME]

## Stack
- FastAPI (Python 3.11+)
- [Database: PostgreSQL / MongoDB / etc.]
- [ORM: SQLAlchemy / SQLModel / etc.]
- Pydantic for validation

## Project Structure

```
src/
├── main.py               # Entry point
├── config.py             # Configuration / settings
│
├── api/                  # API layer
│   ├── __init__.py
│   ├── deps.py           # Dependencies (get_db, get_current_user)
│   └── v1/
│       ├── __init__.py
│       ├── router.py     # Route aggregator
│       ├── auth.py       # Auth endpoints
│       └── users.py      # User endpoints
│
├── services/             # Business logic
│   ├── __init__.py
│   ├── auth.py
│   └── users.py
│
├── repositories/         # Data access layer
│   ├── __init__.py
│   └── users.py
│
├── models/               # SQLAlchemy/DB models
│   ├── __init__.py
│   └── user.py
│
├── schemas/              # Pydantic schemas
│   ├── __init__.py
│   └── user.py
│
├── core/                 # Core utilities
│   ├── __init__.py
│   ├── db.py             # Database connection
│   ├── security.py       # Auth utilities
│   └── exceptions.py     # Custom exceptions
│
└── tests/
    └── ...
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
# Development
uvicorn src.main:app --reload

# Tests
pytest

# Linting
ruff check .
ruff format .

# Type checking
mypy src/
```

## Important Notes

- [Add project-specific considerations here]
