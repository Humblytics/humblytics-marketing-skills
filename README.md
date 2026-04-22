# AI Marketing Skills

A collection of CRO and marketing agent skills for AI coding assistants. Built for the [Humblytics](https://humblytics.com) analytics platform and following the [Agent Skills](https://agentskills.io) specification.

These skills work with **Claude Code**, **Cursor**, **Windsurf**, **Cline**, and any AI assistant that supports the Agent Skills spec.

## Skills

### Live-data skills (connect to Humblytics API)

| Skill | Description |
|-------|-------------|
| [cro-optimizer](skills/cro-optimizer/SKILL.md) | Conversion rate optimization using live Humblytics analytics data |
| [ab-test-generator](skills/ab-test-generator/SKILL.md) | Generate and launch A/B tests from analytics and heatmap data |
| [heatmap-analyst](skills/heatmap-analyst/SKILL.md) | Click, scroll, and rage-click heatmap analysis with UX friction recommendations |
| [revenue-attributor](skills/revenue-attributor/SKILL.md) | Connect Meta/Google ad spend to Stripe revenue — ROAS rankings and reallocation |
| [funnel-reporter](skills/funnel-reporter/SKILL.md) | End-to-end SaaS funnel reporting from Humblytics data |

### Marketing & content skills

| Skill | Description |
|-------|-------------|
| [page-cro](skills/page-cro/SKILL.md) | Page-level conversion audits and optimization recommendations |
| [email-sequences](skills/email-sequences/SKILL.md) | Multi-email drip campaigns — onboarding, nurture, re-engagement, abandoned cart |
| [seo-strategist](skills/seo-strategist/SKILL.md) | Keyword research, content gaps, on-page and technical SEO audits |
| [marketing-strategist](skills/marketing-strategist/SKILL.md) | Full-stack marketing: funnels, GTM, positioning, growth strategy |
| [copywriting](skills/copywriting/SKILL.md) | Conversion copywriting for landing pages, emails, and ads |
| [ad-expert](skills/ad-expert/SKILL.md) | Paid advertising across Meta, Google, TikTok, LinkedIn, YouTube |
| [content-strategist](skills/content-strategist/SKILL.md) | Multi-format content strategy: articles, newsletters, social, video, SEO |

## Installation

### Claude Code

Add this repository as a skill source in your Claude Code configuration:

```bash
# Clone the repo
git clone https://github.com/nicholasmorgan/ai-marketing-skills.git

# Or reference skills directly in your project's AGENTS.md
```

### Cursor / Windsurf / Other Assistants

Copy the relevant `SKILL.md` files into your project's `.cursor/skills/` or equivalent directory, or point your assistant at this repository.

## API-Connected Skills

Several skills connect to the Humblytics API for live data. Before using them:

1. Sign up at [app.humblytics.com](https://app.humblytics.com) and grab your API key + Property ID from **Dashboard > Settings > API**
2. Copy the template: `cp .env.example .env`
3. Fill in `HUMBLYTICS_API_KEY` (and optionally `HUMBLYTICS_PROPERTY_ID`) in `.env`
4. Load it into your shell before running the agent: `source .env` (or use `direnv`, or add the exports to your shell profile)

The `.env` file is gitignored by convention — **never commit it**, and **never paste API keys directly into the agent chat**. Skills read credentials from the environment; that's the only safe path.

See the [Humblytics Agent Documentation](https://app.humblytics.com/agent.md) for the full API reference.

### Meta Ads and Google Ads

None of the skills in this repo call Meta Ads or Google Ads APIs directly. `revenue-attributor` asks you to paste spend data from your Ads Manager dashboards and pairs it with Humblytics attribution — no Meta App Review or Google Ads developer token required.

**Do not give the agent direct Meta Marketing API access through a system user on an unapproved developer app.** Routing production API traffic through a draft or unpublished Meta App — regardless of how the access token was issued — is how ad accounts, including long-standing ones with seven-figure spend, are getting permanently banned. Meta is actively enforcing against unapproved-app API traffic.

If you want to automate ad-spend ingestion later, it is out of scope for this repo and requires real platform setup:
- **Meta Ads**: a Meta Developer App with the Marketing API product and **full App Review completed** for the permissions you need (e.g. `ads_read`). Draft/unpublished apps pulling production data is the exact pattern being banned. Budget weeks for review.
- **Google Ads**: a Google Ads developer token (Basic for low-volume, Standard for production), OAuth on a manager account, and the developer token attached to every request.

## Security

These skills never include hardcoded API keys or credentials. Every API-connected skill reads credentials from environment variables only. Never commit `.env` files or paste keys into agent chat — both leak credentials into logs, transcripts, or version history.

## Resources

- [Humblytics Skills Directory](https://humblytics.com/skills) - Browse all available skills
- [Humblytics Agent Docs](https://app.humblytics.com/agent.md) - API reference for AI agents
- [Agent Skills Spec](https://agentskills.io) - The open specification these skills follow
- [Humblytics Docs](https://docs.humblytics.com/api) - Full API documentation

## Contributing

1. Fork this repository
2. Create a new skill directory under `skills/`
3. Write a `SKILL.md` following the Agent Skills spec format
4. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

Copyright 2026 Humblytics, Inc.
