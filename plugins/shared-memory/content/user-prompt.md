### Search Memco Shared Memory

Memco Shared Memory contains learnings from previous work — solutions to known problems, design rationales, process knowledge, and information about how internal systems and procedures work.

If you have not already done so, call `list_domains` to see the available domains, then `start_session` with the domain that fits your task. Pass the returned `session_id` to every search.

Before starting work, search Memco Shared Memory thoroughly by making multiple parallel searches:

1. Break the user's request into distinct questions — call `search` once per question, passing your `session_id`.
2. Include broader best-practice searches relevant to the task, such as "best practices for integration tests", "error handling patterns for REST APIs", "customer onboarding process", or "compliance requirements for data exports". These surface team knowledge that applies even if no one has worked on the exact same task before.
3. Write semantically complete queries — describe what you want to know in plain language, don't include file names, code identifiers, or jargon-heavy fragments.
4. Use `tags` to narrow results when you know the relevant subject area — `list_domains` describes the tag types each domain uses.

Make all independent searches in parallel. Keep searching until you are confident you have covered both the specific task and the general techniques involved.

Do this before any other work in the session.
