# Project: [PROJECT_NAME]

## Stack
- Hono (TypeScript)
- Node.js / Bun
- [Database: PostgreSQL / MongoDB / etc.]
- [ORM: Drizzle / Prisma / etc.]

## Project Structure

```
src/
├── index.ts              # Entry point
├── app.ts                # Hono app setup
│
├── routes/               # Route definitions
│   ├── index.ts          # Route aggregator
│   ├── auth.route.ts
│   └── users.route.ts
│
├── handlers/             # Request handlers (controllers)
│   ├── auth.handler.ts
│   └── users.handler.ts
│
├── services/             # Business logic
│   ├── auth.service.ts
│   └── users.service.ts
│
├── repositories/         # Data access layer
│   └── users.repository.ts
│
├── middleware/           # Custom middleware
│   ├── auth.middleware.ts
│   └── error.middleware.ts
│
├── lib/                  # Utilities
│   ├── db.ts             # Database connection
│   └── utils.ts
│
├── types/                # TypeScript types
│   └── index.ts
│
└── config/               # Configuration
    └── env.ts
```

## Code Conventions

### Layers
- **Routes**: Only define paths and link to handlers
- **Handlers**: Parse request, call services, return response
- **Services**: Business logic, call repositories
- **Repositories**: Database operations only

### Naming
- Routes: `*.route.ts`
- Handlers: `*.handler.ts`
- Services: `*.service.ts`
- Repositories: `*.repository.ts`

### Error Handling
- Use custom error classes
- Centralized error middleware
- Always return consistent error format

## Project Documentation

- `docs/00_scope.md` - Scope and objectives
- `docs/01_task_list.md` - Task list
- `docs/tasks/` - Individual tasks with execution plans

## Useful Commands

```bash
npm run dev          # Development with hot reload
npm run build        # Build for production
npm run start        # Run production build
npm run test         # Run tests
```

## Important Notes

- [Add project-specific considerations here]
