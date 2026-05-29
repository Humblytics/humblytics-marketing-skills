# Preflight checklist for CRO-style skills

Before producing findings, every CRO-style skill should verify a short list of context items. Missing any of these in silence is the #1 cause of generic, low-confidence recommendations.

Cross-cutting standard adopted from the agent runtime's `STANDARD_PREFLIGHT`.

---

## The 5 required items

1. **Property / page URL identified**
   - For page-level skills: exact page URL or pattern
   - For funnel skills: the full ordered list of steps (URLs or events)
   - For copy/ad skills: where the copy will live and against what audience

2. **Time range and traffic volume in scope**
   - Default to last 7 days, but confirm — short campaigns, recent launches, and seasonal businesses warrant different windows
   - Get rough monthly traffic at the affected page/step — this gates whether a test is even *powerable* (see preflight item 5)

3. **Primary conversion goal**
   - "Increase signups" is vague — pick the specific event: trial start, demo booked, paid conversion, newsletter, add-to-cart
   - Confirm the *current measured rate* of this conversion if available

4. **Vertical and audience**
   - B2B SaaS / consumer SaaS / ecommerce / lead-gen / marketplace / other
   - Deal size: self-serve / SMB / mid-market / enterprise
   - This selects which benchmarks apply — enterprise B2B priors differ wildly from consumer ecom

5. **Statistical reachability**
   - If proposing an A/B test: roughly how long would it take to detect a meaningful lift at current traffic?
   - If the answer is >30 days, surface that — either narrow audience, accept higher MDE, or recommend non-experimental change (qualitative review, manual ship)

---

## Optional items (gather if relevant)

- **Device / segment split** — if the question involves mobile-specific behavior or comparing paid vs organic
- **Recent changes to the page** — a CVR drop in the last 14 days has different causes than a perennial low CVR
- **Current ad spend by channel** — for any LTV / CAC / ROAS reasoning
- **Cohort retention shape** — for SaaS pricing or freemium-vs-trial decisions

---

## How to use this in a skill

If any of the 5 required items is **missing AND would change the recommendation**, ask one focused question and pause. Don't volley back a generic answer.

If the user pushes for an answer despite missing context, **state the assumptions explicitly** before producing findings:

> Proceeding with assumptions:
> - Vertical: B2B SaaS (inferred from domain)
> - Goal: paid conversion (inferred from "$ on paid traffic" framing)
> - Traffic: assuming ≥5k monthly visits to the affected page
> 
> If any of these is wrong, results below may not apply.

This gives the user a clear way to correct without re-running the whole analysis.

---

## What NOT to ask in preflight

Don't ask things you can derive yourself:

- Don't ask the URL if you can read it from the request context
- Don't ask for the current CVR if you can pull it from `getAnalytics` / Humblytics API
- Don't ask "what's your goal?" 4 times — pick the highest-probability one and confirm

The preflight is for **context the data can't tell you** — vertical, deal size, recent strategic changes, audience awareness level.

---

## Use this with

- `_shared/frameworks/largest-leak-first.md` — once preflight is complete, use this to rank findings
- `_shared/frameworks/percentile-framing.md` — turn raw metrics into actionable percentile bands
- `_shared/benchmarks/baselines.json` — the vertical baselines that the audience answer in preflight selects from
