#!/usr/bin/env bash
# Hook: stop (Cursor)
#
# Wraps on_stop.sh into a Cursor `followup_message`, which auto-submits as the
# next user turn so the agent runs its persist-to-Spark pass before stopping.
#
# Guard: fire only once, after a clean completion. Cursor passes `loop_count`
# (incremented each time this hook re-triggers the agent) and `status` on stdin.
# `loop_limit` in cursor-hooks.json is the backstop.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_json.sh"

INPUT=$(cat 2>/dev/null || echo "")

loop_count=$(printf '%s' "$INPUT" | grep -o '"loop_count"[[:space:]]*:[[:space:]]*[0-9]\+' | grep -o '[0-9]\+$' | head -n1)
loop_count=${loop_count:-0}
status=$(printf '%s' "$INPUT" | grep -o '"status"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/' | head -n1)
status=${status:-completed}

# Only nudge once, and only when the agent finished cleanly.
if [ "$loop_count" -ne 0 ] || { [ -n "$status" ] && [ "$status" != "completed" ]; }; then
  printf '{}\n'
  exit 0
fi

TEXT=$("$SCRIPT_DIR/on_stop.sh" 2>/dev/null || echo "")
if [ -z "$TEXT" ]; then
  printf '{}\n'
  exit 0
fi

msg=$(printf '%s' "$TEXT" | spark_json_escape)
printf '{"followup_message":"%s"}\n' "$msg"

exit 0
