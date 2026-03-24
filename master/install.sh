#!/usr/bin/env bash
# AI Powerhouse — Install Script
# Installs all tools into ~/.claude (or --local for repo-local master/.claude)
#
# Usage:
#   bash install.sh           # install to ~/.claude
#   bash install.sh --local   # install to master/.claude (repo-local)
#   bash install.sh --dry-run # preview only
#   bash install.sh --minimal # core tools only (no language rules)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION="$(git -C "$REPO_ROOT" describe --tags --always 2>/dev/null || echo 'dev')"

DRY_RUN=false
LOCAL=false
MINIMAL=false

for arg in "${@:-}"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --local)   LOCAL=true ;;
    --minimal) MINIMAL=true ;;
  esac
done

if $LOCAL; then
  CLAUDE_DIR="$SCRIPT_DIR/.claude"
else
  CLAUDE_DIR="$HOME/.claude"
fi

log()    { echo "[install] $*"; }
warn()   { echo "[install] ⚠️  $*"; }
action() { $DRY_RUN && echo "[dry-run] $*" || eval "$*"; }

# ── Pre-flight checks ────────────────────────────────────────────────────────

log "AI Powerhouse $VERSION"

# Check submodules are initialized
if [[ ! -f "$REPO_ROOT/everything-claude-code/agents/architect.md" ]]; then
  echo ""
  echo "ERROR: Submodules not initialized. Run:"
  echo "  git submodule update --init --recursive"
  echo ""
  exit 1
fi

# Check Node.js ≥18
if ! command -v node &>/dev/null; then
  echo ""
  echo "ERROR: Node.js not found. Install Node.js ≥18:"
  echo "  macOS:  brew install node"
  echo "  Linux:  https://nodejs.org"
  echo ""
  exit 1
fi

node_major=$(node -e 'process.stdout.write(process.version.split(".")[0].replace("v",""))')
if (( node_major < 18 )); then
  echo "ERROR: Node.js ≥18 required (found $(node -v))"
  exit 1
fi

# Check Bun (claude-mem needs it)
if ! command -v bun &>/dev/null; then
  warn "Bun not found — claude-mem memory hooks need it."
  warn "Install: curl -fsSL https://bun.sh/install | bash  (or: npm i -g bun)"
  warn "Continuing without Bun — other tools will still work."
fi

# Verify submodule hashes if lock file exists
LOCK_FILE="$REPO_ROOT/submodule-hashes.lock"
if [[ -f "$LOCK_FILE" ]] && command -v python3 &>/dev/null; then
  log "Verifying submodule integrity..."
  python3 - <<'PYEOF'
import json, subprocess, sys, os
lock = json.load(open(os.environ.get('LOCK_FILE', 'submodule-hashes.lock')))
repo = os.environ.get('REPO_ROOT', '.')
warnings = []
for name, expected in lock.items():
    if name.startswith('_'): continue
    path = os.path.join(repo, name)
    if not os.path.isdir(path): continue
    actual = subprocess.run(['git','-C',path,'rev-parse','HEAD'], capture_output=True, text=True).stdout.strip()
    if actual and actual != expected:
        warnings.append(f"  {name}: expected {expected[:12]}, got {actual[:12]}")
if warnings:
    print("[install] ⚠️  Submodule hash mismatch (upstream changed):")
    for w in warnings: print(w)
    print("[install]    Run: bash scripts/update-hashes.sh  to accept new commits")
PYEOF
fi

# ── Ensure target directories exist ─────────────────────────────────────────

for dir in agents skills commands hooks rules; do
  action "mkdir -p '$CLAUDE_DIR/$dir'"
done

# ── Helper: symlink with absolute source path ────────────────────────────────

link() {
  local src="$1" dst="$2"
  # Always resolve to absolute path so symlinks survive repo moves
  src="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
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
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/agents/ecc-$(basename "$f")"
done

# superpowers
for f in "$REPO_ROOT/superpowers/agents/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/agents/superpowers-$(basename "$f")"
done

# get-shit-done
for f in "$REPO_ROOT/get-shit-done/agents/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/agents/gsd-$(basename "$f")"
done

# ruflo (nested dirs — flatten, prefix category on duplicate names)
declare -A _ruflo_seen
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  base=$(basename "$f" .md)
  rel="${f#$REPO_ROOT/ruflo/plugin/agents/}"
  category=$(dirname "$rel" | sed 's|/|-|g')
  if [[ -n "${_ruflo_seen[$base]+x}" ]]; then
    link "$f" "$CLAUDE_DIR/agents/ruflo-${category}-${base}.md"
    prev_rel="${_ruflo_seen[$base]}"
    prev_cat=$(dirname "$prev_rel" | sed 's|/|-|g')
    rm -f "$CLAUDE_DIR/agents/ruflo-${base}.md"
    link "$REPO_ROOT/ruflo/plugin/agents/${prev_rel}" \
         "$CLAUDE_DIR/agents/ruflo-${prev_cat}-${base}.md"
  else
    _ruflo_seen[$base]="$rel"
    link "$f" "$CLAUDE_DIR/agents/ruflo-${base}.md"
  fi
done < <(find "$REPO_ROOT/ruflo/plugin/agents/" -name "*.md" | sort)
unset _ruflo_seen

log "Agents installed."

# ── SKILLS ───────────────────────────────────────────────────────────────────

log "Installing skills..."

# everything-claude-code
for d in "$REPO_ROOT/everything-claude-code/skills/"/*/; do
  [[ -d "$d" ]] || continue
  link "$d" "$CLAUDE_DIR/skills/ecc-$(basename "$d")"
done

# superpowers
for d in "$REPO_ROOT/superpowers/skills/"/*/; do
  [[ -d "$d" ]] || continue
  link "$d" "$CLAUDE_DIR/skills/superpowers-$(basename "$d")"
done

# claude-mem
for d in "$REPO_ROOT/claude-mem/plugin/skills/"/*/; do
  [[ -d "$d" ]] || continue
  link "$d" "$CLAUDE_DIR/skills/mem-$(basename "$d")"
done

# ui-ux-pro-max
for d in "$REPO_ROOT/ui-ux-pro-max-skill/.claude/skills/"/*/; do
  [[ -d "$d" ]] || continue
  link "$d" "$CLAUDE_DIR/skills/uiux-$(basename "$d")"
done

# ruflo
for d in "$REPO_ROOT/ruflo/plugin/skills/"/*/; do
  [[ -d "$d" ]] || continue
  link "$d" "$CLAUDE_DIR/skills/ruflo-$(basename "$d")"
done

# master (local skills: agent-routing etc.)
if [[ -d "$SCRIPT_DIR/skills" ]]; then
  for d in "$SCRIPT_DIR/skills/"/*/; do
    [[ -d "$d" ]] || continue
    link "$d" "$CLAUDE_DIR/skills/master-$(basename "$d")"
  done
fi

log "Skills installed."

# ── COMMANDS ─────────────────────────────────────────────────────────────────

log "Installing commands..."

# everything-claude-code
for f in "$REPO_ROOT/everything-claude-code/commands/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/commands/ecc-$(basename "$f")"
done

# superpowers
for f in "$REPO_ROOT/superpowers/commands/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/commands/superpowers-$(basename "$f")"
done

# get-shit-done
for f in "$REPO_ROOT/get-shit-done/commands/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/commands/gsd-$(basename "$f")"
done

# ruflo (top-level entry points only)
for f in "$REPO_ROOT/ruflo/plugin/commands/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/commands/ruflo-$(basename "$f")"
done

log "Commands installed."

# ── RULES ────────────────────────────────────────────────────────────────────

log "Installing rules..."

# Always install common rules (core engineering standards)
if [[ -d "$REPO_ROOT/everything-claude-code/rules/common" ]]; then
  link "$REPO_ROOT/everything-claude-code/rules/common" "$CLAUDE_DIR/rules/ecc-common"
fi

# Language-specific rules: only in full install (not --minimal)
if ! $MINIMAL; then
  for d in "$REPO_ROOT/everything-claude-code/rules/"/*/; do
    name=$(basename "$d")
    [[ "$name" == "common" ]] && continue  # already linked above
    link "$d" "$CLAUDE_DIR/rules/ecc-$name"
  done
fi

log "Rules installed$(if $MINIMAL; then echo ' (minimal — language rules skipped)'; fi)."

# ── HOOKS ────────────────────────────────────────────────────────────────────

log "Installing hooks..."

# everything-claude-code
link "$REPO_ROOT/everything-claude-code/hooks/hooks.json" \
     "$CLAUDE_DIR/hooks/ecc-hooks.json"

# get-shit-done
for f in "$REPO_ROOT/get-shit-done/hooks/"*.js; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/hooks/gsd-$(basename "$f")"
done

# claude-mem
# Create marketplace symlink so claude-mem hooks find their scripts
if ! $DRY_RUN; then
  mkdir -p "$HOME/.claude/plugins/marketplaces/thedotmack"
  if [[ -e "$HOME/.claude/plugins/marketplaces/thedotmack/plugin" || \
        -L "$HOME/.claude/plugins/marketplaces/thedotmack/plugin" ]]; then
    rm -rf "$HOME/.claude/plugins/marketplaces/thedotmack/plugin"
  fi
  ln -sf "$REPO_ROOT/claude-mem/plugin" \
         "$HOME/.claude/plugins/marketplaces/thedotmack/plugin"
fi
link "$REPO_ROOT/claude-mem/plugin/hooks/hooks.json" \
     "$CLAUDE_DIR/hooks/mem-hooks.json"
if ! $DRY_RUN && command -v bun &>/dev/null; then
  log "Running claude-mem setup (Bun + SQLite deps)..."
  CLAUDE_PLUGIN_ROOT="$REPO_ROOT/claude-mem/plugin" \
    node "$REPO_ROOT/claude-mem/plugin/scripts/smart-install.js" 2>/dev/null \
    || warn "claude-mem setup failed — memory hooks may not work"
fi

# ruflo — use version-pinned copy (not @alpha)
link "$SCRIPT_DIR/hooks/ruflo-hooks.json" "$CLAUDE_DIR/hooks/ruflo-hooks.json"

log "Hooks installed."

# ── WRITE MANIFEST ───────────────────────────────────────────────────────────

if ! $DRY_RUN; then
  python3 - <<PYEOF
import json, subprocess, datetime, os

repo = os.environ.get('REPO_ROOT', '.')
claude_dir = os.environ.get('CLAUDE_DIR', os.path.expanduser('~/.claude'))

def sha(path):
    r = subprocess.run(['git','-C',path,'rev-parse','HEAD'], capture_output=True, text=True)
    return r.stdout.strip() or 'unknown'

submodules = ['awesome-claude-code','claude-mem','everything-claude-code',
              'get-shit-done','pm-workspace','ruflo','superpowers','ui-ux-pro-max-skill']

manifest = {
    'version': os.environ.get('VERSION', 'dev'),
    'installed_at': datetime.datetime.utcnow().isoformat() + 'Z',
    'install_mode': 'local' if os.environ.get('LOCAL') == 'true' else 'global',
    'minimal': os.environ.get('MINIMAL') == 'true',
    'agents': len([f for f in os.listdir(os.path.join(claude_dir,'agents')) if f.endswith('.md')]),
    'skills': len(os.listdir(os.path.join(claude_dir,'skills'))),
    'commands': len([f for f in os.listdir(os.path.join(claude_dir,'commands')) if f.endswith('.md')]),
    'rules': len(os.listdir(os.path.join(claude_dir,'rules'))),
    'submodule_hashes': {m: sha(os.path.join(repo, m)) for m in submodules if os.path.isdir(os.path.join(repo,m))}
}

out = os.path.join(claude_dir, 'POWERHOUSE_MANIFEST.json')
json.dump(manifest, open(out,'w'), indent=2)
print(f'[install] Manifest written to {out}')
PYEOF
  REPO_ROOT="$REPO_ROOT" CLAUDE_DIR="$CLAUDE_DIR" VERSION="$VERSION" \
  LOCAL="$LOCAL" MINIMAL="$MINIMAL" python3 - <<'PYEOF2'
import json, subprocess, datetime, os

repo = os.environ['REPO_ROOT']
claude_dir = os.environ['CLAUDE_DIR']

def sha(path):
    r = subprocess.run(['git','-C',path,'rev-parse','HEAD'], capture_output=True, text=True)
    return r.stdout.strip() or 'unknown'

submodules = ['awesome-claude-code','claude-mem','everything-claude-code',
              'get-shit-done','pm-workspace','ruflo','superpowers','ui-ux-pro-max-skill']

def count_dir(d, ext=None):
    try:
        files = os.listdir(d)
        return len([f for f in files if (not ext or f.endswith(ext))]) if files else 0
    except: return 0

manifest = {
    'version': os.environ.get('VERSION','dev'),
    'installed_at': datetime.datetime.utcnow().isoformat() + 'Z',
    'install_mode': 'local' if os.environ.get('LOCAL')=='true' else 'global',
    'minimal': os.environ.get('MINIMAL')=='true',
    'counts': {
        'agents':   count_dir(os.path.join(claude_dir,'agents'), '.md'),
        'skills':   count_dir(os.path.join(claude_dir,'skills')),
        'commands': count_dir(os.path.join(claude_dir,'commands'), '.md'),
        'rules':    count_dir(os.path.join(claude_dir,'rules')),
        'hooks':    count_dir(os.path.join(claude_dir,'hooks')),
    },
    'submodule_hashes': {m: sha(os.path.join(repo,m))
                         for m in submodules if os.path.isdir(os.path.join(repo,m))}
}
out = os.path.join(claude_dir,'POWERHOUSE_MANIFEST.json')
with open(out,'w') as f: json.dump(manifest, f, indent=2)
print(f'[install] Manifest written → {out}')
PYEOF2
fi

# ── SUMMARY ──────────────────────────────────────────────────────────────────

if ! $DRY_RUN; then
  echo ""
  echo "✅ AI Powerhouse $VERSION installed to $CLAUDE_DIR"
  echo ""
  echo "  Agents   : $(ls "$CLAUDE_DIR/agents/"  2>/dev/null | grep -c '\.md' || echo 0)"
  echo "  Skills   : $(ls "$CLAUDE_DIR/skills/"  2>/dev/null | wc -l | tr -d ' ')"
  echo "  Commands : $(ls "$CLAUDE_DIR/commands/" 2>/dev/null | grep -c '\.md' || echo 0)"
  echo "  Rules    : $(ls "$CLAUDE_DIR/rules/"   2>/dev/null | wc -l | tr -d ' ')"
  echo "  Hooks    : $(ls "$CLAUDE_DIR/hooks/"   2>/dev/null | wc -l | tr -d ' ')"
  echo ""
  if $MINIMAL; then
    echo "  (Minimal install — language-specific rules skipped)"
    echo "  Re-run without --minimal to add Python/Go/Rust/etc. rules"
    echo ""
  fi
  echo "Restart Claude Code to pick up all new tools."
fi
