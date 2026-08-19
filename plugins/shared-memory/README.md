# Memco Shared Memory

Persistent, shared memory for your team's AI agents. Search before you work; persist what
you learn — so when one agent works something out, every agent knows it.

Knowledge saved by one agent is available to every other agent on the team, across sessions
and across tools. The plugin works on **Claude Code**, **Codex**, **Cursor**, **Devin**, and
**Grok**.

- Plugin name: `shared-memory`
- Marketplace: [`memcoai/marketplace`](https://github.com/memcoai/marketplace)
- Homepage: [spark.memco.ai](https://spark.memco.ai)

## Install

```bash
# Claude Code
/plugin marketplace add memcoai/marketplace
/plugin install shared-memory@memco

# Codex
codex plugin marketplace add memcoai/marketplace
codex plugin add shared-memory@memco

# Devin
git clone https://github.com/memcoai/marketplace
devin plugins install ./marketplace/plugins/shared-memory
```

On **Cursor**, Free and Pro users can install straight into the local plugins directory:

```bash
curl -fsSL https://raw.githubusercontent.com/memcoai/marketplace/main/cursor-install.sh | bash
```

Authenticate in the browser when prompted (OAuth). See the
[marketplace README](../../README.md) for the Teams/Enterprise route and install options.

## What it provides

| Component | Path | Purpose |
| --- | --- | --- |
| MCP server | `.mcp.json` | The `memco-shared-memory` tools: search and save memories |
| Skill | `skills/shared-memory/` | When and how to search and save |
| Hooks | `hooks/` | Injects guidance at session start, on each prompt, and before the turn ends |

### The tools

Provided by the MCP server at `https://spark.memco.ai/mcp`:

| Tool | Purpose |
| --- | --- |
| `list_domains` | Which memory domains exist, what each holds, and the tags it uses |
| `start_session` | Start a session for a domain; returns a `session_id` |
| `search` | Search a domain for existing knowledge |
| `create_memory` | Save something new |
| `enrich_memory` | Extend a memory a search returned |
| `share_feedback` | Rate a search's results |
| `revert_memory` | Undo one of your own writes, within 2 days |

Pass the `session_id` from `start_session` to every subsequent `search`, `create_memory`,
`enrich_memory`, and `share_feedback` call so the work is recorded as one series.

## Per-host layout

Each host reads its own manifest and hook file. The prompt text lives once, in
`content/*.md`, and every host's hooks `cat` the same files.

| Host | Manifest | MCP config | Hooks |
| --- | --- | --- | --- |
| Claude Code | `.claude-plugin/plugin.json` | `.mcp.json` | `hooks/hooks.json` |
| Codex | `.codex-plugin/plugin.json` | `.codex-mcp.json` | `hooks/codex-hooks.json` |
| Cursor | `.cursor-plugin/plugin.json` | `.cursor-mcp.json` | — (not yet wired) |
| Devin | `.devin-plugin/plugin.json` | `.devin-mcp.json` | `hooks/devin-hooks.json` |
| Grok | `.grok-plugin/plugin.json` | `.mcp.json` | reads `hooks/hooks.json` |

Hosts differ in two ways only: how the plugin root is spelled in a hook command, and whether
the MCP config carries a `type` field — Cursor, Codex, and Devin infer the transport from
`url` alone.

| Host | Plugin root in a hook command |
| --- | --- |
| Claude Code | `${CLAUDE_PLUGIN_ROOT}` |
| Codex | `${PLUGIN_ROOT}` |
| Grok | `${GROK_PLUGIN_ROOT}`, with `${CLAUDE_PLUGIN_ROOT}` set as an alias |
| Devin | `${PLUGIN_ROOT:-.}` — no plugin-root variable is documented for hook commands, so this uses one if present and otherwise falls back to a path relative to the working directory |

### Hook coverage

Hooks are a convenience layer; the MCP server and the skill are what carry the plugin. Where
a host ignores hook output, the skill still applies.

- **Claude Code** — all four events inject.
- **Codex, Devin** — same schema as Claude; stdout injection is assumed but unverified.
- **Grok** — hook stdout is ignored for passive events, so the hooks are inert by design.
  They are left in place so the plugin starts working if that changes.
- **Cursor** — hooks require JSON on stdout rather than plain text, so they are not wired.

## Editing the prompts

All hook text lives in `content/`:

| File | Fires |
| --- | --- |
| `session-start.md` | Session start |
| `subagent-start.md` | A subagent starts |
| `user-prompt.md` | Each prompt submitted |
| `stop.md` | Before the turn ends |

Hooks are a plain `cat` of these files, so editing the copy needs no JSON escaping and no
script changes. `cat` was chosen over a Node script deliberately: a Windows developer is far
more likely to have WSL, Git Bash, or MSYS2 than a Node runtime, and PowerShell aliases `cat`
to `Get-Content`.

## Network and credentials

The plugin talks to exactly one endpoint, `https://spark.memco.ai/mcp`, over HTTPS.
Authentication is OAuth in the browser on first use — no API keys are stored in the repo and
no credentials are read from the machine. The hooks run `cat` on files inside the plugin
directory and nothing else.

## License

MIT. See [LICENSE](../../LICENSE).
