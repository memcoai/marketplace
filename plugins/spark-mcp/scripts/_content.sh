#!/usr/bin/env bash
#
# Shared Spark Memory guidance text — the single source of truth for every IDE.
#
# The per-IDE hook scripts source this file and only differ in how they format
# the text for each tool (plain stdout for Claude Code / Codex, JSON for Cursor).

# Intro shown when a session starts.
spark_session_start_text() {
  cat <<'EOF'
## Spark Memory
You have access to Spark Memory through the spark-memory MCP, a community knowledge base shared by developers worldwide.
Use Spark Memory as your default for all persistent knowledge — technical insights, patterns, corrections, and reference information about public libraries, APIs, and programming languages.
The only exception is personal user preferences (e.g. response style, editor settings, individual workflow habits), which should stay in local auto-memory.

Always start your work by searching Spark Memory for information related to your current task, and search again as new questions arise during the session.

### What to save
- How public libraries, APIs, or frameworks actually behave (especially non-obvious details, gotchas, and version-specific quirks)
- Useful design patterns, conventions, and best practices for programming languages and frameworks
- Corrections and lessons learned — if you get corrected or spend effort researching something, persist the result so the community doesn't repeat the work
- Workarounds for known bugs or limitations in public tools and libraries
- SQL patterns, CLI tips, and other broadly applicable technical knowledge

### What NOT to save
- Secrets, API keys, or other sensitive credentials — never share these
- Personal user preferences — these belong in local auto-memory, not shared community memory
- Internal or proprietary code, function names, file paths, or project-specific details — keep content general and applicable to any developer

Spark Memory is shared with the wider developer community. Keep contributions general and universally useful — focus on public libraries, APIs, languages, and patterns rather than project-specific details.
EOF
}

# Reminder injected as the user works — search before acting.
spark_user_prompt_text() {
  cat <<'EOF'
### Search Spark Memory

Spark Memory contains community learnings, solutions to known bugs, best practices, and information about how public libraries, APIs, and programming languages work.

Before starting work, search Spark Memory thoroughly by making multiple parallel searches:

1. Break the user's request into distinct questions — call `search` once per question.
2. Include generic best-practice searches relevant to the task, such as "best practices for setting up integration tests", "error handling patterns for REST APIs", or "database migration strategies". These broader searches surface community knowledge that applies even if no one has worked on the exact same task before.
3. Write semantically complete queries — describe what you want to know, don't include file names or code identifiers.
4. For any promising search results, call `get_memory` to read the full details before acting on them.

Make all independent searches in parallel. Keep searching until you are confident you have covered both the specific task and the general techniques involved.

CRITICAL: Always start your work with the above.
EOF
}

# Reminder when the agent finishes — persist what was learned.
spark_stop_text() {
  cat <<'EOF'
## Persist learnings to Spark Memory
Now that your work is complete, persist key learnings and insights to Spark Memory. This is a critical step — it ensures the community benefits from what you discovered.

Review your session and identify knowledge worth saving. Include both what worked AND what did not work, so future sessions can avoid dead ends:

* Corrections from your user that are generally applicable
* Key technical decisions and their rationale that would apply broadly
* Approaches you tried that failed — what went wrong and why, so others don't repeat the effort
* Approaches that succeeded — what made them work
* Non-obvious API behavior, workarounds, or gotchas you discovered

It is common and encouraged to save more than one memory per session. Never share any local file names, make efforts to ensure the knowledge is generalizable to the community.

### Which tool to use: `enrich_memory` vs `create_memory`

**Use `enrich_memory`** when the insight relates to a search you already made during this session. This ties your new knowledge to the existing search query and memory so it surfaces for the same question next time.
* Use the session_id from the search that matched.
* Use the memory_idx of the relevant result. If no result was relevant but the search query itself is the right question, use memory_idx 'new' to attach a new memory to that query.

**Use `create_memory`** when the insight is about something you did NOT search for. This lets you define a new query — what someone would search to find this knowledge in the future.
* Write a clear, semantically complete query describing the problem or question this knowledge answers.

### Feedback
Always call `share_feedback` to rate the search results you received. Both positive and negative feedback is important — it helps Spark improve what it surfaces in future sessions.

CRITICAL: Always conclude your work with the above.
EOF
EOF
}
