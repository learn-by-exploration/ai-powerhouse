#!/usr/bin/env bash
# AI Powerhouse — Uninstall Script
# Removes everything install.sh put into ~/.claude
#
# Usage:
#   bash uninstall.sh           # remove from ~/.claude
#   bash uninstall.sh --local   # remove from master/.claude

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOCAL=false
for arg in "${@:-}"; do
  [[ "$arg" == "--local" ]] && LOCAL=true
done

if $LOCAL; then
  CLAUDE_DIR="$SCRIPT_DIR/.claude"
else
  CLAUDE_DIR="$HOME/.claude"
fi

log() { echo "[uninstall] $*"; }

MANIFEST="$CLAUDE_DIR/POWERHOUSE_MANIFEST.json"
if [[ ! -f "$MANIFEST" ]]; then
  log "No installation found at $CLAUDE_DIR (manifest missing)."
  log "If you installed manually, remove files with prefix: ecc- gsd- superpowers- ruflo- mem- uiux- master-"
  exit 0
fi

version=$(python3 -c "import json; print(json.load(open('$MANIFEST'))['version'])" 2>/dev/null || echo "unknown")
log "Removing AI Powerhouse $version from $CLAUDE_DIR..."

for prefix in ecc- superpowers- gsd- mem- ruflo- uiux- master-; do
  # agents
  find "$CLAUDE_DIR/agents/" -name "${prefix}*.md" -delete 2>/dev/null || true
  # skills
  find "$CLAUDE_DIR/skills/" -maxdepth 1 -name "${prefix}*" -exec rm -rf {} + 2>/dev/null || true
  # commands
  find "$CLAUDE_DIR/commands/" -name "${prefix}*.md" -delete 2>/dev/null || true
  # hooks
  find "$CLAUDE_DIR/hooks/" -name "${prefix}*" -delete 2>/dev/null || true
  # rules
  find "$CLAUDE_DIR/rules/" -maxdepth 1 -name "${prefix}*" -exec rm -rf {} + 2>/dev/null || true
done

# Remove claude-mem marketplace symlink
if [[ -L "$HOME/.claude/plugins/marketplaces/thedotmack/plugin" ]]; then
  rm -f "$HOME/.claude/plugins/marketplaces/thedotmack/plugin"
  log "Removed claude-mem marketplace symlink."
fi

# Remove manifest
rm -f "$MANIFEST"

log "Done. Restart Claude Code."
