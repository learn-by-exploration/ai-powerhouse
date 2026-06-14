---
name: se-lifecycle
description: Use when starting a new system, evaluating where you are in a multi-phase project, or when the work should follow ISO/IEC/IEEE 15288 system life cycle processes. Routes to the right Powerhouse tool for the current lifecycle phase.
---

# Systems Engineering Lifecycle (ISO/IEC/IEEE 15288)

**Use this when:** you're starting a new system, taking over an existing one and don't know where it is in its lifecycle, or you're auditing whether the work covers all 11 Technical processes 15288 expects.

For the full reference, see `docs/se-15288.md`. This skill is the routing entry point — it answers "given where I am, what tool should I use?"

---

## The 11 Technical processes at a glance

| # | 15288 process | Powerhouse tool | What you produce |
|---|---|---|---|
| 6.4.1 | Stakeholder Needs | `mem-mem-search` + `master-se-systems-engineer` | `docs/stakeholder-needs.md` |
| 6.4.2 | Requirements Definition | `superpowers-writing-plans` | Requirements in the plan's spec section |
| 6.4.3 | Architecture Definition | `ecc-architect` | `docs/adr/0001-*.md`, C4 views |
| 6.4.4 | Implementation | `superpowers-subagent-driven-development` | Code + tests + build |
| 6.4.5 | Integration | `ws-agent-teams-team-lead` | Integration test report |
| 6.4.6 | Verification | `superpowers-test-driven-development`, `ecc-code-reviewer` | Test report, review log |
| 6.4.7 | Validation | `ws-agent-teams-team-review`, `ecc-verify` | Acceptance evidence per need |
| 6.4.8 | Transition | `ws-deployment-validation-config-validate` | Deployment plan + rollback runbook |
| 6.4.9 | Operation | `ws-observability-monitoring-monitor-setup` | Runbook, SLOs, alert routing |
| 6.4.10 | Maintenance | `ecc-refactor-cleaner`, `superpowers-systematic-debugging` | Change records, defect log |
| 6.4.11 | Disposal | _no harness tool_ — write `docs/disposal-plan.md` from the prompt in `docs/se-15288.md` | Disposal plan + sanitization evidence |

The other 19 processes (Agreement, Organizational Project-Enabling, Technical Management) are handled by the org and tooling, not by individual engineers — they're outside the scope of "which skill do I run now?"

---

## How to invoke

### If you want a guided walkthrough

Invoke the `master-se-systems-engineer` agent. It will:
1. Ask which phase you're currently in
2. Run the right Powerhouse tool for that phase
3. Capture the 15288-expected artifact
4. Gate the next phase on the verification/validation evidence the standard requires

### If you know which phase you're in

Jump straight to the tool in the table above. The verification/validation gate between phases is real — if your verification matrix is incomplete, do not start the next phase.

### If you don't know where you are

Answer these four questions:
1. **Is there a written statement of who wants this and why?** If no → start at 6.4.1 (Stakeholder Needs).
2. **Is there a written list of testable requirements?** If no → 6.4.2 (Requirements).
3. **Is there an architecture diagram or ADR set?** If no → 6.4.3 (Architecture).
4. **Is the system running in production?** If yes → 6.4.9 (Operation) or 6.4.10 (Maintenance), depending on whether there's an active incident.

---

## The 15288 philosophy in three lines

- **The lifecycle is iterative, not waterfall.** A verification failure sends you back to requirements. An operational incident triggers maintenance. Don't treat the phases as a Gantt chart.
- **Verification ≠ Validation.** Verification asks "did we build the system right?" (against requirements). Validation asks "did we build the right system?" (against stakeholder needs). Both are required; they are different activities.
- **Transition, Operation, Maintenance, Disposal are not optional.** A system that's "done" at Integration is not done. ISO 15288 explicitly covers the entire lifetime of a system — including its death.
