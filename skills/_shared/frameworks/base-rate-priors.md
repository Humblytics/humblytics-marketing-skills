# Base-rate priors for CRO recommendations

Use these as **realistic priors** when sizing recommendations. They stop skills from anchoring on best-case outliers and overpromising lift.

Source: aggregated from the May 2026 Perplexity research pass — see `_shared/benchmarks/patterns.json` evidence blocks.

---

## How often A/B tests actually win

| Stat | Value | Source |
|---|---|---|
| CTA tests that reach significance | ~14% | VWO / Wingify 2023 A/B Testing Insights Report (n=large) |
| Avg lift when a test does win | +49% | VWO / Wingify, same dataset |
| Headline A/B variants that beat control | ~31% | 73-test controlled study |
| All A/B tests that show *any* lift | ~25–35% (industry rule of thumb) | CXL Institute synthesis |

**Implication:** If a skill proposes 10 test ideas, expect 2–3 to win meaningfully. Don't sell the user on "we'll lift CVR 20% across the board" — sell them on "we'll find the 2–3 winners that compound."

---

## Realistic single-change lift ranges

These ranges are typical for a well-executed test in B2B SaaS / lead-gen / ecom, NOT best-case outliers.

| Change | Typical median lift | Notes |
|---|---|---|
| Headline rewrite (benefit-led, audience-qualified) | +5 to +15% | When it wins. 31% win rate. |
| CTA copy: generic → specific outcome | +10 to +20% | "Get My Audit" vs "Submit". |
| CTA: first-person ("Start MY trial") | +10 to +15% | Modern Unbounce platform baseline. |
| Social proof testimonial above CTA | +30 to +35% | When audience-matched and quantified. |
| Trust badge near checkout (B2C ecom) | +20 to +40% | Brand-recognized badges only. |
| Form field reduction (7+ → 3–5) | +50 to +120% | Largest single-lever opportunity. |
| Sticky CTA on long landing page | +7 to +25% | Bigger on mobile. |
| Annual-billing default | Roughly neutral CVR | But LTV 2–3×, retention +24pp. |
| Three-tier anchor pricing | Mix shifts +30–40% to middle tier | CVR neutral; ARPA boost. |

**Anchor recommendations against these typical ranges, not against the +260% Docsend outlier or the +120% HubSpot field reduction.**

---

## When lift is suspiciously high

If a case study reports >+100% lift, treat with skepticism. Common explanations:

1. **Bundled changes** masquerading as a single-lever test (e.g., "headline rewrite" that also changed sub-headline, image, and CTA)
2. **Underpowered test** stopped at the first peak (regression to mean is high in low-sample tests)
3. **Pre-2018 case study** — habituation has eroded most of these effects since
4. **Outlier audience match** (Docsend enterprise→enterprise +260%) that doesn't generalize

**Rule of thumb:** Single-lever lifts above +50% require explicit corroboration from a second study, or they get downgraded to confidence:"low".

---

## Vertical baselines (use for percentile framing)

Full table in `_shared/benchmarks/baselines.json`. Quick reference:

| Vertical / stage | Metric | p50 |
|---|---|---|
| All sites, desktop | site-wide CVR | 3.82% |
| All sites, mobile | site-wide CVR | 1.32% (~3× desktop gap) |
| B2B SaaS pricing page | CVR | 3.8% |
| B2B SaaS pricing page (well-optimized) | CVR | 8–12% (p75 zone) |
| Ecommerce checkout | fields per checkout | 11.3 |
| Ecommerce checkout (Baymard optimum) | fields per checkout | 8 |
| B2B lead-gen MQL → revenue | conversion | 12% |

**Use baseline_percentile framing in reports** — say "your pricing-page CVR is 2.4%, at roughly p25 of the B2B SaaS distribution" instead of "your conversion is bad." See `_shared/frameworks/percentile-framing.md`.

---

## Mobile vs desktop multipliers

- Mobile CVR is ~3× lower than desktop in most verticals (1.32% vs 3.82% globally)
- Mobile load delay penalty: **1s = −7% CVR, 3s = −20% CVR**
- 60–70% of traffic is mobile in most B2C contexts; 30–50% in B2B
- Mobile lift magnitudes are typically *larger in percentage terms* because baseline is lower — but absolute conversions per visitor are still lower than desktop

**Rule:** When evaluating mobile-specific changes, report both relative lift and absolute conversion delta. Relative-only framing overstates mobile wins.

---

## Use this with

- `_shared/frameworks/anti-patterns.md` — when canon advice backfires
- `_shared/frameworks/ice-confidence-rubric.md` — how to anchor ICE.Confidence on the priors above
- `_shared/frameworks/percentile-framing.md` — how to report current values against p25/p50/p75
