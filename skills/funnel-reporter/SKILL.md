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

Retrieve top-of-funnel metrics from Humblytics:

**API Endpoints:**
- `GET /properties/{propertyId}/analytics/overview?period={period}` — Aggregate metrics
- `GET /properties/{propertyId}/analytics/pages?period={period}` — Page-level breakdown
- `GET /properties/{propertyId}/analytics/sources?period={period}` — Traffic source attribution
- `GET /properties/{propertyId}/analytics/devices?period={period}` — Device breakdown
- `GET /properties/{propertyId}/analytics/locations?period={period}` — Geographic data

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

Pull event data for key conversion actions:

- `GET /properties/{propertyId}/analytics/events?period={period}` — All tracked events

Report on:
- Signup completions
- CTA clicks (by page and CTA)
- Form submissions
- Pricing page views
- Trial starts
- Upgrade/purchase events

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
