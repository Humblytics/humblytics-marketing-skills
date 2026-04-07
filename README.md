# AI Marketing Skills

A collection of CRO and marketing agent skills for AI coding assistants. Built for the [Humblytics](https://humblytics.com) analytics platform and following the [Agent Skills](https://agentskills.io) specification.

These skills work with **Claude Code**, **Cursor**, **Windsurf**, **Cline**, and any AI assistant that supports the Agent Skills spec.

## Skills

| Skill | Description |
|-------|-------------|
| [cro-optimizer](skills/cro-optimizer/SKILL.md) | Conversion rate optimization using live Humblytics analytics data |
| [ab-test-generator](skills/ab-test-generator/SKILL.md) | Generate and launch A/B tests from analytics and heatmap data |
| [marketing-strategist](skills/marketing-strategist/SKILL.md) | Full-stack marketing: funnels, GTM, copy, email, growth |
| [funnel-reporter](skills/funnel-reporter/SKILL.md) | End-to-end SaaS funnel reporting from Humblytics data |
| [ad-expert](skills/ad-expert/SKILL.md) | Paid advertising across Meta, Google, TikTok, LinkedIn, YouTube |
| [content-strategist](skills/content-strategist/SKILL.md) | Multi-format content strategy: articles, newsletters, social, video, SEO |
| [page-cro](skills/page-cro/SKILL.md) | Page-level conversion audits and optimization recommendations |
| [copywriting](skills/copywriting/SKILL.md) | Conversion copywriting for landing pages, emails, and ads |

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

1. Sign up at [app.humblytics.com](https://app.humblytics.com)
2. Get your API key from **Dashboard > Settings > API**
3. Set the `HUMBLYTICS_API_KEY` environment variable
4. Find your Property ID in **Dashboard > Settings > API**

See the [Humblytics Agent Documentation](https://app.humblytics.com/agent.md) for the full API reference.

## Security

These skills never include hardcoded API keys or credentials. Every skill that requires API access instructs the user to provide their own credentials via environment variables. Never commit API keys to version control.

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
