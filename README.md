# pair

AI-to-AI pair programming using Claude Code's agent teams. Two agents collaborate on coding tasks using the **strong-style pairing** model: a Navigator directs strategy while a Driver writes the code.

## How it works

**Strong-style pairing**: "For an idea to go from your head into the computer, it must go through someone else's hands."

1. **Navigator** analyzes the task and codebase, sends a strategic plan
2. **Driver** implements the plan, narrates what they did, shares key snippets
3. **Navigator** reads the actual files to verify, gives feedback, sets next direction
4. **Driver** fixes issues, implements next chunk
5. Repeat until done

The Navigator can only observe (Read/Glob/Grep) and communicate (SendMessage) — no editing, no commands. The Driver has full code manipulation tools. This enforces clean separation: Navigator thinks, Driver acts.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) with agent teams support

## Installation

```bash
git clone https://github.com/TonyMilton/claude-pair.git
cd pair
./install.sh
```

This installs the skills into `~/.claude/skills/` so they're available in any Claude Code session.

## Usage

First, enable agent teams in your project:

```
/pair-setup
```

Then start a session:

```
/pair Create a Node.js CLI that converts temperatures between Celsius and Fahrenheit
```

## What happens

1. The coordinator infers complementary expertise from your task
2. A Navigator and Driver agent spawn in separate tmux panes
3. Navigator speaks first with a strategic plan
4. They alternate — Navigator directs, Driver implements
5. You watch the conversation unfold in real time

## Installed skills

| Skill | Description |
|---|---|
| `/pair` | Coordinator — parses task, infers expertise, spawns and manages both agents |
| `/pair-setup` | Enables agent teams in the current project's `.claude/settings.local.json` |
| `driver` | Driver agent — implements code, runs verification, narrates changes |
| `navigator` | Navigator agent — reads codebase, reviews changes, directs strategy |

## Architecture

A coordinator skill spawns two background agents that communicate via `SendMessage`.

| | Navigator | Driver |
|---|---|---|
| **Role** | Thinks and directs | Implements and narrates |
| **Tools** | SendMessage, Read, Glob, Grep, TaskUpdate | SendMessage, Read, Glob, Grep, Bash, Edit, Write |
| **Speaks** | First (sets direction) | Second (executes plan) |
