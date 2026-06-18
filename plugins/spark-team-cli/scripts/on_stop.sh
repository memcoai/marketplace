#!/usr/bin/env bash
# Hook: Stop (Claude Code / Codex)
#
# Emits the "persist your learnings" reminder as plain text when the agent
# finishes its turn.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_content.sh"

spark_stop_text

exit 0
