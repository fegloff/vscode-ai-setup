# Project: [PROJECT_NAME]

## Stack
- Next.js 15 (App Router)
- TypeScript 5.x
- Tailwind CSS 4.x
- [Other key dependencies]

## Project Structure

```
src/
├── app/                      # ONLY routing
│   ├── layout.tsx
│   ├── page.tsx
│   ├── (auth)/               # Public pages (no header/sidebar)
│   │   ├── layout.tsx
│   │   ├── login/page.tsx
│   │   └── register/page.tsx
│   ├── (app)/                # Authenticated pages (with header/sidebar)
│   │   ├── layout.tsx
│   │   ├── dashboard/page.tsx
│   │   └── settings/page.tsx
│   └── api/                  # Only for webhooks/external APIs
│
├── components/               # SHARED components
│   ├── ui/                   # Button, Input, Modal, Card
│   └── layout/               # Header, Footer, Sidebar
│
├── features/                 # Domain logic by feature
│   └── [feature]/
│       ├── components/       # Feature-specific components
│       └── hooks/            # Feature-specific hooks
│
├── actions/                  # ALL Server Actions
│   └── [domain].action.ts
│
├── hooks/                    # SHARED hooks
│
├── lib/                      # Pure utilities
│
└── types/                    # Global types
```

## Code Conventions

### Components
- One component per file
- Styles in `Component.styles.tsx` (object with Tailwind classes)
- Logic in dedicated hooks
- No complex logic in JSX

### Naming
- Components: PascalCase
- Hooks: camelCase with `use` prefix
- Style files: `*.styles.tsx`
- Server Actions: `*.action.ts`

### Imports
- Use path aliases (`@/components/...`)
- Group: external → internal → relative

## Project Documentation

- `docs/00_scope.md` - Scope and objectives
- `docs/01_task_list.md` - Task list
- `docs/tasks/` - Individual tasks with execution plans

## Useful Commands

```bash
npm run dev          # Development
npm run build        # Production build
npm run lint         # Linter
npm run typecheck    # Type check
```

## Important Notes

- [Add project-specific considerations here]
