---
name: heatmap-analyst
description: "Heatmap analysis specialist that pulls click, scroll, and rage-click data from Humblytics to surface UX friction, ignored CTAs, and dead zones. Generates prioritized heatmap-driven optimization recommendations. Use when analyzing heatmaps, auditing click patterns, finding ignored elements, diagnosing scroll depth issues, or investigating rage clicks. Triggers: heatmap, click map, scroll map, rage click, dead zone, ignored CTA, UX friction, interaction audit."
metadata:
  version: 1.0.0
  author: Humblytics
---

# Heatmap Analyst

## Purpose

Analyze Humblytics heatmap data (click, scroll, and rage-click) to diagnose UX friction and generate prioritized design recommendations. This skill turns raw interaction data into specific, ranked improvements for layout, CTAs, and content hierarchy.

## When to Use

- A page has a high bounce rate and you need to understand *why*
- CTAs are present but click-through rate is below benchmark
- You want to verify that the important content is actually being seen
- Users are reporting confusion or friction on a specific page
- You're auditing a page before a redesign or A/B test
- Investigating whether traffic from a specific source behaves differently on-page

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

1. **Confirm the property ID** — Ask which Humblytics property to analyze
2. **Identify the target page(s)** — Which URL(s) are in scope
3. **Time range** — Default to last 30 days; shorter windows are noisier
4. **Sample size check** — Pages below ~500 sessions in the window produce unreliable heatmaps
5. **Context** — Pull product/persona context if available so recommendations match the audience

## Core Workflow

### Step 1: Pull the Heatmap Data

For each target page, fetch:

- **Click heatmap** — Aggregated click coordinates by element + zone
- **Scroll heatmap** — Depth distribution (what % reached 25/50/75/100%)
- **Rage-click data** — Rapid repeated clicks on the same coordinate (frustration signal)
- **Device split** — Desktop vs mobile vs tablet — heatmaps often diverge sharply

Relevant Humblytics endpoints:
- `GET /properties/{propertyId}/clicks/details?page=/path`
- `GET /properties/{propertyId}/pages/details?page=/path` (for scroll depth + bounce)
- `GET /properties/{propertyId}/clicks/breakdown` (for cross-page comparison)

### Step 2: The Three Heatmap Questions

Run each page through these three diagnostic questions:

**Q1 — Are visitors clicking what you *want* them to click?**
- Primary CTA click share: is it a meaningful fraction of total clicks?
- Secondary CTA click share: proportional to its importance?
- Click-to-scroll ratio: are the clicks happening above or below the fold?

**Q2 — Are visitors *seeing* the important content?**
- Scroll depth distribution: at what depth does 50% of traffic drop off?
- Is the primary CTA above or below that depth?
- Is social proof / pricing / main value prop above that depth?

**Q3 — Are visitors frustrated?**
- Rage-click hotspots: clicking on non-clickable elements?
- Dead links or unresponsive states?
- Visual cues (underlines, button styling) that mislead?

### Step 3: Identify the Top 3 Issues

Rank all issues by **expected conversion impact**:

1. **Blocker** — CTA below the fold for >50% of sessions, or core content unreachable
2. **Friction** — Rage clicks on unresponsive elements, confusing affordances
3. **Waste** — High click share on low-value elements (e.g., stock images)

Always state the evidence: *"38% of mobile visitors never scroll past 45% — but the signup CTA sits at 62% depth."*

### Step 4: Generate Recommendations

For each issue, provide:

- **Specific change** — "Move CTA from below the pricing table to above the hero fold"
- **Expected lift** — Estimate based on traffic volume and issue severity
- **Implementation difficulty** — Copy change / layout change / redesign
- **How to verify** — Which metric to watch; which follow-up A/B test validates the fix

### Step 5: Output Format

Write a clean report with:

```
PAGE: [/path]
DATE RANGE: [window]
SESSIONS ANALYZED: [N]

HEADLINE FINDING:
[1 sentence capturing the biggest insight]

CLICK PATTERN SUMMARY:
- Primary CTA click share: X%
- Highest-click element: [element] (Y% of clicks)
- Below-fold click share: Z%

SCROLL BEHAVIOR:
- 50% of sessions reach: [depth]%
- Primary CTA depth: [position]
- Last-seen content at 50% drop-off: [element]

RAGE CLICKS DETECTED: [locations / count]

TOP 3 RECOMMENDATIONS (prioritized):
1. [Change] — Expected impact: [X] — Difficulty: [level]
2. [Change] — Expected impact: [X] — Difficulty: [level]
3. [Change] — Expected impact: [X] — Difficulty: [level]

SUGGESTED A/B TESTS:
- [Test hypothesis with clear control vs variant]
```

## Heatmap Interpretation Cheatsheet

| Pattern | Likely Cause | Action |
|---------|--------------|--------|
| High clicks on non-interactive element | Looks clickable (underline, button styling) | Remove false affordance OR make it clickable |
| Low scroll past 30% | Weak hook, above-fold doesn't earn attention | Rewrite headline or move proof above the fold |
| CTA clicks concentrated on one variant | Other CTAs are invisible or redundant | Remove redundant CTAs; test single CTA variant |
| Rage clicks on image | Users expect it to be clickable | Add link OR reduce visual prominence |
| Even click distribution across page | No clear visual hierarchy | Add hierarchy: emphasize primary action |
| Desktop clicks ≠ mobile clicks | Layout breaks or re-orders on mobile | Audit mobile design specifically |

## Related Skills

- `cro-optimizer` — Combines heatmap findings with funnel data for holistic CRO
- `page-cro` — Full 10-point page audit; heatmap analysis is one dimension
- `ab-test-generator` — Takes heatmap recommendations and launches them as tests

## Shared Frameworks (REQUIRED reading)

Heatmap interpretation is highly context-dependent. The shared primitives in `skills/_shared/` keep recommendations grounded.

- **`_shared/frameworks/preflight-checklist.md`** — confirm minimum 500 sessions per page-period combo before drawing conclusions. Heatmap patterns on smaller samples are noise.
- **`_shared/frameworks/anti-patterns.md`** — heatmap-relevant counter-evidence:
  - **Mobile hamburger menu**: NN/g says it hurts discoverability on task-oriented SaaS (Spotify hamburger → bottom-tab = +30% menu interactions). **BUT** Amazon's hamburger beat dropdown for browse-heavy ecom. Site_type is load-bearing — don't recommend bottom-tab universally.
  - **Mobile exit-intent**: architecturally broken (no cursor → no mouseleave event). If heatmap shows users leaving on mobile, the answer is not an exit modal.
  - **Progress-bar velocity**: NIH RCT shows slow-to-fast progress bars nearly double form abandonment. If your heatmap shows form-step drop-off, audit progress bar acceleration before redesigning fields.
- **`_shared/benchmarks/patterns.json`** — when heatmap data confirms a problem (e.g., low scroll past 30%, CTA clicks dominated by a single variant), match to a `pattern_id` and quote the evidence-backed lift range for the fix. Most relevant categories: `cta`, `navigation`, `above_fold`.
