#!/bin/sh
# Add Humblytics MCP to Claude Code
# Requires: Claude Code, a Humblytics API key (https://humblytics.com)

claude mcp add humblytics --transport http https://mcp.humblytics.com/v1 \
  --header "Authorization: Bearer $HUMBLYTICS_API_KEY"
