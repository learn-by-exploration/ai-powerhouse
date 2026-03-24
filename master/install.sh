#!/usr/bin/env bash
# AI Powerhouse — Global Install Script
# Installs all state-of-the-art tools into ~/.claude so Claude Code
# can use them in ANY project on your machine.
#
# Usage:
#   bash install.sh           # install everything
#   bash install.sh --dry-run # preview what will be installed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
DRY_RUN=false

[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

log()    { echo "[install] $*"; }
action() { $DRY_RUN && echo "[dry-run] $*" || eval "$*"; }

# ── Ensure ~/.claude directories exist ──────────────────────────────────────

for dir in agents skills commands hooks rules; do
  action "mkdir -p '$CLAUDE_DIR/$dir'"
done

# ── Helper: symlink a file or directory ─────────────────────────────────────

link() {
  local src="$1" dst="$2"
  if $DRY_RUN; then
    echo "[dry-run] ln -sf '$src' -> '$dst'"
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    rm -rf "$dst"
  fi
  ln -sf "$src" "$dst"
}

# ── AGENTS ───────────────────────────────────────────────────────────────────

log "Installing agents..."

# everything-claude-code
for f in "$REPO_ROOT/everything-claude-code/agents/"*.md; do
  name=$(basename "$f")
  link "$f" "$CLAUDE_DIR/agents/ecc-$name"
done

# superpowers
for f in "$REPO_ROOT/superpowers/agents/"*.md; do
  name=$(basename "$f")
  link "$f" "$CLAUDE_DIR/agents/superpowers-$name"
done

# get-shit-done
for f in "$REPO_ROOT/get-shit-done/agents/"*.md; do
  name=$(basename "$f")
  link "$f" "$CLAUDE_DIR/agents/gsd-$name"
done

log "Agents installed."

# ── SKILLS ───────────────────────────────────────────────────────────────────

log "Installing skills..."

# everything-claude-code
for d in "$REPO_ROOT/everything-claude-code/skills/"/*/; do
  name=$(basename "$d")
  link "$d" "$CLAUDE_DIR/skills/ecc-$name"
done

# superpowers
for d in "$REPO_ROOT/superpowers/skills/"/*/; do
  name=$(basename "$d")
  link "$d" "$CLAUDE_DIR/skills/superpowers-$name"
done

# claude-mem
for d in "$REPO_ROOT/claude-mem/plugin/skills/"/*/; do
  name=$(basename "$d")
  link "$d" "$CLAUDE_DIR/skills/mem-$name"
done

# ui-ux-pro-max
for d in "$REPO_ROOT/ui-ux-pro-max-skill/.claude/skills/"/*/; do
  name=$(basename "$d")
  link "$d" "$CLAUDE_DIR/skills/uiux-$name"
done

log "Skills installed."

# ── COMMANDS ─────────────────────────────────────────────────────────────────

log "Installing commands..."

# everything-claude-code
for f in "$REPO_ROOT/everything-claude-code/commands/"*.md; do
  name=$(basename "$f")
  link "$f" "$CLAUDE_DIR/commands/ecc-$name"
done

# superpowers
for f in "$REPO_ROOT/superpowers/commands/"*.md; do
  name=$(basename "$f")
  link "$f" "$CLAUDE_DIR/commands/superpowers-$name"
done

# get-shit-done
for f in "$REPO_ROOT/get-shit-done/commands/"*.md; do
  name=$(basename "$f")
  link "$f" "$CLAUDE_DIR/commands/gsd-$name"
done

log "Commands installed."

# ── RULES ────────────────────────────────────────────────────────────────────

log "Installing rules..."

for d in "$REPO_ROOT/everything-claude-code/rules/"/*/; do
  name=$(basename "$d")
  link "$d" "$CLAUDE_DIR/rules/ecc-$name"
done

log "Rules installed."

# ── HOOKS ─────────────────────────────────────────────────────────────────────

log "Installing hooks..."

# everything-claude-code
link "$REPO_ROOT/everything-claude-code/hooks/hooks.json" "$CLAUDE_DIR/hooks/ecc-hooks.json"

# get-shit-done
for f in "$REPO_ROOT/get-shit-done/hooks/"*.js; do
  [[ -f "$f" ]] || continue
  name=$(basename "$f")
  link "$f" "$CLAUDE_DIR/hooks/gsd-$name"
done

# claude-mem
link "$REPO_ROOT/claude-mem/plugin/hooks/hooks.json" "$CLAUDE_DIR/hooks/mem-hooks.json"

# ruflo
link "$REPO_ROOT/ruflo/plugin/hooks/hooks.json" "$CLAUDE_DIR/hooks/ruflo-hooks.json"

log "Hooks installed."

# ── SUMMARY ──────────────────────────────────────────────────────────────────

if ! $DRY_RUN; then
  echo ""
  echo "✅ AI Powerhouse installed to ~/.claude"
  echo ""
  echo "  Agents   : $(ls "$CLAUDE_DIR/agents/" | grep -c '\.md' || true)"
  echo "  Skills   : $(ls "$CLAUDE_DIR/skills/" | wc -l | tr -d ' ')"
  echo "  Commands : $(ls "$CLAUDE_DIR/commands/" | grep -c '\.md' || true)"
  echo "  Rules    : $(ls "$CLAUDE_DIR/rules/" | wc -l | tr -d ' ')"
  echo "  Hooks    : $(ls "$CLAUDE_DIR/hooks/" | wc -l | tr -d ' ')"
  echo ""
  echo "Restart Claude Code to pick up all new tools."
fi
