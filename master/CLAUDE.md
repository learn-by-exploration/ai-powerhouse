# AI Powerhouse — Master Configuration

You have access to 310 agents, 640 skills, and 284 commands from 17 sources (default install; add `--with-ruflo` for 365 agents / 750 skills / 332 commands).
**First, invoke the `master-agent-routing` skill to select the right tool for your task.**

---

## Routing Quick Reference

| You want to... | Use this |
|---|---|
| **New feature** (>2h) | `mem-mem-search` → `superpowers-writing-plans` → `superpowers-subagent-driven-development` |
| **Bug fix** | Write failing test → implement → `ecc-code-reviewer` |
| **Debug mystery** | `superpowers-systematic-debugging` |
| **Code review** | `ecc-code-reviewer` (quality) or `ecc-security-reviewer` (security) |
| **Security review** | `ecc-security-reviewer` (app code) or `ecc-agentshield-scan` (harness config) |
| **Refactor** | `ecc-refactor-cleaner` |
| **Architecture** | `ecc-architect` |
| **UI/UX design** | `uiux-ui-ux-pro-max` or `uiux-design-system` |
| **Draw.io diagram** (exportable) | `drawio-skill` |
| **PlantUML diagram** (text-based) | `plantuml-skill` |
| **PDF / DOCX / PPTX / XLSX** | `anthropic-pdf` / `anthropic-docx` / `anthropic-pptx` / `anthropic-xlsx` |
| **Build an MCP server** | `anthropic-mcp-builder` |
| **Webapp testing** | `anthropic-webapp-testing` |
| **Business / marketing / finance** | `rez-business-*` / `rez-marketing-skill-*` / `rez-finance-*` |
| **C-level strategy** | `rez-c-level-advisor-*` |
| **Compliance / regulatory** | `rez-compliance-os-*` / `rez-ra-qm-team-*` |
| **Multi-agent / enterprise** | `ruflo-sparc-coordinator` + `ruflo-swarm-orchestration` |
| **Systems engineering lifecycle** (ISO 15288) | `se-lifecycle` skill (route) → `se-systems-engineer` agent (walk through) |
| **Over-engineering review** (YAGNI / lazy mode) | `ponytail-ponytail` (lazy mode), `ponytail-ponytail-review` (review), `ponytail-ponytail-audit` (code-to-delete audit) |
| **"Did we build this before?"** | `mem-mem-search` |
| **Document something** | `ecc-doc-updater` agent |
| **Onboard to a new codebase** | `mem-smart-explore` → `ecc-architect` → `gsd-codebase-mapper` |
| **PR description** | `ruflo-pr-manager` |
| **Database migration** | `ecc-database-migrations` skill |
| **Not sure what to use** | `master-agent-routing` skill |

> Full decision tree: `master-agent-routing` skill.

---

## Unified Philosophy

Five systems are loaded. They agree on the fundamentals:

1. **Memory first** — `mem-mem-search` before writing new code. 10 min of search saves 2 hrs.
2. **Plan before code** — `superpowers-writing-plans` for features >2h. Never skip.
3. **TDD always** — Write failing test first, implement to pass. No exceptions.
4. **80% coverage** — ECC minimum. Superpowers enforces it. Both mandate it.
5. **Verify before done** — `superpowers-verification-before-completion`. Evidence first.
6. **Subagents for heavy work** — Keep this session clean; delegate implementation.
7. **SE lifecycle first** — For new systems, follow ISO/IEC/IEEE 15288 (stakeholder needs → disposal). The phase you're in drives the tool you pick. See `master-se-lifecycle` and `master-se-systems-engineer`.

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

## Context Budget Awareness

This harness loads ~80K tokens at session start in minimal mode (~120K with `--full`).

**To reduce token overhead:**
- Default install is already minimal — use `bash master/install.sh` (no flags needed)
- Exclude ruflo enterprise agents: `bash master/install.sh --no-ruflo` (saves ~40-60K)
- Check current usage: `/ecc-context-budget`
- When context is high: `ecc-strategic-compact` skill, then delegate to subagents
- For large codebases: `mem-smart-explore` (10-18x cheaper than reading files directly)

**MCP dependencies:** `mem-mem-search`, `mem-smart-explore`, and `mem-timeline-report` require
the claude-mem MCP server entries in `~/.claude/settings.json`. If memory search returns nothing,
verify the MCP server is registered and running (`bun run start` in `claude-mem/plugin/`).
