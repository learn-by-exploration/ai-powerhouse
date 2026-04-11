# AI Powerhouse — 325+ Agents, 338+ Skills & 198+ Commands for Claude Code

> Install the entire Claude Code community ecosystem in a single script. One command. Zero configuration.

[![GitHub Stars](https://img.shields.io/github/stars/learn-by-exploration/ai-powerhouse?style=flat-square&logo=github&label=Stars)](https://github.com/learn-by-exploration/ai-powerhouse/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/learn-by-exploration/ai-powerhouse?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse/commits)
[![License](https://img.shields.io/github/license/learn-by-exploration/ai-powerhouse?style=flat-square)](LICENSE)
[![Agents](https://img.shields.io/badge/Agents-325%2B-blueviolet?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)
[![Skills](https://img.shields.io/badge/Skills-338%2B-blue?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)
[![Commands](https://img.shields.io/badge/Commands-198%2B-green?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-orange?style=flat-square)](https://claude.ai/code)
[![Community Stars](https://img.shields.io/badge/Community-81k%2B%20★-yellow?style=flat-square)](https://github.com/learn-by-exploration/ai-powerhouse)

**AI Powerhouse** is a curated meta-collection of 12 Claude Code submodules — sourced from the highest-starred community repos and installed in one script. Stop spending hours reading READMEs. Get every production-ready agent, skill, and command the community has built, working in your `~/.claude` in 60 seconds.

```bash
git clone --recurse-submodules git@github.com:learn-by-exploration/ai-powerhouse.git
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
| Token bloat from monolithic configs | Single-purpose plugins, minimal token usage |

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

### Clone with all submodules
```bash
git clone --recurse-submodules git@github.com:learn-by-exploration/ai-powerhouse.git
cd ai-powerhouse
```

### Install (symlinks all tools into `~/.claude`)
```bash
bash master/install.sh
```

### Install modes
```bash
bash master/install.sh              # Minimal (recommended) — core tools only
bash master/install.sh --full       # Full — adds 11 language rule sets
bash master/install.sh --no-ruflo   # Skip 76 enterprise agents (saves ~50K tokens)
bash master/install.sh --dry-run    # Preview without writing
```

Restart Claude Code after installing.

---

## The 12 Source Repos (81,000+ Combined ★)

Every agent and skill in AI Powerhouse comes from repos the developer community has already validated:

| Repo | Stars | Prefix | What It Adds |
|------|-------|--------|--------------|
| [wshobson/agents](https://github.com/wshobson/agents) | ★ 33k | `ws-` | 182 agents, 149 skills, 96 commands across 77 domain plugins |
| [eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master) | ★ 26k | `ctm-` | AI-powered task lifecycle management + MCP server |
| [SuperClaude-Org/SuperClaude_Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework) | ★ 22k | `sc-` | 20 agents, 30 `/sc:` commands, 7 behavioral modes |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | ★ 151k | `ecc-` | Anthropic hackathon winner — core agent framework |
| [ruvnet/ruflo](https://github.com/ruvnet/ruflo) | ★ 6k | `ruflo-` | Enterprise multi-agent orchestration + WASM kernels |
| [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) | ★ 50k | `gsd-` | Meta-prompting + context engineering + spec-driven dev |
| [obra/superpowers](https://github.com/obra/superpowers) | ★ 2k | `superpowers-` | Spec-to-code autonomous workflow |
| [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | ★ 1k | `mem-` | Cross-session memory via vector search + MCP |
| [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | ★ 2k | `uiux-` | 67 UI styles, 161 design rules, 13 framework stacks |
| [gonzalezpazmonica/pm-workspace](https://github.com/gonzalezpazmonica/pm-workspace) | ★ 1k | ref | Full AI project management suite (Savia) |
| [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | ★ 38k | ref | Canonical curated list of Claude Code resources |
| [karpathy/autoresearch](https://github.com/karpathy/autoresearch) | ★ 70k | ref | Automated research reference (standalone Python tool) |

> **"ref"** = tracked for reference, not installed. See [USAGE.md](USAGE.md) for full install details.

---

## Tools by Category

### Routing — Start Here

The `master-agent-routing` skill (auto-loaded at session start) applies a decision tree across all 325+ tools. Describe your task — it routes automatically.

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
| PR description | `ruflo-pr-manager` |
| DB migration | `ecc-database-migrations` |
| Parallel agent teams | `ws-agent-teams-team-lead` |
| Multi-agent orchestration | `ruflo-sparc-coordinator` |
| Task/project lifecycle | `ctm-` + Task Master MCP |
| AI research with confidence scoring | `sc-researcher` + `sc-confidence-check` |

### Production-Ready Agents

**`ecc-architect`** — System design, trade-off analysis, ADR creation. Read-only — advises, never edits.

**`ecc-code-reviewer`** — Reviews `git diff`. CRITICAL/HIGH/MEDIUM/LOW severity. Only reports issues with >80% confidence.

**`ecc-security-reviewer`** — OWASP-aware security analysis. Run before any commit touching auth, inputs, or external APIs.

**`ecc-chief-of-staff`** — High-level task orchestrator. Classifies work into 4 priority tiers, routes to specialists.

**`gsd-gsd-executor`** — Executes a GSD plan phase by phase with checkpoints and atomic commits.

**`ws-agent-orchestration-context-manager`** — Multi-agent context coordination across parallel tasks.

**`sc-researcher`** — Deep research agent with multi-hop reasoning and confidence scoring (0.0–1.0).

### Key Skills

**`mem-mem-search`** — 3-layer memory search across all past sessions. Run before writing new code. 10 minutes of search saves 2+ hours of rework.

**`mem-smart-explore`** — Semantic codebase mapping. 10-18x cheaper than reading individual files. Start here on any unfamiliar project.

**`superpowers-writing-plans`** — Extracts a spec, writes it back for approval, then breaks into 2–5 min tasks. Forces alignment before any code is written.

**`superpowers-systematic-debugging`** — Structured debugging for mystery failures: generates hypotheses, isolates variables, tracks what's been tried.

**`gsd-context-engineering`** — Solves context rot. Maintains spec fidelity as Claude fills its context window across long sessions.

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

## What "Battle-Tested" Means

Every submodule in AI Powerhouse is sourced from repos that have been:

- **Community-validated** — 81k+ combined GitHub stars, earned over years of real-world use
- **Actively maintained** — all 12 repos had commits in the last 30 days
- **Compatibility-tested** — prefixes prevent collisions; `install.sh` patches known name conflicts automatically
- **Token-efficient** — single-purpose agents, progressive disclosure, minimal context overhead
- **Multi-platform** — works with Claude Code, Cursor, OpenCode, Gemini CLI, Codex, Windsurf, Roo

---

## Installation Reference

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
| ruflo _(optional)_ | 76 | 38 | 4 | Enterprise multi-agent |
| claude-task-master | — | — | 3 | AI task management |
| master | — | 1 | — | Agent routing skill |
| **Total (with ruflo)** | **~325** | **~338** | **~198** | |
| **Total (--no-ruflo)** | **~249** | **~300** | **~194** | Recommended for solo devs |

All tools are prefixed by source — zero name collisions:
`ecc-` · `ws-` · `superpowers-` · `gsd-` · `sc-` · `mem-` · `uiux-` · `ruflo-` · `ctm-`

### Updating to latest

```bash
git submodule update --remote --merge   # pull latest from all 12 upstream repos
bash scripts/update-hashes.sh           # update lock file
git add submodule-hashes.lock && git commit -m "chore: update submodule hashes"
bash master/install.sh                  # refresh symlinks
```

### Uninstalling

```bash
bash master/uninstall.sh            # remove from ~/.claude
bash master/uninstall.sh --dry-run  # preview first
```

---

## Memory Setup (Cross-Session Intelligence)

`mem-mem-search`, `mem-smart-explore`, and `mem-timeline-report` require the **claude-mem MCP server**. Without it, memory search returns nothing — you lose the most differentiating feature of this collection.

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
      "args": ["run", "/path/to/ai-powerhouse/claude-mem/plugin/src/index.ts"]
    }
  }
}
```

---

## Repository Structure

```
ai-powerhouse/
├── master/                   # Install/uninstall scripts + routing skill
├── everything-claude-code/   # ecc-* — Anthropic hackathon winner framework
├── wshobson-agents/          # ws-* — 182 agents, 149 skills, 96 commands
├── super-claude/             # sc-* — 20 agents, 6 skills, 30 /sc: commands
├── get-shit-done/            # gsd-* — context engineering + spec-driven dev
├── superpowers/              # superpowers-* — spec-to-code workflow
├── claude-mem/               # mem-* — cross-session memory + MCP server
├── claude-task-master/       # ctm-* — AI task lifecycle + MCP
├── ui-ux-pro-max-skill/      # uiux-* — UI/UX design intelligence
├── ruflo/                    # ruflo-* — enterprise multi-agent (optional)
├── pm-workspace/             # [ref] AI PM suite (Savia)
├── awesome-claude-code/      # [ref] canonical community list
├── autoresearch/             # [ref] Karpathy's automated research
└── submodule-hashes.lock     # Pinned commit hashes for reproducibility
```

---

## Contributing

Found a high-quality Claude Code repo that belongs here? Open an issue or PR:

1. It should have real community traction (stars + active maintenance)
2. It should add something not already covered by the 12 existing submodules
3. Include the repo URL, star count, and what unique gap it fills

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
