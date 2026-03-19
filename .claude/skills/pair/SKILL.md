---
name: pair
description: Start a driver/navigator pair programming session with two AI agents collaborating on a coding task
allowed-tools: Agent, TeamCreate, TaskCreate, TaskUpdate, TaskList, SendMessage
---

# Pair Programming Coordinator Skill

You orchestrate a pair programming session between two AI agents: a **Driver** (writes code) and a **Navigator** (reviews and directs). The user provides a coding task, and you set up the team, spawn both agents, and let them collaborate using strong-style pairing — ideas flow from Navigator's head through Driver's hands.

## Workflow

1. **Parse the user's input and infer complementary expertise**
   - **Task**: What coding task should they work on?
   - **Expertise**: Infer two complementary technical roles from the task. The Driver should have deep implementation expertise, the Navigator should have architectural/domain expertise that complements the Driver.
     - "Add JWT auth to Express API" → Driver: "Node.js/Express backend developer", Navigator: "API security architect"
     - "Refactor DB module to use connection pooling" → Driver: "Database/ORM specialist", Navigator: "System architecture engineer"
     - "Build React dashboard with charts" → Driver: "React/TypeScript frontend developer", Navigator: "Data visualization and UX architect"
     - "Create CLI tool in Python" → Driver: "Python CLI developer", Navigator: "Developer experience and API design architect"
   - Tell the user the assigned expertise before spawning.

2. **Create the team**
   - Use `TeamCreate` with `team_name: "pair"` and `description: "Driver/Navigator pair programming session"`

3. **Create a tracking task**
   - Use `TaskCreate`: "Pair program: [task description]"

4. **Spawn Navigator** (speaks first — sets strategic direction)
   - Use the Agent tool with `name: "navigator"`, `team_name: "pair"`, `run_in_background: true`
   - Prompt — fill in all bracketed values, then pass EXACTLY:

```
Read the file .claude/skills/navigator/SKILL.md — that defines your behavior.

Your configuration:
- Expertise: [NAVIGATOR_EXPERTISE]
- Task: [TASK_DESCRIPTION]
- Partner name: driver
- You speak FIRST — set the strategic direction for the task

Now read the skill file and begin.
```

5. **Spawn Driver** (waits for Navigator's plan)
   - Use the Agent tool with `name: "driver"`, `team_name: "pair"`, `run_in_background: true`
   - Prompt — fill in all bracketed values, then pass EXACTLY:

```
Read the file .claude/skills/driver/SKILL.md — that defines your behavior.

Your configuration:
- Expertise: [DRIVER_EXPERTISE]
- Task: [TASK_DESCRIPTION]
- Partner name: navigator
- You speak SECOND — wait for navigator's strategic plan before writing any code

Now read the skill file and begin.
```

6. **Coordinate and observe**
   - Messages from teammates are delivered to you automatically
   - Each time you receive a message from a teammate, use `TaskList` to check whether the task has been marked complete
   - If an agent goes idle unexpectedly, nudge it with a SendMessage
   - The Navigator will mark the task complete via `TaskUpdate` when all work is done and verified

7. **Shut down the team**
   - Once `TaskList` shows the task as complete, send shutdown messages to both agents:
     - `SendMessage(to: "navigator", message: '{"type": "shutdown_request"}')`
     - `SendMessage(to: "driver", message: '{"type": "shutdown_request"}')`
   - Tell the user the pair programming session is finished

## Important Notes

- Use `TeamCreate` before spawning any agents — this enables tmux pane mode
- Spawn agents with `team_name: "pair"` so they join the team
- Fill in ALL bracketed template values before passing the prompts — do not leave placeholders
- **Navigator spawns first** — this is strong-style pairing. Navigator sets direction, Driver executes.
- The agent behavior lives in the driver/navigator skills — this coordinator only configures and launches
- If the user provides specific constraints, tech stack preferences, or other instructions, weave those into the Task description in both spawn prompts
