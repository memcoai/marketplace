#!/usr/bin/env bash
#
# Install memco plugins into a local Cursor setup, straight from this repo.
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
#   MEMCO_PLUGIN=shared-memory        which plugin to install; comma-separate to
#                                     install several in one run, e.g.
#                                     MEMCO_PLUGIN=shared-memory,personal-memory
#   MEMCO_MARKETPLACE_REF=main        branch or tag to install from
#   MEMCO_MARKETPLACE_REPO=<url>      override the source repo
#   CURSOR_HOME=~/.cursor             override Cursor's home directory
#
set -euo pipefail

REPO="${MEMCO_MARKETPLACE_REPO:-https://github.com/memcoai/marketplace.git}"
REF="${MEMCO_MARKETPLACE_REF:-main}"        # branch or tag
CURSOR_HOME="${CURSOR_HOME:-${HOME}/.cursor}"

# Space-separated plugin list. Plugin names are kebab-case with no spaces, so the
# word splitting this relies on below is safe.
PLUGINS="$(printf '%s' "${MEMCO_PLUGIN:-shared-memory}" | tr ',' ' ' | tr -s '[:space:]' ' ' | sed 's/^ *//; s/ *$//')"
[ -n "${PLUGINS}" ] || { echo "error: MEMCO_PLUGIN is empty" >&2; exit 1; }

command -v git >/dev/null 2>&1 || { echo "error: git is required" >&2; exit 1; }

# Subdirectories to pull, one per requested plugin.
SUBDIRS=""
for plugin in ${PLUGINS}; do
  SUBDIRS="${SUBDIRS} plugins/${plugin}"
done

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

echo "Fetching ${PLUGINS} from ${REPO}@${REF} ..."
# Try a shallow + sparse clone so we only pull the plugin folders we need. Fall
# back to a plain shallow clone on older gits / servers without partial-clone
# support.
if git clone --depth 1 --branch "${REF}" --filter=blob:none --sparse "${REPO}" "${tmp}/repo" >/dev/null 2>&1; then
  # shellcheck disable=SC2086  # deliberate word splitting; names have no spaces
  ( cd "${tmp}/repo" && git sparse-checkout set ${SUBDIRS} >/dev/null 2>&1 )
else
  git clone --depth 1 --branch "${REF}" "${REPO}" "${tmp}/repo" >/dev/null 2>&1
fi

# Read a top-level string field out of a plugin manifest.
manifest_field() {
  sed -n "s/.*\"$2\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$1" | head -n1
}

# Validate every requested plugin before copying any, so a typo in the second
# name does not leave the first half-installed.
for plugin in ${PLUGINS}; do
  if [ ! -f "${tmp}/repo/plugins/${plugin}/.cursor-plugin/plugin.json" ]; then
    echo "error: plugin manifest not found at plugins/${plugin}/.cursor-plugin/plugin.json" >&2
    echo "       (checked ${REPO}@${REF})" >&2
    exit 1
  fi
done

for plugin in ${PLUGINS}; do
  SRC="${tmp}/repo/plugins/${plugin}"
  DEST="${CURSOR_HOME}/plugins/local/${plugin}"

  echo "Installing to ${DEST} ..."
  mkdir -p "${DEST%/*}"
  rm -rf "${DEST}"
  mkdir -p "${DEST}"
  cp -R "${SRC}/." "${DEST}/"          # the trailing /. copies dotfiles too
done

echo
for plugin in ${PLUGINS}; do
  DEST="${CURSOR_HOME}/plugins/local/${plugin}"
  NAME="$(manifest_field "${DEST}/.cursor-plugin/plugin.json" displayName)"
  VERSION="$(manifest_field "${DEST}/.cursor-plugin/plugin.json" version)"
  echo "✓ Installed ${NAME:-${plugin}}${VERSION:+ (v${VERSION})} to:"
  echo "    ${DEST}"
done

echo
echo "Next steps in Cursor:"
echo "  1. Reload: Cmd/Ctrl+Shift+P → 'Developer: Reload Window'  (or restart Cursor)"
echo "  2. Open Cursor Settings → Plugins to confirm the plugin is listed"
echo "  3. Authenticate in the browser when prompted (OAuth)"
