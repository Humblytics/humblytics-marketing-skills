# Shared skill primitives

Reference material that more than one skill in this repo relies on. Importing skills should link to these files in their `## Frameworks Used` or `## Related Resources` sections rather than re-stating the content.

## `benchmarks/`

- `patterns.json` — 54 curated CRO patterns with cited lift ranges, prerequisites, anti-patterns, and source URLs. Mirrored from `humblytics-backend/services/benchmarks/patterns.json` (the chat agent's runtime evidence library). Use when you need defensible numbers behind a recommendation.
- `baselines.json` — 29 vertical-stage-metric percentile baselines (p25/p50/p75). Use to frame a user's current value as "below p25 = lots of headroom" / "above p75 = marginal gains left".

Every pattern entry follows the shape:
```json
{
  "pattern_id": "snake_case_id",
  "category": "social_proof" | "trust" | "urgency" | "form" | "pricing" | "cta" | "headline" | "navigation" | "above_fold",
  "description": "...",
  "applies_to": ["pricing","landing","checkout","signup","product"],
  "evidence": [
    { "source":"GoodUI #47","lift_range_pct":[3,9],"sample_size":124,
      "confidence":"high"|"med"|"low","vertical":"saas"|"ecommerce"|"lead_gen"|"general","year":2023,"url":"..." }
  ],
  "prerequisites": ["..."],
  "anti_patterns": ["..."],
  "notes": "..."
}
```

## `frameworks/`

Stable, cross-skill reference modules. Each file is short and self-contained — link to it rather than copy-paste.

- `anti-patterns.md` — Negative evidence the canon usually omits. Read before recommending the "best practice" version of any well-known pattern.
- `base-rate-priors.md` — Realistic priors on win rate, lift magnitude, and test reach. Stops skills from anchoring on best-case outliers.
- `ice-confidence-rubric.md` — How to anchor ICE.Confidence on evidence quality so scores don't drift to vibes.
- `largest-leak-first.md` — Absolute vs relative drop-off math. Ranks fixes by people-lost, not percentage.
- `percentile-framing.md` — How to report "your X is at p35" instead of raw decimals. Sets realistic improvement expectations.
- `preflight-checklist.md` — Five context items every CRO-style skill should verify before producing findings.

## Provenance

Curated from a Perplexity-driven research pass run in May 2026. Raw research and curation notes archived in `humblytics-backend/research/` for full audit trail.
