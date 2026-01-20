# Quick Reference / Cheatsheet

## Daily Commands

```bash
# Start router (first terminal)
ccr start

# Work with Claude Code
cd your-project
claude

# Switch model in session
/model ollama,qwen2.5-coder:7b           # Local (free)
/model anthropic,claude-sonnet-4-20250514 # Premium

# Check router status
ccr status
```

## Typical Workflow

```
1. Open project      → cd my-project && claude
2. Plan feature      → "I need to implement X"
                       (Claude uses 'planner' → Sonnet)
3. Review plan       → docs/tasks/task-XXX.md
4. Execute           → "Execute the plan for TASK-XXX"
                       (Claude uses 'task-executor' → Ollama)
5. Iterate           → "Adjust component Y"
```

## Ollama Management

```bash
# Check loaded models (RAM usage)
ollama ps

# Manually unload from RAM
ollama stop qwen2.5-coder:7b

# List available models
ollama list

# Download new model
ollama pull codellama:7b
```

## File Structure

```
.claude/
├── agents/
│   ├── planner.md        # model: sonnet
│   └── task-executor.md  # model: ollama local
└── settings.json

docs/
├── 00_scope.md           # What we're building
├── 01_task_list.md       # Task list
└── tasks/
    └── task-XXX.md       # Execution plans

CLAUDE.md                 # Project context
```

## CCR Automatic Routing

| Context | Assigned Model |
|---------|----------------|
| `default` | Ollama qwen2.5-coder:7b |
| `background` | Ollama qwen2.5-coder:7b |
| `think` | Claude Sonnet |
| `longContext` (>60k tokens) | Claude Sonnet |

## Quick Troubleshooting

```bash
# CCR not responding
ccr stop && ccr start

# Claude Code doesn't find agents
ls -la .claude/agents/  # Verify they exist

# Ollama using too much RAM
ollama ps               # Check what's loaded
ollama stop <model>     # Unload from memory
```

## API Keys Required

| Service | Variable | Where to get |
|---------|----------|--------------|
| Claude | `ANTHROPIC_API_KEY` | console.anthropic.com |
| DeepSeek (optional) | `DEEPSEEK_API_KEY` | platform.deepseek.com |
