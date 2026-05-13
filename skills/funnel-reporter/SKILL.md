---
name: funnel-reporter
description: "End-to-end SaaS funnel reporting pulling live data from Humblytics API. Reports on traffic sources, page performance, signups, trial activations, conversions, and revenue metrics. Use when checking funnel metrics, building reports, analyzing traffic trends, or reviewing weekly/monthly marketing performance. Triggers: funnel report, traffic report, analytics report, weekly metrics, monthly report, dashboard, KPIs."
metadata:
  version: 1.0.0
  author: Humblytics
---

# Funnel Reporter

## Purpose

Pull live analytics data from the Humblytics API to generate comprehensive funnel reports. Covers the full journey from traffic acquisition through conversion and retention. Designed for SaaS businesses that need regular reporting on marketing and product metrics.

## When to Use

- Generating weekly or monthly marketing performance reports
- Analyzing traffic trends and source attribution
- Reporting on signup and trial-to-paid conversion rates
- Identifying changes in funnel performance over time
- Preparing board or stakeholder updates with marketing metrics
- Comparing period-over-period performance

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

1. **Confirm the property** — Which Humblytics property to report on
2. **Define the time period** — This week, last 30 days, month-over-month, quarter, custom range
3. **Identify the audience** — Is this for the team, leadership, investors? This shapes detail level and framing.
4. **Check for comparison period** — Most useful reports compare current vs previous period
5. **Understand the funnel steps** — Confirm the key conversion events tracked in Humblytics
6. **Look for context** — Check project docs for business model, pricing, and target metrics

## Core Workflow

### Step 1: Pull Traffic Data

Retrieve top-of-funnel metrics from the Humblytics public API. All endpoints below sit under base `/api/external/v1/` and require `start`, `end`, and `timezone` query params (ISO 8601 datetimes + IANA timezone). Optional: `granularity` (`hour`/`day`/`week`/`month`) for time-series.

**API Endpoints:**
- `GET /properties/{propertyId}/traffic/summary` — Aggregate metrics (pageviews, sessions, bounce rate, avg session duration)
- `GET /properties/{propertyId}/traffic/trends` — Timeseries pageviews & unique visitors (use `granularity`)
- `GET /properties/{propertyId}/pages/breakdown` — Page-level performance: views, visitors, scroll depth, bounce rate
- `GET /properties/{propertyId}/traffic/breakdown` — UTM source/medium/campaign + device + location dimensions, all from the same endpoint
- `GET /properties/{propertyId}/traffic/entry-exit-pages` — Top entry and exit pages

**Key traffic metrics to pull:**
- Total sessions and unique visitors
- Page views and pages per session
- Average session duration
- Bounce rate
- New vs returning visitors ratio

### Step 2: Analyze Traffic Sources

Break down where traffic is coming from:

| Source | Sessions | % of Total | Bounce Rate | Conv Rate | Trend |
|--------|----------|-----------|-------------|-----------|-------|
| Organic Search | — | — | — | — | up/down/flat |
| Direct | — | — | — | — | — |
| Paid Search | — | — | — | — | — |
| Paid Social | — | — | — | — | — |
| Organic Social | — | — | — | — | — |
| Referral | — | — | — | — | — |
| Email | — | — | — | — | — |

Flag any source with:
- Significant volume change (>20% vs previous period)
- Unusually high or low conversion rate
- High bounce rate (>70%) suggesting poor targeting or landing page mismatch

### Step 3: Page Performance

Identify top-performing and underperforming pages:

**Top pages by traffic** — Which pages attract the most visitors?
**Top pages by conversion** — Which pages drive the most signups/purchases?
**Highest bounce rate pages** — Where are people leaving immediately?
**Lowest engagement pages** — Short time-on-page, low scroll depth

For key landing pages, report:
- Sessions, bounce rate, avg time on page
- Conversion rate and total conversions
- Period-over-period change

### Step 4: Funnel Step Analysis

Map the full conversion funnel with data:

```
Visitors → Signups → Activated → Trial → Paid → Retained

  10,000 → 500 → 300 → 200 → 80 → 65
         5.0%  60.0%  66.7%  40.0%  81.3%
```

For each transition, report:
- **Volume**: How many users at each step
- **Conversion rate**: Percentage moving to next step
- **Period comparison**: How this compares to the previous period
- **Trend**: Improving, declining, or stable

### Step 5: Conversion Events

The public API doesn't expose a generic events endpoint — pull conversion data from the dedicated form and click endpoints instead:

- `GET /properties/{propertyId}/forms/breakdown` — All form submissions across pages
- `GET /properties/{propertyId}/forms/details?page=/path` — Conversion rates for a specific form/page
- `GET /properties/{propertyId}/clicks/breakdown` — Click data with top targets across all pages
- `GET /properties/{propertyId}/clicks/details?page=/path` — Clicks on a specific page with UTM attribution

Report on:
- Signup completions (forms/breakdown filtered to signup pages)
- CTA clicks (clicks/details by page and CTA target)
- Form submissions (forms/breakdown)
- Pricing page views (pages/details with `?page=/pricing`)
- Trial starts (forms/breakdown filtered to the trial-start form)
- Upgrade/purchase events (forms/breakdown filtered to checkout/purchase)

### Step 5.5: Attach Paid Attribution (when reporting revenue or paid channels)

If the report needs to surface paid-channel performance, ROAS, or revenue-by-campaign, enrich the funnel with the Ads Attribution endpoint:

- `GET /api/v1/properties/{propertyId}/ads-attribution?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD`

Returns per-campaign rows with `spend`, `impressions`, `clicks`, `sessions`, `revenue_conversions`, `revenue`, `roas`, plus `unmatched_ad_campaigns` (UTM hygiene gaps) and `unmatched_utm_campaigns` (organic/email traffic). Pair with `traffic/breakdown` source data to build a paid-vs-organic split.

Note the different base path — this endpoint sits under `/api/v1/`, not `/api/external/v1/`. Same Bearer `HUMBLYTICS_API_KEY`. For raw connector metadata (ad accounts, daily insights, ad creative), use `/api/meta-connections` and `/api/google-ads-connections` — see `revenue-attributor` for the full workflow.

### Step 6: Period-over-Period Comparison

Always compare against the previous period (week-over-week or month-over-month):

| Metric | This Period | Last Period | Change | Trend |
|--------|------------|-------------|--------|-------|
| Sessions | — | — | +X% | — |
| Signups | — | — | +X% | — |
| Conversion Rate | — | — | +X pp | — |
| Bounce Rate | — | — | -X pp | — |

Highlight:
- Metrics that improved significantly (celebrate wins)
- Metrics that declined (flag for investigation)
- Metrics that are flat but should be growing (stagnation risk)

### Step 7: Insights and Recommendations

Do not just present data — interpret it:

**The Report Summary Structure:**

1. **Executive Summary** (3 sentences max)
   - Overall funnel health: healthy / needs attention / critical
   - Biggest win this period
   - Biggest concern this period

2. **Key Metrics Table** — The 5-8 most important numbers

3. **Traffic Analysis** — Sources, trends, notable changes

4. **Funnel Performance** — Step-by-step with conversion rates

5. **Page Performance** — Top and bottom performers

6. **Insights** (3-5 bullets)
   - What changed and why
   - What is working well
   - What needs attention

7. **Recommended Actions** (3 bullets)
   - One quick win
   - One strategic initiative
   - One thing to investigate further

## Report Templates

### Weekly Report (concise)
- Executive summary (3 lines)
- Key metrics table (5 numbers)
- Top 3 insights
- Top 3 actions

### Monthly Report (comprehensive)
- Executive summary
- Full traffic analysis with source breakdown
- Complete funnel with step-by-step conversion rates
- Page-level performance (top 10 pages)
- Channel-by-channel breakdown
- Month-over-month trends
- Insights and strategic recommendations

### Board/Stakeholder Report (high-level)
- 3 headline metrics (traffic, signups, revenue)
- Trend arrows and period comparison
- One paragraph narrative
- Strategic outlook

## Metric Benchmarks (SaaS)

Use these as reference points when analyzing data:

| Metric | Poor | Average | Good | Excellent |
|--------|------|---------|------|-----------|
| Landing page conversion | <2% | 2-5% | 5-10% | >10% |
| Trial-to-paid | <10% | 10-20% | 20-40% | >40% |
| Bounce rate | >70% | 50-70% | 30-50% | <30% |
| Activation rate | <20% | 20-40% | 40-60% | >60% |
| Monthly churn | >10% | 5-10% | 2-5% | <2% |

## Related Skills

- **cro-optimizer** — Take report findings and turn them into optimization actions
- **ab-test-generator** — Create tests based on underperforming pages or steps
- **marketing-strategist** — Use report data to inform strategic planning
- **page-cro** — Deep-dive into specific underperforming pages

## Shared Frameworks (REQUIRED reading)

Two primitives are load-bearing for this skill. Without them, funnel reports fall back to flagging the highest-percentage drop and quoting raw decimals — both of which mislead.

- **`_shared/frameworks/largest-leak-first.md`** — rank funnel steps by **absolute people lost**, not percentage drop. A 10% drop on 10,000 visitors (1,000 lost) outranks a 50% drop on 100 visitors (50 lost) by 20×. Compute `absolute_loss_per_step = step_in - step_out` first; only sort by percentage as a secondary view. This often inverts the priority order.

- **`_shared/frameworks/percentile-framing.md`** — replace "your trial-to-paid CVR is low" with "your trial-to-paid CVR is 11%, at p25 in the OpenView B2B SaaS distribution (p50=14%, p75=22%) — meaningful headroom to median." Use the bands in `_shared/benchmarks/baselines.json`:
  - All sites desktop: p50 = 3.82% CVR
  - All sites mobile: p50 = 1.32% CVR (~3× desktop gap)
  - B2B SaaS pricing page: p50 = 3.8% CVR (well-optimized: p75 = 8–12%)
  - Ecommerce checkout fields: p50 = 11.3 fields (Baymard optimum = 8)

- **`_shared/frameworks/preflight-checklist.md`** — confirm time range and traffic volume *before* the report. Funnel diagnostics on <500 sessions are noise, not signal — flag rather than pretend the percentages are meaningful.

- **`_shared/benchmarks/baselines.json`** — full vertical baselines library. Cite the source on every comparison ("Aggregated Statsig/Eppo/FirstMark 2023-2024 reports").

The existing benchmark table in this SKILL.md (Poor/OK/Good/Excellent) is a coarse heuristic. Prefer percentile-band framing from the baselines library when the vertical-stage-metric combination is present there.
