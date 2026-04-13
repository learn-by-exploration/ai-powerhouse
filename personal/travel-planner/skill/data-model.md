# AI Travel Planner — Data Model Reference

## Core Types

### Money
All monetary values use this format:
```yaml
money:
  amount: number          # Always in smallest practical unit (¥1, $1, ₹1)
  currency: string        # ISO 4217: JPY, USD, INR, SGD, EUR, GBP, etc.
```

### DateTime
All timestamps in ISO 8601 with timezone:
```
"2026-04-28T21:00:00+09:00"    # 9PM JST
"2026-04-29T08:30:00+05:30"    # 8:30AM IST
```

### Confidence
```yaml
confidence: "HIGH" | "MEDIUM" | "LOW" | "ESTIMATED" | "STALE" | "RANGE"

# Rules:
# HIGH:      3+ truly independent sources agree within ±5% (meta-search agreement is NOT independent — same GDS backend)
# MEDIUM:    2 sources agree within ±10%, OR airline direct quote alone
# LOW:       1 non-airline source only → BLOCKS recommendation
# ESTIMATED: Calculated from known ranges, not real-time data
# STALE:     Was HIGH/MEDIUM but data is >30 minutes old (display) or >10 minutes old (booking decision)
# RANGE:     Web search data only — presented as a range, not a fact
```

---

## TripRequest (Input)

The top-level input structure provided by the user (parsed by orchestrator):

```yaml
trip_request:
  # Who is traveling
  travelers:
    - name: string
      origin_city: string
      origin_airports: string[]        # IATA codes
      passport_nationality: string     # For visa checks      passport_expiry_date: date        # REQUIRED — 6-month validity check
      ecnr_status: string               # For Indian passports: "ECR" | "ECNR"      residence_country: string        # May differ from passport
      calendar:
        country_holidays: string       # Country code for public holiday lookup
        wfh_days: weekday[]            # Days the traveler can work from home
        leave_cost_per_day: Money      # Opportunity cost of 1 leave day
        work_hours: string             # "09:00-18:00" default
      preferences:
        max_travel_hours: number       # Total door-to-door, default 24
        max_stops: number              # Per leg, default 2
        preferred_airlines: string[]   # Optional whitelist
        avoided_airlines: string[]     # Optional blacklist
        cabin_class: string            # economy | premium_economy | business | first
        miles_programs:
          - program: string            # "JAL Mileage Bank"
            balance: number            # Current miles balance (optional)
            tier: string               # "regular" | "silver" | "gold" | "diamond"
      budget:
        max_true_cost: Money           # Hard cap on True Cost
        max_ticket_price: Money        # Hard cap on flight ticket alone

  # Where to go (ordered sequence)
  destinations:
    - city: string
      country: string
      airports: string[]               # IATA codes
      arrival_window:
        earliest: datetime
        latest: datetime
      departure_window:
        earliest: datetime
        latest: datetime
      purpose: string                  # meetup | transit | sightseeing | family | work
      min_nights: number
      max_nights: number
      accommodation_needed: boolean    # false if staying with family/friends
      ground_transport_to_next:
        preferred_mode: string         # flight | train | bus | cab | any
        max_hours: number

  # Group-wide settings
  constraints:
    group_must_arrive_together: boolean
    max_arrival_spread_hours: number
    booking_strategy: string           # individual | group | flexible
    date_flexibility_days: number      # ±N days around target dates
    trip_name: string                  # Human-friendly name for the trip
```

---

## Agent Output Types

### CalendarAnalysis (from tp-calendar)
```yaml
calendar_analysis:
  holidays_found:
    - country: string
      holidays:
        - date: date
          name: string
          type: string                 # national | bank | regional

  date_windows:
    - id: string                       # W1, W2, ...
      depart_date: date
      depart_day_of_week: string
      return_date: date
      return_day_of_week: string
      per_traveler:
        - name: string
          total_days_away: number
          weekend_days: number
          holidays: number
          wfh_days_saved: number
          leave_days_needed: number
          leave_cost: Money
          notes: string

  recommendations:
    best_window: string                # Window ID
    reason: string
    date_sensitivity: string           # LOW | MEDIUM | HIGH
```

### VisaAnalysis (from tp-visa)
```yaml
visa_analysis:
  travelers:
    - name: string
      passport: string
      destination_visas:
        - country: string
          required: boolean
          type: string                 # e-visa | visa_on_arrival | embassy | none
          processing_time_days: number
          fee: Money
          feasibility: string          # OK | WARNING | BLOCKER
      transit_visas:
        - hub: string                  # Airport code
          required: boolean
          type: string
          fee: Money
          note: string

  blockers: string[]                   # Empty = no blockers
  warnings: string[]
  total_visa_fees:
    - name: string
      total: Money
```

### FlightResults (from tp-flight)
```yaml
flight_results:
  search_timestamp: datetime

  routes:
    - leg_id: string
      traveler: string
      options:
        - id: string                   # F1, F2, ...
          strategy: string             # round_trip | multi_city | split_one_way
          airline: string
          operating_airline: string     # If different from marketing airline
          flight_numbers: string[]
          origin: string               # IATA code
          destination: string
          depart: datetime
          arrive: datetime
          stops: number
          stop_airports: string[]
          layover_durations: string[]
          total_travel_hours: number
          cabin_class: string
          fare_class: string              # RBD: Y, B, M, H, V, L, etc.
          fare_basis_code: string         # Full fare basis code (e.g., VLXJPIN)
          fare_rules:
            cancellation:
              free_period_hours: number   # e.g., 24 (US DOT rule)
              fee_tiers:                  # [{before_hours: 72, fee: 25000}, {before_hours: 0, fee: 40000}]
                - before_hours: number
                  fee: number
              refund_type: string         # cash | credit | voucher | none
            change:
              fee_tiers:
                - before_hours: number
                  fee: number
              routing_change: boolean
              name_change: boolean
            no_show: string               # forfeit | fee
            min_stay_nights: number
            max_stay_days: number
            advance_purchase_days: number
          fare_decomposition:
            base_fare: number
            taxes: number
            yq_surcharge: number          # Fuel/carrier surcharge
            yr_surcharge: number          # Carrier-imposed surcharge
            booking_fee: number           # OTA/agent markup
          ticketing_deadline: datetime    # TTL — book by this time or fare expires
          booking_protection_level: string # FULL | PARTIAL | NONE
          baggage_included: boolean
          baggage_weight_kg: number     # If included
          miles_program: string
          miles_earned: number
          price: Money
          source: string
          source_url: string
          searched_at: datetime
          confidence: Confidence
          price_notes: string
          hacks_applied:
            - type: string
              savings_estimate: Money
              note: string

  summary:
    cheapest_ticket: string
    shortest_travel: string
    best_schedule: string
    most_miles: string

  warnings: string[]
```

### TransportResults (from tp-transport)
```yaml
transport_results:
  segments:
    - segment_id: string
      origin: string
      destination: string
      options:
        - id: string                   # TR1, TR2, ...
          mode: string                 # cab | train | bus | shuttle | metro | walk
          provider: string
          estimated_cost: Money
          travel_time: string
          per_person_if_shared: Money
          travelers_sharing: number
          comfort: string              # LOW | MEDIUM | HIGH
          luggage_capacity: string
          availability: string
          booking_method: string
          confidence: Confidence
          notes: string

  total_transport_cost:
    cheapest: Money
    recommended: Money
```

### ConvergenceAnalysis (from tp-convergence)
```yaml
convergence_analysis:
  hub_options:
    - hub: string                      # Airport code
      hub_name: string
      arrival_window:
        first_arrival: datetime
        last_arrival: datetime
        spread_hours: number
      per_traveler_arrivals:
        - name: string
          flight: string
          arrives: datetime
          price: Money
          wait_hours: number
      total_person_wait_hours: number
      group_transport:
        mode: string
        cost: Money
        time: string
        per_person: Money
      convergence_score: number        # 0-10
      total_flight_cost: string

  recommendation:
    best_hub: string
    reason: string

  meeting_plan:
    hub_airport: string
    meeting_point: string
    first_to_arrive: string
    last_to_arrive: string
    departure_to_destination: datetime
```

### TrueCost (calculated by tp-optimizer)
```yaml
true_cost:
  traveler: string
  components:
    flight_price:       { value: Money, confidence: Confidence, source: string }
    ground_transport:   { value: Money, confidence: Confidence, source: string }
    airport_transfer:   { value: Money, confidence: Confidence, source: string }
    accommodation:      { value: Money, confidence: Confidence, source: string }
    travel_insurance:   { value: Money, confidence: Confidence, source: string }
    checked_bags:       { value: Money, confidence: Confidence, source: string }
    seat_selection:     { value: Money, confidence: Confidence, source: string }
    meals_inflight:     { value: Money, confidence: Confidence, source: string }
    visa_fees:          { value: Money, confidence: Confidence, source: string }
    leave_cost:         { value: Money, confidence: Confidence, source: string }
    disruption_cost:    { value: Money, confidence: Confidence, source: string }  # For split tickets: P(disruption) × rebooking_cost
    fx_fees:            { value: Money, confidence: Confidence, source: string }  # 1.5-3.5% for cross-currency bookings
    miles_earned:       { value: number, unit: "miles", note: string }            # INFORMATIONAL ONLY — NOT subtracted from total
  total: Money
  booking_protection_level: string    # FULL | PARTIAL | NONE
  overall_confidence: Confidence       # Lowest confidence among all components
```

### PlanCandidate (final output from tp-optimizer)
```yaml
plan:
  rank: number
  plan_id: string
  nickname: string
  composite_score: number              # 0-100
  scores:
    cost: number
    convenience: number
    time: number
    reliability: number
  itinerary:
    legs:
      - leg_id: string
        type: string                   # outbound | return | internal | ground
        flight: FlightOption           # If air leg
        ground: TransportOption        # If ground leg
        accommodation: AccommodationOption  # If overnight
  booking_protection_level: string     # FULL | PARTIAL | NONE (worst across all legs)
  disruption_risk: string              # LOW | MEDIUM | HIGH (based on split tickets, tight connections, monsoon)
  true_cost_breakdown:
    per_traveler: TrueCost[]
    group_total: Money
  warnings: string[]
  action_items: string[]
  booking_links:
    - source: string
      url: string
      note: string
  verification_status: string          # VERIFIED | PENDING | STALE
```

### VerificationReport (from tp-verifier)
```yaml
verification_report:
  verified_at: datetime
  prices_verified:
    - item: string
      original_price: Money
      original_source: string
      verification_source: string
      verified_price: Money
      price_change: string             # "+1.8%" or "-5%"
      confidence: Confidence
      constraint_check:
        total_travel_hours: { value: number, max: number, status: string }
        layover_minimum: { value: string, status: string }
      status: string                   # VERIFIED | KILLED | STALE
      reason: string                   # If killed, why

  summary:
    total_verified: number
    high: number
    medium: number
    low: number
    killed: number

  plans_affected:
    - plan: string
      original_true_cost: Money
      verified_true_cost: Money
      change: string
      recommendation: string

  final_ranking_changes: string[]
  action_items:
    - priority: string                 # HIGH | MEDIUM | LOW
      action: string
```
