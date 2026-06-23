# Multi-Agent Coordination

Multiple agents editing the same checkout is a recipe for lost work. Pick
the pattern that matches the work shape, and **say which one you picked
in the PR description** so reviewers know how to rebase.

## Patterns

| Pattern | Use when | How |
|---|---|---|
| **Worktree isolation** | Two agents, unrelated areas (e.g. new feature + UI redesign) | Spawn with `Agent(..., { isolation: "worktree" })`; merge each branch back on `main` |
| **File ownership** | Many agents, well-scoped tasks (`team-lead` → `team-implementer` flow) | Declare `Agent A owns lib/<area>/** + test/<area>/**` etc. up front; a same-file collision is a **contract violation**, not a git conflict |
| **Branch-per-agent, serial writes** | Small ordered pipeline, cheap to set up | One agent at a time on `main`; `git checkout -b feat/agent-N`, work, merge, repeat |
| **Sequential pipeline** | One big feature where correctness > speed (planner → tdd → impl → review) | Serialize — no parallelism. `superpowers-subagent-driven-development` does this |
| **Read-only + scratch** | Most agents are explorers/reviewers; one or two are writers | Writers commit to their branches; readers write only to `.claude/scratch/<agent>.md` (`.gitignore` it) |

## Default

**File ownership.** Pre-declare which agent owns which files in the
task brief. A collision at merge time is a planning bug, not a git bug.

## If Two Agents Must Touch the Same File

- Drop one agent to **worktree isolation**, **or**
- Stop and replan into a **sequential pipeline**.

**Never hand-merge mid-PR.** Re-dispatch the conflicting agent with the
other's diff in its context so the second pass is informed.

## Conflict Resolution Playbook

```bash
git merge feat/agent-a
# CONFLICT in path/to/file.dart
git status                              # see conflicted files
git diff --name-only --diff-filter=U    # list them
# Open the file, resolve <<<<<<< markers
git add path/to/file.dart
git commit                              # completes the merge
```

- Same-file, same-range → real conflict; resolve by hand or re-dispatch.
- Same-file, different-range → fast manual resolve, usually 1–2 minutes.
- Different files → auto-merge, nothing to do.

## PR Description Checklist

Every multi-agent PR should state:

1. **Pattern used** (one of the five above).
2. **Agent → file map** (who owned what).
3. **Merge order** (which branch lands first, which depends on it).
4. **Conflicts resolved** (list any manual merge points and why).

## Maintenance Note

This rule lives in the **parent repo's** `.claude/rules/`, **not** inside
any submodule. That keeps it stable across `git submodule update --remote`
runs — submodule-tracked rules (`~/.claude/rules/ecc-common/...`) are
upstream-owned and will get reset on update.