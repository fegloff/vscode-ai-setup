# Quick Reference / Cheatsheet

## Daily Commands

```bash
# Make sure Ollama is running (if using local models)
# Either via macOS app (menu bar icon) or:
ollama serve

# Work with Claude Code
cd your-project

# With Anthropic (planning, complex tasks)
claude

# With local model (execution, simple tasks)
claude --model qwen3-coder

# Switch model during session
/model qwen3-coder
/model gpt-oss:20b
```

## Typical Workflow

```
1. Open project      → cd my-project && claude
2. Plan feature      → "I need to implement X"
                       (Claude uses 'planner')
3. Review plan       → docs/tasks/task-XXX.md
4. Execute           → "Execute the plan for TASK-XXX"
                       (switch to local: /model qwen3-coder)
5. Iterate           → "Adjust component Y"
```

## Ollama Management

```bash
# Check loaded models (RAM usage)
ollama ps

# Manually unload from RAM
ollama stop qwen3-coder

# List available models
ollama list

# Download new model
ollama pull gpt-oss:20b

# Check if Ollama is running
curl http://localhost:11434/api/tags
```

## File Structure

```
.claude/
├── agents/
│   ├── planner.md        # For planning (use with Sonnet or capable model)
│   └── task-executor.md  # For execution (use with local model)
└── settings.json

docs/
├── 00_scope.md           # What we're building
├── 01_task_list.md       # Task list
└── tasks/
    └── task-XXX.md       # Execution plans

CLAUDE.md                 # Project context
```

## Quick Troubleshooting

```bash
# Ollama not responding
curl http://localhost:11434/api/tags
# If error, start it:
ollama serve

# Claude Code doesn't find agents
ls -la .claude/agents/  # Verify they exist

# Ollama using too much RAM
ollama ps               # Check what's loaded
ollama stop <model>     # Unload from memory

# Context length errors - create larger context model
echo 'FROM qwen3-coder
PARAMETER num_ctx 32768' > /tmp/Modelfile
ollama create qwen3-coder-32k -f /tmp/Modelfile
```

## Environment Setup

```bash
# Option A: Ollama only (add to ~/.zshrc)
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_BASE_URL=http://localhost:11434

# Option B: Anthropic + Ollama alias (add to ~/.zshrc)
export ANTHROPIC_API_KEY="sk-ant-..."
alias claude-local='ANTHROPIC_AUTH_TOKEN=ollama ANTHROPIC_BASE_URL=http://localhost:11434 claude --model qwen3-coder'
```

## Recommended Models

| Model | RAM | Best For |
|-------|-----|----------|
| `qwen3-coder` | 8GB | Coding tasks |
| `gpt-oss:20b` | 16GB | General purpose |
| `gpt-oss:120b` | 64GB+ | Complex reasoning |
