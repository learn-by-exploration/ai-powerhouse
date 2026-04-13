# AI Travel Planner — Multi-Agent System

Plan trips that minimize **True Cost** (ticket + leave days + ground transport + insurance + every hidden fee) instead of just ticket price. Handles solo trips, multi-stop itineraries, and multi-traveler group reunions from different cities.

**Scope:** Personal travel optimizer (v1). Designed for individuals, families, and friend groups. NOT for corporate travel (which requires TMC integration, policy engines, and approval workflows).

**Data source honesty:** This system uses web search to find **indicative pricing**. Web-search prices are ranges and estimates, not bookable fares. The system cannot hold inventory, issue tickets, or guarantee prices. All prices should be verified on the airline's website before booking.

## Trigger Conditions

Activate this skill when the user asks to:
- Plan a trip, flight, or vacation
- Find cheap flights or optimize travel dates
- Compare travel options with leave/PTO cost
- Plan group travel from multiple origin cities
- Search for multi-city or open-jaw flights

**Keywords:** trip, flight, travel, vacation, holiday, PTO, leave days, true cost, golden week, open jaw, multi-city, group travel

## System Architecture

```
User Request (natural language)
    │
    ▼
┌──────────────────────────────────────────────┐
│  travel-planner-orchestrator                  │
│  (parses request → dispatches agents →        │
│   collects results → presents ranked plans)   │
└──────────┬───────────────────────────────────┘
           │
     ┌─────┴─────────────────────────────────┐
     │  Phase 1: PARALLEL (independent)       │
     │  ┌─────────────┐  ┌────────────────┐  │
     │  │ tp-calendar  │  │   tp-visa      │  │
     │  │ (date windows│  │ (requirements, │  │
     │  │  + leave     │  │  processing    │  │
     │  │  cost)       │  │  time, fees)   │  │
     │  └──────┬──────┘  └───────┬────────┘  │
     └─────────┴─────────────────┴────────────┘
               │
          ★ GATE 1 ★  Feasibility check
               │
     ┌─────────┴─────────────────────────────┐
     │  Phase 2: flight-agent (fan-out)       │
     │  ┌─────────────────────────────────┐   │
     │  │ tp-flight                        │   │
     │  │ (search ALL legs × ALL windows   │   │
     │  │  × multiple sources in parallel) │   │
     │  └──────────────┬──────────────────┘   │
     └─────────────────┴─────────────────────┘
               │
     ┌─────────┴─────────────────────────────┐
     │  Phase 3: PARALLEL (need flights)      │
     │  ┌───────────────┐ ┌────────────────┐ │
     │  │tp-convergence │ │tp-accommodation│ │
     │  │(multi-origin  │ │(hotels per     │ │
     │  │ meeting point)│ │ sub-stop)      │ │
     │  └──────┬────────┘ └──────┬─────────┘ │
     └─────────┴─────────────────┴────────────┘
               │
     ┌─────────┴─────────────────────────────┐
     │  Phase 4: SEQUENTIAL                   │
     │  ┌─────────────────────────────────┐   │
     │  │ tp-transport                     │   │
     │  │ (airport transfers, inter-city   │   │
     │  │  ground transport, cab/train)    │   │
     │  └────────────────┬────────────────┘   │
     └───────────────────┴────────────────────┘
               │
     ┌─────────┴─────────────────────────────┐
     │  Phase 5: SEQUENTIAL                   │
     │  ┌─────────────────────────────────┐   │
     │  │ tp-optimizer                     │   │
     │  │ (True Cost calculation,          │   │
     │  │  ranking, plan generation)       │   │
     │  └────────────────┬────────────────┘   │
     └───────────────────┴────────────────────┘
               │
     ┌─────────┴─────────────────────────────┐
     │  Phase 6: PARALLEL (per-price)         │
     │  ┌─────────────────────────────────┐   │
     │  │ tp-verifier                      │   │
     │  │ (cross-source price validation,  │   │
     │  │  confidence scoring, stale check)│   │
     │  └────────────────┬────────────────┘   │
     └───────────────────┴────────────────────┘
               │
          ★ GATE 2 ★  Human review
               │
          BOOKING LINKS + ACTION ITEMS
```

## How to Use

### Basic Solo Trip
```
Plan a trip from Tokyo (NRT/HND) to Pune (PNQ) or Mumbai (BOM).
Depart April 28 evening, return May 10-11 arriving before noon.
My leave costs ¥20,000/day. I can WFH on Tuesdays and Fridays.
Max 20h travel time, max 1-2 stops.
```

### Multi-Stop Trip
```
Plan: Tokyo → Mumbai → Pune (5 days) → Goa (2 days) → Delhi → Tokyo
Depart April 28, return May 10.
Leave cost: ¥20,000/day, WFH: Tue/Fri.
```

### Multi-Traveler Group Trip
```
Plan a group trip to Pune for Golden Week 2026:
- Shyam: from Tokyo, leave costs ¥20,000/day
- Priya: from Tokyo, leave costs ¥18,000/day
- Raj: from Osaka, leave costs ¥22,000/day
- Anita: from Singapore, leave costs S$300/day
Everyone should arrive Mumbai by noon Apr 29, depart May 10.
```

## Data Sources (Priority Order)

1. **Airline direct websites** — most reliable single source (jal.co.jp, ana.co.jp, singaporeair.com, qatarairways.com)
2. **Google Flights** — best for price discovery and date flexibility (via web search)
3. **Kayak / Skyscanner** — useful for comparison, but **shares GDS backends with Google Flights** — agreement is NOT independent confirmation
4. **Aggregators (Trip.com, Expedia)** — often stale or promotional prices. ALWAYS verify against airline direct before recommending.

**Future API integration (not yet implemented):**
- SerpAPI Google Flights ($50/mo) — structured price data
- Amadeus Self-Service (free tier) — real GDS data
- Duffel (pay-per-booking) — NDC booking
- Kiwi/Tequila — creative routings, virtual interlining

**Important limitation:** Without API access, the system operates in the **information layer** (price discovery and optimization) but not the **transaction layer** (fare holding, ticketing, booking). A price on a screen is not a seat on a plane.

## True Cost Formula

```
True Cost = Σ(all components below)

  + flight_price          (ticket cost, all legs)
  + ground_transport      (cab/train between cities)
  + airport_transfer      (NEx, taxi, shuttle to/from airport)
  + accommodation         (hotels per sub-stop, if multi-day)
  + travel_insurance      (per-trip policy)
  + checked_bags          (if not included in fare — per-carrier, per-fare-class)
  + seat_selection        (if desired — per-carrier)
  + meals_inflight        (if not included — budget carriers)
  + visa_fees             (if applicable)
  + leave_cost            (leave_days_taken × daily_rate)
  + disruption_cost       (for split tickets: P(disruption) × rebooking_cost)
  + fx_fees               (1.5-3.5% for cross-currency bookings)

  Miles earned shown as INFORMATIONAL line item (NOT subtracted — value varies ¥1-15/mile depending on redemption)
```

Each component carries a **confidence score**:
- **HIGH**: 3+ sources agree within ±5% → proceed
- **MEDIUM**: 2 sources agree within ±10% → proceed with warning
- **LOW**: single source only → BLOCKS plan from being recommended

## Agent List

| Agent | File | Purpose |
|-------|------|---------|
| `travel-planner-orchestrator` | `tp-orchestrator.md` | Parses request, dispatches agents, assembles final output |
| `tp-calendar` | `tp-calendar.md` | Work calendar analysis, holiday detection, leave day calculation |
| `tp-visa` | `tp-visa.md` | Visa requirements, processing times, transit visa detection |
| `tp-flight` | `tp-flight.md` | Flight search across multiple sources with multi-city support |
| `tp-accommodation` | `tp-accommodation.md` | Hotel/accommodation search per sub-stop |
| `tp-transport` | `tp-transport.md` | Ground transport between cities, airport transfers |
| `tp-convergence` | `tp-convergence.md` | Multi-traveler meeting point optimization |
| `tp-optimizer` | `tp-optimizer.md` | True Cost calculation, plan ranking, strategy selection |
| `tp-verifier` | `tp-verifier.md` | Cross-source price verification, confidence scoring |

## Key Design Decisions

### Why agents call web search, NOT flight APIs directly
Claude Code agents can't make HTTP API calls to SerpAPI/Amadeus directly. Instead, each agent uses **web search tools** (Exa, fetch_webpage) to query Google Flights, Kayak, airline websites, and fare aggregators. The agents parse the results and extract structured pricing data.

### Verification prevents the ¥158K→¥317K disaster
In our manual planning session, ANA was quoted at ¥158,560 RT from a single cached source. The actual price was ¥317,060 — a 100% error. The verifier-agent now requires 2+ sources with ±10% agreement before marking a price as usable.

### Leave days are the biggest cost lever
At ¥20,000/day, moving departure from Friday to Tuesday saved ¥60,000 — more than any routing optimization. The calendar-agent runs first specifically so the optimizer can evaluate date flexibility as its primary ranking signal.

### Multi-city booking is always searched
Open-jaw booking (NRT→BOM / PNQ→HND) saved ¥7,000 + 2.5 hours vs round-trip to the same airport. The flight-agent always searches round-trip, multi-city, AND open-jaw for every route, so the optimizer can compare strategies automatically.

## Travel Hack Detectors

The flight-agent incorporates these optimization strategies:

| Hack | Description | When to Apply |
|------|-------------|---------------|
| **open_jaw** | Fly into one airport, out of another (single PNR) | Different arrival/departure cities |
| **date_flex** | Shift departure ±1-3 days (±7 for peak season) | When leave cost per day is high |
| **positioning** | Depart from cheaper nearby airport | Multiple airports in origin metro |
| **split_ticket** | Two one-ways across different airlines | When RT pricing is inflated. **⚠️ MUST include disruption cost warning** |
| **evening_departure** | Depart after work to save a leave day | When departure day is a workday |
| **ex_india_pricing** | Book same itinerary from Indian POS for 20-40% savings | Japan→India routes (largest single savings) |
| **fifth_freedom** | Airlines flying between two foreign countries | Ethiopian NRT→ICN→ADD, SQ routes |
| **stopover_program** | Free 1-3 day stopover at hub | Qatar (DOH), Emirates (DXB), SQ (SIN), Turkish (IST) |
| **multimodal** | Replace short flight with train/bus | When cities are <4h by ground |
| **advance_purchase** | Book 21-55+ days ahead for deepest discounts | ANA Super Value, JAL Special Saver |
| **midweek_departure** | Fly Tue/Wed for lower-demand pricing | When schedule allows |

## Supporting Files

| File | Purpose |
|------|---------|
| [data-model.md](data-model.md) | All data types: TripRequest, TrueCost, FlightResults, PlanCandidate, VerificationReport |
| [examples/solo-round-trip.yaml](examples/solo-round-trip.yaml) | Example: Tokyo → Pune for Diwali (solo, family stay) |
| [examples/multi-stop-tour.yaml](examples/multi-stop-tour.yaml) | Example: Tokyo → Mumbai → Pune → Goa → Delhi → Tokyo |
| [examples/multi-traveler-group.yaml](examples/multi-traveler-group.yaml) | Example: 4 friends from Tokyo, Singapore, Bangalore → Bali |

## Requirements Spec

Full requirements document with 14 user stories, edge cases, and acceptance criteria:
[docs/specs/ai-travel-planner-requirements.md](/home/shyam/synclyf/docs/specs/ai-travel-planner-requirements.md)
