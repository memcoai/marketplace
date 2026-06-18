#!/usr/bin/env bash
# Hook: UserPromptSubmit (Claude Code / Codex)
#
# Emits the "search Spark before you work" reminder as plain text, injected into
# the agent's context on each prompt.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_content.sh"

spark_user_prompt_text

exit 0
