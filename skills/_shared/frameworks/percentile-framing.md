# Percentile framing for reported metrics

Always frame a user's current metric against a vertical baseline percentile band — not as a raw number with vague qualitative judgment.

---

## Bad framing (what to avoid)

> Your pricing-page CVR is **2.4%**. This is **lower than average** and there's a lot of room to improve.

Problems:
- "Lower than average" is ambiguous — average of what?
- "A lot of room to improve" is vibes — how much room?
- The user can't tell whether 2.4% is bad, mediocre, or roughly fine

---

## Good framing

> Your pricing-page CVR is **2.4%**. Vertical baseline (B2B SaaS pricing pages, 2024): p25 = 1.2% / **p50 = 3.8%** / p75 = 8%. You're at roughly **p35** — below median, with **~60% headroom to p50** and **~3× headroom to top-quartile**.

Why this is better:
- Anchors against a specific source (B2B SaaS pricing pages, 2024)
- Gives the user a sense of where realistic ceiling is
- Headroom math sets reasonable expectations on lift magnitude

---

## How to compute the band

1. **Open `_shared/benchmarks/baselines.json`** and find the row matching `vertical × stage × metric`
2. Read `p25`, `p50`, `p75`
3. Classify the user's value:
   - **value < p25** → "below p25 — significant headroom, treat as priority"
   - **p25 ≤ value < p50** → "at roughly p35–p45, below median, meaningful headroom"
   - **p50 ≤ value < p75** → "above median but below top quartile, moderate headroom"
   - **value ≥ p75** → "at or above top quartile, gains will be marginal — focus elsewhere"

Use the same band labels across all skills so users build a consistent mental model.

---

## When to NOT use percentile framing

- **Sub-segment metrics with small N.** Don't say "your mobile-from-paid-search CVR is p20" if the segment has 87 sessions. The denominator noise overwhelms the band.
- **Net-new product categories** where the benchmarks library doesn't have data. Say so explicitly: *"No reliable baseline available for this vertical-stage combination — reporting absolute value only."*
- **Metrics where direction is ambiguous.** Bounce rate at p50 isn't necessarily "average" — some product pages benefit from short visits (quick decisions); others don't.

---

## Reasonable improvement framings

Once you've placed the user in a band, frame the *recommended target* against the next band:

| Current band | Reasonable target | Stretch target |
|---|---|---|
| Below p25 | p50 | p75 |
| p25–p50 | p50 | p75 |
| p50–p75 | p75 | top decile |
| Above p75 | Maintain | Test net-new optimizations (lower expected lift) |

**Don't promise "we'll get you to p75" from a p20 baseline without showing the chain of changes that compound there.** Most users won't double their CVR with one test. Reach p50 first.

---

## Example phrasings to reuse

- *"Your bounce rate is 71%, which sits at roughly p82 in the B2B SaaS landing-page distribution — meaning 18% of comparable pages are doing worse, 82% are doing better."*
- *"Trial-to-paid CVR of 14% matches the OpenView free-trial median exactly. You're not under-performing; the lever here is signup volume, not trial conversion."*
- *"Form abandonment of 82% is above the Formstack multi-step baseline (~80%). Reduction by even 5pp would be a meaningful win — anchor expected lift on that, not on the +120% HubSpot field-cut outlier."*

---

## Use this with

- `_shared/benchmarks/baselines.json` — the actual p25/p50/p75 numbers
- `_shared/frameworks/base-rate-priors.md` — realistic lift expectations once you've placed the user in a band
- `_shared/frameworks/largest-leak-first.md` — combine percentile framing with absolute-loss math for full prioritization
