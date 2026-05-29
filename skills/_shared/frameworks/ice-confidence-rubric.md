# ICE confidence rubric (anchor on evidence quality)

The ICE prioritization framework (Impact × Confidence × Ease) drifts to vibes if Confidence isn't anchored on something concrete. This file defines the anchor.

When scoring a recommendation, use this rubric for the Confidence column:

| Score | Anchor | Example |
|---|---|---|
| **9–10** | Direct A/B test evidence in the same vertical, ≥2 independent sources, n ≥ 1000 per source | Form-field reduction 7→3 (HubSpot +120%, n>10k; Aagaard Unbounce +19%, n>5k) |
| **7–8** | One controlled A/B test with n ≥ 1000, OR multi-source synthesis with consistent direction | Sticky CTA mobile drawer (GrowthRock +5.2%, n~2k, 99% sig) |
| **5–6** | General best practice with directional support — no clean A/B test in target vertical | Audience-qualifying headlines (consistent in case studies, no controlled vertical-matched RCT) |
| **3–4** | Anecdotal — single dramatic case OR pre-2020 study OR synthesis without sample sizes | Pre-2018 exit-intent +300–600% claims |
| **1–2** | Directional hunch, no evidence | "Adding emojis should help engagement" |

---

## Practical procedure for scoring Confidence

1. **Open `_shared/benchmarks/patterns.json`** and search for the pattern_id matching your recommendation.
2. Read the `evidence[]` array. For each entry:
   - Check `confidence` field (high/med/low)
   - Check `vertical` — does it match the user's vertical? If no, *downgrade* by 1–2 points
   - Check `year` — is it 2023 or newer? If pre-2020, *downgrade* by 1
   - Check `sample_size` — is it ≥ 1000? If unknown or <200, downgrade
3. Check `prerequisites[]` — does the user's situation meet them?
   - If yes, lock in the score from step 2
   - If unclear, downgrade by 1
   - If clearly NO, downgrade by 2–3 (or mark as anti-pattern)
4. Check `anti_patterns[]` — is the user about to do one of these?
   - If yes, flag risk in `risks[]` and consider whether the change is net-positive

---

## Common scoring mistakes to avoid

**Don't anchor Confidence on the *headline* lift number.** Docsend's +260% from customer logos was a single audience-perfect outlier — `customer_logos_landing` in the benchmark library still has confidence:"med" because the broader DoWhatWorks A/B aggregate shows logos LOST in most tests.

**Don't anchor Confidence on familiarity.** "I've recommended testimonials a hundred times" is not evidence. Anchor on the structured citations in the benchmark library.

**Do downgrade when prerequisites are unverified.** If you don't know whether the user's audience recognizes their customer logos, don't score Confidence > 5 on "add customer logos" — you have no basis for the prerequisite.

**Do upgrade when multiple specialists agree.** If `page-cro` and `copywriting` independently flag the same change with citations to different sources, that's stronger evidence than either alone.

---

## Linked priors

- For the realistic base-rate distributions to anchor Impact against, see `_shared/frameworks/base-rate-priors.md`.
- For the negative-evidence patterns that should DROP Confidence, see `_shared/frameworks/anti-patterns.md`.
