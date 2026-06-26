#!/usr/bin/env bash
#
# Install the Spark plugin into a local Cursor setup, straight from this repo.
#
# Works on ANY Cursor plan (Free / Pro included). It uses Cursor's local-plugins
# directory (~/.cursor/plugins/local/<plugin>) rather than a Team Marketplace,
# which is gated to Teams/Enterprise admins. The result is identical to the
# marketplace install: the full plugin — MCP server + hooks — is loaded.
#
# Quick start:
#   curl -fsSL https://raw.githubusercontent.com/memcoai/marketplace/main/cursor-install.sh | bash
#
# Options (environment variables):
#   SPARK_PLUGIN=spark-mcp            plugin to install (default; or spark-team-mcp)
#   SPARK_MARKETPLACE_REF=main        branch or tag to install from
#   SPARK_MARKETPLACE_REPO=<url>      override the source repo
#   CURSOR_HOME=~/.cursor             override Cursor's home directory
#
set -euo pipefail

REPO="${SPARK_MARKETPLACE_REPO:-https://github.com/memcoai/marketplace.git}"
REF="${SPARK_MARKETPLACE_REF:-main}"        # branch or tag
PLUGIN="${SPARK_PLUGIN:-spark-mcp}"         # or spark-team-mcp
PLUGIN_SUBDIR="plugins/${PLUGIN}"

CURSOR_HOME="${CURSOR_HOME:-${HOME}/.cursor}"
DEST="${CURSOR_HOME}/plugins/local/${PLUGIN}"

command -v git >/dev/null 2>&1 || { echo "error: git is required" >&2; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

echo "Fetching ${PLUGIN} from ${REPO}@${REF} ..."
# Try a shallow + sparse clone so we only pull the one plugin folder. Fall back
# to a plain shallow clone on older gits / servers without partial-clone support.
if git clone --depth 1 --branch "${REF}" --filter=blob:none --sparse "${REPO}" "${tmp}/repo" >/dev/null 2>&1; then
  ( cd "${tmp}/repo" && git sparse-checkout set "${PLUGIN_SUBDIR}" >/dev/null 2>&1 )
else
  git clone --depth 1 --branch "${REF}" "${REPO}" "${tmp}/repo" >/dev/null 2>&1
fi

SRC="${tmp}/repo/${PLUGIN_SUBDIR}"
if [ ! -f "${SRC}/.cursor-plugin/plugin.json" ]; then
  echo "error: plugin manifest not found at ${PLUGIN_SUBDIR}/.cursor-plugin/plugin.json" >&2
  echo "       (is SPARK_PLUGIN='${PLUGIN}' a real plugin in the marketplace repo?)" >&2
  exit 1
fi

echo "Installing to ${DEST} ..."
mkdir -p "${DEST%/*}"
rm -rf "${DEST}"
mkdir -p "${DEST}"
cp -R "${SRC}/." "${DEST}/"          # the trailing /. copies dotfiles too

# Hook scripts must stay executable.
if [ -d "${DEST}/scripts" ]; then
  find "${DEST}/scripts" -type f -name '*.sh' -exec chmod +x {} +
fi

VERSION="$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "${DEST}/.cursor-plugin/plugin.json" | head -n1)"

echo
echo "✓ Installed Spark plugin '${PLUGIN}'${VERSION:+ (v${VERSION})} to:"
echo "    ${DEST}"
echo
echo "Next steps in Cursor:"
echo "  1. Reload: Cmd/Ctrl+Shift+P → 'Developer: Reload Window'  (or restart Cursor)"
echo "  2. Open Cursor Settings → Plugins to confirm 'Spark' is listed"
echo "  3. Authenticate Spark in the browser when prompted (OAuth)"
