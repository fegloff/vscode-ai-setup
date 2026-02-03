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

## for Mac use
brew install uv

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

## Code Patterns (MUST USE)

### 1. Settings Configuration (pydantic-settings v2)

```python
# src/config.py
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    database_url: str = Field(..., alias="DATABASE_URL")
    debug: bool = Field(default=False)
    secret_key: str = Field(..., min_length=32)


settings = Settings()
```

```python
# ❌ WRONG - Pydantic v1 pattern - .env files won't load!
class Config:  # ❌ Ignored in v2
    env_file = ".env"
```

---

### 2. SQLAlchemy 2.0 Async Engine & Session

```python
# src/core/db.py
from collections.abc import AsyncGenerator

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from src.config import settings

engine = create_async_engine(
    settings.database_url,
    echo=settings.debug,
    pool_pre_ping=True,
)

AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False,
)


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
```

```python
# ❌ WRONG - SQLAlchemy 1.x patterns
from sqlalchemy import create_engine  # ❌ Sync engine
from sqlalchemy.orm import sessionmaker  # ❌ Sync sessionmaker
Session = sessionmaker(bind=engine)  # ❌ Old binding pattern
```

---

### 3. FastAPI Lifespan (startup/shutdown)

```python
# src/main.py
from contextlib import asynccontextmanager
from collections.abc import AsyncIterator

from fastapi import FastAPI

from src.core.db import engine


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    # Startup
    yield
    # Shutdown
    await engine.dispose()


app = FastAPI(lifespan=lifespan)
```

```python
# ❌ WRONG - Deprecated in FastAPI 0.109+
@app.on_event("startup")  # ❌ Deprecated
async def startup():
    pass

@app.on_event("shutdown")  # ❌ Deprecated
async def shutdown():
    pass
```

---

### 4. SQLAlchemy 2.0 Models (DeclarativeBase)

```python
# src/models/base.py
from datetime import datetime

from sqlalchemy import DateTime, func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    pass


class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
    )
```

```python
# src/models/user.py
from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from src.models.base import Base, TimestampMixin


class User(TimestampMixin, Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    hashed_password: Mapped[str] = mapped_column(String(255))
    is_active: Mapped[bool] = mapped_column(default=True)
```

```python
# ❌ WRONG - SQLAlchemy 1.x declarative
from sqlalchemy.ext.declarative import declarative_base  # ❌ Deprecated
Base = declarative_base()  # ❌ Old pattern

class User(Base):
    id = Column(Integer, primary_key=True)  # ❌ Column() is legacy
    email = Column(String)  # ❌ No type hints
```

---

### 5. Pydantic v2 Schemas

```python
# src/schemas/user.py
from pydantic import BaseModel, ConfigDict, EmailStr


class UserBase(BaseModel):
    email: EmailStr


class UserCreate(UserBase):
    password: str


class UserResponse(UserBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    is_active: bool
```

```python
# ❌ WRONG - Pydantic v1 patterns
class UserResponse(UserBase):
    class Config:  # ❌ Use model_config = ConfigDict(...) instead
        orm_mode = True  # ❌ Renamed to from_attributes in v2
```

---

### 6. Alembic Async Configuration

```python
# alembic/env.py
import asyncio
from logging.config import fileConfig

from sqlalchemy import pool
from sqlalchemy.ext.asyncio import async_engine_from_config

from alembic import context

from src.config import settings
from src.models.base import Base

config = context.config
config.set_main_option("sqlalchemy.url", settings.database_url)

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata


def run_migrations_offline() -> None:
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()


def do_run_migrations(connection):
    context.configure(connection=connection, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()


async def run_async_migrations() -> None:
    connectable = async_engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    async with connectable.connect() as connection:
        await connection.run_sync(do_run_migrations)
    await connectable.dispose()


def run_migrations_online() -> None:
    asyncio.run(run_async_migrations())


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
```

---

### 7. Database Dependency Injection

```python
# src/api/deps.py
from collections.abc import AsyncGenerator
from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from src.core.db import AsyncSessionLocal


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with AsyncSessionLocal() as session:
        yield session


# Type alias for cleaner route signatures
DbSession = Annotated[AsyncSession, Depends(get_db)]
```

```python
# Usage in routes
from src.api.deps import DbSession

@router.get("/users/{user_id}")
async def get_user(user_id: int, db: DbSession) -> UserResponse:
    ...
```

```python
# ❌ WRONG - Old dependency patterns
from fastapi import Depends
from sqlalchemy.orm import Session

def get_db():  # ❌ Sync generator
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

---

### 8. Custom Exception Handling

```python
# src/core/exceptions.py
from fastapi import HTTPException, status


class AppException(HTTPException):
    def __init__(
        self,
        status_code: int = status.HTTP_500_INTERNAL_SERVER_ERROR,
        detail: str = "Internal server error",
    ) -> None:
        super().__init__(status_code=status_code, detail=detail)


class NotFoundException(AppException):
    def __init__(self, detail: str = "Resource not found") -> None:
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail=detail)


class UnauthorizedException(AppException):
    def __init__(self, detail: str = "Not authenticated") -> None:
        super().__init__(status_code=status.HTTP_401_UNAUTHORIZED, detail=detail)
```

---

### 9. SQLAlchemy 2.0 Query Patterns

```python
# Repository example - src/repositories/user.py
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.models.user import User


class UserRepository:
    def __init__(self, db: AsyncSession) -> None:
        self.db = db

    async def get_by_id(self, user_id: int) -> User | None:
        result = await self.db.execute(select(User).where(User.id == user_id))
        return result.scalar_one_or_none()

    async def get_by_email(self, email: str) -> User | None:
        result = await self.db.execute(select(User).where(User.email == email))
        return result.scalar_one_or_none()

    async def create(self, user: User) -> User:
        self.db.add(user)
        await self.db.flush()
        await self.db.refresh(user)
        return user
```

```python
# ❌ WRONG - SQLAlchemy 1.x query patterns
user = db.query(User).filter(User.id == user_id).first()  # ❌ Legacy Query API
users = db.query(User).all()  # ❌ Use select() instead
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

## Common Dependencies Reference

```toml
# pyproject.toml dependencies
dependencies = [
    "fastapi>=0.115",
    "uvicorn[standard]>=0.32",
    "pydantic>=2.0",
    "pydantic-settings>=2.0",    # Separate package in v2!
    "sqlalchemy[asyncio]>=2.0",  # async support extra
    "asyncpg>=0.29",             # async PostgreSQL driver (separate package)
    "alembic>=1.14",
    "python-dotenv>=1.0",        # Optional: if loading .env manually
]

# WRONG patterns:
# "sqlalchemy[asyncpg]"    # ❌ No such extra - use asyncpg separately
# "pydantic[settings]"     # ❌ No such extra - use pydantic-settings
```

## Important Notes

- Virtual environment stored locally in `.venv/` (add to `.gitignore`)
- Use `pydantic-settings` for configuration management
- [Add project-specific considerations here]
