# AGENTS.md

Guidelines for AI agents working in this repository.

## Repository Purpose

This repository contains Agent Skills for CRO and marketing workflows that integrate with the Humblytics analytics platform. Each skill is a self-contained markdown file under `skills/<skill-name>/SKILL.md`.

## Security Rules

- NEVER hardcode API keys, secrets, tokens, or credentials in any file
- ALWAYS use environment variables (`$HUMBLYTICS_API_KEY`) or prompt the user for credentials
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

## Humblytics API

Skills that connect to Humblytics use:
- **Base URL**: `https://app.humblytics.com/api/external/v1`
- **Auth**: Bearer token via `HUMBLYTICS_API_KEY` environment variable
- **Docs**: https://docs.humblytics.com/api

The user must always provide their own API key and property ID.

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
    cro-optimizer/SKILL.md
    ab-test-generator/SKILL.md
    marketing-strategist/SKILL.md
    funnel-reporter/SKILL.md
    ad-expert/SKILL.md
    content-strategist/SKILL.md
    page-cro/SKILL.md
    copywriting/SKILL.md
```
