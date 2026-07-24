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

### Live-data skills (connect to the Humblytics MCP)

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

### Installing the standalone skills

**Claude Code** — clone the repo, or reference the skills directly from your project's `AGENTS.md`:

```bash
git clone https://github.com/Humblytics/humblytics-marketing-skills.git
```

**Cursor / Windsurf / other assistants** — copy the relevant `SKILL.md` files into your project's `.cursor/skills/` (or equivalent) directory, or point your assistant at this repository.

### Connecting the live-data skills

The five live-data skills call the `humblytics` MCP tools directly — register the server as described in [Connect in 30 seconds](#connect-in-30-seconds) and they work as-is. There is no API key to paste into a URL and no base URL to manage; the MCP handles auth, routing, and property resolution.

If you manage several properties, you can pin one for the whole connection by adding an optional `X-Humblytics-Property-Id: $HUMBLYTICS_PROPERTY_ID` header alongside the `Authorization` header, instead of passing `propertyId` per tool call. Copy `.env.example` to a gitignored `.env` and `source` it before registering the server.

> **Your API key is a secret.** Keep it out of `CLAUDE.md`, `.cursorrules`, `AGENTS.md`, chat messages, and anything committed to git. Store it in an environment variable and reference it as `$HUMBLYTICS_API_KEY`.

To verify, ask your agent to list the `humblytics` server's tools and call `get_traffic_realtime` with no arguments. If tools don't appear, confirm `$HUMBLYTICS_API_KEY` is set in the environment the client launched from, then reload the client.

> The context-only skills (page-cro, email-sequences, seo-strategist, marketing-strategist, copywriting, ad-expert, content-strategist) work without any connection. `ad-expert` will additionally pull live spend and attribution through the `humblytics` MCP when it's connected, but doesn't require it.

## Meta Ads and Google Ads — three paths

### Path A — Humblytics connectors (preferred, read-only)

Connect Meta Ads and Google Ads once at **Connectors** in the Humblytics dashboard. Skills then read campaign metadata, daily insights, ad creative, and full-funnel revenue attribution through Humblytics' managed connections — using the same `HUMBLYTICS_API_KEY` you already set up. No Meta App Review, no Google Ads developer token. `revenue-attributor` and `ad-expert` use this path by default. **Read-only** — connectors don't let agents pause campaigns or change budgets.

### Path B — Meta CLI (read + write)

When the agent needs to *manage* campaigns (pause laggards, shift budget), use Meta's official `meta ads` CLI (released April 29, 2026). It's a published, supported tool that creates resources in `PAUSED` status by default. Scope the access token to a single ad account, store it in `.env` (never `CLAUDE.md`), and review every campaign before flipping it active. Skills hand off to the CLI for write actions; they don't call it directly.

### Path C — Don't roll your own

**Do not give the agent direct Meta Marketing API access through a system user on an unapproved developer app.** Routing production API traffic through a draft or unpublished Meta App — regardless of how the access token was issued — is how ad accounts, including long-standing ones with seven-figure spend, are getting permanently banned. Meta is actively enforcing against unapproved-app API traffic. Use Path A or Path B above. The only safe DIY route is a Meta Developer App with the Marketing API product and **full App Review completed** for the permissions you need (e.g. `ads_read`) — budget weeks for review.

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
