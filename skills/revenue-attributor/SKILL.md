---
name: revenue-attributor
description: "Revenue attribution specialist that connects Meta Ads, Google Ads, and Stripe revenue to show which campaigns actually pay back. Generates campaign-level ROAS breakdowns with waste detection and budget reallocation recommendations. Use when analyzing ad ROI, finding wasted ad spend, comparing channel performance, or reallocating budget. Triggers: attribution, ROAS, ad spend, campaign performance, channel mix, budget reallocation, ad waste."
metadata:
  version: 1.0.0
  author: Humblytics
---

# Revenue Attributor

## Purpose

Connect ad spend to actual Stripe revenue using Humblytics multi-touch attribution. Rank campaigns by real ROAS (not clicks, not conversions — *revenue*), surface ad waste, and generate reallocation recommendations. This skill moves marketing teams from vanity metrics to revenue accountability.

## When to Use

- Planning next month's ad budget and need data to reallocate
- Diagnosing why spend is up but revenue is flat
- Comparing paid vs organic vs direct revenue contribution
- Auditing campaign-level ROAS across Meta, Google, TikTok, LinkedIn
- Building a quarterly ad performance review for leadership
- Deciding whether to kill, scale, or hold a specific campaign

## API Configuration

- **API Key**: `HUMBLYTICS_API_KEY` env var or prompt user
- **Property ID**: Humblytics Dashboard > Settings > API
- **Base URL**: `https://app.humblytics.com/api/external/v1`
- **Stripe requirement**: The Humblytics property must have Stripe connected for revenue attribution to work

See https://docs.humblytics.com/api for full reference.

## Before You Start

1. **Confirm Stripe is connected** — Attribution requires Stripe revenue events; without it, you only get click data
2. **Confirm UTM hygiene** — Campaigns without UTM parameters can't be attributed to source
3. **Time range** — Default to last 30 days; 60-90 days for monthly comparison; 12 months for strategic planning
4. **Attribution model** — Default to last-touch; switch to first-touch or linear if specified
5. **Property ID** — Ask which property to analyze

## Core Workflow

### Step 1: Pull Revenue + Spend Data

Fetch the revenue-to-source breakdown:

- `GET /properties/{propertyId}/traffic/breakdown` — UTM source/medium/campaign breakdown
- `GET /properties/{propertyId}/forms/breakdown` — Conversion events (signups, purchases)
- `GET /properties/{propertyId}/pages/breakdown?page_group=stripe` or revenue endpoints for Stripe-linked revenue

Combine with **ad spend data** (user provides from Meta Ads Manager, Google Ads, etc.) to calculate true ROAS per campaign.

### Step 2: Build the Attribution Table

For each source → campaign → ad level:

| Source | Campaign | Spend | Clicks | Signups | Revenue | ROAS |
|--------|----------|-------|--------|---------|---------|------|
| google/cpc | brand-search | $1,200 | 340 | 28 | $4,200 | 3.5× |
| meta/paid | lookalike-v3 | $2,800 | 1,240 | 42 | $1,680 | 0.6× |
| organic | seo-longtail | $0 | 860 | 31 | $3,720 | ∞ |

### Step 3: ROAS Ranking + Waste Detection

Sort campaigns into four tiers:

| Tier | ROAS | Action |
|------|------|--------|
| **Scale** | > 3× | Increase budget 20-50% |
| **Hold** | 1.5-3× | Optimize creative/audience; budget stays |
| **Fix** | 0.5-1.5× | Audit targeting, creative, landing page before killing |
| **Kill** | < 0.5× | Reallocate budget immediately |

**Waste detection rules:**
- Campaign has > $500 spend and < 1× ROAS → hard flag
- Ad set has > 100 clicks and 0 conversions → landing page or audience mismatch
- Campaign clicks but no UTMs → invisible to attribution, fix tracking first

### Step 4: Channel Mix Analysis

Compare revenue contribution across channels:

- **Paid share**: % of revenue from paid ads
- **Organic share**: % from SEO/direct
- **Referral share**: % from partner/affiliate sources
- **Blended CAC**: Total ad spend / total acquired customers

**Red flags:**
- Paid share > 80% → business is dependent on ad spend; diversify
- Paid share < 10% with high spend → attribution is broken, fix UTMs
- One campaign > 50% of revenue → concentration risk

### Step 5: Reallocation Recommendation

Build a specific reallocation plan:

```
CURRENT ALLOCATION (monthly):
- Google Ads: $8,000 (2.1× ROAS)
- Meta Ads:   $12,000 (0.9× ROAS)
- LinkedIn:   $3,000 (4.2× ROAS)

RECOMMENDED REALLOCATION:
- Google Ads: $9,000 (+$1,000) — scale branded search
- Meta Ads:   $6,000 (-$6,000) — kill "lookalike-v3", keep retargeting only
- LinkedIn:   $7,000 (+$4,000) — scale the 4.2× ROAS campaign
- Reserve:    $4,000 — test new channel (TikTok or YouTube)

NET CHANGE: $0 (same total budget)
EXPECTED ROAS LIFT: 1.6× → 2.4× (projected)
```

### Step 6: Output Format

```
PERIOD: [start] to [end]
TOTAL AD SPEND: $X
TOTAL ATTRIBUTED REVENUE: $Y
BLENDED ROAS: Z×

TOP 3 PERFORMERS:
1. [Campaign] — [ROAS]× — [Recommendation]
2. [Campaign] — [ROAS]× — [Recommendation]
3. [Campaign] — [ROAS]× — [Recommendation]

BOTTOM 3 (KILL CANDIDATES):
1. [Campaign] — [ROAS]× — $[spend] wasted
2. [Campaign] — [ROAS]× — $[spend] wasted
3. [Campaign] — [ROAS]× — $[spend] wasted

CHANNEL MIX:
- Paid: X%   Organic: Y%   Direct: Z%   Referral: W%

REALLOCATION PLAN:
[Specific budget moves with dollar amounts]

PROJECTED IMPACT:
[Expected ROAS lift and revenue gain]

TRACKING GAPS:
[Campaigns missing UTMs, ad sets with zero attribution, Stripe integration issues]
```

## Attribution Principles

1. **Revenue over clicks.** A campaign with 10× the clicks of another means nothing if it doesn't drive revenue.
2. **Absolute wins matter, not just ROAS.** A 10× ROAS campaign at $200/mo spend matters less than a 2× ROAS campaign at $20K/mo.
3. **Kill slowly, scale cautiously.** A low ROAS campaign might be the top-funnel driver. Check assisted conversions before killing.
4. **UTM hygiene is everything.** Without clean UTMs, attribution is fiction. Fix tracking before fixing spend.
5. **Blended CAC is the truth.** Per-campaign ROAS is useful, but blended CAC tells you whether the business model works.

## Related Skills

- `funnel-reporter` — End-to-end funnel metrics for the periods you're analyzing
- `ad-expert` — Creative and targeting fixes once you've identified waste
- `cro-optimizer` — If ads are working but landing pages aren't converting, pair with CRO
