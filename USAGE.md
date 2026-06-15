# Usage Guide — AI Powerhouse

A practical guide to getting the most out of this collection. Jump to the section you need:

- [Installation](#installation)
- [What gets installed](#what-gets-installed)
- [Daily workflows](#daily-workflows)
- [Tool reference](#tool-reference)
- [MCP setup (memory)](#mcp-setup-memory)
- [Updating](#updating)
- [Uninstalling](#uninstalling)
- [Troubleshooting](#troubleshooting)

---

## Installation

### 1. Clone with submodules

```bash
# SSH (recommended)
git clone --recurse-submodules git@github.com:learn-by-exploration/ai-powerhouse.git
# HTTPS alternative
git clone --recurse-submodules https://github.com/learn-by-exploration/ai-powerhouse.git
cd ai-powerhouse
```

Already cloned without `--recurse-submodules`? Run:
```bash
git submodule update --init --recursive
```

### 2. Install

> **macOS users:** macOS ships bash 3.2 which lacks associative arrays. Install bash 4+ first:
> `brew install bash && /opt/homebrew/bin/bash master/install.sh`

> **Note:** The repo must stay in a permanent location — symlinks use absolute paths. Moving it later requires re-running install.sh.

```bash
bash master/install.sh
```

This symlinks ~310 agents, ~640 skills, ~284 commands, and hooks into `~/.claude`. Restart Claude Code after.

**Preview before installing:**
```bash
bash master/install.sh --dry-run
```

### Install modes

| Flag | What it does |
|------|-------------|
| _(no flags)_ | **Default install** — all tools except ruflo. Best for most users. |
| `--with-ruflo` | Adds 77 ruflo enterprise agents, skills, and hooks (~50K extra tokens). |
| `--full` | Adds 11 language rule sets (Python, Go, Rust, TypeScript, Java, Kotlin, C++, C#, PHP, Swift, Perl). Adds ~15-20K tokens. |
| `--backup` | Snapshots `~/.claude` to `~/.claude.backup-<timestamp>` before writing. Recommended on first install if you have existing customizations. |
| `--no-ruflo` | _(alias, same as default)_ |
| `--local` | Installs to `master/.claude/` instead of `~/.claude`. Useful for trying changes without touching your global setup. |
| `--dry-run` | Prints what would happen, writes nothing. |

**Example — add ruflo enterprise agents:**
```bash
bash master/install.sh --with-ruflo
```

**Example — full install with all language rules:**
```bash
bash master/install.sh --full
```

---

## What gets installed

| Source | Agents | Skills | Commands | Notes |
|--------|--------|--------|----------|-------|
| everything-claude-code | 64 | 262 | 84 | Core ECC framework (v2.0) |
| anthropics-skills | — | 17 | — | Official Anthropic skills: PDF/DOCX/PPTX/XLSX, mcp-builder, webapp-testing |
| superpowers | — | 14 | — | Spec-to-code workflow |
| get-shit-done | 33 | — | 67 | Context engineering + spec dev |
| claude-mem | — | 16 | — | Cross-session memory |
| ui-ux-pro-max | — | 7 | — | UI/UX design |
| drawio-skill | — | 1 | — | Draw.io diagram generation (always installed) |
| plantuml-skill | — | 1 | — | PlantUML via Kroki (always installed) |
| alirezarezvani-skills | — | 154 | — | Business skills: marketing, finance, C-level, compliance, PM (non-engineering subset) |
| ponytail | — | 4 | — | "Lazy mode" — YAGNI / stdlib-first (skills only via symlink) |
| ruflo _(optional)_ | 55 | 110 | 48 | Enterprise multi-agent |
| wshobson-agents | 192 | 156 | 102 | 77-plugin agent+skill collection |
| super-claude | 20 | 6 | 30 | Behavioral modes + MCP orchestration |
| claude-task-master | — | — | 1 | AI task management commands |
| master | 1 | 2 | — | Agent routing + SE lifecycle orchestrator |
| **Total (default)** | **~310** | **~640** | **~284** | Recommended for most |
| **Total (--with-ruflo)** | **~365** | **~750** | **~332** | Enterprise/team setups |

All tools are prefixed by source (`ecc-`, `superpowers-`, `gsd-`, `mem-`, `uiux-`, `ruflo-`, `ws-`, `sc-`, `ctm-`, `anthropic-`, `rez-`, `ponytail-`, `drawio-skill`, `plantuml-skill`) so they never collide.

**Reference-only submodules** (browsable but not installed):
- `awesome-claude-code` — curated community list
- `pm-workspace` — PM workspace reference
- `autoresearch` — Karpathy's automated nanochat training research (standalone Python tool)

---

## Daily workflows

### Starting a new feature

```
1. mem-mem-search        ← search past sessions first ("did we build this before?")
2. superpowers-writing-plans   ← create a bite-sized plan (2-5 min tasks)
3. superpowers-subagent-driven-development  ← execute with automated review loop
4. ecc-code-reviewer     ← final quality gate
```

In practice: just describe your feature and Claude will route to these automatically if you've invoked the `master-agent-routing` skill (done at session start via CLAUDE.md).

### Fixing a bug

```
1. Write a failing test that reproduces the bug
2. Run it — confirm it fails
3. Implement the fix
4. Run again — confirm it passes
5. ecc-code-reviewer / ecc-security-reviewer as appropriate
```

For mysterious or flaky bugs: invoke `superpowers-systematic-debugging`.

### Code review

```bash
# Quality review (logic, patterns, coverage)
/ecc-code-review

# Security review (OWASP, secrets, injection)
# (invoke ecc-security-reviewer agent)

# Review your harness config for security issues
# (invoke ecc-agentshield-scan — scans hooks, agents, CLAUDE.md)
```

### Architecture decisions

Invoke the `ecc-architect` agent. It will:
- Read the codebase read-only
- Analyse trade-offs
- Produce an ADR (Architecture Decision Record)
- Flag risks without making changes

### UI/UX work

Invoke `uiux-ui-ux-pro-max` or `uiux-design-system`. These give Claude access to 67 UI styles, 161 design rules, colour palettes, font pairings, and framework-specific guidance.

### Diagrams

For diagram work, two skills cover most cases:

- `drawio-skill` — use when you need an exportable, polished diagram (PNG/SVG/PDF) with rich shape vocabulary (architecture, ER, strict UML, swimlanes).
- `plantuml-skill` — use when you want a text-based `.puml` source that lives in git, renders in Markdown, and uses the Kroki API (no local Java install needed).

### Document processing (PDF / DOCX / PPTX / XLSX)

The `anthropic-pdf`, `anthropic-docx`, `anthropic-pptx`, `anthropic-xlsx` skills cover most document workflows. Each one is self-contained and includes Python scripts for the heavy lifting.

### MCP server development

`anthropic-mcp-builder` walks you through designing and building an MCP server end-to-end. Use it whenever you need to expose tools to Claude Code.

### Saving and resuming sessions

```bash
# Save current session state (branch, files changed, what worked, what didn't)
/ecc-save-session

# Resume a saved session in a new Claude Code window
/ecc-resume-session
```

The save format includes what **didn't** work — prevents Claude from trying the same broken approach again.

### Onboarding to an unfamiliar codebase

```
1. mem-smart-explore     ← efficient codebase mapping (10-18x cheaper than reading files)
2. ecc-architect         ← architecture summary
3. gsd-codebase-mapper   ← detailed component map
```

Or just open the project and say: "Onboard me to this codebase using mem-smart-explore, then ecc-architect."

---

## Tool reference

### Routing — where to start

The `master-agent-routing` skill is automatically loaded at session start. Ask Claude "what should I use for X" or just describe your task — it will apply the decision tree.

Quick reference:

| Task | Tool |
|------|------|
| New feature >2h | `mem-mem-search` → `superpowers-writing-plans` → `superpowers-subagent-driven-development` |
| Bug fix | Write failing test → implement → `ecc-code-reviewer` |
| Mystery/flaky bug | `superpowers-systematic-debugging` |
| Code review | `ecc-code-reviewer` |
| Security review | `ecc-security-reviewer` |
| Architecture | `ecc-architect` |
| Refactor/cleanup | `ecc-refactor-cleaner` |
| UI/UX design | `uiux-ui-ux-pro-max` |
| Draw.io diagram (exportable) | `drawio-skill` |
| PlantUML diagram (text-based) | `plantuml-skill` |
| PDF / DOCX / PPTX / XLSX | `anthropic-pdf` / `anthropic-docx` / `anthropic-pptx` / `anthropic-xlsx` |
| Build an MCP server | `anthropic-mcp-builder` |
| Webapp testing | `anthropic-webapp-testing` |
| Business / marketing / finance | `rez-business-*` / `rez-marketing-skill-*` / `rez-finance-*` |
| C-level strategy | `rez-c-level-advisor-*` |
| Compliance / regulatory | `rez-compliance-os-*` / `rez-ra-qm-team-*` |
| Project management | `rez-project-management-*` |
| "Did we do this before?" | `mem-mem-search` |
| Write docs | `ecc-doc-updater` |
| PR description | `ruflo-pr-manager` (requires ruflo install) |
| DB migration | `ecc-database-migrations` skill |
| Multi-agent orchestration | `ruflo-sparc-coordinator` (requires ruflo + claude-flow MCP) |
| Parallel agent teams | `ws-agent-orchestration-context-manager` + `ws-agent-teams-*` |
| Task/project lifecycle | `/ctm-dedupe` + claude-task-master MCP server |
| Confidence scoring | `sc-confidence-check` skill |

### Key agents

**`ecc-architect`** — System design, trade-off analysis, ADR creation. Read-only — it advises, never edits.

**`ecc-code-reviewer`** — Reviews `git diff` output. CRITICAL/HIGH/MEDIUM/LOW severity. Only reports issues with >80% confidence.

**`ecc-security-reviewer`** — OWASP-aware security analysis. Run before any commit touching auth, input handling, or external APIs.

**`ecc-tdd-guide`** — Enforces red → green → refactor. Will refuse to let you skip writing the failing test first.

**`ecc-chief-of-staff`** — High-level task orchestrator. Classifies work into 4 priority tiers, routes to specialists, enforces quality gates.

**`gsd-gsd-executor`** — Executes a GSD plan phase by phase with checkpoints. Has deviation rules, analysis-paralysis guards, and atomic commit protocol.

**`superpowers-code-reviewer`** — Post-step plan-alignment checker. Ensures implementation matches the spec from `superpowers-writing-plans`.

### Key skills

**`mem-mem-search`** — 3-layer memory search across all past sessions. Always run this before writing new code. The 10-minute investment reliably saves hours.

**`mem-smart-explore`** — Efficiently explores a codebase using a semantic index. 10-18x cheaper than reading individual files. Start here on any unfamiliar project.

**`superpowers-writing-plans`** — Extracts a spec, writes it back for approval, then breaks it into 2-5 minute tasks. Forces alignment before any code is written.

**`superpowers-systematic-debugging`** — Structured debugging process for mystery failures. Generates hypotheses, isolates variables, tracks what's been tried.

**`superpowers-dispatching-parallel-agents`** — Pattern for running independent tasks concurrently (e.g. review + security scan + language lint simultaneously).

**`master-agent-routing`** — The decision tree for all 924+ tools. Auto-loaded at session start.

### New: wshobson-agents (`ws-` prefix)

192 agents and 136 skills across 77 domain-focused plugins. Covers areas not found elsewhere: accessibility auditing, blockchain/Web3, ARM microcontrollers, business analytics, C4 architecture, CICD automation, and multi-agent team coordination with built-in PluginEval quality scoring.

```
ws-agent-teams-team-lead          ← orchestrate a 4-agent dev team
ws-agent-orchestration-context-manager  ← manage context across parallel agents
ws-backend-development-*          ← backend API agents
ws-cicd-automation-*              ← CI/CD agents
```

### New: Diagram skills (`drawio-skill` and `plantuml-skill`)

Always-installed diagram generation skills from Agents365-ai.

```
drawio-skill      ← generate .drawio XML and export to PNG/SVG/PDF via draw.io desktop CLI
                    best for: architecture diagrams, ER/UML/sequence, anything with rich shape vocabulary
plantuml-skill    ← generate .puml text and render to PNG/SVG via Kroki API (no Java needed)
                    best for: UML, sequence, class, component, ER diagrams, diagrams-as-code in git
```

Use `drawio-skill` for polished, exportable diagrams; use `plantuml-skill` for text-based, version-controlled diagrams.

### New: Official Anthropic skills (`anthropic-`)

Always-installed, 17 skills from the official anthropics/skills repo (★ 150k).

```
anthropic-pdf          ← read, extract, fill, merge, split, rotate, OCR PDFs
anthropic-docx         ← create and edit Word documents with tracked changes
anthropic-pptx         ← build PowerPoint decks programmatically
anthropic-xlsx         ← Excel: read/write sheets, formulas, pivot tables
anthropic-mcp-builder  ← guided workflow to build MCP servers
anthropic-webapp-testing  ← Playwright-based web app testing
anthropic-frontend-design ← modern frontend design guidance
anthropic-brand-guidelines, anthropic-theme-factory, anthropic-canvas-design
anthropic-claude-api, anthropic-skill-creator, anthropic-doc-coauthoring
anthropic-internal-comms, anthropic-slack-gif-creator, anthropic-web-artifacts-builder
anthropic-algorithmic-art
```

### New: Business skills (`rez-` prefix, from alirezarezvani/claude-skills)

~158 skills in 12 non-engineering domains — fills the business / marketing / finance / compliance gap that no other repo covers.

```
rez-business-growth-*         ← sales engineer, revenue ops, contract writer
rez-business-operations-*     ← capacity planner, process mapper, knowledge ops
rez-c-level-advisor-*         ← CEO, CTO, CFO, Chief AI Officer advisors
rez-commercial-*              ← vendor mgmt, partnerships, sales enablement
rez-compliance-os-*           ← SOC 2, HIPAA, GDPR compliance playbooks
rez-finance-*                 ← investment advisor, financial modeling
rez-marketing-skill-*         ← SEO, content, growth, demand-gen
rez-product-team-*            ← PM, UX research, roadmap
rez-productivity-*            ← personal productivity systems
rez-project-management-*      ← PMBOK, agile, sprint planning
rez-ra-qm-team-*              ← regulatory affairs, quality management
rez-research-ops-*            ← research operations, IRB
```

### New: SuperClaude (`sc-` prefix)

20 specialized agents and 30 `/sc:` commands with 7 behavioral modes (research, coder, architect, analyst, security, docs, devops). Coordinated MCP integrations for Tavily, Playwright, Context7.

```
sc-researcher        ← deep research agent with confidence scoring
sc-security-auditor  ← security analysis agent
/sc:analyze          ← analyze code with specified mode
/sc:implement        ← implement with auto-selected agent
sc-confidence-check  ← skill: score output confidence (0.0-1.0)
```

### New: claude-task-master (`ctm-` prefix)

AI-powered task lifecycle management. Parses PRDs into structured tasks with dependencies, runs as MCP server for cross-session tracking. Best used alongside the Task Master MCP server.

```
/ctm-dedupe          ← deduplicate tasks across projects
```

See [claude-task-master README](claude-task-master/README.md) for full MCP setup.

### Key commands

```bash
/ecc-tdd              # Full TDD workflow for a feature
/ecc-plan             # Implementation planning
/ecc-code-review      # Quality review
/ecc-checkpoint       # Snapshot current session state mid-task
/ecc-save-session     # Save full session for resuming later
/ecc-resume-session   # Resume a saved session
/ecc-context-budget   # Check how much context window is consumed
/ecc-harness-audit    # 7-category health check of your Claude Code setup
/ecc-learn            # Extract reusable pattern from this session
/ecc-verify           # Verification checklist before marking work done

/gsd-gsd              # Full spec → plan → build workflow (56 sub-commands)
```

---

## MCP setup (memory)

`mem-mem-search`, `mem-smart-explore`, and `mem-timeline-report` all depend on the **claude-mem MCP server**. Without it, memory search returns nothing — you lose the most differentiating feature of this harness.

### Step 1 — Install Bun (required by claude-mem)

```bash
curl -fsSL https://bun.sh/install | bash
```

### Step 2 — Install claude-mem dependencies

```bash
cd claude-mem/plugin
bun install
```

### Step 3 — Register the MCP server in Claude Code settings

Add to `~/.claude/settings.json` under `mcpServers`:

```json
{
  "mcpServers": {
    "claude-mem": {
      "command": "bun",
      "args": ["run", "/path/to/ai-powerhouse/claude-mem/plugin/src/index.ts"],
      "env": {}
    }
  }
}
```

Replace `/path/to/ai-powerhouse` with the actual path.

### Step 4 — Verify it's working

In a Claude Code session:
```
invoke mem-mem-search for "test"
```

If it returns results (or "no memories found"), the MCP server is connected. If it errors on the tool call, check that `bun` is in your PATH and the path in `settings.json` is correct.

---

## Updating

### Update all submodules to latest upstream

`submodule-hashes.lock` records the exact git SHA of every submodule at install time — it is a reproducibility record, not a pin. Running `update --remote --merge` pulls the current upstream HEAD; reviewing the resulting diff tells you exactly what changed before you commit.

```bash
git submodule update --remote --merge
bash scripts/update-hashes.sh       # record new SHAs in lock file
git diff submodule-hashes.lock      # review what changed across all 12 repos
git add submodule-hashes.lock
git commit -m "chore: update submodule hashes"
bash master/install.sh              # refresh symlinks
```

### Verify submodule integrity

```bash
bash scripts/verify-submodules.sh            # strict — exits 1 on mismatch
bash scripts/verify-submodules.sh --warn-only  # advisory — just prints warnings
```

---

## Uninstalling

```bash
# Remove from ~/.claude
bash master/uninstall.sh

# Preview what would be removed
bash master/uninstall.sh --dry-run

# Remove from master/.claude (local install)
bash master/uninstall.sh --local
```

The uninstall removes all prefixed agents, skills, commands, hooks, rules, the claude-mem marketplace symlink, and the manifest file. Your existing non-Powerhouse Claude Code setup is untouched.

---

## Troubleshooting

### "Submodules not initialized"

```bash
git submodule update --init --recursive
```

### Memory search returns nothing

1. Check Bun is installed: `bun --version`
2. Check claude-mem MCP server is registered in `~/.claude/settings.json` (see [MCP setup](#mcp-setup-memory))
3. Run `bun install` in `claude-mem/plugin/` if first-time setup

### Context window filling up fast

```bash
# Check what's consuming context
/ecc-context-budget

# Reinstall without ruflo (saves 40-60K tokens)
bash master/uninstall.sh
bash master/install.sh --no-ruflo

# Or use the strategic compact skill to compress current session
# (invoke ecc-strategic-compact skill, then delegate to subagents)
```

### Ruflo hooks failing silently

Ruflo hooks require the `claude-flow@3.5.0` npm package and ideally the claude-flow MCP server. If you're not using the ruflo enterprise agents, reinstall with `--no-ruflo` to skip these hooks entirely.

### Agent invokes the wrong tool

The `name:` field in agent frontmatter determines which agent is called. Known collisions are patched by `install.sh` automatically. If you see unexpected behavior, check:

```bash
grep "^name:" ~/.claude/agents/*.md | sort -t: -k2 | uniq -f1 -D
```

Any line appearing twice indicates a remaining collision — report it as a bug.

### Symlinks broken after moving the repo

Re-run `bash master/install.sh`. Symlinks are always created with absolute paths, so moving the repo breaks them. The install script rebuilds them correctly from the new location.

### Install script errors on macOS with bash

macOS ships bash 3.2 which doesn't support associative arrays (`declare -A`). The install script requires bash 4+:

```bash
brew install bash
/opt/homebrew/bin/bash master/install.sh
```
