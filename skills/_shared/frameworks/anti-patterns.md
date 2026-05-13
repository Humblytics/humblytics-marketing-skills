# Anti-patterns: when "best practice" backfires

The biggest single learning from the May 2026 research pass: for every canonical CRO best practice, there is a documented counter-context where it underperforms or actively hurts conversions. Read this file before recommending any of the patterns below as a default — the prerequisite check matters more than the recipe.

Full evidence lives in `_shared/benchmarks/patterns.json`. This file is the human-readable summary.

---

## Customer logos on landing pages

**Common advice:** Add a strip of customer logos above the fold.

**Counter-evidence:**
- DoWhatWorks aggregate (Dropbox, Jotform, Navan): **customer logos LOST in most A/B tests** when prerequisites unmet. All three kept the no-logo variant.
- Lift range when prerequisites fail: **[-15%, +5%]** — net-zero to negative.

**Prerequisites that have to be true for logos to lift:**
1. Logos represent brands the prospect *recognizes and trusts*
2. Audience segment matches: enterprise prospects see enterprise logos; SMB prospects see SMB logos
3. Limited to ~5–8 highest-recognition logos, not a 30-logo wall
4. Placed near the CTA, not in the footer

**When it works:** Docsend +260% — but that was enterprise selling to enterprise with audience-matched logos. Single outlier; don't generalize.

**Default prior:** null-to-negative unless segment match is verified.

---

## "Free" in CTA copy

**Common advice:** Use "Free Trial" / "Free Demo" / "Get it Free" — the word "free" universally lifts CTAs.

**Counter-evidence:**
- **Unbounce platform-wide** (~thousands of pages): CTAs *without* "free" outperform CTAs *with* "free" by **−16.8%** (10.79% vs 9.24% CVR).
- **CXL email test**: no-"free" version got **+17% CTR** vs the "free" version.
- The famous Corcentric +99.42% from "Free Demo" is the outlier, not the rule. Context-dependent.

**Prerequisites for "free" to help:**
1. Audience is price-sensitive consumers or SMBs
2. Product genuinely has a free tier or trial
3. "Free" isn't competing with other trust signals in the same CTA

**When it hurts:** Enterprise/sophisticated buyers — "free" signals low-stakes / hobbyist product. Use specific value language ("Save 23 hours/week") instead.

---

## Hero video on landing pages

**Common advice:** Add an autoplay product video to the hero — video lifts engagement.

**Counter-evidence:**
- **Device Magic SaaS**: image slider **beat the hero-video variant by +35%** on signup CVR and +31% on downstream conversions.
- **CXL e-com case**: static beat video 3.92% vs 0.85% lift.
- **Baymard**: **59% of users skip product videos entirely.**
- **Mobile load-time math**: 1s delay = -7% CVR; 3s = -20%. Hero video must overcome ~15-20% baseline CVR loss before netting positive.

**Prerequisites for hero video to lift:**
1. Desktop-dominant traffic (mobile is the kill zone)
2. Site loads fast enough that video doesn't add >1s to LCP
3. Auto-play silently with captions (not auto-play-with-audio — Unbounce + Harvard accessibility both prohibit it)
4. Video is short (<30s) and shows product, not company

**Default prior:** Net-negative on mobile-heavy sites. Test against static control before shipping.

---

## Manufactured urgency / perpetual countdown timers

**Common advice:** Add a countdown timer — urgency boosts conversion.

**Counter-evidence:**
- **Detected fake urgency reduces customer lifetime value by 15–40%.** A +20% short-term CVR lift can be net-negative on a CLTV basis.
- **B2B SaaS pricing-page countdowns frequently backfire** — buying committees read them as vendor desperation.
- FTC scrutiny: perpetual countdowns ("Sale ends in 2h" that resets) are increasingly legally risky.

**Prerequisites for urgency to help (and not hurt long-term):**
1. The deadline is *genuine* — real expiry, not a perpetual reset
2. Sub-24-hour timer, above the fold
3. Audience is consumer / SMB (not enterprise procurement)
4. You're measuring CLTV, not just immediate CVR

**Anti-pattern:** Perpetual reset countdown timers. Always net-negative once retention costs are accounted for.

---

## Trust badges (SSL seals, Norton, McAfee)

**Common advice:** Add security badges near checkout — they reduce purchase anxiety.

**Counter-evidence:**
- **Baymard longitudinal research**: a homemade padlock icon outperformed most real SSL seals (Thawte, GeoTrust, Comodo). **Brand recognition, not actual certification, drives lift.**
- Norton beat technically identical DigiCert sister-brands by ~20× — brand awareness math, not security math.
- **Get Elastic**: prominent security badges *decreased* conversions in some cases by amplifying anxiety rather than alleviating it.
- The "famous Blue Fountain Media negative test" widely cited as proof badges hurt is actually mis-cited — original is from Get Elastic.

**Prerequisites for trust badges to lift:**
1. Audience recognizes the badge brand (Norton, PayPal, BBB)
2. Placed where users have already started feeling anxious (checkout, not landing)
3. B2C / ecommerce context — B2B SaaS gains are smaller (+10–20% per SaaS Hero compliance-badge data)

**Anti-pattern:** Unbranded "secure!" graphics that look like clip art. Strict negative.

---

## "Always multi-step" forms

**Common advice:** Split long forms into steps — perceived effort drops, completion rises.

**Counter-evidence:**
- **Baymard 2024**: step count exerts substantially less impact than total field count. An 11-field three-step checkout typically beats a 15-field three-step checkout.
- **HubSpot**: 11 → 4 fields = **+120%** — dwarfs any architectural multi-step lift.
- **Formstack 2026**: multi-step abandonment 82.4% vs single-page 68%. Stepping without field reduction hurts.

**Prerequisites for multi-step to help:**
1. You first reduced fields to the minimum
2. Each step has a clear logical group (contact info, then preferences, then payment)
3. Visible accurate progress indicator (see anti-pattern below on velocity)

**Default order:** Reduce fields first. Step only if the form is still long after reduction.

---

## Slow-to-fast progress bars

**Common advice:** Progress bars reduce form abandonment.

**Counter-evidence:**
- **NIH RCT (p<.001)**: slow-to-fast progress bars (start slow, accelerate) nearly **double form abandonment** — 21.8% breakoff vs 11.3% for fast-to-slow.
- Constant-speed bars produce zero lift over no feedback at all (14.4% vs 12.7%).
- **Velocity design beats truthfulness or placement** as the dominant variable.

**Prerequisite:** Progress bar must accelerate visibly — early progress should feel fast, with the bar slowing as it approaches 100%. This matches the perceived-effort curve.

**Anti-pattern:** Progress bar that starts at 5% after the first field and stalls. Worse than no bar.

---

## Mobile exit-intent modals

**Common advice:** Trigger an exit-intent popup on cart-abandon mobile sessions.

**Counter-evidence:**
- **Architectural failure**: mobile has no cursor → no mouseleave event → no genuine exit signal. Alternative triggers (scroll-up, back-button) have unacceptable false-positive rates.
- **Google's mobile intrusive interstitial penalty** demotes mobile pages with full-screen popups.
- Pre-2018 case studies showing +300–600% lift are non-replicable today (Venture Harbour) — users have habituated.

**Prerequisite for exit-intent to work:**
1. Desktop traffic only
2. Lead-magnet or content-gate offer (not discount, which trains discount-seeking behavior)
3. Mobile config must explicitly disable the popup

**Anti-pattern:** Time-triggered "exit-intent" popups on mobile. Disable entirely.

---

## Hamburger menu on task-oriented mobile SaaS

**Common advice:** Use a hamburger menu on mobile to save space.

**Counter-evidence + nuance:**
- **NN/g multi-study**: hamburger reduces discoverability on task-oriented apps (Spotify hamburger → bottom-tab = **+9% interactions, +30% menu-item interactions**).
- **But — Amazon's hamburger beat dropdown** in a GoodUI A/B leak. Browse-heavy ecom with deep catalogs absorbs the discoverability penalty differently.

**Site type is load-bearing:**
- Task-oriented B2B SaaS → bottom-tab nav wins
- Browse-heavy ecom with hundreds of categories → hamburger can win

**Default prior:** Bottom-tab for SaaS, but test before changing on ecom.

---

## Generic / polished testimonials

**Common advice:** Add customer testimonials to build trust.

**Counter-evidence:**
- DoWhatWorks: generic short testimonials ("absolutely perfect") consistently underperform.
- Stock photos with names like "John, CEO" actively *hurt* trust compared to no testimonial.
- Anonymized "a satisfied customer" framing reduces conversion.

**Prerequisites for testimonials to lift:**
1. Real name + real photo + company name + job title
2. *Specific quantified result* ("cut WordPress costs $2k/month within Q1") — not "great service"
3. Audience industry/company-size matches the testimonial source
4. Dated within ~18 months (2021–2022 dates signal neglect)

---

## Headline rewrites (calibration, not anti-pattern)

**Common advice:** "Headlines are the highest-leverage CRO lever."

**Counter-evidence (base rate):**
- 73-test study: **only ~31% of headline variants beat the control.** ~69% produce no significant lift or regress.
- Most "headline wins" in case studies are confounded with value-prop, layout, and supporting-copy changes.

**Implication:** When recommending a headline rewrite, anchor on the 31% base rate, not on the +104% best-case outliers. Frame as: *"There's roughly a 1-in-3 chance a rewrite will beat the control with meaningful effect."*

---

## Use this with

- `_shared/frameworks/base-rate-priors.md` — realistic priors on test win rate and lift magnitude
- `_shared/frameworks/preflight-checklist.md` — what to verify before recommending any of the above
- `_shared/benchmarks/patterns.json` — full structured library with citations
