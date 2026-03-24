# AI Powerhouse — Master Configuration

You have access to 123 agents, 189 skills, and 68 commands from 8 best-in-class repos.
**Start here before reading anything else:** invoke the `master-agent-routing` skill.

---

## Start Here: Routing Quick Reference

| You want to... | Use this |
|---|---|
| **New feature** (>2h) | `mem-mem-search` → `superpowers-writing-plans` → `superpowers-subagent-driven-development` |
| **Bug fix** | Write failing test → implement → `ecc-code-reviewer` |
| **Debug mystery** | `superpowers-systematic-debugging` |
| **Code review** | `ecc-code-reviewer` (quality) or `ecc-security-reviewer` (security) |
| **Refactor** | `ecc-refactor-cleaner` |
| **Architecture** | `ecc-architect` |
| **UI/UX design** | `uiux-ui-ux-pro-max` or `uiux-design-system` |
| **Multi-agent / enterprise** | `ruflo-sparc` + `ruflo-swarm-orchestration` |
| **"Did we build this before?"** | `mem-mem-search` |
| **Not sure what to use** | `master-agent-routing` skill |

> Full decision tree: `master-agent-routing` skill (loaded automatically).

---

## Unified Philosophy

Five systems are loaded. They agree on the fundamentals:

1. **Memory first** — `mem-mem-search` before writing new code. 10 min of search saves 2 hrs.
2. **Plan before code** — `superpowers-writing-plans` for features >2h. Never skip.
3. **TDD always** — Write failing test first, implement to pass. No exceptions.
4. **80% coverage** — ECC minimum. Superpowers enforces it. Both mandate it.
5. **Verify before done** — `superpowers-verification-before-completion`. Evidence first.
6. **Subagents for heavy work** — Keep this session clean; delegate implementation.

### When Rules Conflict: Resolution Order

1. Project-specific `CLAUDE.md` (highest)
2. Task type (see `master-agent-routing` skill)
3. Superpowers skills (TDD, verification — non-negotiable)
4. ECC rules (80% coverage, conventional commits)
5. Claude-Mem (opportunistic reuse — don't force it)

### Testing: One Unified Strategy

All systems mandate TDD. They're additive, not conflicting:

```
Before coding:  mem-mem-search      (reuse if found)
While coding:   TDD                 (red → green → refactor)
Coverage:       80%+ minimum        (ECC)
Commits:        feat:/fix:/refactor: (conventional)
```

---

## What's Available

### Agents (123 total)

**Core development** (`ecc-` prefix):
`ecc-architect`, `ecc-code-reviewer`, `ecc-security-reviewer`, `ecc-planner`,
`ecc-tdd-guide`, `ecc-refactor-cleaner`, `ecc-build-error-resolver`, `ecc-chief-of-staff`

Language reviewers: `ecc-python-reviewer`, `ecc-typescript-reviewer`, `ecc-go-reviewer`,
`ecc-rust-reviewer`, `ecc-java-reviewer`, `ecc-kotlin-reviewer`, `ecc-cpp-reviewer`

**Workflow** (`superpowers-`, `gsd-`):
`superpowers-code-reviewer`, `gsd-planner`, `gsd-executor`, `gsd-verifier`,
`gsd-debugger`, `gsd-ui-auditor`, `gsd-codebase-mapper`

**Multi-agent orchestration** (`ruflo-` prefix, 76 agents):
- Core: `ruflo-coder`, `ruflo-planner`, `ruflo-researcher`, `ruflo-reviewer`, `ruflo-tester`
- Consensus: `ruflo-raft-manager`, `ruflo-byzantine-coordinator`, `ruflo-quorum-manager`
- Swarm: `ruflo-hierarchical-coordinator`, `ruflo-mesh-coordinator`, `ruflo-adaptive-coordinator`
- GitHub: `ruflo-pr-manager`, `ruflo-issue-tracker`, `ruflo-release-manager`
- SPARC: `ruflo-specification`, `ruflo-architecture`, `ruflo-refinement`

### Skills (189 total + master routing skill)

**`ecc-`** — Engineering standards (TDD, API design, patterns, security, language-specific)
**`superpowers-`** — Autonomous workflow (writing-plans, subagent-driven-development, systematic-debugging, verification-before-completion, dispatching-parallel-agents)
**`mem-`** — Memory (mem-search, make-plan, do, smart-explore, timeline-report)
**`uiux-`** — Design (ui-ux-pro-max, design-system, ui-styling, brand, slides)
**`ruflo-`** — Orchestration (sparc-methodology, swarm-orchestration, agentdb-*, flow-nexus-*, github-*)
**`master-`** — This harness (agent-routing ← start here)

### Commands (68 total)

**`/ecc-`**: plan, tdd, code-review, build-fix, e2e, verify, learn, checkpoint, context-budget
**`/superpowers-`**: write-plan, execute-plan, brainstorm
**`/gsd-`**: gsd (full spec→plan→build workflow)
**`/ruflo-`**: claude-flow-help, claude-flow-memory, claude-flow-swarm, sparc

---

## Context Budget Awareness

This harness loads ~120K tokens of rules/agents at session start (60% of a 200K window).

**To reduce token overhead:**
- Re-install with `bash master/install.sh --minimal` (skips language-specific rules, saves ~40K)
- Check usage: `/ecc-context-budget`
- When context is high: `ecc-strategic-compact` skill, then delegate to subagents
- For large codebases: `mem-smart-explore` (cheaper than reading 50 files directly)

---

## Installation & Maintenance

```bash
bash master/install.sh            # install to ~/.claude
bash master/install.sh --minimal  # core tools only (~40K fewer tokens)
bash master/install.sh --local    # install to master/.claude (this repo's context)
bash master/uninstall.sh          # remove everything

git submodule update --remote --merge  # update all submodules
```

Manifest at `~/.claude/POWERHOUSE_MANIFEST.json` tracks what's installed and submodule hashes.
