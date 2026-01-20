# Project: [PROJECT_NAME]

## Stack
- **Monorepo**: Turborepo
- **Frontend**: Next.js 15 (App Router)
- **Contracts**: Solidity / Foundry
- **Package Manager**: pnpm

## Project Structure

```
root/
├── apps/
│   ├── web/                  # Next.js frontend
│   │   └── (same structure as frontend-nextjs template)
│   └── docs/                 # Documentation site (optional)
│
├── packages/
│   ├── ui/                   # Shared UI components
│   │   ├── src/
│   │   │   ├── Button/
│   │   │   ├── Modal/
│   │   │   └── index.ts
│   │   └── package.json
│   │
│   ├── contracts/            # Smart contracts
│   │   ├── src/
│   │   ├── test/
│   │   ├── script/
│   │   └── foundry.toml
│   │
│   ├── config/               # Shared configs
│   │   ├── eslint/
│   │   ├── typescript/
│   │   └── tailwind/
│   │
│   └── types/                # Shared TypeScript types
│       └── src/
│
├── turbo.json
├── pnpm-workspace.yaml
└── package.json
```

## Code Conventions

### Monorepo Rules
- Shared code goes in `packages/`
- Apps import from packages using workspace protocol
- Each package has its own `package.json`

### Package Naming
- `@project/ui` - UI components
- `@project/contracts` - Smart contracts
- `@project/config` - Shared configs
- `@project/types` - Shared types

### Imports
```typescript
// In apps/web
import { Button } from '@project/ui';
import { ContractABI } from '@project/contracts';
import type { User } from '@project/types';
```

### Smart Contracts
- Use Foundry for development
- Tests in Solidity
- Deploy scripts in `script/`

## Project Documentation

- `docs/00_scope.md` - Scope and objectives
- `docs/01_task_list.md` - Task list
- `docs/tasks/` - Individual tasks with execution plans

## Useful Commands

```bash
# Install all dependencies
pnpm install

# Development (all apps)
pnpm dev

# Build all
pnpm build

# Run specific app
pnpm --filter web dev

# Smart contracts
cd packages/contracts
forge build
forge test
```

## Important Notes

- [Add project-specific considerations here]
