---
name: shared-memory
description: >
  Use this skill whenever working on any task where the team may have relevant
  prior knowledge — coding, writing, research, analysis, customer work, process
  questions, compliance, onboarding, or any knowledge-intensive activity. Also
  use when the user corrects you, when you discover non-obvious behaviour in a
  system or process, or when you complete a task where the outcome would benefit
  future sessions. Search before you work; persist what you learn.
when-to-use: >
  At the start of any task, before researching or implementing something, and
  whenever an unfamiliar system, API, process, or convention comes up. Also when
  the user corrects you, when an approach fails, when you discover non-obvious
  behaviour, and when finishing a task worth recording. Triggers on: search
  memory, check memory, shared memory, team memory, what do we know about,
  has anyone done this before, save this, remember this, persist what you learned.
metadata:
  author: The Memory Company (Memco)
  short-description: Persistent shared memory for your team's agents
---

# Memco Shared Memory

You have access to **Memco Shared Memory** through the memco-shared-memory MCP server — a persistent, shared memory for you and your colleagues. Knowledge saved here is available to every agent on the team, across sessions.

## Starting a session

1. Call `list_domains` to see which memory domains are available and what each one holds.
2. Call `start_session` with the domain that fits your task. This returns a `session_id`.
3. Pass this `session_id` to every subsequent `search`, `create_memory`, `enrich_memory`, and `share_feedback` call.

## When to search

Search Memco Shared Memory **before starting any task** and again whenever new questions come up. Your colleagues may have already solved this problem, documented this process, or learned something that saves you from a dead end.

### How to search well

- Break the task into distinct questions. Call `search` once per question, in parallel, passing your `session_id`.
- Write semantically complete queries — describe what you want to know in plain language.
  - Good: "how to handle retry logic for payment webhooks"
  - Good: "client onboarding steps for enterprise accounts"
  - Bad: "retry" or "onboarding.ts"
- Include broader best-practice queries relevant to the task, not just the specific problem. These surface team knowledge that applies even when no one has tackled the exact same task.
- Use `tags` to narrow results when you know the relevant subject area — `list_domains` describes the tag types each domain uses and the format they take.

## When to save

After completing a task, review your session and persist anything the team would benefit from knowing:

- **Corrections**: your user corrected you on something generally applicable
- **Decisions and rationale**: why a particular approach, architecture, policy interpretation, or process was chosen
- **What failed**: approaches that didn't work, and why — so others skip the dead end
- **What succeeded**: what made an approach work, especially non-obvious factors
- **System behaviour**: how an API, tool, service, or internal process actually behaves (especially surprises, edge cases, workarounds)
- **Domain knowledge**: compliance rules, client preferences, product constraints, internal terminology, approval workflows

It is common and encouraged to save more than one memory per session.

### Which tool to use

**`enrich_memory`** — when the insight relates to a search you already made this session. Pass your `session_id` and set `memory_idx` to the index of the relevant result (or `'new'` if no result matched but the query is the right question).

**`create_memory`** — when the insight is about something you did NOT search for. Pass your `session_id` and write a clear query describing what someone would search to find this knowledge.

### Setting the source

Set `source` to `'user'` when saving something the user corrected you on or explicitly told you. Set it to `'agent'` for insights you discovered yourself. This distinction affects how strongly the memory is trusted.

### Using tags

Add `tags` to help future searches find your memory in the right context. Call `list_domains` to see the tag types and format the current domain uses.

### Reverting a memory

If you saved something by mistake — wrong content, wrong domain, or something that should not have been shared — call `revert_memory` with the `op_id` returned by the `create_memory` or `enrich_memory` call. You can only revert your own writes, and only within 2 days.

### Feedback

Always call `share_feedback` with your `session_id` to rate the search results you received. Both positive and negative ratings help improve what surfaces in future sessions.

## What NOT to save

- Secrets, API keys, credentials, or personally identifiable information
- Personal user preferences (these belong in local auto-memory)
