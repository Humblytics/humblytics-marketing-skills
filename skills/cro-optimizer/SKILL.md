---
name: cro-optimizer
description: "CRO specialist that pulls live analytics data from Humblytics API, analyzes conversion funnels, identifies drop-off points, and generates prioritized A/B test hypotheses. Use when analyzing conversion rates, diagnosing funnel leaks, optimizing signup flows, or creating test roadmaps. Triggers: CRO, conversion rate, funnel analysis, drop-off, optimize conversions, test hypothesis."
metadata:
  version: 1.0.0
  author: Humblytics
---

# CRO Optimizer

## Purpose

Analyze conversion funnels using live Humblytics analytics data, identify the highest-impact drop-off points, and generate prioritized A/B test hypotheses with expected revenue impact. This skill turns raw analytics into a ranked optimization roadmap.

## When to Use

- Diagnosing why a funnel is underperforming
- Identifying the biggest conversion bottleneck across a user journey
- Generating a prioritized list of A/B test ideas
- Preparing a CRO sprint plan or quarterly optimization roadmap
- Analyzing page-level or step-level drop-off rates
- Comparing conversion performance across segments (device, source, geography)

## API Configuration

Before using this skill, configure your Humblytics API credentials:

- **API Key**: Set `HUMBLYTICS_API_KEY` environment variable or provide when prompted
- **Property ID**: Your Humblytics property ID (found in Dashboard > Settings > API)
- **Base URL**: `https://app.humblytics.com/api/external/v1`

See https://docs.humblytics.com/api for full API documentation.

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
- **Heatmap summaries** if available for high-traffic pages

Use the Humblytics API endpoints:
- `GET /properties/{propertyId}/analytics/pages` — Page-level traffic
- `GET /properties/{propertyId}/analytics/funnel` — Funnel step data
- `GET /properties/{propertyId}/analytics/events` — Custom event tracking
- `GET /properties/{propertyId}/heatmaps` — Click and scroll heatmap data

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
- **Scroll depth** — Are users seeing the CTA? Check heatmap scroll data.
- **Click patterns** — Are users clicking non-interactive elements? Confusing UI.
- **Form fields** — For forms, which field has the highest abandonment rate?

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
- **funnel-reporter** — Pull comprehensive funnel reports with revenue data
- **page-cro** — Deep-dive into a specific page's conversion issues
- **copywriting** — Generate optimized copy for test variants
