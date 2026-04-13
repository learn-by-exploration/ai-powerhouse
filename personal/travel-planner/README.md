# Travel Planner — Multi-Agent System

Personal travel optimizer using a 9-agent architecture for True Cost flight planning on Japan↔India routes.

## Structure

```
agents/          9 specialist agents (Claude Code agent definitions)
  tp-orchestrator.md   Master dispatcher — routes to all agents
  tp-flight.md         Flight search + hack detection
  tp-optimizer.md      True Cost calculator + plan ranker
  tp-verifier.md       Price verification + confidence scoring
  tp-visa.md           Visa/passport/document checks
  tp-calendar.md       Work calendar + leave cost analysis
  tp-transport.md      Ground transport specialist
  tp-accommodation.md  Accommodation for multi-stop trips
  tp-convergence.md    Multi-traveler meeting point optimizer

skill/           Skill definition + shared data model
  SKILL.md             Entry point — triggers, scope, data sources
  data-model.md        Type definitions shared by all agents
  examples/            Sample trip configurations (YAML)
```

## Usage

Copy agents to `.claude/agents/travel-planner/` and skill to `.claude/skills/travel-planner/` in any Claude Code project.

Trigger: "plan a trip", "find flights", "optimize travel".

## Key Features

- **True Cost formula**: Base fare + ancillaries + opportunity cost + disruption risk + FX fees
- **9 travel hack detectors**: ex-India pricing, fifth freedom flights, stopover programs, split tickets, etc.
- **Practical MCT table**: Real-world minimum connection times for DEL, BOM, NRT, HND, SIN, DOH, DXB
- **Passport/visa pre-validation**: Step 0 checks before any flight search
- **Multi-traveler convergence**: Booking state machine for group coordination
