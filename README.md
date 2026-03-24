# AI Powerhouse

A curated monorepo for tracking, organizing, and exploring the state-of-the-art in AI-assisted development tooling — with a focus on Claude Code and agentic workflows.

## What is this?

AI Powerhouse is a living collection of the best open-source AI development tools, assembled as git submodules. The goal is to have a single place to:

- Track the most impactful Claude Code plugins, skills, and workflows
- Study how top practitioners are structuring agentic systems
- Experiment with and compare different approaches to AI-assisted development
- Stay current as the ecosystem evolves rapidly

Each submodule points to the `main` branch of its upstream repo, so the collection stays up to date.

---

## Repositories

### 1. `awesome-claude-code`
**Source:** [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)

A community-curated Awesome List of Claude Code skills, agents, hooks, plugins, slash commands, CLAUDE.md files, and tooling. The central discovery index for the Claude Code ecosystem. Auto-generated from a CSV source with multiple README styles.

---

### 2. `claude-mem`
**Source:** [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem)

A persistent memory compression system built as a Claude Code plugin. Captures tool usage across sessions, compresses observations using the Claude Agent SDK, and injects relevant context into future sessions via 5 lifecycle hooks.

**Tech:** TypeScript, Bun, SQLite, Chroma (vector embeddings), React viewer UI
**Notable:** Vector semantic search, privacy tags, Express API on port 37777

---

### 3. `everything-claude-code`
**Source:** [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code)

An Anthropic Hackathon winner. A complete performance optimization system for AI agents — production-ready agents, hooks, commands, rules, and MCP configurations evolved over 10+ months of daily use. Covers token optimization, memory persistence, security scanning (AgentShield), continuous learning, and parallelization.

**Tech:** TypeScript, Shell, Python, Go, Java, Perl
**Notable:** Cross-platform (Windows/macOS/Linux), 50K+ stars

---

### 4. `get-shit-done`
**Source:** [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done)

A lightweight meta-prompting, context engineering, and spec-driven development system. Solves "context rot" — the quality degradation that happens as Claude fills its context window. Designed for solo developers who want to describe what they want and have it built correctly.

**Tech:** Node.js (`npx get-shit-done-cc@latest`)
**Notable:** Works with Claude Code, OpenCode, Gemini CLI, Codex, Copilot

---

### 5. `pm-workspace`
**Source:** [gonzalezpazmonica/pm-workspace](https://github.com/gonzalezpazmonica/pm-workspace)

The most ambitious entry: a full AI-powered project management suite built around "Savia", an owl-themed PM agent. Manages sprints, backlogs, code agents, billing, executive reporting, and technical debt — all from Claude Code.

**Tech:** Node.js, Python, MicroPython (ESP32 hardware), Android, Vue.js, Docker, .NET
**Scale:** 496 commands, 46 agents, 82 skills, 22 hooks, 16 programming language packs
**Notable:** Azure DevOps/Jira integration, voice assistant (ZeroClaw hardware device), meeting transcription with speaker diarization, Spec-Driven Development pipeline, adversarial security pipeline

---

### 6. `superpowers`
**Source:** [obra/superpowers](https://github.com/obra/superpowers)

A complete software development workflow built on composable skills. Forces spec-extraction before coding, then runs a subagent-driven implementation loop with automated review. Lets Claude work autonomously for hours without deviating from the agreed plan.

**Tech:** Markdown-based skills, available on the official Claude plugin marketplace
**Notable:** TDD-first (YAGNI + DRY), works across Claude Code, Cursor, Codex, OpenCode, Gemini CLI

---

### 7. `ui-ux-pro-max-skill`
**Source:** [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)

An AI skill providing design intelligence for building professional UI/UX across multiple platforms and frameworks. Ships a searchable database of 67 UI styles, 161 reasoning rules, color palettes, font pairings, chart types, and UX guidelines.

**Tech:** Python 3.x (BM25 + regex search engine), TypeScript CLI (`uipro-cli` on npm), CSV databases
**Notable:** Design System Generator, supports 13 stacks (React, Next.js, Vue, Flutter, SwiftUI, Jetpack Compose, etc.)

---

## Structure

```
ai-powerhouse/
├── awesome-claude-code/       # Curated ecosystem directory
├── claude-mem/                # Persistent memory system
├── everything-claude-code/    # Production agent optimization framework
├── get-shit-done/             # Context-engineering & spec-driven dev
├── pm-workspace/              # Full AI PM suite (Savia)
├── superpowers/               # Autonomous spec-to-code workflow
└── ui-ux-pro-max-skill/       # UI/UX design intelligence toolkit
```

All subdirectories are git submodules tracking the `main` branch of their upstream repositories.

---

## Getting Started

Clone with all submodules:

```bash
git clone --recurse-submodules git@github.com:learn-by-exploration/ai-powerhouse.git
```

Or if already cloned:

```bash
git submodule update --init --recursive
```

Update all submodules to latest upstream:

```bash
git submodule update --remote --merge
```

---

## Roadmap

- Add more state-of-the-art repos as they emerge
- Add comparison notes and use-case guides for each tool
- Identify overlaps and complementary combinations
- Track which tools work best together
