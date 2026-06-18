#!/usr/bin/env bash
# Hook: sessionStart (Cursor)
#
# Wraps on_session_start.sh and converts its plain-text output into Cursor's
# expected JSON: {"additional_context":"<text>"}.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_json.sh"

TEXT=$("$SCRIPT_DIR/on_session_start.sh" 2>/dev/null || echo "")
if [ -z "$TEXT" ]; then
  echo '{}'
  exit 0
fi

ctx=$(printf '%s' "$TEXT" | spark_json_escape)
printf '{"additional_context":"%s"}\n' "$ctx"

exit 0
