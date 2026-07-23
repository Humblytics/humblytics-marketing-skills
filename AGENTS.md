# AGENTS.md

Guidelines for AI agents working in this repository.

## Repository Purpose

This repository contains Agent Skills for CRO and marketing workflows that integrate with the Humblytics analytics platform. Each skill is a self-contained markdown file under `skills/<skill-name>/SKILL.md`.

## Security Rules

- NEVER hardcode API keys, secrets, tokens, or credentials in any file
- ALWAYS read credentials from environment variables (`$HUMBLYTICS_API_KEY`) — do NOT ask the user to paste keys into chat, since that persists them in transcripts
- Direct users to `.env.example` → `.env` → `source .env` when credentials are missing
- NEVER commit `.env` files or any file containing real credentials
- When referencing API keys in examples, use placeholders like `your_api_key_here` or `$HUMBLYTICS_API_KEY`

## Skill File Format

Every `SKILL.md` must include YAML frontmatter:

```yaml
---
name: skill-name
description: When to use this skill (1-1024 chars). Include trigger phrases.
metadata:
  version: 1.0.0
  author: Humblytics
---
```

Followed by markdown content with these sections:
- Purpose
- When to Use
- Before You Start (prerequisites, context gathering)
- Core workflow or principles
- Related Skills

## Humblytics MCP

Skills that use live data call the **Humblytics MCP server** — they invoke `mcp__humblytics__*` tools, never raw HTTP. There is no base URL or `curl` in the skills.

- **Server name**: `humblytics`
- **URL**: `https://mcp.humblytics.com/mcp` (Streamable HTTP, ~36 tools)
- **Auth**: sent as connection headers — `Authorization: Bearer $HUMBLYTICS_API_KEY` and `X-Humblytics-Property-Id: $HUMBLYTICS_PROPERTY_ID`. Set once when the server is registered (see the repo README), not per call.
- **Property**: the MCP auto-resolves the property for a single-property key; for a multi-property key, call `list_properties` and pass the matching `propertyId`.
- **Tools**: traffic (`get_traffic_summary`, `get_traffic_trends`, `get_traffic_breakdown`, `get_entry_exit_pages`, `get_traffic_realtime`), pages (`get_pages_breakdown`, `get_page_details`), clicks/forms (`get_clicks_breakdown`, `get_clicks_details`, `get_forms_breakdown`, `get_forms_details`), funnels (`query_funnel`, `get_funnel_sankey`, `get_funnel_suggestions`, `list_saved_funnels`, `save_funnel`), split tests (`get_split_test_recommendations`, `create_split_test`, `list_split_tests`, `get_split_test`, `update_split_test`, `stop_split_test`), ads (`get_ads_attribution` + the `list_meta_*`/`get_meta_*` and `list_google_ads_*`/`get_google_ads_connection` tools).
- **Docs**: https://docs.humblytics.com

The user must connect the MCP with their own API key + property ID. Never accept a key pasted into chat, and never write the literal key into a committed file — it belongs in the MCP connection headers (from `$HUMBLYTICS_API_KEY`). If the `humblytics` MCP tools aren't available, stop and point the user at the README's "connect the Humblytics MCP" section.

## Writing Style

- Be direct and actionable, not theoretical
- Use frameworks and mental models, not vague advice
- Include specific examples where possible
- Reference related skills when workflows overlap
- Write for experienced marketers who want execution speed, not education

## File Structure

```
ai-marketing-skills/
  README.md
  AGENTS.md
  LICENSE
  skills/
    cro-optimizer/SKILL.md          (API)
    ab-test-generator/SKILL.md      (API)
    heatmap-analyst/SKILL.md        (API)
    revenue-attributor/SKILL.md     (API)
    funnel-reporter/SKILL.md        (API)
    page-cro/SKILL.md
    email-sequences/SKILL.md
    seo-strategist/SKILL.md
    marketing-strategist/SKILL.md
    copywriting/SKILL.md
    ad-expert/SKILL.md
    content-strategist/SKILL.md
```
