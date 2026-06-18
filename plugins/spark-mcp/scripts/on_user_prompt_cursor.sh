#!/usr/bin/env bash
# Hook: beforeSubmitPrompt (Cursor)
#
# Wraps on_user_prompt.sh and converts its plain-text output into Cursor's
# expected JSON: {"continue":true,"user_message":"<text>"}. `continue` is always
# true — this hook only adds guidance, it never blocks the prompt.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_json.sh"

TEXT=$("$SCRIPT_DIR/on_user_prompt.sh" 2>/dev/null || echo "")
if [ -z "$TEXT" ]; then
  echo '{"continue":true}'
  exit 0
fi

msg=$(printf '%s' "$TEXT" | spark_json_escape)
printf '{"continue":true,"user_message":"%s"}\n' "$msg"

exit 0
