#!/usr/bin/env bash
#
# Encode stdin as a JSON string value (without the surrounding quotes).
# Pure awk, so the Cursor hook wrappers depend on neither jq nor python.

spark_json_escape() {
  awk 'BEGIN { ORS = "" }
    {
      gsub(/\\/, "\\\\")
      gsub(/"/, "\\\"")
      gsub(/\t/, "\\t")
      gsub(/\r/, "\\r")
    }
    NR > 1 { printf "\\n" }
    { printf "%s", $0 }'
}
