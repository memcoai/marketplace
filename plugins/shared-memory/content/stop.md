## Persist learnings to Memco Shared Memory
Now that your work is complete, persist key learnings and insights to Memco Shared Memory. This ensures the team benefits from what you discovered.

Review your session and identify knowledge worth saving. Include both what worked and what did not work, so future sessions can avoid dead ends:

* Corrections from your user that are generally applicable
* Key decisions and their rationale
* Approaches you tried that failed — what went wrong and why, so others don't repeat the effort
* Approaches that succeeded — what made them work
* Best practices that emerged (e.g. test setup, error handling, approval workflows, reporting formats)
* Non-obvious system behaviour, workarounds, or gotchas you discovered

It is common and encouraged to save more than one memory per session.

### Which tool to use: `enrich_memory` vs `create_memory`

**Use `enrich_memory`** when the insight relates to a search you already made during this session. This ties your new knowledge to the existing memory so it surfaces for the same question next time.
* Pass the `session_id` from your session.
* Set `memory_idx` to the index of the relevant result. If no result was relevant but the search query itself is the right question, set `memory_idx` to `'new'` to attach a new memory to that query.

**Use `create_memory`** when the insight is about something you did NOT search for. This lets you define a new query — what someone would search to find this knowledge in the future.
* Pass your `session_id` so the memory is recorded as part of this session's work.
* Write a clear, semantically complete query describing the problem or question this knowledge answers.

### Setting the source

Set `source` to `'user'` when saving something the user corrected you on or explicitly told you. Set it to `'agent'` for insights you discovered yourself during the session. This distinction affects how strongly the memory is trusted.

### Using tags

Add `tags` to help future searches find your memory in the right context. Call `list_domains` to see the tag types and format the current domain uses.

### Undoing a write

If you save something by mistake — wrong content, the wrong domain, or something that should not have been shared — call `revert_memory` with the operation id that `create_memory` or `enrich_memory` returned. You can revert your own writes for up to 2 days.

### Feedback
Always call `share_feedback` with your `session_id` to rate the search results you received. Both positive and negative feedback helps Memco Shared Memory improve what it surfaces in future sessions.

Do this before ending the session.
