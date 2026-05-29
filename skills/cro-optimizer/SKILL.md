---
name: cro-optimizer
description: "CRO specialist that pulls live analytics data from Humblytics API, analyzes conversion funnels, identifies drop-off points, and generates prioritized A/B test hypotheses. Use when analyzing conversion rates, diagnosing funnel leaks, optimizing signup flows, or creating test roadmaps. Triggers: CRO, conversion rate, funnel analysis, drop-off, optimize conversions, test hypothesis."
metadata:
  version: 1.0.0
  author: Humblytics
---

# CRO Optimizer

## Purpose

Analyze conversion funnels using live Humblytics analytics data, identify the highest-impact drop-off points, and generate prioritized A/B test hypotheses with expected conversion-rate / volume impact. This skill turns raw analytics into a ranked optimization roadmap.

## When to Use

- Diagnosing why a funnel is underperforming
- Identifying the biggest conversion bottleneck across a user journey
- Generating a prioritized list of A/B test ideas
- Preparing a CRO sprint plan or quarterly optimization roadmap
- Analyzing page-level or step-level drop-off rates
- Comparing conversion performance across segments (device, source, geography)

## Credentials

This skill reads a Humblytics API key from the environment. **Never paste API keys directly into chat** — they persist in transcripts and logs.

Setup (one time):
1. `cp .env.example .env` at the repo root and fill in `HUMBLYTICS_API_KEY`
2. `source .env` in your shell before running the agent (or use `direnv`, or add the exports to your shell profile)
3. Get the key from Humblytics Dashboard > Settings > API
4. The skill will ask for your **Property ID** (also in Dashboard > Settings > API)

- **Base URL**: `https://app.humblytics.com/api/external/v1`
- **Docs**: https://docs.humblytics.com/api

If `HUMBLYTICS_API_KEY` is not in the environment, stop and point the user at `.env.example` — do not accept the key in chat.

## Before You Start

1. **Confirm the property ID** — Ask the user which Humblytics property to analyze
2. **Identify the funnel** — Clarify which conversion flow to examine (e.g., homepage > pricing > signup > onboarding)
3. **Check for context** — Look for existing project docs, AGENTS.md, or product briefs that describe the business model, target audience, and current conversion goals
4. **Establish the time range** — Default to last 30 days; ask if the user wants a different window
5. **Confirm API access** — Verify `HUMBLYTICS_API_KEY` is available as an environment variable

## Core Workflow

### Step 1: Pull Funnel Data

Retrieve analytics data from the Humblytics API:

- **Page views and sessions** for each step in the funnel
- **Event data** for key conversion actions (signups, clicks, form submissions)
- **Device and source breakdowns** to identify segment-specific issues
- **Scroll depth via `pages/details`** and **click density via `clicks/details`** (no `/heatmaps` endpoint exists) for high-traffic pages

Use the Humblytics public API endpoints. All sit under base `/api/external/v1/` and take `start`, `end`, `timezone` query params:

- `GET /properties/{propertyId}/pages/breakdown` — Page-level traffic across the site
- `GET /properties/{propertyId}/pages/details?page=/path` — Single-page deep dive (UTM, device, country breakdowns, scroll depth)
- `GET /properties/{propertyId}/funnels?steps={JSON}` — Funnel step data; the `steps` param is a JSON array describing each step. Optional: `mode=unbounded|sequential`, `breakdownBy`
- `GET /properties/{propertyId}/funnels/sankey?steps={JSON}` — Sankey path diagram for the same funnel

> **Fallback when funnels are down.** `funnels` and `funnels/sankey` currently return HTTP 500 (verified live 2026-05-29). If they return 500 (or otherwise fail), approximate the funnel from the endpoints that do work: pull per-step page volume from `pages/breakdown` (and `funnels/suggestions?page=/path` for the ranked next-page sequence), and pull conversion-event volume for the final step(s) from `forms/breakdown`. Compute step-to-step conversion / drop-off from these `unique_sessions` (pages) and submission counts (forms). Note in your output that the funnel is an approximation from page + form breakdowns because the native funnel endpoint was unavailable.
- `GET /properties/{propertyId}/forms/breakdown` and `forms/details?page=/path` — Form/conversion event data (the public API doesn't expose a generic `events` endpoint)
- `GET /properties/{propertyId}/clicks/details?page=/path` — Click heatmap data for a specific page (no top-level `/heatmaps` endpoint exists; click data is the closest analogue)
- `GET /properties/{propertyId}/clicks/breakdown` — Cross-page click comparison

### Step 2: Map the Funnel

Build a complete picture of the user journey:

```
Traffic Source → Landing Page → Key Action → Conversion → Retention
```

For each step, calculate:
- **Volume**: How many users reach this step
- **Conversion rate**: Percentage who proceed to the next step
- **Drop-off rate**: Percentage who abandon at this step
- **Absolute drop-off**: Raw number of users lost

### Step 3: Identify the Biggest Leak

Apply the **Largest Leak First** principle:

1. Calculate the absolute number of users lost at each step
2. Rank steps by absolute drop-off (not percentage)
3. The step losing the most users in absolute terms is your highest-priority optimization target

Why absolute over percentage: A 50% drop-off at a step with 100 visitors loses 50 people. A 10% drop-off at a step with 10,000 visitors loses 1,000 people. Fix the 1,000-person leak first.

### Step 4: Diagnose Root Causes

For each high-drop-off step, investigate:

- **Page load time** — Slow pages kill conversions. Check if the step has performance issues.
- **Mobile vs desktop** — Is the drop-off concentrated on mobile? Layout/UX issue.
- **Traffic source** — Do certain acquisition channels show higher drop-off? Expectation mismatch.
- **Scroll depth** — Are users seeing the CTA? Check scroll depth via `pages/details` and click density via `clicks/details` (no `/heatmaps` endpoint exists).
- **Click patterns** — Are users clicking non-interactive elements? Confusing UI.
- **Form fields** — For forms, which field has the highest abandonment rate?

When the leak appears concentrated in **paid traffic** (drop-off significantly worse for `utm_source=google` or `utm_source=facebook` than for organic), pull `GET /api/v1/properties/{propertyId}/ads-attribution?startDate=&endDate=` to see which specific campaigns are landing on the underperforming page. A creative/landing-page mismatch on one campaign can drag down a whole step's conversion rate. Hand off to `revenue-attributor` for the full ROAS picture or `ad-expert` to fix the creative.

### Step 5: Generate Test Hypotheses

For each identified issue, create a hypothesis using the ICE framework:

**Format:**
```
IF we [change], THEN [metric] will [improve/increase/decrease]
BECAUSE [evidence from data]

Impact: [1-10] — How much will this move the needle?
Confidence: [1-10] — How sure are we this will work?
Ease: [1-10] — How quickly can we implement and test this?
ICE Score: [average of three]
```

### Step 6: Prioritize and Recommend

Rank all hypotheses by ICE score and present:

1. **Top 3 Quick Wins** — High ease, decent impact (ship this week)
2. **Top 3 High-Impact Tests** — High impact, may require more effort (sprint backlog)
3. **Strategic Bets** — Lower confidence but potentially transformative (quarterly roadmap)

For each recommendation, include:
- The specific page or funnel step
- What to change and why
- Expected impact on conversion rate
- Suggested test duration based on traffic volume

## Analysis Frameworks

### The RICE Prioritization (for larger teams)

- **Reach**: How many users per month does this affect?
- **Impact**: Expected lift (minimal / low / medium / high / massive)
- **Confidence**: Data quality supporting the hypothesis (low / medium / high)
- **Effort**: Engineering/design time (days)

Score = (Reach x Impact x Confidence) / Effort

### Segment Analysis Checklist

Always break down conversion data by:
- Device type (mobile / desktop / tablet)
- Traffic source (organic / paid / direct / referral / social)
- Geography (if international)
- New vs returning visitors
- Entry page

### Common Funnel Archetypes

| Funnel Type | Key Metrics | Common Leaks |
|------------|-------------|--------------|
| SaaS Free Trial | Visit > Signup > Activate > Convert | Signup form friction, activation failure |
| E-commerce | PDP > Cart > Checkout > Purchase | Cart abandonment, checkout form |
| Lead Gen | Landing > Form > Thank You | Form length, trust signals |
| Content > Conversion | Blog > CTA > Signup | CTA visibility, relevance match |

## Output Format

Present findings as:

1. **Funnel Overview** — Visual step-by-step with volumes and rates
2. **Key Finding** — The single biggest insight in one sentence
3. **Drop-off Analysis** — Ranked list of leaks with absolute numbers
4. **Root Cause Diagnosis** — What is causing each major leak
5. **Prioritized Test Roadmap** — ICE-scored hypotheses ready for execution
6. **Expected Impact** — If top 3 tests succeed, projected conversion lift

## Related Skills

- **ab-test-generator** — Take the hypotheses from this skill and generate actual test configurations
- **funnel-reporter** — Pull comprehensive funnel reports with traffic & conversion volume (revenue only if a Stripe/ChartMogul revenue connector is attached)
- **page-cro** — Deep-dive into a specific page's conversion issues
- **copywriting** — Generate optimized copy for test variants

## Shared Frameworks (REQUIRED reading)

Before producing recommendations, anchor your analysis against the shared primitives in `skills/_shared/`. Skipping these is the #1 cause of generic, low-confidence output.

- **`_shared/frameworks/preflight-checklist.md`** — five context items to verify before scoring (URL, time range, goal, vertical, statistical reachability). If anything's missing AND would change the recommendation, ask one focused question; otherwise state assumptions explicitly.
- **`_shared/frameworks/largest-leak-first.md`** — rank by absolute people lost, not by percentage drop. A 10% drop on 10,000 visitors outranks a 50% drop on 100. Always compute absolute loss per step before applying ICE.
- **`_shared/frameworks/percentile-framing.md`** — report current metrics against vertical p25/p50/p75 bands from `_shared/benchmarks/baselines.json`. Replace "your CVR is low" with "your CVR is at p35 — meaningful headroom to p50".
- **`_shared/frameworks/ice-confidence-rubric.md`** — anchor ICE.Confidence on evidence quality, not familiarity. 9–10 = ≥2 sources with n≥1000 in target vertical; 5–6 = general best practice; 1–3 = directional hunch.
- **`_shared/frameworks/anti-patterns.md`** — counter-evidence for canon advice (customer logos LOST in most DoWhatWorks tests, "free" CTAs lose −16.8% platform-wide on Unbounce, hero video net-negative on mobile, etc.). Read before recommending the "best practice" version of any well-known pattern.
- **`_shared/frameworks/base-rate-priors.md`** — realistic priors: only ~14% of CTA tests reach significance; ~31% of headline rewrites beat control. Anchor expectations against base rates, not best-case outliers.
- **`_shared/benchmarks/patterns.json`** — 54 curated patterns with cited lift ranges, prerequisites, anti-patterns. When recommending a change, find the matching `pattern_id` and quote `evidence[].lift_range_pct` instead of guessing.
