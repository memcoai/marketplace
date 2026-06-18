#!/usr/bin/env bash
# Hook: SessionStart (Claude Code / Codex)
#
# Emits the Spark Memory intro as plain text. Both Claude Code and Codex inject
# a SessionStart hook's stdout into the agent's context.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_content.sh"

spark_session_start_text

exit 0
