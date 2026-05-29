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

## Credentials

This skill reads a Humblytics API key from the environment. **Never paste API keys directly into chat** — they persist in transcripts and logs. Keep `HUMBLYTICS_API_KEY` out of `CLAUDE.md`, `.cursorrules`, and any file that gets committed to git.

Setup (one time):
1. `cp .env.example .env` at the repo root and fill in `HUMBLYTICS_API_KEY`
2. `source .env` in your shell before running the agent (or use `direnv`, or add the exports to your shell profile)
3. Get the key from Humblytics Dashboard > Settings > API
4. The skill will ask for your **Property ID** (also in Dashboard > Settings > API)

- **Bases used by this skill** (all accept the same Bearer `HUMBLYTICS_API_KEY`):
  - `https://app.humblytics.com/api/external/v1` — traffic, pages, forms, clicks, funnels
  - `https://app.humblytics.com/api/v1` — ads-attribution
  - `https://app.humblytics.com/api` — meta-connections, google-ads-connections
- **Docs**: https://docs.humblytics.com/api
- **Stripe requirement**: The Humblytics property must have Stripe connected for revenue attribution to work. No separate Stripe key is needed here — Humblytics handles Stripe ingestion internally.

If `HUMBLYTICS_API_KEY` is not in the environment, stop and point the user at `.env.example` — do not accept the key in chat.

### Three paths to ad data (Meta Ads + Google Ads)

#### Path A — Humblytics connectors (preferred, read-only)

If the property has Meta Ads or Google Ads connected at **Connectors** in the Humblytics dashboard, this skill pulls campaign metadata, daily insights, and full-funnel attribution directly through the public API — no Meta App Review, no Google Ads developer token. This is the default path. The connectors are **read-only** — they let the agent see campaign data and revenue, but not pause campaigns or change budgets.

- Detect availability via `GET /api/meta-connections?propertyId=` and `GET /api/google-ads-connections?propertyId=`. Empty `connections` arrays mean nothing is connected; fall back to Path A2 below.

#### Path A2 — User-provided CSV (fallback)

If no connectors are set up, the skill asks the user to paste ad spend from Meta Ads Manager or Google Ads Editor. Pair the CSV columns with Humblytics-attributed revenue from `ads-attribution` (which still works for revenue even without a spend connector — it just leaves spend fields zero).

#### Path B — Meta CLI (only when the agent needs to *manage* campaigns)

For pausing laggards, shifting budget, or other write actions, point the user at Meta's official `meta ads` CLI (released April 29, 2026). It's a published, supported tool that creates resources in `PAUSED` status by default. Scope the access token to a single ad account, store it in `.env` (never `CLAUDE.md`), and review every campaign before flipping it active. This skill does not call the Meta CLI itself — it just hands off when management actions are required.

#### Path C — Don't roll your own Meta app

**Do not give the agent direct Meta Marketing API access through a system user on an unapproved developer app.** Routing production API traffic through a draft or unpublished Meta App — regardless of how the access token was issued — is how ad accounts, including long-standing ones with seven-figure spend, are getting permanently banned. Meta is actively enforcing against unapproved-app API traffic. Use Path A or Path B instead. The only safe DIY route is a Meta Developer App with the Marketing API product and **full App Review completed** for the permissions you need (e.g. `ads_read`) — budget weeks for review.

## Before You Start

1. **Confirm Stripe is connected** — Attribution requires Stripe revenue events; without it, you only get click data
2. **Confirm UTM hygiene** — Campaigns without UTM parameters can't be attributed to source
3. **Time range** — Default to last 30 days; 60-90 days for monthly comparison; 12 months for strategic planning
4. **Attribution model** — Default to last-touch; switch to first-touch or linear if specified
5. **Property ID** — Ask which property to analyze

## Core Workflow

### Step 1: Pull Revenue + Spend Data

**Primary call** — full-funnel attribution merging ad spend with sessions and revenue:

- `GET /api/v1/properties/{propertyId}/ads-attribution?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD`

This returns per-campaign rows with `spend`, `impressions`, `clicks`, `sessions`, `revenue_conversions`, `revenue`, `roas`, `true_cpa`, plus `unmatched_ad_campaigns` (UTM hygiene gaps) and `unmatched_utm_campaigns` (organic/email traffic). Empty `campaigns[]` with non-empty `unmatched_*` is the strongest signal that UTM tagging needs work — the data is flowing, it just isn't joining.

**Spend supplement (Path A — connectors connected):**

- Meta: `GET /api/meta-connections?propertyId={propertyId}` → pick a connection → `GET /api/meta-connections/{id}/accounts/{accountId}/daily-insights?since=&until=`
- Google: `GET /api/google-ads-connections?propertyId={propertyId}` → pick a connection → `GET /api/google-ads-connections/{id}/campaigns?customerId={customerId}`

**Path A2 fallback (no connectors):** ask the user to paste a CSV from Ads Manager. The skill joins those rows to the `ads-attribution` revenue side.

**Context endpoints** for source/page-level breakdowns:

- `GET /properties/{propertyId}/traffic/breakdown` — UTM source/medium/campaign + device + location dimensions
- `GET /properties/{propertyId}/forms/breakdown` — Conversion events (signups, purchases)
- `GET /properties/{propertyId}/pages/breakdown` — Page performance (the public API doesn't expose a `page_group` filter; pull all pages and filter client-side if needed)

All endpoints accept the same Bearer `HUMBLYTICS_API_KEY`.

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

## Creative Inspection (Path A only)

When `ads-attribution` flags a high-spend / low-revenue Meta campaign, drill into the underlying creative before recommending kill:

- `GET /api/meta-connections/{id}/campaigns/{campaignId}/ads` — list ads in the campaign with creative + destination URL
- `GET /api/meta-connections/{id}/ads/{adId}` — full creative metadata for one ad

Look for: destination URL mismatch (ad copy promises X, lands on Y), broken links, low-quality stock visuals, or one ad in the campaign hogging the spend with poor performance. This is the read-only diagnostic step. To pause the ad, hand off to Meta CLI (Path B).

## Related Skills

- `funnel-reporter` — End-to-end funnel metrics for the periods you're analyzing
- `ad-expert` — Creative and targeting fixes once you've identified waste
- `cro-optimizer` — If ads are working but landing pages aren't converting, pair with CRO
