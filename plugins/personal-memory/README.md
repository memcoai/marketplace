# Memco Personal Memory

A private, portable memory of your preferences for your AI agents. Your agent loads how you
like to work at the start of every session, and saves durable preferences as it learns them.

Memco Personal Memory is yours alone — no one else can read it. Because it lives with your
account rather than on one machine, a preference learned in one tool is already there the next
time you open a session in another. The plugin works on **Claude Code**, **Codex**, **Cursor**,
**Devin**, and **Grok**.

- Plugin name: `personal-memory`
- Marketplace: [`memcoai/marketplace`](https://github.com/memcoai/marketplace)
- Homepage: [spark.memco.ai](https://spark.memco.ai)

## Install

```bash
# Claude Code
/plugin marketplace add memcoai/marketplace
/plugin install personal-memory@memco

# Codex
codex plugin marketplace add memcoai/marketplace
codex plugin add personal-memory@memco

# Grok
grok plugin marketplace add memcoai/marketplace
grok plugin install personal-memory --trust

# Devin
git clone https://github.com/memcoai/marketplace
devin plugins install ./marketplace/plugins/personal-memory
```

On **Cursor**, Free and Pro users can install straight into the local plugins directory:

```bash
curl -fsSL https://raw.githubusercontent.com/memcoai/marketplace/main/cursor-install.sh \
  | MEMCO_PLUGIN=personal-memory bash
```

Authenticate in the browser when prompted (OAuth). See the
[marketplace README](../../README.md) for the Teams/Enterprise route and install options.

## Relationship to Memco Shared Memory

Personal memory is yours; [shared memory](../shared-memory/README.md) is your team's. Install
both and they divide cleanly:

| | Memco Personal Memory | Memco Shared Memory |
| --- | --- | --- |
| Holds | How *you* like to work — response style, settings, workflow habits, personal context | Anything a teammate could reuse — how systems behave, why decisions were made, what failed |
| Readable by | You only | Your team |
| Answers | "How does this user want this done?" | "Has anyone solved this before?" |

Agents are told to prefer Memco Personal Memory over their own built-in or local memory, so
your preferences follow you between tools rather than being relearned in each one.

## What it provides

| Component | Path | Purpose |
| --- | --- | --- |
| MCP server | `.mcp.json` | The `memco-personal-memory` tools, at `https://spark.memco.ai/mcp-personal` |
| Skill | `skills/personal-memory/` | When and how to load and save preferences |
| Hooks | `hooks/` | Injects guidance at session start and on each prompt |

The first call in any session is `start_session`, which returns an index of what is already
known about you. Durable preferences are saved with `write_memory`, one preference per memory.

## Per-host layout

Each host reads its own manifest and hook file. The prompt text lives once, in `content/*.md`,
and every host's hooks `cat` the same files.

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

Two events are wired: session start, and each prompt submitted. Preferences must be loaded
before the first reply, and re-applied on every turn — the remaining lifecycle events do not
carry that job, so they are left alone.

Hooks are a convenience layer; the MCP server and the skill are what carry the plugin. Where a
host ignores hook output, the skill still applies.

- **Claude Code** — both events inject.
- **Codex, Devin** — same schema as Claude; stdout injection is assumed but unverified.
- **Grok** — hook stdout is ignored for passive events, so the hooks are inert by design. They
  are left in place so the plugin starts working if that changes.
- **Cursor** — hooks require JSON on stdout rather than plain text, so they are not wired.

## Editing the prompts

All hook text lives in `content/`:

| File | Fires |
| --- | --- |
| `session-start.md` | Session start |
| `user-prompt.md` | Each prompt submitted |

Hooks are a plain `cat` of these files, so editing the copy needs no JSON escaping and no
script changes. `cat` was chosen over a Node script deliberately: a Windows developer is far
more likely to have WSL, Git Bash, or MSYS2 than a Node runtime, and PowerShell aliases `cat`
to `Get-Content`.

## Network and credentials

The plugin talks to exactly one endpoint, `https://spark.memco.ai/mcp-personal`, over HTTPS.
Authentication is OAuth in the browser on first use — no API keys are stored in the repo and no
credentials are read from the machine. The hooks run `cat` on files inside the plugin directory
and nothing else.

## License

MIT. See [LICENSE](../../LICENSE).
