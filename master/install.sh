#!/usr/bin/env bash
# AI Powerhouse — Install Script
# Installs all tools into ~/.claude (or --local for repo-local master/.claude)
#
# Usage:
#   bash install.sh              # install to ~/.claude (default: minimal)
#   bash install.sh --full        # install all language rules
#   bash install.sh --with-ruflo  # include 76 ruflo enterprise agents/skills/hooks (+~50K tokens)
#   bash install.sh --local      # install to master/.claude (repo-local)
#   bash install.sh --dry-run    # preview only (no changes made)
#   bash install.sh --backup     # snapshot ~/.claude before writing (safe first-time install)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION="$(git -C "$REPO_ROOT" describe --tags --always 2>/dev/null || echo 'dev')"

DRY_RUN=false
LOCAL=false
MINIMAL=true    # default ON — full install requires --full
NO_RUFLO=true
BACKUP=false

for arg in "$@"; do
  case "$arg" in
    --dry-run)  DRY_RUN=true ;;
    --local)    LOCAL=true ;;
    --backup)   BACKUP=true ;;
    --minimal)  MINIMAL=true ;;   # kept for backwards compat
    --full)     MINIMAL=false ;;
    --no-ruflo)   NO_RUFLO=true ;;   # kept for backwards compat
    --with-ruflo) NO_RUFLO=false ;;
    --*)
      echo "[install] WARNING: Unknown flag '$arg' — ignored." >&2
      ;;
  esac
done

if $LOCAL; then
  CLAUDE_DIR="$SCRIPT_DIR/.claude"
else
  CLAUDE_DIR="$HOME/.claude"
fi

log()  { echo "[install] $*"; }
warn() { echo "[install] ⚠️  $*" >&2; }

# ── Pre-flight checks ────────────────────────────────────────────────────────

log "AI Powerhouse $VERSION"

# NOTE: Some submodules are tracked for reference/browsing only and NOT installed:
# - pm-workspace: incompatible directory structure (commands in root, not commands/ subdir)
# - awesome-claude-code: curated Awesome List with no installable agents/skills
# - autoresearch (karpathy): pure Python nanochat training research; no Claude Code tooling
# See their READMEs for standalone usage.

# Check all installable submodules are initialized.
# Reference-only submodules (autoresearch, awesome-claude-code, pm-workspace)
# are NOT in this list — they ship as browse-only and have no install loop.
_required_subs=(everything-claude-code superpowers get-shit-done claude-mem
                ui-ux-pro-max-skill drawio-skill plantuml-skill
                anthropics-skills alirezarezvani-claude-skills ponytail
                claude-task-master super-claude wshobson-agents)
if ! $NO_RUFLO; then
  _required_subs+=(ruflo)
fi
_missing=()
for _sm in "${_required_subs[@]}"; do
  if [[ ! -d "$REPO_ROOT/$_sm" ]] || [[ -z "$(ls -A "$REPO_ROOT/$_sm" 2>/dev/null)" ]]; then
    _missing+=("$_sm")
  fi
done
if (( ${#_missing[@]} > 0 )); then
  echo ""
  echo "ERROR: Submodules not initialized: ${_missing[*]}"
  echo "  Run: git submodule update --init --recursive"
  echo ""
  exit 1
fi
unset _required_subs _missing _sm

# Check Node.js ≥18
if ! command -v node &>/dev/null; then
  echo ""
  echo "ERROR: Node.js not found. Install Node.js ≥18:"
  echo "  macOS:  brew install node"
  echo "  Linux:  https://nodejs.org"
  echo ""
  exit 1
fi

node_major=$(node -e 'process.stdout.write(process.version.split(".")[0].replace("v",""))' 2>/dev/null || echo "0")
if ! [[ "$node_major" =~ ^[0-9]+$ ]]; then
  warn "Could not determine Node.js version — skipping version check."
elif (( node_major < 18 )); then
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
  LOCK_FILE="$LOCK_FILE" REPO_ROOT="$REPO_ROOT" python3 - <<'PYEOF'
import json, subprocess, sys, os
lock_path = os.environ['LOCK_FILE']
repo      = os.environ['REPO_ROOT']
try:
    lock = json.load(open(lock_path))
except Exception as e:
    print(f"[install] WARNING: Could not read lock file: {e}", file=sys.stderr)
    sys.exit(0)
warnings = []
for name, expected in lock.items():
    if name.startswith('_'): continue
    path = os.path.join(repo, name)
    if not os.path.isdir(path): continue
    r = subprocess.run(['git','-C',path,'rev-parse','HEAD'], capture_output=True, text=True)
    actual = r.stdout.strip()
    if actual and actual != expected:
        warnings.append(f"  {name}: expected {expected[:12]}, got {actual[:12]}")
if warnings:
    print("[install] ⚠️  Submodule hash mismatch (upstream changed):")
    for w in warnings: print(w)
    print("[install]    Run: bash scripts/update-hashes.sh  to accept new commits")
PYEOF
fi

# ── Backup existing ~/.claude if requested ───────────────────────────────────

if $BACKUP && ! $DRY_RUN && [[ -d "$CLAUDE_DIR" ]]; then
  BACKUP_PATH="${CLAUDE_DIR}.backup-$(date +%Y%m%d-%H%M%S)"
  log "Backing up $CLAUDE_DIR → $BACKUP_PATH"
  cp -r "$CLAUDE_DIR" "$BACKUP_PATH"
  log "Backup complete. Restore with: cp -r '$BACKUP_PATH' '$CLAUDE_DIR'"
elif $BACKUP && $DRY_RUN; then
  echo "[dry-run] cp -r '$CLAUDE_DIR' '${CLAUDE_DIR}.backup-<timestamp>'"
fi

# ── Ensure target directories exist ─────────────────────────────────────────

for dir in agents skills commands hooks rules; do
  if $DRY_RUN; then
    echo "[dry-run] mkdir -p '$CLAUDE_DIR/$dir'"
  else
    mkdir -p "$CLAUDE_DIR/$dir"
  fi
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
    if [[ -L "$dst" ]]; then
      rm -f "$dst"
    else
      warn "Skipping '$dst' — exists as a real file/dir (not a symlink). Remove manually to reinstall."
      return
    fi
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
  base=$(basename "$f")
  # Source files already have gsd- prefix — don't double it
  if [[ "$base" == gsd-* ]]; then
    link "$f" "$CLAUDE_DIR/agents/$base"
  else
    link "$f" "$CLAUDE_DIR/agents/gsd-$base"
  fi
done

# ruflo (nested dirs — flatten, prefix category on duplicate basenames)
# ruflo v3.7+ moved agents/skills/commands from ruflo/plugin/ → ruflo/plugins/ (plural).
# We walk ruflo/plugins/ recursively and use the top-level plugin name as the category.
if ! $NO_RUFLO && [[ -d "$REPO_ROOT/ruflo/plugins/" ]]; then
  declare -A _ruflo_seen
  while IFS= read -r f; do
    [[ -f "$f" ]] || continue
    base=$(basename "$f" .md)
    rel="${f#$REPO_ROOT/ruflo/plugins/}"
    category=$(dirname "$rel" | sed 's|/|-|g')
    if [[ -n "${_ruflo_seen[$base]+x}" ]]; then
      link "$f" "$CLAUDE_DIR/agents/ruflo-${category}-${base}.md"
      prev_rel="${_ruflo_seen[$base]}"
      prev_cat=$(dirname "$prev_rel" | sed 's|/|-|g')
      rm -f "$CLAUDE_DIR/agents/ruflo-${base}.md"
      link "$REPO_ROOT/ruflo/plugins/${prev_rel}" \
           "$CLAUDE_DIR/agents/ruflo-${prev_cat}-${base}.md"
    else
      _ruflo_seen[$base]="$rel"
      link "$f" "$CLAUDE_DIR/agents/ruflo-${base}.md"
    fi
  done < <(find "$REPO_ROOT/ruflo/plugins/" -path "*/agents/*" -name "*.md" 2>/dev/null | sort)
  unset _ruflo_seen
fi

# wshobson-agents (nested plugin structure — flatten, prefix with ws-)
if [[ -d "$REPO_ROOT/wshobson-agents/plugins" ]]; then
  while IFS= read -r f; do
    [[ -f "$f" ]] || continue
    base=$(basename "$f")
    plugin=$(basename "$(dirname "$(dirname "$f")")")
    link "$f" "$CLAUDE_DIR/agents/ws-${plugin}-${base}"
  done < <(find "$REPO_ROOT/wshobson-agents/plugins" -name "*.md" -path "*/agents/*" 2>/dev/null | sort)
fi

# super-claude (plugins/superclaude/agents/ structure)
for f in "$REPO_ROOT/super-claude/plugins/superclaude/agents/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/agents/sc-$(basename "$f")"
done

# claude-task-master (no dedicated agents dir — MCP-based)

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

# ruflo (skills live in ruflo/plugins/*/skills/*/ in v3.7+)
if ! $NO_RUFLO; then
  while IFS= read -r d; do
    [[ -d "$d" ]] || continue
    link "$d" "$CLAUDE_DIR/skills/ruflo-$(basename "$d")"
  done < <(find "$REPO_ROOT/ruflo/plugins/" -mindepth 3 -maxdepth 3 -type d -path "*/skills/*" 2>/dev/null | sort)
fi

# master/CLAUDE.md → ~/.claude/CLAUDE.md so the routing table is auto-loaded
# at session start. Skipped silently if the user already has a real CLAUDE.md
# (the link() helper only overwrites its own previous symlinks).
log "Linking master/CLAUDE.md → $CLAUDE_DIR/CLAUDE.md"
link "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

# master (local skills: agent-routing, se-lifecycle, ...)
if [[ -d "$SCRIPT_DIR/skills" ]]; then
  for d in "$SCRIPT_DIR/skills/"*/; do
    [[ -d "$d" ]] || continue
    link "$d" "$CLAUDE_DIR/skills/master-$(basename "$d")"
  done
fi

# master (local agents: se-systems-engineer, ...)
if [[ -d "$SCRIPT_DIR/agents" ]]; then
  for f in "$SCRIPT_DIR/agents/"*.md; do
    [[ -f "$f" ]] || continue
    base="$(basename "$f" .md)"
    link "$f" "$CLAUDE_DIR/agents/master-${base}.md"
  done
fi

# wshobson-agents skills (nested: plugins/*/skills/SKILL_NAME/)
if [[ -d "$REPO_ROOT/wshobson-agents/plugins" ]]; then
  while IFS= read -r d; do
    [[ -d "$d" ]] || continue
    link "$d" "$CLAUDE_DIR/skills/ws-$(basename "$d")"
  done < <(find "$REPO_ROOT/wshobson-agents/plugins" -mindepth 3 -maxdepth 3 -type d -path "*/skills/*" 2>/dev/null | sort)
fi

# super-claude skills
for d in "$REPO_ROOT/super-claude/plugins/superclaude/skills/"/*/; do
  [[ -d "$d" ]] || continue
  link "$d" "$CLAUDE_DIR/skills/sc-$(basename "$d")"
done

# drawio-skill (single skill — symlink as-is, no prefix)
if [[ -d "$REPO_ROOT/drawio-skill/skills/drawio-skill" ]]; then
  link "$REPO_ROOT/drawio-skill/skills/drawio-skill" "$CLAUDE_DIR/skills/drawio-skill"
fi

# plantuml-skill (single skill — symlink as-is, no prefix)
if [[ -d "$REPO_ROOT/plantuml-skill/skills/plantuml-skill" ]]; then
  link "$REPO_ROOT/plantuml-skill/skills/plantuml-skill" "$CLAUDE_DIR/skills/plantuml-skill"
fi

# anthropics/skills — official Anthropic skill library (17 skills: pdf, docx, pptx, xlsx,
# mcp-builder, webapp-testing, frontend-design, brand-guidelines, theme-factory, etc.)
if [[ -d "$REPO_ROOT/anthropics-skills/skills" ]]; then
  for d in "$REPO_ROOT/anthropics-skills/skills/"*/; do
    [[ -d "$d" ]] || continue
    link "$d" "$CLAUDE_DIR/skills/anthropic-$(basename "$d")"
  done
fi

# alirezarezvani/claude-skills — install only non-engineering business domains to
# avoid overlap with wshobson-agents (which covers engineering) and super-claude
# (which covers commands). Domains kept: business-growth, business-operations,
# c-level-advisor, commercial, compliance-os, finance, marketing-skill, product-team,
# project-management, ra-qm-team, research-ops.
# Domains deliberately skipped: engineering, engineering-team (overlap with
# wshobson-agents), marketing (plugin-style, no skills/), productivity (plugin-style).
if [[ -d "$REPO_ROOT/alirezarezvani-claude-skills" ]]; then
  for domain in business-growth business-operations c-level-advisor commercial compliance-os \
                finance marketing-skill product-team project-management \
                ra-qm-team research-ops; do
    [[ -d "$REPO_ROOT/alirezarezvani-claude-skills/$domain/skills" ]] || continue
    while IFS= read -r d; do
      [[ -d "$d" ]] || continue
      link "$d" "$CLAUDE_DIR/skills/rez-${domain}-$(basename "$d")"
    done < <(find "$REPO_ROOT/alirezarezvani-claude-skills/$domain/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
  done
fi

# ponytail (lazy-mode plugin) — install only the 4 skills (which work via symlink).
# The TOML commands and the ${CLAUDE_PLUGIN_ROOT}-relative hooks require the
# official marketplace install (`/plugin marketplace add DietrichGebert/ponytail`)
# to function; symlinks would break them. For full features, run that separately.
if [[ -d "$REPO_ROOT/ponytail/skills" ]]; then
  for d in "$REPO_ROOT/ponytail/skills/"*/; do
    [[ -d "$d" ]] || continue
    link "$d" "$CLAUDE_DIR/skills/ponytail-$(basename "$d")"
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

# get-shit-done (commands are nested under commands/gsd/)
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  base=$(basename "$f")
  # Source files already have gsd- prefix — don't double it
  if [[ "$base" == gsd-* ]]; then
    link "$f" "$CLAUDE_DIR/commands/$base"
  else
    link "$f" "$CLAUDE_DIR/commands/gsd-$base"
  fi
done < <(find "$REPO_ROOT/get-shit-done/commands/" -name "*.md" 2>/dev/null | sort)

# ruflo (commands live in ruflo/plugins/*/commands/ in v3.7+)
if ! $NO_RUFLO; then
  while IFS= read -r f; do
    [[ -f "$f" ]] || continue
    base=$(basename "$f")
    plugin=$(basename "$(dirname "$(dirname "$f")")")
    link "$f" "$CLAUDE_DIR/commands/ruflo-${plugin}-${base}"
  done < <(find "$REPO_ROOT/ruflo/plugins/" -path "*/commands/*" -name "*.md" 2>/dev/null | sort)
fi

# wshobson-agents commands
if [[ -d "$REPO_ROOT/wshobson-agents/plugins" ]]; then
  while IFS= read -r f; do
    [[ -f "$f" ]] || continue
    base=$(basename "$f")
    plugin=$(basename "$(dirname "$(dirname "$f")")")
    link "$f" "$CLAUDE_DIR/commands/ws-${plugin}-${base}"
  done < <(find "$REPO_ROOT/wshobson-agents/plugins" -name "*.md" -path "*/commands/*" 2>/dev/null | sort)
fi

# super-claude commands
for f in "$REPO_ROOT/super-claude/plugins/superclaude/commands/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/commands/sc-$(basename "$f")"
done

# claude-task-master commands
for f in "$REPO_ROOT/claude-task-master/.claude/commands/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/commands/ctm-$(basename "$f")"
done

log "Commands installed."

# ── RULES ────────────────────────────────────────────────────────────────────

log "Installing rules..."

# Always install common rules (core engineering standards)
if [[ -d "$REPO_ROOT/everything-claude-code/rules/common" ]]; then
  link "$REPO_ROOT/everything-claude-code/rules/common" "$CLAUDE_DIR/rules/ecc-common"
fi

# Language-specific rules: only in full install (not --minimal, default is minimal)
if ! $MINIMAL; then
  for d in "$REPO_ROOT/everything-claude-code/rules/"/*/; do
    name=$(basename "$d")
    [[ "$name" == "common" ]] && continue  # already linked above
    link "$d" "$CLAUDE_DIR/rules/ecc-$name"
  done
fi

log "Rules installed$(if $MINIMAL; then echo ' (minimal — language rules skipped, use --full to include)'; fi)."

# ── HOOKS ────────────────────────────────────────────────────────────────────

log "Installing hooks..."

# everything-claude-code
link "$REPO_ROOT/everything-claude-code/hooks/hooks.json" \
     "$CLAUDE_DIR/hooks/ecc-hooks.json"

# get-shit-done
for f in "$REPO_ROOT/get-shit-done/hooks/"*.js; do
  [[ -f "$f" ]] || continue
  base=$(basename "$f")
  # Source files already have gsd- prefix — don't double it
  if [[ "$base" == gsd-* ]]; then
    link "$f" "$CLAUDE_DIR/hooks/$base"
  else
    link "$f" "$CLAUDE_DIR/hooks/gsd-$base"
  fi
done

# claude-mem — marketplace symlink must use $CLAUDE_DIR (respects --local mode)
if ! $DRY_RUN; then
  mkdir -p "$CLAUDE_DIR/plugins/marketplaces/thedotmack"
  if [[ -e "$CLAUDE_DIR/plugins/marketplaces/thedotmack/plugin" || \
        -L "$CLAUDE_DIR/plugins/marketplaces/thedotmack/plugin" ]]; then
    rm -f "$CLAUDE_DIR/plugins/marketplaces/thedotmack/plugin"
  fi
  ln -sf "$REPO_ROOT/claude-mem/plugin" \
         "$CLAUDE_DIR/plugins/marketplaces/thedotmack/plugin"
fi
link "$REPO_ROOT/claude-mem/plugin/hooks/hooks.json" \
     "$CLAUDE_DIR/hooks/mem-hooks.json"
if ! $DRY_RUN && command -v bun &>/dev/null; then
  log "Running claude-mem setup (Bun + SQLite deps)..."
  CLAUDE_PLUGIN_ROOT="$REPO_ROOT/claude-mem/plugin" \
    node "$REPO_ROOT/claude-mem/plugin/scripts/smart-install.js" 2>/dev/null \
    || warn "claude-mem setup failed — memory hooks may not work"
fi

# ruflo — use the upstream hooks file. Requires claude-flow MCP server / npm package.
# (Previously had a fallback to a local pinned copy at master/hooks/ruflo-hooks.json;
# removed — upstream is the source of truth and a stale pin is worse than no hook.)
if ! $NO_RUFLO && [[ -f "$REPO_ROOT/ruflo/plugin/hooks/hooks.json" ]]; then
  link "$REPO_ROOT/ruflo/plugin/hooks/hooks.json" "$CLAUDE_DIR/hooks/ruflo-hooks.json"
fi

log "Hooks installed."

# ── FIX AGENT NAME COLLISIONS ────────────────────────────────────────────────
# Agent `name:` frontmatter must be unique — patched files replace symlinks
# so each agent gets its own invocation name matching its filename prefix.

if ! $DRY_RUN; then
  log "Patching agent name collisions..."
  _patch_name() {
    local file="$1" old_name="$2" new_name="$3"
    if [[ -L "$file" ]]; then
      local src
      src=$(readlink "$file")
      sed "s/^name: ${old_name}$/name: ${new_name}/" "$src" > "${file}.tmp"
      mv "${file}.tmp" "$file"
    fi
  }
  # superpowers-code-reviewer shadows ecc-code-reviewer
  _patch_name "$CLAUDE_DIR/agents/superpowers-code-reviewer.md" "code-reviewer" "superpowers-code-reviewer"
  # ruflo-planner shadows ecc-planner
  _patch_name "$CLAUDE_DIR/agents/ruflo-planner.md" "planner" "ruflo-planner" 2>/dev/null || true
  # ruflo goal-planner duplicates
  _patch_name "$CLAUDE_DIR/agents/ruflo-reasoning-goal-planner.md" "goal-planner" "ruflo-reasoning-goal-planner" 2>/dev/null || true
  # ruflo-github-pr-manager shadows ruflo-pr-manager
  _patch_name "$CLAUDE_DIR/agents/ruflo-github-pr-manager.md" "pr-manager" "ruflo-github-pr-manager" 2>/dev/null || true
  unset -f _patch_name
fi

# ── WRITE MANIFEST ───────────────────────────────────────────────────────────

if ! $DRY_RUN; then
  REPO_ROOT="$REPO_ROOT" CLAUDE_DIR="$CLAUDE_DIR" VERSION="$VERSION" \
  LOCAL="$LOCAL" MINIMAL="$MINIMAL" NO_RUFLO="$NO_RUFLO" python3 - <<'PYEOF'
import json, subprocess, datetime, os, re

repo      = os.environ['REPO_ROOT']
claude_dir = os.environ['CLAUDE_DIR']

def sha(path):
    r = subprocess.run(['git','-C',path,'rev-parse','HEAD'], capture_output=True, text=True)
    return r.stdout.strip() or 'unknown'

def count_dir(d, ext=None):
    try:
        files = os.listdir(d)
        return len([f for f in files if (not ext or f.endswith(ext))]) if files else 0
    except: return 0

submodules = sorted({m.group(1) for m in re.finditer(r'\[submodule "([^"]+)"\]', open(os.path.join(repo,'.gitmodules')).read())})

manifest = {
    'version': os.environ.get('VERSION','dev'),
    'installed_at': datetime.datetime.utcnow().isoformat() + 'Z',
    'install_mode': 'local' if os.environ.get('LOCAL')=='true' else 'global',
    'minimal': os.environ.get('MINIMAL')=='true',
    'no_ruflo': os.environ.get('NO_RUFLO')=='true',
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
PYEOF
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
    echo "  Re-run with --full to add Python/Go/Rust/etc. rules (~15-20K more tokens)"
  fi
  if $NO_RUFLO; then
    echo "  (ruflo not included — use --with-ruflo to add ruflo enterprise agents/skills)"
  fi
  echo "  (drawio-skill + plantuml-skill + anthropics official skills always installed; alirezarezvani non-engineering domains too)"
  echo ""
  echo "Restart Claude Code to pick up all new tools."
fi
