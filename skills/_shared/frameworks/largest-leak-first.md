# Largest leak first

A CRO principle: rank fixes by **absolute people lost**, not by **drop-off percentage**. Bigger leaks at the top of the funnel often dwarf bigger percentage drops at the bottom.

---

## The math

A 50% drop-off at 100 visitors = **50 people lost**.
A 10% drop-off at 10,000 visitors = **1,000 people lost**.

The 10% drop is the larger leak by 20×, even though the percentage is far smaller.

---

## Why this matters

Most CRO skills default to flagging the **highest percentage drop-off** in a funnel. That's the wrong ranking for a brand-new analysis. The right ranking is:

1. **Compute absolute drop-off per step** (visitors entered − visitors exited)
2. **Rank steps by absolute people lost**
3. **Multiply each by the average revenue per converted user** to get $ exposure per fix
4. **THEN apply ICE** to compare against effort

This usually changes the priority order. Common reshuffles:

- A top-of-funnel page with 70% bounce rate on 50k visits (35,000 lost) outranks a checkout step with 90% drop on 200 visits (180 lost) — even though the checkout looks "worse" in percentage terms.
- A high-volume landing page with a 5% relative drop in CVR (from 4.2% → 4.0%) outranks a low-volume pricing page that already converts at 18%.

---

## When the percentage IS the right ranking

- When two steps have **comparable absolute volume** — then percentage *is* a fair comparison
- When you're measuring **rate of change**, not magnitude (e.g., "step 3 CVR dropped 8pp over the last month")
- For **segment-level diagnostics** (mobile vs desktop within the same step)

---

## How to apply in a skill

In every funnel-style analysis (`funnel-reporter`, `cro-optimizer`, `heatmap-analyst`):

1. Pull the per-step counts via `getAnalytics` / `runFunnel` / equivalent
2. Compute `absolute_loss_per_step = step_in_count - step_out_count`
3. Identify the step with `max(absolute_loss)` — call it out as the **primary opportunity**
4. ONLY THEN sort the other steps by `relative_drop_pct` for the secondary list

In reports, phrase it as:

> Your largest absolute leak is **/pricing → /signup**: 1,240 of 1,800 visitors don't proceed (68.9% drop). The /signup → /paid step has a higher percentage drop (84%) but only affects 47 of 56 visitors — fixing it is worth 17× less revenue.

---

## Use this with

- `_shared/frameworks/percentile-framing.md` — frame the loss against vertical baselines for context
- `_shared/frameworks/preflight-checklist.md` — confirm time range and traffic volume before ranking
