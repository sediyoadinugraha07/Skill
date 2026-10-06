#!/bin/bash
# Installs claude-mem from npm and starts its worker in Claude Code cloud sessions.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

export CLAUDE_MEM_ONLINE_OPTIN=false

# Run from a neutral dir: the repo root has a package.json named claude-mem,
# which makes npx resolve a local (unbuilt) bin instead of the npm package.
cd /tmp

# Idempotent: skip the installer when the plugin is already registered.
if [ ! -d "$HOME/.claude/plugins/marketplaces/thedotmack" ]; then
  npx -y claude-mem install </dev/null
fi

# Worker does not autostart in non-interactive installs.
if ! curl -fsS -m 3 http://127.0.0.1:37700/api/health >/dev/null 2>&1; then
  npx -y claude-mem start </dev/null
fi
