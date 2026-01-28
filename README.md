# VS Code AI Setup

Personal AI-assisted development environment configuration, optimized to reduce cognitive load and maximize productivity.

## Stack

| Tool | Role | Cost |
|------|------|------|
| **Claude Code** | Planning, architecture, orchestration | Claude subscription or Ollama |
| **Ollama** | Local models for code execution | Free |
| **GitHub Copilot Free** | Inline autocomplete | Free |

## Philosophy

- **Role separation**: Claude Code for thinking, local models for execution
- **Specialized agents**: `planner` (Sonnet or cloud) and `task-executor` (Ollama local)
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

### 2. Install Ollama

Download the macOS app (recommended - includes menu bar icon):
```bash
open https://ollama.com/download/mac
```

Or install via Homebrew (terminal only):
```bash
# macOS
brew install ollama

# Linux
curl -fsSL https://ollama.com/install.sh | sh
```

After installation:
```bash
# Download recommended coding model
ollama pull qwen3-coder

# Or for larger context (if you have 16GB+ RAM)
ollama pull gpt-oss:20b

# Verify
ollama list
```

> **Note**: Ollama only uses RAM when a model is loaded. It automatically unloads after 5 minutes of inactivity.

### 3. Install Claude Code

```bash
# Install globally
npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version
```

### 4. Enable GitHub Copilot Free (VS Code)

GitHub Copilot Free is built into VS Code. Just:

1. Open VS Code
2. Click "Use AI Features" in the welcome screen
3. Sign in with your GitHub account

Limits: ~2,000 completions/month, ~50 chat messages/month.

---

## Configuration

### Option A: Use Ollama only (100% free, local)

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# Claude Code with Ollama
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_BASE_URL=http://localhost:11434
```

Then reload your shell:
```bash
source ~/.zshrc
```

Usage:
```bash
# Run with local model
claude --model qwen3-coder

# Or with larger model
claude --model gpt-oss:20b
```

### Option B: Use Anthropic for planning + Ollama for execution (recommended)

This gives you the best of both worlds:
- **Planning** with Claude Sonnet (smarter, uses your subscription)
- **Execution** with local models (free, fast)

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# Keep Anthropic as default for planning
export ANTHROPIC_API_KEY="sk-ant-..."

# Alias for quick switching to local model
alias claude-local='ANTHROPIC_AUTH_TOKEN=ollama ANTHROPIC_BASE_URL=http://localhost:11434 claude --model qwen3-coder'
```

Usage:
```bash
# Use Anthropic (planning, complex tasks)
claude

# Use local model (execution, simple tasks)
claude-local
```

### Recommended Models

| Model | Size | Use Case | RAM Required |
|-------|------|----------|--------------|
| `qwen3-coder` | ~4GB | Coding tasks | 8GB |
| `gpt-oss:20b` | ~12GB | General purpose | 16GB |
| `gpt-oss:120b` | ~70GB | Complex tasks | 64GB+ |

> **Important**: Claude Code requires at least 32K context window. See [Ollama context length docs](https://docs.ollama.com/context-length) to adjust if needed.

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

# Start Claude Code session (with Anthropic)
claude

# Or with local model
claude --model qwen3-coder

# Claude will auto-detect agents in .claude/agents/

# Example: plan a feature
> I need to implement authentication with NextAuth

# Claude invokes 'planner' → generates Execution Plan
# Plan is saved in docs/tasks/task-XXX.md

# Example: execute the plan
> Execute the plan for TASK-002

# Claude invokes 'task-executor' → implements code
```

### Switch models on the fly

```bash
# Inside a Claude Code session, you can switch models:
/model qwen3-coder         # Local Ollama
/model gpt-oss:20b         # Larger local model
/model claude-sonnet-4-20250514  # Anthropic (if configured)
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

### Ollama not connecting

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# If not running, start it
ollama serve

# Or if using the macOS app, click the llama icon in menu bar
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
ollama stop qwen3-coder

# Use a smaller model if needed
ollama pull qwen3-coder:1.5b
```

### Context length errors

Claude Code needs at least 32K context. Increase it:
```bash
# Create a Modelfile
echo 'FROM qwen3-coder
PARAMETER num_ctx 32768' > Modelfile

# Create custom model with larger context
ollama create qwen3-coder-32k -f Modelfile

# Use it
claude --model qwen3-coder-32k
```

---

## Resources

- [Claude Code Docs](https://code.claude.com/docs)
- [Ollama + Claude Code Integration](https://docs.ollama.com/integrations/claude-code)
- [Ollama Models](https://ollama.com/library)
- [Next.js App Router](https://nextjs.org/docs/app)
- [Hono](https://hono.dev/)
- [FastAPI](https://fastapi.tiangolo.com/)
- [Turborepo](https://turbo.build/repo)

---

## License

MIT - Use and adapt freely.
