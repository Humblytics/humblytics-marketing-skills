# Humblytics Marketing Skills

A collection of CRO and marketing agent skills for AI coding assistants. Built for the [Humblytics](https://humblytics.com) analytics platform and following the [Agent Skills](https://agentskills.io) specification.

These skills work with **Claude Code**, **Cursor**, **Windsurf**, **Cline**, and any AI assistant that supports the Agent Skills spec.

## Skills

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

## Installation

### Claude Code

Add this repository as a skill source in your Claude Code configuration:

```bash
# Clone the repo
git clone https://github.com/Humblytics/humblytics-marketing-skills.git

# Or reference skills directly in your project's AGENTS.md
```

### Cursor / Windsurf / Other Assistants

Copy the relevant `SKILL.md` files into your project's `.cursor/skills/` or equivalent directory, or point your assistant at this repository.

## Live-data skills — connect the Humblytics MCP

The five live-data skills read your analytics through the **Humblytics MCP server** — a remote [Model Context Protocol](https://modelcontextprotocol.io) server that exposes ~36 tools (`get_traffic_summary`, `query_funnel`, `create_split_test`, `get_ads_attribution`, the Meta/Google connection tools, and more). The skills call these tools directly; there is no API key to paste into a URL and no base URL to manage — the MCP handles auth, routing, and property resolution.

| | |
|---|---|
| **Server name** | `humblytics` |
| **URL** | `https://mcp.humblytics.com/v1` |
| **Transport** | Streamable HTTP |
| **Auth headers** | `Authorization: Bearer $HUMBLYTICS_API_KEY` and `X-Humblytics-Property-Id: $HUMBLYTICS_PROPERTY_ID` |

### 1. Get your key

Sign up at [app.humblytics.com](https://app.humblytics.com) and grab your **API key** + **Property ID** from **Dashboard > Settings > API**. Your key looks like `hmb_…`.

> **Your API key is a secret.** Keep it out of `CLAUDE.md`, `.cursorrules`, `AGENTS.md`, chat messages, and anything committed to git. Store it in an environment variable and reference it as `$HUMBLYTICS_API_KEY`. Put the two lines in a gitignored `.env` (`cp .env.example .env`) and `source .env` before you register the server.

### 2. Register the server

**Claude Code**

```bash
claude mcp add humblytics --transport http https://mcp.humblytics.com/v1 \
  --header "Authorization: Bearer $HUMBLYTICS_API_KEY" \
  --header "X-Humblytics-Property-Id: $HUMBLYTICS_PROPERTY_ID"
```

**Cursor / Windsurf / Cline** (and any client with remote HTTP MCP support) — add to your MCP config (e.g. `.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "humblytics": {
      "url": "https://mcp.humblytics.com/v1",
      "headers": {
        "Authorization": "Bearer ${HUMBLYTICS_API_KEY}",
        "X-Humblytics-Property-Id": "${HUMBLYTICS_PROPERTY_ID}"
      }
    }
  }
}
```

**Codex CLI** — add to `~/.codex/config.toml`:

```toml
[mcp_servers.humblytics]
url = "https://mcp.humblytics.com/v1"
http_headers = { "Authorization" = "Bearer ${HUMBLYTICS_API_KEY}", "X-Humblytics-Property-Id" = "${HUMBLYTICS_PROPERTY_ID}" }
```

### 3. Verify

Ask your agent to list the `humblytics` server's tools (you should see ~36) and call `get_traffic_realtime` with no arguments. If tools don't appear, confirm `$HUMBLYTICS_API_KEY` is set in the environment the client launched from and reload the client.

The fastest path is the dashboard: when you create an API key, the **key-created dialog** on the API Access page gives you a one-click "Copy MCP setup prompt" you can paste straight into your agent.

> The context-only skills (page-cro, email-sequences, seo-strategist, marketing-strategist, copywriting, ad-expert, content-strategist) work without any connection. `ad-expert` will additionally pull live spend and attribution through the `humblytics` MCP when it's connected, but doesn't require it.

### Meta Ads and Google Ads — three paths

#### Path A — Humblytics connectors (preferred, read-only)

Connect Meta Ads and Google Ads once at **Connectors** in the Humblytics dashboard. Skills then read campaign metadata, daily insights, ad creative, and full-funnel revenue attribution through Humblytics' managed connections — using the same `HUMBLYTICS_API_KEY` you already set up. No Meta App Review, no Google Ads developer token. `revenue-attributor` and `ad-expert` use this path by default. **Read-only** — connectors don't let agents pause campaigns or change budgets.

#### Path B — Meta CLI (read + write)

When the agent needs to *manage* campaigns (pause laggards, shift budget), use Meta's official `meta ads` CLI (released April 29, 2026). It's a published, supported tool that creates resources in `PAUSED` status by default. Scope the access token to a single ad account, store it in `.env` (never `CLAUDE.md`), and review every campaign before flipping it active. Skills hand off to the CLI for write actions; they don't call it directly.

#### Path C — Don't roll your own

**Do not give the agent direct Meta Marketing API access through a system user on an unapproved developer app.** Routing production API traffic through a draft or unpublished Meta App — regardless of how the access token was issued — is how ad accounts, including long-standing ones with seven-figure spend, are getting permanently banned. Meta is actively enforcing against unapproved-app API traffic. Use Path A or Path B above. The only safe DIY route is a Meta Developer App with the Marketing API product and **full App Review completed** for the permissions you need (e.g. `ads_read`) — budget weeks for review.

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
