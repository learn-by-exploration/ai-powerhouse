# Fix Review Findings Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix all issues found in the repo review — stale counts, double-prefixed hooks, missing LICENSE, stale CLAUDE.md, and per-source table inaccuracies.

**Architecture:** All changes are documentation and script fixes. No new features. The install script has one bug (GSD hooks double-prefix) and one missed pattern (GSD commands not installed because they're nested under `commands/gsd/`). The counts are stale across README.md, USAGE.md, master/CLAUDE.md, and GitHub badges.

**Tech Stack:** Bash (install.sh), Markdown (README/USAGE/CLAUDE.md), GitHub CLI (badge URLs)

---

### Task 1: Fix GSD hooks double-prefix in install.sh

The GSD hooks source files are already named `gsd-*.js` (e.g., `gsd-check-update.js`). The install script prepends another `gsd-` prefix, producing `gsd-gsd-check-update.js`.

**Files:**
- Modify: `master/install.sh:383-386`

- [ ] **Step 1: Fix the GSD hooks prefix logic**

Change the install loop to strip the existing `gsd-` prefix from source filenames before adding the symlink prefix, so the destination becomes `gsd-check-update.js` instead of `gsd-gsd-check-update.js`.

In `master/install.sh`, replace:
```bash
# get-shit-done
for f in "$REPO_ROOT/get-shit-done/hooks/"*.js; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/hooks/gsd-$(basename "$f")"
done
```

With:
```bash
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
```

- [ ] **Step 2: Verify dry-run shows correct hook names**

Run:
```bash
bash master/install.sh --dry-run 2>&1 | grep "hooks/gsd"
```

Expected: `gsd-check-update.js`, `gsd-context-monitor.js`, etc. — NO `gsd-gsd-*` names.

- [ ] **Step 3: Commit**

```bash
git add master/install.sh
git commit -m "fix: remove double gsd- prefix on hooks"
```

---

### Task 2: Fix GSD commands not being installed

GSD commands live at `get-shit-done/commands/gsd/*.md` (71 files), but the install script globs `get-shit-done/commands/*.md` which matches nothing. These commands are currently not installed at all.

**Files:**
- Modify: `master/install.sh:315-320`

- [ ] **Step 1: Fix the GSD commands glob to find nested files**

In `master/install.sh`, replace:
```bash
# get-shit-done
for f in "$REPO_ROOT/get-shit-done/commands/"*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/commands/gsd-$(basename "$f")"
done
```

With:
```bash
# get-shit-done (commands are nested under commands/gsd/)
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  link "$f" "$CLAUDE_DIR/commands/gsd-$(basename "$f")"
done < <(find "$REPO_ROOT/get-shit-done/commands/" -name "*.md" 2>/dev/null | sort)
```

- [ ] **Step 2: Verify dry-run shows GSD commands**

Run:
```bash
bash master/install.sh --dry-run 2>&1 | grep "commands/gsd-" | head -5
```

Expected: Lines like `[dry-run] ln -sf '.../get-shit-done/commands/gsd/gsd.md' -> '.../commands/gsd-gsd.md'`

- [ ] **Step 3: Count updated totals after fix**

Run:
```bash
bash master/install.sh --dry-run 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep -c "/commands/"
```

Expected: ~280 (was 209, now +71 GSD commands).

- [ ] **Step 4: Commit**

```bash
git add master/install.sh
git commit -m "fix: install GSD commands from nested commands/gsd/ directory"
```

---

### Task 3: Re-count all actuals after script fixes

After Tasks 1-2, the counts change. We need fresh numbers before updating docs.

**Files:**
- None (read-only verification)

- [ ] **Step 1: Run full count sweep**

```bash
# Default (no ruflo)
bash master/install.sh --dry-run 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep -c "/agents/" && echo "agents (default)"
bash master/install.sh --dry-run 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep -c "/skills/" && echo "skills (default)"
bash master/install.sh --dry-run 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep -c "/commands/" && echo "commands (default)"

# With ruflo
bash master/install.sh --dry-run --with-ruflo 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep -c "/agents/" && echo "agents (ruflo)"
bash master/install.sh --dry-run --with-ruflo 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep -c "/skills/" && echo "skills (ruflo)"
bash master/install.sh --dry-run --with-ruflo 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep -c "/commands/" && echo "commands (ruflo)"
```

Record these exact numbers — they're needed for Tasks 4, 5, 6.

Expected (approximate):
- Default: 279 agents, 365 skills, 280 commands
- With ruflo: 356 agents, 403 skills, 284 commands

- [ ] **Step 2: Run per-source breakdown**

```bash
bash master/install.sh --dry-run 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep "/agents/" | sed 's|.*claude/agents/||' | cut -d- -f1 | sort | uniq -c | sort -rn
bash master/install.sh --dry-run 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep "/skills/" | sed 's|.*claude/skills/||' | cut -d- -f1 | sort | uniq -c | sort -rn
bash master/install.sh --dry-run 2>&1 | grep "ln -sf" | awk -F"'" '{print $4}' | grep "/commands/" | sed 's|.*claude/commands/||' | cut -d- -f1 | sort | uniq -c | sort -rn
```

Record these numbers for the per-source tables in README.md and USAGE.md.

---

### Task 4: Update README.md counts

Use the **exact** numbers from Task 3. The numbers below assume the GSD commands fix adds ~71 commands. Replace all placeholder `{N}` notation with the actual numbers from Task 3.

**Files:**
- Modify: `README.md` (lines 1, 8-10, 72, 78-80, 137-139, 271, 290-303)

- [ ] **Step 1: Update the H1 headline**

Line 1, change:
```markdown
# AI Powerhouse — 325+ Claude Code Agents, Skills, Hooks & Subagents
```
To (use with-ruflo agent count):
```markdown
# AI Powerhouse — 356+ Claude Code Agents, Skills, Hooks & Subagents
```

- [ ] **Step 2: Update the badges (lines 8-10)**

```markdown
[![Agents](https://img.shields.io/badge/Agents-356%2B-blueviolet?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)
[![Skills](https://img.shields.io/badge/Skills-403%2B-blue?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)
[![Commands](https://img.shields.io/badge/Commands-{RUFLO_CMD_COUNT}%2B-green?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)
```

Replace `{RUFLO_CMD_COUNT}` with the actual --with-ruflo commands count from Task 3.

- [ ] **Step 3: Update "full tool set" reference (line 72)**

Change `325+` to match the with-ruflo agents count.

- [ ] **Step 4: Update "What You Get" bullets (lines 78-80)**

```markdown
- **356+ AI agents** — specialists for coding, security, architecture, devops, UI/UX, and more
- **403+ skills** — composable Claude Code capabilities across every workflow
- **{RUFLO_CMD_COUNT}+ slash-commands** — turn Claude Code into a full agentic coding workstation
```

- [ ] **Step 5: Update dry-run sample output (lines 137-139)**

```
... (~356 agent symlinks, ~403 skill symlinks, ~{RUFLO_CMD_COUNT} command symlinks)
[install] Agents   : {DEFAULT_AGENT_COUNT}
[install] Skills   : {DEFAULT_SKILL_COUNT}
[install] Commands : {DEFAULT_CMD_COUNT}
```

- [ ] **Step 6: Update token loading reference (line 271)**

Change `325+ agents` to match the with-ruflo agent count.

- [ ] **Step 7: Update per-source table (lines 290-303)**

Update every row with the actual per-source counts from Task 3 step 2. Key changes expected:

| Source | Agents | Skills | Commands |
|--------|--------|--------|----------|
| everything-claude-code | 47 | 181 | 79 |
| wshobson-agents | 182 | 149 | 96 |
| superpowers | 1 | 14 | 3 |
| get-shit-done | 29 | — | 71 |
| super-claude | 20 | 6 | 30 |
| claude-mem | — | 7 | — |
| ui-ux-pro-max | — | 7 | — |
| ruflo _(--with-ruflo only)_ | 77 | 38 | 4 |
| claude-task-master | — | — | 1 |
| master | — | 1 | — |
| **Total (default)** | **{DEF_A}** | **{DEF_S}** | **{DEF_C}** |
| **Total (--with-ruflo)** | **{RUF_A}** | **{RUF_S}** | **{RUF_C}** |

Replace all `{...}` with the actual counts from Task 3.

- [ ] **Step 8: Commit**

```bash
git add README.md
git commit -m "docs: update README counts to match actual install output"
```

---

### Task 5: Update USAGE.md counts

**Files:**
- Modify: `USAGE.md` (lines 44, 89-90)

- [ ] **Step 1: Update the install summary line (line 44)**

Change:
```markdown
This symlinks ~249 agents, ~300 skills, ~194 commands, and hooks into `~/.claude`. Restart Claude Code after.
```
To:
```markdown
This symlinks ~{DEF_A} agents, ~{DEF_S} skills, ~{DEF_C} commands, and hooks into `~/.claude`. Restart Claude Code after.
```

- [ ] **Step 2: Update the per-source totals table (lines 89-90)**

Same numbers as README Task 4 Step 7. Update every row with actual per-source counts, including the GSD row which now has commands.

- [ ] **Step 3: Commit**

```bash
git add USAGE.md
git commit -m "docs: update USAGE.md counts to match actual install output"
```

---

### Task 6: Update master/CLAUDE.md counts

This is what Claude reads at every session start. Currently says "123 agents, 189 skills, and 68 commands from 8 best-in-class repos" — severely outdated.

**Files:**
- Modify: `master/CLAUDE.md:3`

- [ ] **Step 1: Update the counts line**

Change:
```markdown
You have access to 123 agents, 189 skills, and 68 commands from 8 best-in-class repos.
```
To:
```markdown
You have access to {DEF_A} agents, {DEF_S} skills, and {DEF_C} commands from 10 sources.
```

Use the default (no ruflo) counts from Task 3. Change "8 best-in-class repos" to "10 sources" to match reality (ecc, ws, superpowers, gsd, sc, mem, uiux, ctm, master = 9 source prefixes + hooks).

- [ ] **Step 2: Commit**

```bash
git add master/CLAUDE.md
git commit -m "docs: update CLAUDE.md counts to match actual install"
```

---

### Task 7: Add root LICENSE file

The README badge links to `LICENSE` but no root LICENSE file exists. The submodules each have their own licenses (MIT for most). The meta-repo itself (install script, routing skill, README) should have an explicit license.

**Files:**
- Create: `LICENSE`

- [ ] **Step 1: Create MIT LICENSE file**

```
MIT License

Copyright (c) 2026 AI Powerhouse Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

Note: Confirm with the repo owner that MIT is the intended license. Check if there's a preference for a different license or copyright holder name.

- [ ] **Step 2: Commit**

```bash
git add LICENSE
git commit -m "chore: add MIT license"
```

---

### Task 8: Update GitHub repo description and badges

The GitHub description still says "325+ Claude Code agents" — needs to match the new counts.

**Files:**
- None (GitHub API calls)

- [ ] **Step 1: Update GitHub description**

```bash
gh repo edit learn-by-exploration/ai-powerhouse \
  --description "{RUF_A}+ Claude Code agents, skills, hooks & subagents — one install script. Curated from 12 highest-starred community repos (680k+ ★). MCP servers, agentic coding, context engineering & workflow automation."
```

Replace `{RUF_A}` with the with-ruflo agent count from Task 3.

- [ ] **Step 2: Verify**

```bash
gh api repos/learn-by-exploration/ai-powerhouse --jq '.description'
```

Expected: Description starts with the updated agent count.

- [ ] **Step 3: Commit all remaining changes and push**

```bash
git push origin main
```

---

### Task 9: Verify end-to-end

**Files:**
- None (read-only verification)

- [ ] **Step 1: Run dry-run install and compare counts to README**

```bash
bash master/install.sh --dry-run 2>&1 | tail -10
```

Verify the printed Agents/Skills/Commands counts match what README says for default install.

- [ ] **Step 2: Run dry-run with ruflo and compare**

```bash
bash master/install.sh --dry-run --with-ruflo 2>&1 | tail -10
```

Verify counts match README's "Total (--with-ruflo)" row.

- [ ] **Step 3: Verify no double-prefix hooks**

```bash
bash master/install.sh --dry-run 2>&1 | grep "gsd-gsd"
```

Expected: No output (zero matches).

- [ ] **Step 4: Verify GSD commands are now installed**

```bash
bash master/install.sh --dry-run 2>&1 | grep "commands/gsd-" | wc -l
```

Expected: ~71 lines.

- [ ] **Step 5: Verify LICENSE badge resolves**

```bash
test -f LICENSE && echo "LICENSE exists" || echo "MISSING"
```

Expected: `LICENSE exists`
