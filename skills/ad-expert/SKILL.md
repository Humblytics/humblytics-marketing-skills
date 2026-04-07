---
name: ad-expert
description: "Expert in paid advertising across Meta (Facebook/Instagram), Google Ads, TikTok, LinkedIn, and YouTube. Specializes in ad ideation, creative concepting, copywriting, audience targeting, campaign structure, and performance optimization. Use when creating ad campaigns, writing ad copy, designing audience targeting, planning ad creative, or optimizing ROAS. Triggers: ads, paid media, Facebook ads, Google ads, TikTok ads, LinkedIn ads, YouTube ads, ROAS, ad copy, audience targeting, campaign."
metadata:
  version: 1.0.0
  author: Humblytics
---

# Ad Expert

## Purpose

Plan, create, and optimize paid advertising campaigns across all major platforms. Covers the full lifecycle from strategy and audience research through creative development, copywriting, campaign structure, and performance optimization.

## When to Use

- Planning a new paid advertising campaign on any platform
- Writing ad copy (headlines, descriptions, primary text, CTAs)
- Designing audience targeting strategies
- Structuring campaigns, ad sets, and ad groups
- Creating creative briefs for ad visuals or video
- Optimizing existing campaigns for better ROAS
- Deciding budget allocation across platforms
- Researching competitor ad strategies

## Before You Start

1. **Understand the product/offer** — What is being advertised? What is the value proposition?
2. **Identify the goal** — Awareness, traffic, leads, sales, app installs?
3. **Define the audience** — Who is the ideal customer? Demographics, interests, behaviors, pain points.
4. **Budget** — What is the daily/monthly ad budget?
5. **Platform preference** — Does the user have a platform in mind, or should you recommend one?
6. **Existing data** — Any historical ad performance data? Humblytics analytics on landing page performance?
7. **Creative assets** — What images, videos, or brand assets are available?
8. **Look for context** — Check project docs for brand guidelines, tone of voice, and competitive positioning

## Platform Selection Guide

### Meta (Facebook + Instagram)

**Best for:** B2C, e-commerce, local businesses, SaaS with broad appeal, retargeting
**Audience size:** 3B+ monthly active users
**Strengths:** Visual storytelling, lookalike audiences, retargeting pixel, broad targeting with AI optimization
**Ad formats:** Single image, carousel, video, Stories, Reels, collection, lead forms
**Typical CPM:** $5-15 (varies by audience and objective)

**Campaign structure:**
```
Campaign (1 objective)
  └── Ad Set (audience + placement + budget)
       └── Ad (creative + copy)
```

**Best practices:**
- Use Advantage+ campaigns for e-commerce
- Broad targeting often outperforms narrow interest targeting (let Meta's AI optimize)
- Minimum 3-5 creatives per ad set for proper testing
- Use UTM parameters to track in Humblytics
- Optimize for the conversion event closest to revenue

### Google Ads

**Best for:** High-intent search capture, B2B, SaaS, local services, competitor conquesting
**Strengths:** Intent-based targeting, massive reach, diverse formats
**Ad types:** Search, Display, Shopping, Video (YouTube), Performance Max, Demand Gen

**Search campaign structure:**
```
Campaign (budget + settings)
  └── Ad Group (keyword theme)
       └── Keywords + Responsive Search Ad
```

**Best practices:**
- Start with exact and phrase match keywords
- Use negative keywords aggressively
- Write 15 headlines and 4 descriptions per RSA
- Include the keyword in at least 3 headlines
- Use ad extensions: sitelinks, callouts, structured snippets, call
- Bid on branded terms (competitors will)
- Track conversions via Humblytics integration or Google tag

### TikTok Ads

**Best for:** Gen Z/Millennial audiences, e-commerce, apps, brand awareness, viral content
**Strengths:** Low CPM, high engagement, native-feeling content
**Ad formats:** In-feed video, TopView, Spark Ads (boost organic), branded effects

**Best practices:**
- Ads must feel native — not polished, not corporate
- Hook in the first 1-2 seconds
- Use trending sounds and formats
- UGC-style content outperforms studio content
- Vertical video only (9:16)
- Keep videos 15-30 seconds
- Strong CTA in the last 3 seconds

### LinkedIn Ads

**Best for:** B2B, enterprise SaaS, recruiting, professional services, high-ticket offers
**Strengths:** Professional targeting (job title, company, industry, seniority)
**Ad formats:** Single image, carousel, video, text ads, message ads, document ads, lead gen forms
**Typical CPM:** $30-80 (expensive but highly targeted)

**Best practices:**
- Use job title + company size for targeting
- Lead gen forms convert better than landing page clicks
- Document ads (PDF carousels) get strong engagement
- Thought leadership content outperforms hard sells
- Retarget website visitors and video viewers
- Minimum budget: $50/day per campaign

### YouTube Ads

**Best for:** Brand awareness, education-based selling, retargeting, B2B and B2C
**Strengths:** Video storytelling, intent targeting, long-form engagement
**Ad formats:** Skippable in-stream, non-skippable, bumper (6s), Shorts, discovery

**Best practices:**
- Hook in the first 5 seconds (before skip button)
- Lead with the problem or a bold statement
- Target competitor channels and relevant content
- Use custom intent audiences (people who searched relevant terms)
- Retarget website visitors with testimonial/case study videos

## Ad Copy Frameworks

### PAS (Problem-Agitate-Solve)
1. **Problem**: State the pain clearly
2. **Agitate**: Make it worse, show consequences
3. **Solve**: Present your product as the answer

### AIDA (Attention-Interest-Desire-Action)
1. **Attention**: Pattern interrupt, bold claim
2. **Interest**: Relevant detail that hooks them
3. **Desire**: Benefits, proof, transformation
4. **Action**: Clear CTA

### Before/After/Bridge
1. **Before**: Their current painful state
2. **After**: Their desired state
3. **Bridge**: Your product is how they get there

### The 4U Headline Formula
- **Useful**: Is it beneficial to the reader?
- **Urgent**: Is there a reason to act now?
- **Ultra-specific**: Does it include concrete details?
- **Unique**: Is it differentiated from competitors?

## Creative Brief Template

When concepting ad creative:

```
Campaign: [name]
Platform: [Meta / Google / TikTok / LinkedIn / YouTube]
Objective: [awareness / traffic / leads / sales]
Target Audience: [ICP description]

Key Message: [one sentence]
Supporting Points: [2-3 bullet points]
Tone: [professional / casual / urgent / educational / entertaining]
CTA: [specific action]

Visual Direction:
- Format: [image / video / carousel / stories]
- Style: [UGC / polished / minimal / data-driven / testimonial]
- Must include: [logo, product screenshot, etc.]
- Avoid: [stock photos, competitor references, etc.]

Copy Variations:
- Headline A: [...]
- Headline B: [...]
- Primary text A: [...]
- Primary text B: [...]
```

## Budget Allocation Framework

For a new campaign with no historical data:

1. **Start with one platform** — Don't spread thin
2. **Allocate 70% to proven, 20% to testing, 10% to experiments**
3. **Minimum viable budget per platform:**
   - Meta: $20/day per ad set
   - Google Search: $30/day per campaign
   - TikTok: $20/day per ad group
   - LinkedIn: $50/day per campaign
   - YouTube: $30/day per campaign
4. **Test for 7-14 days** before making optimization decisions
5. **Scale winners by 20% every 3-5 days** (not more, to avoid audience fatigue)

## Output Format

When creating an ad campaign, deliver:

1. **Campaign Strategy** — Objective, platform, audience, budget
2. **Audience Targeting** — Detailed targeting setup per platform
3. **Ad Copy** — Multiple variations of headlines, descriptions, primary text
4. **Creative Brief** — Visual direction and format specifications
5. **Campaign Structure** — Campaigns, ad sets, ads hierarchy
6. **Tracking Setup** — UTM parameters, conversion events, Humblytics integration
7. **Optimization Plan** — What to measure, when to scale, when to kill

## Related Skills

- **copywriting** — Deep-dive into ad copy and landing page copy
- **marketing-strategist** — Broader channel strategy and funnel design
- **cro-optimizer** — Optimize the landing pages your ads drive traffic to
- **content-strategist** — Create organic content that complements paid campaigns
