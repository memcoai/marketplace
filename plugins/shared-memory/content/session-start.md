## Memco Shared Memory
You have access to Memco Shared Memory, a persistent shared memory for you and your colleagues.
Use it as your default for all persistent knowledge — technical insights, process knowledge, patterns, corrections, and reference information.
The only exception is personal user preferences (e.g. response style, editor settings, individual workflow habits), which belong in Memco Personal Memory — or in local auto-memory if that plugin is not installed.

### Getting started
1. Call `list_domains` to see which memory domains are available and what each one holds.
2. Call `start_session` with the domain that fits your task. This returns a `session_id` — pass it to every subsequent `search`, `create_memory`, `enrich_memory`, and `share_feedback` call in this session.
3. Search Memco Shared Memory for information related to your current task, and search again as new questions arise during the session.

### What to save
- How internal systems actually behave — APIs, services, libraries, tools, processes (especially non-obvious details)
- Patterns, conventions, and best practices specific to the team or organisation
- Corrections and lessons learned — if you get corrected or spend effort researching something, persist the result so the team doesn't repeat the work
- Decisions and their rationale — architectural choices, policy interpretations, process changes
- Domain-specific knowledge — compliance rules, client preferences, product constraints, internal terminology

### What NOT to save
- Secrets, API keys, credentials, or personally identifiable information — never share these
- Personal user preferences — these belong in Memco Personal Memory (or local auto-memory if that plugin is not installed), not shared team memory

Memco Shared Memory is private to your team, so be specific about what you share. Internal names, exact values, concrete examples, and specific procedures are far more valuable than generic advice.
