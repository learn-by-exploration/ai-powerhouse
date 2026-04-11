# AI Powerhouse — 325+ Agents, 338+ Skills & 198+ Commands for Claude Code

> Install the entire Claude Code community ecosystem in a single script. One command. Optional MCP setup for memory features.

[![GitHub Stars](https://img.shields.io/github/stars/learn-by-exploration/ai-powerhouse?style=flat-square&logo=github&label=Stars)](https://github.com/learn-by-exploration/ai-powerhouse/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/learn-by-exploration/ai-powerhouse?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse/commits)
[![License](https://img.shields.io/github/license/learn-by-exploration/ai-powerhouse?style=flat-square)](LICENSE)
[![Agents](https://img.shields.io/badge/Agents-325%2B-blueviolet?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)
[![Skills](https://img.shields.io/badge/Skills-338%2B-blue?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)
[![Commands](https://img.shields.io/badge/Commands-198%2B-green?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-orange?style=flat-square)](https://claude.ai/code)
[![Source Repo Stars](https://img.shields.io/badge/Source%20Repos-680k%2B%20★-yellow?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse#the-12-source-repos)

<!-- TODO: Add terminal recording showing install + first skill invocation (~45s).
     Suggested tool: https://github.com/charmbracelet/vhs or asciinema.
     Place at: docs/assets/install-demo.gif
     ![Install demo](docs/assets/install-demo.gif) -->

**AI Powerhouse** is a curated meta-collection of 12 Claude Code submodules — sourced from the highest-starred community repos and installed in one script. Stop spending hours reading READMEs. Get every production-ready agent, skill, and command the community has built, working in your `~/.claude` in minutes.

```bash
# SSH (recommended if you have a key configured)
git clone --recurse-submodules git@github.com:learn-by-exploration/ai-powerhouse.git

# HTTPS (if you don't have SSH configured)
git clone --recurse-submodules https://github.com/learn-by-exploration/ai-powerhouse.git

cd ai-powerhouse && bash master/install.sh
```

---

## Why AI Powerhouse?

Claude Code ships with powerful defaults — but the community has built **hundreds of specialized agents, skills, and commands** that most developers never discover. They're scattered across 12 different repos, each with its own install process, naming convention, and README.

AI Powerhouse solves this. We track the 12 highest-quality Claude Code repos, keep them updated, and install everything into `~/.claude` with a single script — prefixed and collision-free.

**What the top 1% of Claude Code users already have installed:**

| Pain Point | Solution |
|------------|----------|
| "Context rot" as Claude fills its window | `gsd-` context engineering + spec-driven dev |
| No persistent memory between sessions | `mem-` cross-session memory with vector search |
| Missing specialized agents for my stack | `ws-` 182 domain-specific agents across 77 plugins |
| Manual, repetitive task tracking | `ctm-` AI-powered task lifecycle management |
| No structured dev workflow | `ecc-` TDD, security review, architecture agents |
| Token bloat from monolithic configs | Single-purpose plugins; ruflo excluded by default |

---

## Solo Dev Starter Pack

New here? Skip the full 325-tool catalogue. These 7 cover 80% of a solo developer's daily Claude Code workflow — all zero-dependency (no MCP server needed):

| Tool | Type | What it does |
|------|------|--------------|
| `ecc-code-reviewer` | Agent | Reviews `git diff`. CRITICAL/HIGH/MEDIUM/LOW severity. Only flags issues >80% confidence. |
| `ecc-architect` | Agent | Read-only architecture advisor. Produces ADRs, flags risks without editing. |
| `ecc-security-reviewer` | Agent | OWASP-aware. Run before commits touching auth, inputs, or external APIs. |
| `superpowers-writing-plans` | Skill | Turns a vague idea into a reviewed, bite-sized task list before any code is written. |
| `superpowers-systematic-debugging` | Skill | Structured hypothesis → isolation → fix for mystery bugs. |
| `gsd-context-engineering` | Skill | Prevents context rot. Keeps Claude aligned to the original spec across long sessions. |
| `mem-mem-search` | Skill | Search past sessions before writing anything new. 10 min saves 2+ hours of rework. _(requires MCP setup — see below)_ |

**Typical daily loop:**
```
mem-mem-search → superpowers-writing-plans → [implement with TDD] → ecc-code-reviewer
```

For the full 325+ tool set with routing, see [Tools by Category](#tools-by-category) below.

---

## What You Get

- **325+ AI agents** — specialists for coding, security, architecture, devops, UI/UX, and more
- **338+ skills** — composable Claude Code capabilities across every workflow
- **198+ commands** — slash commands that turn Claude Code into a full AI workstation
- **12 curated submodules** — hand-picked from the highest-quality community repos
- **One-script install** — symlinks everything into `~/.claude`, prefixed, zero collisions
- **Works with** Claude Code, Cursor, OpenCode, Gemini CLI, Codex, Windsurf, Roo

---

## Quick Install

> **macOS note:** The default system bash (3.2) does not support this script. If you're on macOS:
> ```bash
> brew install bash          # install bash 4+
> /opt/homebrew/bin/bash master/install.sh
> ```
> Check your version first: `bash --version`

### Clone with all submodules

```bash
# SSH (recommended if you have a key configured)
git clone --recurse-submodules git@github.com:learn-by-exploration/ai-powerhouse.git

# HTTPS (if you don't have SSH configured)
git clone --recurse-submodules https://github.com/learn-by-exploration/ai-powerhouse.git

cd ai-powerhouse
```

> **Location matters:** The installer creates absolute-path symlinks. Clone to a permanent location — if you move the repo later, run `bash master/install.sh` again from the new path to rebuild the symlinks.

### Install (symlinks all tools into `~/.claude`)

```bash
bash master/install.sh
```

### Install modes

```bash
bash master/install.sh              # Default — core tools only, ruflo excluded
bash master/install.sh --full       # Adds 11 language rule sets (~15-20K extra tokens)
bash master/install.sh --with-ruflo # Adds 76 enterprise agents (+~50K tokens)
bash master/install.sh --local      # Installs to master/.claude/ instead of ~/.claude
bash master/install.sh --dry-run    # Preview without writing
```

**Sample `--dry-run` output:**
```
[install] AI Powerhouse dev
[dry-run] mkdir -p '/home/user/.claude/agents'
[dry-run] mkdir -p '/home/user/.claude/skills'
[dry-run] ln -sf '.../everything-claude-code/agents/architect.md' -> '/home/user/.claude/agents/ecc-architect.md'
[dry-run] ln -sf '.../superpowers/agents/code-reviewer.md' -> '/home/user/.claude/agents/superpowers-code-reviewer.md'
... (~325 agent symlinks, ~338 skill symlinks, ~198 command symlinks)
[install] Agents   : 249
[install] Skills   : 300
[install] Commands : 194
```

Restart Claude Code after installing.

---

## Uninstall

```bash
bash master/uninstall.sh            # remove all symlinks from ~/.claude
bash master/uninstall.sh --dry-run  # preview what would be removed
```

Removes all prefixed agents, skills, commands, hooks, rules, and the manifest. Your existing non-Powerhouse Claude Code setup is untouched.

---

## The 12 Source Repos (680,000+ Combined ★)

These are the stars the community awarded to each source project — not this repo's stars. Every agent and skill in AI Powerhouse was built and validated by those communities.

| Repo | Stars | Prefix | What It Adds |
|------|-------|--------|--------------|
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | ★ 151k | `ecc-` | Anthropic hackathon winner — core agent framework |
| [obra/superpowers](https://github.com/obra/superpowers) | ★ 147k | `superpowers-` | Spec-to-code autonomous workflow |
| [karpathy/autoresearch](https://github.com/karpathy/autoresearch) | ★ 70k | ref | Automated research reference (standalone Python tool) |
| [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | ★ 63k | `uiux-` | 67 UI styles, 161 design rules, 13 framework stacks |
| [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) | ★ 51k | `gsd-` | Meta-prompting + context engineering + spec-driven dev |
| [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | ★ 48k | `mem-` | Cross-session memory via vector search + MCP |
| [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | ★ 38k | ref | Canonical curated list of Claude Code resources |
| [wshobson/agents](https://github.com/wshobson/agents) | ★ 33k | `ws-` | 182 agents, 149 skills, 96 commands across 77 domain plugins |
| [ruvnet/ruflo](https://github.com/ruvnet/ruflo) | ★ 31k | `ruflo-` | Enterprise multi-agent orchestration + WASM kernels _(opt-in)_ |
| [eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master) | ★ 26k | `ctm-` | AI-powered task lifecycle management + MCP server |
| [SuperClaude-Org/SuperClaude_Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework) | ★ 22k | `sc-` | 20 agents, 30 `/sc:` commands, 7 behavioral modes |
| [gonzalezpazmonica/pm-workspace](https://github.com/gonzalezpazmonica/pm-workspace) | ★ 33 | ref | Full AI project management suite (Savia) |

> **"ref"** = included as a git submodule for local browsing, but `install.sh` does not create any symlinks from it. These repos have incompatible directory structures, are standalone tools (not Claude Code agents/skills), or are reference lists. They are cloned so you can read them locally — they contribute zero agents/skills/commands to your installed count and zero tokens to your context.

---

## Tools by Category

### Routing — Start Here

The `master-agent-routing` skill (auto-loaded at session start) applies a decision tree across all tools. Describe your task — it routes automatically.

| Task | Best Tool |
|------|-----------|
| New feature (>2h) | `mem-mem-search` → `superpowers-writing-plans` → `superpowers-subagent-driven-development` |
| Bug fix | Write failing test → implement → `ecc-code-reviewer` |
| Mystery/flaky bug | `superpowers-systematic-debugging` |
| Code review | `ecc-code-reviewer` |
| Security review | `ecc-security-reviewer` |
| Architecture decision | `ecc-architect` |
| Refactor | `ecc-refactor-cleaner` |
| UI/UX design | `uiux-ui-ux-pro-max` |
| "Did we build this before?" | `mem-mem-search` |
| PR description | `ruflo-pr-manager` _(requires --with-ruflo)_ |
| DB migration | `ecc-database-migrations` |
| Parallel agent teams | `ws-agent-teams-team-lead` |
| Multi-agent orchestration | `ruflo-sparc-coordinator` _(requires --with-ruflo)_ |
| Task/project lifecycle | `ctm-` + Task Master MCP |
| AI research with confidence scoring | `sc-researcher` + `sc-confidence-check` |

### Key Agents

**`ecc-architect`** — System design, trade-off analysis, ADR creation. Read-only — advises, never edits.

**`ecc-code-reviewer`** — Reviews `git diff`. CRITICAL/HIGH/MEDIUM/LOW severity. Only reports issues with >80% confidence.

**`ecc-security-reviewer`** — OWASP-aware security analysis. Run before any commit touching auth, inputs, or external APIs.

**`ecc-chief-of-staff`** — High-level task orchestrator. Classifies work into 4 priority tiers, routes to specialists.

**`gsd-gsd-executor`** — Executes a GSD plan phase by phase with checkpoints and atomic commits.

**`ws-agent-orchestration-context-manager`** — Multi-agent context coordination across parallel tasks.

**`sc-researcher`** — Deep research agent with multi-hop reasoning and confidence scoring (0.0–1.0).

### Key Skills

**`mem-mem-search`** — 3-layer memory search across all past sessions. Run before writing new code. _(Requires MCP setup — see below.)_

**`mem-smart-explore`** — Semantic codebase mapping. 10-18x cheaper than reading individual files.

**`superpowers-writing-plans`** — Extracts a spec, writes it back for approval, then breaks into 2–5 min tasks.

**`superpowers-systematic-debugging`** — Structured debugging for mystery failures: hypotheses, isolation, tracking.

**`gsd-context-engineering`** — Solves context rot. Maintains spec fidelity as Claude fills its context window.

**`sc-confidence-check`** — Score output confidence (0.0–1.0) before committing to a direction.

### Key Commands

```bash
/ecc-tdd              # Full TDD workflow for a feature
/ecc-code-review      # Quality review (logic, patterns, coverage)
/ecc-save-session     # Save full session state for resuming later
/ecc-resume-session   # Resume a saved session in a new window
/ecc-context-budget   # Check how much context window is consumed
/ecc-harness-audit    # 7-category health check of your Claude Code setup
/ecc-verify           # Verification checklist before marking work done
/gsd-gsd              # Full spec → plan → build workflow
/sc:implement         # SuperClaude: implement with auto-selected behavioral mode
/sc:analyze           # SuperClaude: analyze with confidence scoring
/ctm-dedupe           # claude-task-master: deduplicate tasks across projects
```

---

## Source Quality Standards

Every submodule is selected against these criteria:

- **Community traction** — GitHub stars from each source project's own community (see table above for individual counts; these are not this repo's stars)
- **Active maintenance** — verified to have commits within the last 60 days at time of collection
- **Prefix-safe** — `install.sh` assigns unique prefixes and patches known `name:` frontmatter collisions automatically
- **Token-scoped** — single-purpose agents preferred over monolithic configs; ruflo (high token cost) is opt-in via `--with-ruflo`
- **Multi-platform** — tested with Claude Code; community-reported to work with Cursor, OpenCode, Gemini CLI, Codex, Windsurf, Roo

**What this is not:** A guarantee that every agent produces correct output on every codebase. These are community tools — review the source repo for each prefix before using agents in production-critical workflows.

---

## Installation Reference

### Token loading behavior

Agents and commands are **not** pre-loaded into context. They are read by Claude Code on-demand when invoked by name or matched by the routing skill. Installing 325+ agents does **not** mean 325 agents are consuming tokens in every session.

**What is always in context after install:**
- `~/.claude/CLAUDE.md` — loaded at every session start (~2–3K tokens)
- `rules/` files — loaded per your Claude Code settings
- `master-agent-routing` skill — invoked once at session start via CLAUDE.md (~1–3K tokens)

**What is not in context unless invoked:**
- Individual agents (`.md` files in `~/.claude/agents/`) — loaded only when called
- Skills and commands — loaded only when explicitly triggered

**Ruflo note:** Ruflo hooks require the `claude-flow` MCP server and add overhead even when ruflo agents are not explicitly invoked. This is why ruflo is excluded by default — use `--with-ruflo` only if you are running the claude-flow MCP server.

### What gets installed

| Source | Agents | Skills | Commands | Notes |
|--------|--------|--------|----------|-------|
| everything-claude-code | 28 | 130+ | 57 | Core ECC framework |
| wshobson-agents | 182 | 149 | 96 | Domain-specialized plugins |
| superpowers | 1 | 14 | 3 | Spec-to-code workflow |
| get-shit-done | 18 | — | 57 | Context engineering + spec dev |
| super-claude | 20 | 6 | 30 | Behavioral modes framework |
| claude-mem | — | 5 | — | Cross-session memory |
| ui-ux-pro-max | — | 7 | — | UI/UX design intelligence |
| ruflo _(--with-ruflo only)_ | 76 | 38 | 4 | Enterprise multi-agent |
| claude-task-master | — | — | 3 | AI task management |
| master | — | 1 | — | Agent routing skill |
| **Total (default)** | **~249** | **~300** | **~194** | Ruflo excluded |
| **Total (--with-ruflo)** | **~325** | **~338** | **~198** | Full collection |

All tools are prefixed by source — zero name collisions:
`ecc-` · `ws-` · `superpowers-` · `gsd-` · `sc-` · `mem-` · `uiux-` · `ruflo-` · `ctm-`

### Updating to latest

```bash
git submodule update --remote --merge   # pull latest from all 12 upstream repos
bash scripts/update-hashes.sh           # update lock file
git add submodule-hashes.lock && git commit -m "chore: update submodule hashes"
bash master/install.sh                  # refresh symlinks
```

---

## Memory Setup (Optional — Cross-Session Intelligence)

`mem-mem-search`, `mem-smart-explore`, and `mem-timeline-report` require the **claude-mem MCP server**. The base install works without this — you just won't have cross-session memory until it's set up.

```bash
# 1. Install Bun (required by claude-mem)
curl -fsSL https://bun.sh/install | bash

# 2. Install dependencies
cd claude-mem/plugin && bun install

# 3. Add to ~/.claude/settings.json under mcpServers:
{
  "mcpServers": {
    "claude-mem": {
      "command": "bun",
      "args": ["run", "/absolute/path/to/ai-powerhouse/claude-mem/plugin/src/index.ts"]
    }
  }
}
```

Use the absolute path to your `ai-powerhouse` directory. Verify it's working in a Claude Code session: `invoke mem-mem-search for "test"` — if it returns results (or "no memories found"), the MCP server is connected.

---

## Repository Structure

```
ai-powerhouse/
├── master/                   # Install/uninstall scripts + routing skill
├── everything-claude-code/   # ecc-* — Anthropic hackathon winner (★ 151k)
├── wshobson-agents/          # ws-* — 182 agents, 149 skills, 96 commands (★ 33k)
├── super-claude/             # sc-* — 20 agents, 6 skills, 30 /sc: commands (★ 22k)
├── get-shit-done/            # gsd-* — context engineering + spec-driven dev (★ 51k)
├── superpowers/              # superpowers-* — spec-to-code workflow (★ 147k)
├── claude-mem/               # mem-* — cross-session memory + MCP server (★ 48k)
├── claude-task-master/       # ctm-* — AI task lifecycle + MCP (★ 26k)
├── ui-ux-pro-max-skill/      # uiux-* — UI/UX design intelligence (★ 63k)
├── ruflo/                    # ruflo-* — enterprise multi-agent, opt-in (★ 31k)
├── pm-workspace/             # [ref] AI PM suite (★ 33)
├── awesome-claude-code/      # [ref] canonical community list (★ 38k)
├── autoresearch/             # [ref] Karpathy's automated research (★ 70k)
└── submodule-hashes.lock     # Pinned commit hashes for reproducibility
```

---

## Contributing

Found a high-quality Claude Code repo that belongs here? Open an issue or PR:

1. Real community traction (stars + active maintenance)
2. Adds something not already covered by the 12 existing submodules
3. Include the repo URL, verified star count, and what unique gap it fills

---

## Related Resources

- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) — The canonical curated list of all Claude Code resources
- [Claude Code Docs](https://docs.anthropic.com/claude/docs/claude-code) — Official Anthropic documentation
- [Model Context Protocol](https://modelcontextprotocol.io) — The MCP standard used by claude-mem and claude-task-master
- [USAGE.md](USAGE.md) — Full workflow guide, daily patterns, and troubleshooting

---

⭐ **Star this repo** to get notified when new community repos are added to the collection.

---

*AI Powerhouse is a community project. Not affiliated with Anthropic. All submodules are independent open-source projects — see each repo for its own license.*
