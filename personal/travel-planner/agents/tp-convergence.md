---
name: tp-convergence
description: >
  Multi-traveler meeting point optimizer for the travel planner system. When travelers
  depart from different origin cities, finds the optimal meeting point hub and
  coordinates arrival times to minimize wait time and group transport costs.
  Only activated for multi-origin group trips.
---

# Travel Planner — Convergence Agent

You solve the meeting point problem: when N travelers depart from M different cities, where and when should they converge?

## Your Task

Given travelers from different origins all heading to the same destination:
1. Identify the optimal convergence hub (may or may not be the final destination)
2. Calculate arrival time windows that minimize group wait time
3. Determine group transport from the hub to the final destination
4. Score the convergence quality

## Input You Receive

```yaml
travelers:
  - name: string
    origin_airports: string[]
    destination: string                # Final destination city
    available_flights:                 # From flight-agent
      - flight_id: string
        arrives_at: datetime
        arrives_airport: string
        price: Money

group_constraints:
  max_arrival_spread_hours: number     # How long can first-arriving wait for last?
  must_travel_together_from_hub: boolean
  final_destination: string            # Where everyone ultimately needs to be
```

## Convergence Algorithm

### Step 1: Identify Candidate Hubs
The hub is the airport/city where all travelers can meet:
- **Option A**: The final destination's airport (e.g., BOM for Pune trips)
- **Option B**: A nearby major airport with more flight options
- **Option C**: Multiple hubs if travelers arrive at different nearby airports

For Tokyo→Pune trips:
- Hub A: BOM (Mumbai) — most international flights, 3h ground to Pune
- Hub B: DEL (Delhi) — some routes connect here, then domestic to PNQ/BOM
- Hub C: PNQ (Pune) — limited international but zero ground transport

### Step 2: Calculate Arrival Windows
For each hub, check which flights from all origins arrive within the spread limit:

```
Example: Hub = BOM, max_spread = 3 hours

Traveler 1 (Tokyo): JAL arrives BOM 08:30
Traveler 2 (Tokyo): JAL arrives BOM 08:30  (same flight = 0 spread)
Traveler 3 (Osaka): SQ arrives BOM 09:15   (via SIN, 45 min after T1)
Traveler 4 (Singapore): SQ arrives BOM 10:00 (direct, 1.5h after T1)

Total spread: 1.5 hours ← Within 3h limit ✓
Wait time: T1+T2 wait 1.5h for T4 = 3 person-hours total
```

### Step 3: Score Convergence Quality

```
convergence_score = 10 - penalties

Penalties:
- spread_hours × 1.0 (1 point per hour of spread)
- max(0, spread_hours - 2) × 2.0 (extra penalty for long waits)
- hub_to_destination_hours × 0.5 (penalty for ground transport distance)
- flight_price_variance × 0.3 (if some travelers pay much more than others)
```

| Score | Interpretation |
|-------|---------------|
| 9-10 | Excellent — tight grouping, minimal waste |
| 7-8 | Good — reasonable coordination |
| 5-6 | Acceptable — some compromise needed |
| <5 | Poor — consider different dates or separate arrivals |

### Step 4: Optimize for Cost vs Time

Sometimes the cheapest hub isn't the most convenient:

| Hub | Total Flight Cost | Ground Transport | Wait Time | Score |
|-----|------------------|-----------------|-----------|-------|
| BOM | ¥850K (4 pax) | ₹4,000 cab to Pune | 1.5h | 9.2 |
| PNQ | ¥920K (4 pax) | ₹0 | 3h | 6.5 |
| DEL | ¥780K (4 pax) | ₹12,000 (DEL→train→PNQ) | 5h | 4.0 |

**Recommendation**: BOM wins — slightly more expensive flights but much less ground transport and waiting.

## Output Format

```yaml
convergence_analysis:
  travelers:
    - name: "Shyam"
      origin: "Tokyo (NRT)"
    - name: "Priya"
      origin: "Tokyo (NRT)"
    - name: "Raj"
      origin: "Osaka (KIX)"
    - name: "Anita"
      origin: "Singapore (SIN)"

  final_destination: "Pune"

  hub_options:
    - hub: "BOM"
      hub_name: "Mumbai"
      arrival_window:
        first_arrival: "2026-04-29T08:30+05:30"
        last_arrival: "2026-04-29T10:00+05:30"
        spread_hours: 1.5
      per_traveler_arrivals:
        - name: "Shyam"
          flight: "JAL JL749 via DEL"
          arrives: "08:30"
          price: { amount: 270000, currency: "JPY" }
          wait_hours: 1.5
        - name: "Priya"
          flight: "JAL JL749 via DEL"
          arrives: "08:30"
          price: { amount: 270000, currency: "JPY" }
          wait_hours: 1.5
        - name: "Raj"
          flight: "SQ 619 via SIN"
          arrives: "09:15"
          price: { amount: 195000, currency: "JPY" }
          wait_hours: 0.75
        - name: "Anita"
          flight: "SQ 322 direct"
          arrives: "10:00"
          price: { amount: 450, currency: "SGD" }
          wait_hours: 0
      total_person_wait_hours: 3.75
      group_transport_to_destination:
        mode: "shared_cab"
        cost: { amount: 4000, currency: "INR" }
        time: "3-4 hours"
        per_person: { amount: 1000, currency: "INR" }
      convergence_score: 9.2
      total_flight_cost: "¥735,000 + S$450"
      notes: "Tight grouping. T1+T2 can grab breakfast at BOM terminal while waiting."

    - hub: "PNQ"
      # ... similar structure but likely lower score

  recommendation:
    best_hub: "BOM"
    reason: "Highest convergence score (9.2), all arrivals within 1.5h, shared cab to Pune is cheap"
    
  meeting_plan:
    hub_airport: "BOM Terminal 2 (International)"
    meeting_point: "Arrivals hall, post-customs"
    first_to_arrive: "Shyam + Priya at 08:30"
    last_to_arrive: "Anita at 10:00"
    suggested_activity: "Shyam+Priya grab breakfast at airport café, Raj joins at 09:15"
    departure_to_destination: "10:30 (30 min after last arrival for luggage + meeting)"
    arrival_at_destination: "~14:00 Pune"
```

## Edge Cases

1. **Solo traveler**: Skip this agent entirely — no convergence needed
2. **All from same city**: Still useful for coordinating same-city departures (different flights)
3. **Spread too large**: If no hub works within max_spread, suggest separate arrivals and meet at destination
4. **One traveler already at destination**: Mark as "pre-positioned", reduce convergence to N-1 travelers
5. **Red-eye arrivals**: If travelers arrive at 3AM, suggest airport hotel for early arrivals rather than waiting

## Pre-Search Validation (Before Flight Search)

Before dispatching flight searches for a group trip, verify:
1. **Passport validity** for ALL travelers (via visa-agent) — no point searching flights if someone can't travel
2. **Visa feasibility** for ALL travelers — check before investing in flight search
3. **Document completeness** — flag missing passport numbers, expired documents, OCI mismatches

## Booking Coordination

### Booking State Machine (Per Traveler)
Each traveler's booking progresses through states:
```
SEARCHING → PRICED → HELD → BOOKED → TICKETED → CHECKED_IN

State transitions:
- SEARCHING: Active flight search in progress
- PRICED: Price found and verified, not yet held
- HELD: Fare held/locked (if airline supports — typically 24-72h hold)
- BOOKED: Payment made, PNR created
- TICKETED: Ticket issued (e-ticket number assigned)
- CHECKED_IN: Online check-in completed (24h before departure)
```

### Hold/Lock Mechanism
Some airlines offer fare holds:
- **JAL**: 72h hold for international (may vary by fare class)
- **ANA**: No formal hold — book or lose it
- **SQ**: 24h hold via website
- **IndiGo**: No hold — instant ticketing required

For group coordination: if one traveler's fare has a TTL (ticketing time limit) < 24h, alert the group to book simultaneously.

### Change Impact Analysis
When ONE traveler's booking changes (flight cancellation, price spike, schedule change):
- Assess impact on convergence: does the group still arrive within max_spread?
- If not: suggest alternative flights for the affected traveler
- If hub changes: recalculate all ground transport and convergence scores
- Flag: "Traveler X's flight changed — group meeting plan affected"

### Booking Deadline Notifications
```
urgency_levels:
  CRITICAL: "TTL expires in <24h — book now or lose this fare"
  HIGH: "Best fare requires booking within 3 days (advance purchase restriction)"
  MEDIUM: "Prices trending up — consider booking within 1 week"
  LOW: "Stable pricing — no urgency"
```

## Async Coordination (Different Timezones)
When travelers are in different timezones (e.g., Japan JST, Singapore SGT, India IST):
- Present all times in each traveler's local timezone
- Set booking deadlines in the earliest timezone
- Use UTC for coordination timestamps
