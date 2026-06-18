#!/usr/bin/env bash
# AI Powerhouse — Uninstall Script
# Removes everything install.sh put into ~/.claude (or master/.claude with --local)
#
# Usage:
#   bash uninstall.sh           # remove from ~/.claude
#   bash uninstall.sh --local   # remove from master/.claude
#   bash uninstall.sh --dry-run # preview only

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=false
LOCAL=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --local)   LOCAL=true ;;
    --*)
      echo "[uninstall] WARNING: Unknown flag '$arg' — ignored." >&2
      ;;
  esac
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
  log "If you installed manually, remove files with prefix: ecc- gsd- superpowers- ruflo- mem- uiux- master- ws- sc- ctm- drawio-skill plantuml-skill ponytail-"
  exit 0
fi

version=$(python3 -c "import json; print(json.load(open('$MANIFEST'))['version'])" 2>/dev/null || echo "unknown")
log "Removing AI Powerhouse $version from $CLAUDE_DIR..."

_remove() {
  local desc="$1" path="$2"
  if $DRY_RUN; then
    echo "[dry-run] rm -rf '$path'"
  else
    rm -rf "$path"
  fi
}

for prefix in ecc- superpowers- gsd- mem- ruflo- uiux- master- ws- sc- ctm- ponytail-; do
  # agents (files)
  for f in "$CLAUDE_DIR/agents/${prefix}"*.md; do
    [[ -e "$f" ]] || continue
    _remove "agent" "$f"
  done
  # skills (dirs)
  for d in "$CLAUDE_DIR/skills/${prefix}"*/; do
    [[ -e "$d" ]] || continue
    _remove "skill" "$d"
  done
  # commands (files)
  for f in "$CLAUDE_DIR/commands/${prefix}"*.md; do
    [[ -e "$f" ]] || continue
    _remove "command" "$f"
  done
  # hooks (files)
  for f in "$CLAUDE_DIR/hooks/${prefix}"*; do
    [[ -e "$f" ]] || continue
    _remove "hook" "$f"
  done
  # rules (dirs/symlinks)
  for d in "$CLAUDE_DIR/rules/${prefix}"*/; do
    [[ -e "$d" ]] || continue
    _remove "rule" "$d"
  done
  # rules (non-trailing-slash symlinks, e.g. plain links)
  for f in "$CLAUDE_DIR/rules/${prefix}"*; do
    [[ -e "$f" ]] || continue
    _remove "rule" "$f"
  done
done

# Remove claude-mem marketplace symlink (use $CLAUDE_DIR, not hardcoded $HOME/.claude)
_mem_plugin="$CLAUDE_DIR/plugins/marketplaces/thedotmack/plugin"
if [[ -L "$_mem_plugin" ]]; then
  if $DRY_RUN; then
    echo "[dry-run] rm '$_mem_plugin'"
  else
    rm -f "$_mem_plugin"
    log "Removed claude-mem marketplace symlink."
  fi
fi

# Remove unprefixed skills (drawio-skill, plantuml-skill) by exact name
for skill in drawio-skill plantuml-skill; do
  if [[ -e "$CLAUDE_DIR/skills/$skill" || -L "$CLAUDE_DIR/skills/$skill" ]]; then
    _remove "skill" "$CLAUDE_DIR/skills/$skill"
  fi
done

# Remove master/CLAUDE.md symlink (only if it's our symlink, never a real user file)
if [[ -L "$CLAUDE_DIR/CLAUDE.md" ]] && \
   [[ "$(readlink "$CLAUDE_DIR/CLAUDE.md")" == *"ai-powerhouse/master/CLAUDE.md" || \
      "$(readlink "$CLAUDE_DIR/CLAUDE.md")" == *"/master/CLAUDE.md" ]]; then
  _remove "claude.md symlink" "$CLAUDE_DIR/CLAUDE.md"
fi

# Remove manifest
if $DRY_RUN; then
  echo "[dry-run] rm '$MANIFEST'"
else
  rm -f "$MANIFEST"
fi

if ! $DRY_RUN; then
  log "Done. Restart Claude Code."
fi
