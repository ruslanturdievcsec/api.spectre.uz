#!/bin/bash
# Installs the Agent Reach CLI (https://github.com/Panniantong/Agent-Reach)
# in Claude Code cloud sessions. The skill itself lives in .claude/skills/agent-reach.
# Local machines are left alone.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

export PATH="$HOME/.local/bin:$PATH"

if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$HOME/.local/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi

if command -v agent-reach >/dev/null 2>&1; then
  exit 0
fi

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1
fi

# Never install from PyPI: the PyPI package with this name is a different project.
uv tool install https://github.com/Panniantong/Agent-Reach/releases/latest/download/agent-reach.zip >/dev/null 2>&1
agent-reach setup >/dev/null 2>&1

# setup also links the skill into ~/.claude/skills; the repo already ships it.
if [ -L "$HOME/.claude/skills/agent-reach" ]; then
  rm "$HOME/.claude/skills/agent-reach"
fi
