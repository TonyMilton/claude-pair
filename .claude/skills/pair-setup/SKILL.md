---
name: pair-setup
description: Enable agent teams in the current project by configuring .claude/settings.local.json
allowed-tools: Read, Edit, Write, Bash
---

# Pair Setup Skill

Enable agent teams for the current project so `/pair` can work here.

## What to do

1. Check if `.claude/settings.local.json` exists in the current working directory
2. If it exists, read it and check whether `env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` is already set to `"1"`
   - If already set, tell the user: "Agent teams already enabled in this project."
   - If not set, merge `"CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"` into the existing `env` object (create the `env` key if missing), preserving all other settings
3. If the file doesn't exist, create it with:
   ```json
   {
     "env": {
       "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
     }
   }
   ```
4. Tell the user: "Agent teams enabled. You can now use `/pair` in this project."
