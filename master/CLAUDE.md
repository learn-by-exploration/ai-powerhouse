# AI Powerhouse — Master Configuration

You have access to a curated collection of state-of-the-art Claude Code tools assembled from the best open-source repos in the ecosystem. Use them proactively.

## What's Available

### Agents (123 total)

**everything-claude-code agents** (prefix: `ecc-`):
- `ecc-architect` — System design, layer assignment, architecture decisions
- `ecc-code-reviewer` — Deep code quality and security review
- `ecc-chief-of-staff` — Orchestration and task delegation
- `ecc-tdd-guide` — Test-driven development guidance
- `ecc-planner` — Implementation planning
- `ecc-security-reviewer` — Security audit
- `ecc-refactor-cleaner` — Code cleanup and refactoring
- `ecc-build-error-resolver` — Fix build errors (generic, go, rust, java, kotlin, cpp, pytorch)
- Language reviewers: `ecc-python-reviewer`, `ecc-typescript-reviewer`, `ecc-go-reviewer`, `ecc-rust-reviewer`, `ecc-java-reviewer`, `ecc-kotlin-reviewer`, `ecc-cpp-reviewer`, `ecc-flutter-reviewer`, `ecc-database-reviewer`

**superpowers agents** (prefix: `superpowers-`):
- `superpowers-code-reviewer` — Code review with systematic feedback

**get-shit-done agents** (prefix: `gsd-`):
- `gsd-planner` — Spec extraction and project planning
- `gsd-executor` — Implementation execution
- `gsd-verifier` — Verification and QA
- `gsd-debugger` — Systematic debugging
- `gsd-ui-researcher`, `gsd-ui-auditor`, `gsd-ui-checker` — UI research and auditing
- `gsd-codebase-mapper` — Understand existing codebase
- `gsd-roadmapper` — Roadmap generation
- And more specialized research/planning agents

### Skills (189 total)

**everything-claude-code skills** (prefix: `ecc-`) — Production-battle-tested:
- Engineering: `ecc-tdd-workflow`, `ecc-coding-standards`, `ecc-api-design`, `ecc-security-review`
- Architecture: `ecc-architecture-decision-records`, `ecc-backend-patterns`, `ecc-frontend-patterns`
- Language-specific: `ecc-python-patterns`, `ecc-golang-patterns`, `ecc-rust-patterns`, `ecc-kotlin-patterns`, `ecc-swift*`
- AI/Agents: `ecc-agentic-engineering`, `ecc-autonomous-loops`, `ecc-agent-eval`, `ecc-continuous-learning`
- Quality: `ecc-e2e-testing`, `ecc-verification-loop`, `ecc-eval-harness`
- Context: `ecc-context-budget`, `ecc-deep-research`, `ecc-codebase-onboarding`

**superpowers skills** (prefix: `superpowers-`) — Autonomous workflow:
- `superpowers-subagent-driven-development` — Launch parallel subagents for implementation
- `superpowers-test-driven-development` — TDD enforcement
- `superpowers-writing-plans` — Structured implementation plans
- `superpowers-executing-plans` — Execute plans step by step
- `superpowers-systematic-debugging` — Root-cause debugging
- `superpowers-using-git-worktrees` — Parallel work with worktrees
- `superpowers-verification-before-completion` — Never mark done without proof
- `superpowers-dispatching-parallel-agents` — Parallelization patterns
- `superpowers-receiving-code-review` — How to process review feedback

**claude-mem skills** (prefix: `mem-`) — Memory and planning:
- `mem-mem-search` — Search past work and context across sessions
- `mem-make-plan` — Create phased implementation plans
- `mem-do` — Execute phased plans using subagents
- `mem-smart-explore` — Smart codebase exploration
- `mem-timeline-report` — Report on past activity

**ui-ux-pro-max skills** (prefix: `uiux-`) — Design intelligence:
- `uiux-ui-ux-pro-max` — Full design intelligence (161 rules, 67 styles)
- `uiux-design-system` — Generate complete design systems
- `uiux-ui-styling` — Platform-specific styling guidance
- `uiux-brand` — Brand identity and color systems
- `uiux-design` — Design recommendations by product type
- `uiux-slides` — Presentation design

**ruflo agents** (prefix: `ruflo-`) — 76 specialized agents across:
- Core: `ruflo-coder`, `ruflo-planner`, `ruflo-researcher`, `ruflo-reviewer`, `ruflo-tester`
- Consensus: `ruflo-raft-manager`, `ruflo-byzantine-coordinator`, `ruflo-crdt-synchronizer`, `ruflo-quorum-manager`
- Swarm: `ruflo-hierarchical-coordinator`, `ruflo-mesh-coordinator`, `ruflo-adaptive-coordinator`
- Hive mind: `ruflo-queen-coordinator`, `ruflo-worker-specialist`, `ruflo-scout-explorer`
- GitHub: `ruflo-pr-manager`, `ruflo-issue-tracker`, `ruflo-release-manager`, `ruflo-workflow-automation`
- SPARC: `ruflo-specification`, `ruflo-architecture`, `ruflo-refinement`
- Optimization: `ruflo-load-balancer`, `ruflo-performance-monitor`, `ruflo-topology-optimizer`

**ruflo skills** (prefix: `ruflo-`) — 38 skills for multi-agent orchestration:
- Memory: `ruflo-agentdb-advanced`, `ruflo-agentdb-vector-search`, `ruflo-reasoningbank-agentdb`
- Swarm: `ruflo-swarm-orchestration`, `ruflo-swarm-advanced`, `ruflo-hive-mind-advanced`, `ruflo-flow-nexus-swarm`
- Dev: `ruflo-sparc-methodology`, `ruflo-pair-programming`, `ruflo-verification-quality`, `ruflo-agentic-jujutsu`
- GitHub: `ruflo-github-code-review`, `ruflo-github-workflow-automation`, `ruflo-github-multi-repo`
- v3 arch: `ruflo-v3-ddd-architecture`, `ruflo-v3-core-implementation`, `ruflo-v3-security-overhaul`

**ruflo hooks** — Pre/post-tool hooks integrating with `npx ruflo` swarm CLI (`ruflo-hooks.json`)

**ruflo commands** (prefix: `ruflo-`):
- `/ruflo-claude-flow-help` — Help and overview of all ruflo commands
- `/ruflo-claude-flow-memory` — Memory management (AgentDB store/retrieve)
- `/ruflo-claude-flow-swarm` — Launch multi-agent swarms
- `/ruflo-sparc` — SPARC development methodology entry point

### Commands (68 total)

**everything-claude-code** (prefix: `/ecc-`):
- `/ecc-plan` — Create implementation plans
- `/ecc-tdd` — Test-driven development workflow
- `/ecc-code-review` — Run code review
- `/ecc-build-fix` — Fix build errors
- `/ecc-e2e` — E2E testing
- `/ecc-learn` — Extract patterns from sessions
- `/ecc-skill-create` — Generate skills from git history
- `/ecc-verify` — Verify implementation
- `/ecc-checkpoint` — Save session checkpoint
- `/ecc-context-budget` — Show context usage

**superpowers** (prefix: `/superpowers-`):
- `/superpowers-write-plan` — Write an implementation plan
- `/superpowers-execute-plan` — Execute a plan
- `/superpowers-brainstorm` — Brainstorm solutions

**get-shit-done** (prefix: `/gsd-`):
- `/gsd-gsd` — Main GSD workflow (spec → plan → build)

## How to Use

### For a new feature
1. Use `superpowers-writing-plans` skill to create a solid spec first
2. Use `ecc-architect` agent to review the architecture
3. Use `superpowers-subagent-driven-development` or `gsd-executor` to implement
4. Use `ecc-code-reviewer` agent for review
5. Use `superpowers-verification-before-completion` before marking done

### For debugging
- Use `gsd-debugger` agent for systematic root-cause analysis
- Use `superpowers-systematic-debugging` skill

### For UI/UX work
- Use `uiux-ui-ux-pro-max` skill for design decisions
- Use `uiux-design-system` to generate a complete design system
- Use `gsd-ui-auditor` agent to audit existing UI

### For memory across sessions
- Use `mem-mem-search` to recall past work
- Use `mem-make-plan` for phased planning
- Use `mem-do` to execute plans with subagents

### For context management
- Use `ecc-context-budget` command to check usage
- Use `ecc-strategic-compact` skill when context is high
- Use `ecc-continuous-learning` skill to extract patterns

## Key Principles (from all sources)

1. **Spec before code** — Never jump to implementation without a clear plan
2. **Verify before done** — Always prove it works, never assume
3. **One slice at a time** — Implement in small, testable increments
4. **TDD** — Write tests first
5. **Subagents for heavy work** — Delegate to keep context clean
6. **Memory across sessions** — Use mem-search to avoid repeating work
