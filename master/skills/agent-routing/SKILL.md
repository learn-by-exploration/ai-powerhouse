---
name: agent-routing
description: Use this FIRST when unsure which agent, skill, or command to invoke. Maps task types to the right tool from this harness.
---

# Agent Routing — Which Tool to Use

**Read this before reading any other skill description.** It will save you 10-15K tokens.

---

## Quick Reference Table

| You want to... | Use this | Notes |
|---|---|---|
| Build a new feature (>2h) | `superpowers-writing-plans` | Creates spec + bite-sized task plan |
| Execute a written plan | `superpowers-subagent-driven-development` | Spawns workers per task, reviews each |
| Fix a bug | Write failing test first, then `ecc-code-reviewer` | TDD loop: red → green → review |
| Debug a mystery failure | `superpowers-systematic-debugging` | Root-cause methodology |
| Review code quality | `ecc-code-reviewer` | Checks style, correctness, tests |
| Security review | `ecc-security-reviewer` | Auth, secrets, injection, OWASP |
| Language-specific review | `ecc-<lang>-reviewer` | python, go, rust, typescript, etc. |
| Refactor / clean up | `ecc-refactor-cleaner` | Dead code, extract, rename |
| Architecture decision | `ecc-architect` | System design, layer assignment |
| Check if similar was built before | `mem-mem-search` | Search past sessions first |
| Plan with memory-aware phases | `mem-make-plan` | Phased plan with past context |
| Execute multi-agent plan | `mem-do` | Run phases with subagents |
| Parallel independent tasks | `superpowers-dispatching-parallel-agents` | 2+ truly independent workstreams |
| UI/UX design decision | `uiux-ui-ux-pro-max` | 67 styles, 161 rules |
| Generate a design system | `uiux-design-system` | Tokens, components, guidelines |
| Multi-agent orchestration (enterprise) | `ruflo-sparc` + `ruflo-swarm-orchestration` | SPARC methodology + swarm |
| Consensus across agents | `ruflo-raft-manager` or `ruflo-quorum-manager` | Distributed agent coordination |

---

## Decision Tree

```
What are you doing?
│
├─ PLANNING a new feature or large change
│  ├─ Have you solved something similar before?
│  │  └─ YES → mem-mem-search first, then plan
│  ├─ Solo developer, <1 week work → ecc-planner
│  ├─ Small team OR 1-2 weeks → superpowers-writing-plans (recommended default)
│  ├─ Large scope, enterprise → ruflo-sparc (full SDLC with 17 modes)
│  └─ Need architecture decision first → ecc-architect → then plan
│
├─ IMPLEMENTING (have a plan)
│  ├─ Executing task list → superpowers-subagent-driven-development
│  ├─ Parallel workstreams → superpowers-dispatching-parallel-agents
│  └─ Memory-aware execution → mem-do
│
├─ FIXING a bug
│  ├─ 1. Write test that reproduces the bug (TDD: RED)
│  ├─ 2. Implement fix (TDD: GREEN)
│  ├─ 3. ecc-code-reviewer (verify no regression)
│  └─ Mystery/flaky → superpowers-systematic-debugging first
│
├─ REVIEWING code
│  ├─ General quality → ecc-code-reviewer
│  ├─ Security → ecc-security-reviewer
│  ├─ Language-specific → ecc-<lang>-reviewer
│  └─ UI/UX → gsd-ui-auditor
│
├─ REFACTORING
│  ├─ Dead code / cleanup → ecc-refactor-cleaner
│  └─ Architecture change → ecc-architect first
│
└─ MEMORY & CONTINUITY
   ├─ "Did we solve this before?" → mem-mem-search
   ├─ "What did we do last session?" → mem-timeline-report
   └─ "Explore codebase efficiently" → mem-smart-explore
```

---

## When Multiple Apply: Priority Order

1. **mem-mem-search** — always search memory before building new
2. **superpowers skills** — TDD and planning are non-negotiable
3. **ecc rules** — 80% coverage, conventional commits
4. **Routing-matched tool** — from the table above
5. **ecc-code-reviewer** — always run after implementation

---

## The Four Planners: When to Use Which

| Planner | Best for | Output |
|---|---|---|
| `ecc-planner` | Short tasks, clear spec, solo | Task list + dependencies |
| `superpowers-writing-plans` | Most features (recommended default) | Bite-sized plan (2-5 min tasks) |
| `gsd-planner` | Spec extraction from vague requirements | Spec + phased plan |
| `ruflo-sparc` | Enterprise, large team, critical systems | Full SDLC + orchestration |

**Default**: `superpowers-writing-plans` unless you have a specific reason to deviate.

---

## Unified Testing Strategy (Resolve Conflicts)

All three rule systems (ECC, Superpowers, Claude-Mem) mandate testing. They are additive:

1. **Before writing code**: `mem-mem-search` — has this been solved before?
2. **While writing code**: TDD always — write failing test first (Superpowers mandate)
3. **Coverage target**: 80%+ minimum (ECC mandate)
4. **Commit format**: `feat:`, `fix:`, `refactor:`, `test:` (ECC conventional commits)

**No exceptions to TDD.** If tempted to skip: "This is simple" → test takes 30s. Write it.
