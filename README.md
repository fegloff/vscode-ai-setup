# VS Code AI Setup

Personal AI-assisted development environment configuration, optimized to reduce cognitive load and maximize productivity.

## Stack

| Tool | Role | Cost |
|------|------|------|
| **Claude Code** | Planning, architecture, orchestration | Claude subscription |
| **Claude Code Router (CCR)** | Routing to free/cheap models | Free |
| **GitHub Copilot Free** | Inline autocomplete | Free |
| **Ollama** | Local models | Free |

## Philosophy

- **Role separation**: Claude Code for thinking, cheap models for execution
- **Specialized agents**: `planner` (Sonnet) and `task-executor` (Ollama local)
- **Structured documentation**: Scope → Tasks → Execution Plans
- **Minimal friction**: Repeatable setup, low cognitive overhead

---

## Installation

### Prerequisites

- macOS (Apple Silicon or Intel) / Linux / WSL2
- Node.js 18+
- Git
- ~8GB free RAM (for local models)

### 1. Clean unwanted AI extensions (VS Code)

If you have a fresh VS Code install, skip this step.

```bash
# List installed AI extensions
code --list-extensions | grep -iE "blackbox|tabnine|codewhisperer"

# Uninstall Blackbox (if installed)
code --uninstall-extension Blackbox.blackbox

# Verify removal
code --list-extensions | grep -i blackbox
```

#### Full VS Code reset (if needed)

```bash
# Close VS Code
osascript -e 'quit app "Visual Studio Code"' 2>/dev/null

# Remove all configuration
rm -rf ~/Library/Application\ Support/Code
rm -rf ~/.vscode
rm -rf ~/Library/Caches/com.microsoft.VSCode
rm -rf ~/Library/Saved\ Application\ State/com.microsoft.VSCode.savedState

# Reinstall VS Code from https://code.visualstudio.com/
```

### 2. Install Claude Code

```bash
# Install globally
npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version

# Login (opens browser for authentication)
claude login
```

### 3. Install Claude Code Router (CCR)

```bash
# Install globally
npm install -g @musistudio/claude-code-router

# Verify installation
ccr --version

# Create config directory
mkdir -p ~/.claude-code-router

# Copy config template (edit afterwards)
cp config/ccr-config.json ~/.claude-code-router/config.json
```

### 4. Install Ollama (Local Models)

```bash
# macOS
brew install ollama

# Linux
curl -fsSL https://ollama.com/install.sh | sh

# Start service
ollama serve

# Download recommended coding model (~4.5GB)
ollama pull qwen2.5-coder:7b

# Verify
ollama list
```

> **Note**: Ollama only uses RAM when a model is loaded. It automatically unloads after 5 minutes of inactivity. With 16GB RAM you'll be fine.

### 5. Enable GitHub Copilot Free (VS Code)

GitHub Copilot Free is built into VS Code. Just:

1. Open VS Code
2. Click "Use AI Features" in the welcome screen
3. Sign in with your GitHub account

Limits: ~2,000 completions/month, ~50 chat messages/month.

---

## Configuration

### Configure CCR

Edit `~/.claude-code-router/config.json`:

```json
{
  "Providers": [
    {
      "name": "anthropic",
      "api_base_url": "https://api.anthropic.com/v1/messages",
      "api_key": "$ANTHROPIC_API_KEY",
      "models": ["claude-sonnet-4-20250514"]
    },
    {
      "name": "ollama",
      "api_base_url": "http://localhost:11434/v1/chat/completions",
      "api_key": "ollama",
      "models": ["qwen2.5-coder:7b"]
    }
  ],
  "Router": {
    "default": "ollama,qwen2.5-coder:7b",
    "background": "ollama,qwen2.5-coder:7b",
    "think": "anthropic,claude-sonnet-4-20250514",
    "longContext": "anthropic,claude-sonnet-4-20250514",
    "longContextThreshold": 60000
  },
  "API_TIMEOUT_MS": 120000
}
```

### Activate CCR

```bash
# Start the router (separate terminal or as service)
ccr start

# Add to your shell profile (~/.zshrc or ~/.bashrc):
eval "$(ccr activate)"

# Reload shell
source ~/.zshrc
```

### Environment variables

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# API Keys
export ANTHROPIC_API_KEY="sk-ant-..."

# Optional: DeepSeek as cloud backup
# export DEEPSEEK_API_KEY="sk-..."

# CCR activation (after ccr start)
eval "$(ccr activate)"
```

---

## Usage

### Create new project with template

```bash
# Clone this repo
git clone https://github.com/YOUR_USER/vscode-ai-setup.git

# Copy template to your project
cp -r vscode-ai-setup/templates/frontend-nextjs/.claude your-project/
cp vscode-ai-setup/templates/frontend-nextjs/CLAUDE.md your-project/
cp -r vscode-ai-setup/templates/frontend-nextjs/docs your-project/

# Customize
cd your-project
# Edit CLAUDE.md with project details
# Edit docs/00_scope.md with project scope
```

### Workflow

```bash
cd your-project

# Start Claude Code session
claude

# Claude will auto-detect agents in .claude/agents/

# Example: plan a feature
> I need to implement authentication with NextAuth

# Claude invokes 'planner' → generates Execution Plan
# Plan is saved in docs/tasks/task-XXX.md

# Example: execute the plan
> Execute the plan for TASK-002

# Claude invokes 'task-executor' → implements code
```

### Switch models manually

```bash
# Inside a Claude Code session
/model ollama,qwen2.5-coder:7b        # Local (free)
/model anthropic,claude-sonnet-4-20250514  # Premium
```

---

## Available Templates

| Template | Use case |
|----------|----------|
| `frontend-nextjs/` | Next.js 15 with App Router |
| `backend-hono/` | Hono API (TypeScript) |
| `backend-fastapi/` | FastAPI (Python) |
| `monorepo-web3/` | Turborepo + Next.js + Contracts |

---

## Project Structure (Next.js)

```
src/
├── app/                      # ONLY routing
│   ├── layout.tsx
│   ├── page.tsx
│   ├── (auth)/               # Route group (public pages)
│   │   ├── layout.tsx        # No header/sidebar
│   │   ├── login/page.tsx    # → /login
│   │   └── register/page.tsx # → /register
│   ├── (app)/                # Route group (authenticated)
│   │   ├── layout.tsx        # With header/sidebar
│   │   ├── dashboard/page.tsx
│   │   └── settings/page.tsx
│   └── api/                  # Only for webhooks/external APIs
│       └── webhooks/stripe/route.ts
│
├── components/               # SHARED components
│   ├── ui/                   # Button, Input, Modal, Card
│   └── layout/               # Header, Footer, Sidebar
│
├── features/                 # Domain logic
│   ├── auth/
│   │   ├── components/       # LoginForm, RegisterForm
│   │   └── hooks/            # useAuth, useSession
│   └── dashboard/
│       ├── components/
│       └── hooks/
│
├── actions/                  # ALL Server Actions
│   ├── auth.action.ts
│   ├── user.action.ts
│   └── dashboard.action.ts
│
├── hooks/                    # SHARED hooks
│   ├── useMediaQuery.ts
│   └── useDebounce.ts
│
├── lib/                      # Pure utilities
│   └── utils.ts
│
└── types/                    # Global types
    └── index.ts
```

---

## Troubleshooting

### CCR not connecting

```bash
# Check if service is running
ccr status

# Restart
ccr stop && ccr start

# Verify environment variables
echo $ANTHROPIC_BASE_URL  # Should point to local router
```

### Claude Code doesn't find agents

```bash
# Verify structure
ls -la .claude/agents/

# Files must have .md extension and valid YAML frontmatter
```

### Ollama slow or using too much RAM

```bash
# Check loaded models
ollama ps

# Manually unload a model
ollama stop qwen2.5-coder:7b

# Use a smaller model if needed
ollama pull qwen2.5-coder:3b
```

---

## Resources

- [Claude Code Docs](https://code.claude.com/docs)
- [Claude Code Router](https://github.com/musistudio/claude-code-router)
- [Ollama](https://ollama.com/)
- [Next.js App Router](https://nextjs.org/docs/app)
- [Hono](https://hono.dev/)
- [FastAPI](https://fastapi.tiangolo.com/)
- [Turborepo](https://turbo.build/repo)

---

## License

MIT - Use and adapt freely.
