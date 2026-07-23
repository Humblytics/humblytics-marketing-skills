# Humblytics MCP

Give Claude, Cursor and other AI agents access to your live website analytics and experiments — so they can find conversion problems, recommend tests, implement tracking and evaluate results.

**Endpoint:** `https://mcp.humblytics.com/v1`

## Prerequisites

You need a [Humblytics](https://humblytics.com) account on the Plus plan or higher. Once signed up, grab your API key from **Dashboard → Utilities → API**.

## Connect in 30 seconds

### Claude Code

```bash
claude mcp add humblytics --transport http https://mcp.humblytics.com/v1 \
  --header "Authorization: Bearer $HUMBLYTICS_API_KEY"
```

### Cursor

Add to `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "humblytics": {
      "url": "https://mcp.humblytics.com/v1",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY"
      }
    }
  }
}
```

### VS Code (GitHub Copilot)

Add to `.vscode/mcp.json`:

```json
{
  "servers": {
    "humblytics": {
      "type": "http",
      "url": "https://mcp.humblytics.com/v1",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY"
      }
    }
  }
}
```

### Any MCP client (generic)

```
Transport:     Streamable HTTP
URL:           https://mcp.humblytics.com/v1
Auth header:   Authorization: Bearer <your-api-key>
```

## What your agent can do

Once connected, your agent has 37 tools covering everything in the Humblytics API:

### Analytics
Fetch traffic summaries, trends, realtime visitors, page breakdowns, click maps, form analytics, entry/exit pages, and multi-property aggregations.

### Funnels
Query any funnel, get Sankey visualisations, fetch AI-generated funnel suggestions, and manage saved funnels.

### A/B testing
Get experiment recommendations, create and manage split tests, retrieve results.

> `create_split_test` activates immediately — your agent will present recommendations before creating anything.

### Ads attribution
Pull full-funnel revenue attribution connecting Meta/Google ad spend to Stripe conversions.

### Ads connections (read-only)
Access Google Ads and Meta campaign metadata, daily insights, ad creative, and campaign performance — through Humblytics' managed connectors. No Meta App Review or Google developer token required.

### Properties
`list_properties` discovers every site your API key can access — useful when you manage multiple properties.

## Authentication

Your API key is account-level: one key covers every property you have access to. Pass it as `Authorization: Bearer <key>` on each request. The server stores nothing.

If your key covers multiple properties, call `list_properties` first to get the `propertyId` for the site you want to work with, then pass it explicitly on subsequent tool calls.

## Skill prompts

The server also exposes 12 marketing skill prompts. Five connect to your live Humblytics data automatically; the rest are standalone strategy and copy skills.

| Prompt | Live data |
|---|---|
| `cro-optimizer` | ✅ |
| `ab-test-generator` | ✅ |
| `heatmap-analyst` | ✅ |
| `revenue-attributor` | ✅ |
| `funnel-reporter` | ✅ |
| `page-cro` | — |
| `email-sequences` | — |
| `seo-strategist` | — |
| `marketing-strategist` | — |
| `copywriting` | — |
| `ad-expert` | — |
| `content-strategist` | — |

Skill prompts appear in your MCP client's prompt picker. The `_shared` CRO benchmark library and reasoning frameworks are also exposed as MCP resources.

## Example prompts

```
What pages are losing the most visitors this week?
```

```
Suggest an A/B test for my pricing page based on current scroll and click data.
```

```
Which Meta campaigns have the best revenue attribution this month?
```

```
Run the funnel-reporter skill for my /signup flow.
```

## Skills (standalone, no MCP required)

The `skills/` directory contains the same 12 skills as plain markdown files following the [Agent Skills](https://agentskills.io) spec. They work with Claude Code, Cursor, Windsurf, Cline, and any assistant that supports the spec — without needing the MCP server.

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

To use live-data skills directly (outside the MCP server), set `HUMBLYTICS_API_KEY` in your environment. Get your key from **Dashboard → Utilities → API**.

## Security

API keys are passed at request time and never stored by the server. Never commit keys to version control or paste them into agent chat.

## Resources

- [Sign up for Humblytics](https://humblytics.com)
- [Humblytics Dashboard](https://app.humblytics.com)
- [API Documentation](https://docs.humblytics.com/api)
- [Agent Skills Spec](https://agentskills.io)

## Source availability

The Humblytics MCP is a hosted commercial service. This repository contains public integration documentation, skill prompts, and configuration examples. The production server implementation is proprietary and is not distributed through this repository.

## License

MIT License — see [LICENSE](LICENSE) for details.

Copyright 2026 Humblytics, Inc.
