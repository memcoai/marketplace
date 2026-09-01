# memco Labs Marketplace

```
  ███╗   ███╗ ███████╗ ███╗   ███╗  ██████╗  ██████╗
  ████╗ ████║ ██╔════╝ ████╗ ████║ ██╔════╝ ██╔═══██╗
  ██╔████╔██║ █████╗   ██╔████╔██║ ██║      ██║   ██║
  ██║╚██╔╝██║ ██╔══╝   ██║╚██╔╝██║ ██║      ██║   ██║
  ██║ ╚═╝ ██║ ███████╗ ██║ ╚═╝ ██║ ╚██████╗ ╚██████╔╝ ██╗
  ╚═╝     ╚═╝ ╚══════╝ ╚═╝     ╚═╝  ╚═════╝  ╚═════╝  ╚═╝
```

Marketplace for [memco](https://memco.ai) plugins. It provides two memories for your AI
agents:

- **Memco Shared Memory** — a persistent shared memory for your team. Search before you work,
  persist what you learn, so when one agent works something out every agent knows it.
- **Memco Personal Memory** — a private, portable memory of your own preferences. Your agent
  loads how you like to work at the start of every session, so it follows you between tools
  instead of being relearned in each one.

Install either or both; they divide cleanly, with personal preferences on one side and
knowledge a teammate could reuse on the other. The same marketplace works across
**Claude Code**, **Codex**, **Cursor**, **Devin**, and **Grok**.

## Installation

The marketplace is hosted at [`memcoai/marketplace`](https://github.com/memcoai/marketplace).
Add it to your agent, then install [`shared-memory`](#memco-shared-memory),
[`personal-memory`](#memco-personal-memory), or both. Swap in any other plugin name from the
[list](#plugins) if you want one of the others.

### Claude Code

```bash
/plugin marketplace add memcoai/marketplace
/plugin install shared-memory@memco
/plugin install personal-memory@memco
```

### Codex

```bash
codex plugin marketplace add memcoai/marketplace
codex plugin add shared-memory@memco
codex plugin add personal-memory@memco
```

> You can also run `codex` and open `/plugins` to browse and install marketplace entries
> interactively.

### Grok

```bash
grok plugin marketplace add memcoai/marketplace
grok plugin install shared-memory --trust
grok plugin install personal-memory --trust
```

> Without `--trust`, Grok shows the source and warns that installing activates the plugin's
> hooks, MCP servers, and skills, then stops. You can also browse and install from the
> Plugins tab of the extensions modal (`/plugins`).

### Devin

Devin (the Cognition CLI, also shipped as **Windsurf**) installs plugins from a folder.
Clone the marketplace and install the plugin you want as a local plugin:

```bash
git clone https://github.com/memcoai/marketplace
devin plugins install ./marketplace/plugins/shared-memory
devin plugins install ./marketplace/plugins/personal-memory
```

Swap `shared-memory` for any plugin name from the [list](#plugins). For the MCP-based
plugins, authenticate in the browser when prompted (OAuth).

### Cursor

#### Free / Pro users (install script)

**Team Marketplaces are gated to Teams/Enterprise admins.** If you're on the Free or Pro
plan, use the install script instead — it drops the plugin straight into Cursor's local
plugins directory (`~/.cursor/plugins/local/<plugin>`). The result is identical to a
marketplace install: the full plugin (MCP server + skill) is loaded.

```bash
curl -fsSL https://raw.githubusercontent.com/memcoai/marketplace/main/cursor-install.sh | bash
```

Then in Cursor:

1. Reload the window (**Cmd/Ctrl+Shift+P → Developer: Reload Window**), or restart Cursor.
2. Open **Cursor Settings → Plugins** to confirm the plugin is listed.
3. Authenticate in the browser when prompted (OAuth).

The script installs `shared-memory` by default. Set `MEMCO_PLUGIN` to install a different
plugin, or comma-separate to install several in one run:

```bash
# Memco Personal Memory instead
curl -fsSL https://raw.githubusercontent.com/memcoai/marketplace/main/cursor-install.sh | MEMCO_PLUGIN=personal-memory bash

# both
curl -fsSL https://raw.githubusercontent.com/memcoai/marketplace/main/cursor-install.sh | MEMCO_PLUGIN=shared-memory,personal-memory bash
```

| Variable | Default | Purpose |
| --- | --- | --- |
| `MEMCO_PLUGIN` | `shared-memory` | Plugin to install; comma-separate for several |
| `MEMCO_MARKETPLACE_REF` | `main` | Branch or tag to install from |
| `MEMCO_MARKETPLACE_REPO` | `…/memcoai/marketplace.git` | Override the source repo (full git URL) |
| `CURSOR_HOME` | `~/.cursor` | Override Cursor's home directory |

> Requires `git`. To inspect the script before running it, open
> [`cursor-install.sh`](cursor-install.sh) or download it first instead of piping to `bash`.

#### Teams / Enterprise (Team Marketplace)

Teams/Enterprise admins can add the marketplace through the dashboard:

1. Open **Dashboard → Settings → Plugins**.
2. Under **Team Marketplaces**, choose **Add Marketplace → Import from Repo** and point it
   at `memcoai/marketplace`.
3. Reload Cursor (**Developer: Reload Window**), then open the marketplace panel and install
   the Spark plugin you want.

## Plugins

### Memco Shared Memory

Persistent, shared memory for your team's AI agents, delivered as an MCP server plus a skill
and lifecycle hooks. Agents search it for proven solutions, design rationale, and gotchas
before starting work, and persist what they learn afterwards. This is the plugin to install;
it supersedes the four Spark plugins below.

- Plugin name: `shared-memory`
- [Plugin README](plugins/shared-memory/README.md)

### Memco Personal Memory

A private, portable memory of your own preferences, delivered as an MCP server plus a skill
and lifecycle hooks. Your agent loads your identity and preferences at the start of every
session and saves durable ones as it learns them — so how you like to work follows you across
tools and machines rather than being relearned in each one. Only you can read it. It
complements Memco Shared Memory: personal preferences here, anything a teammate could reuse
there.

- Plugin name: `personal-memory`
- [Plugin README](plugins/personal-memory/README.md)

### Spark MCP

Spark delivered as an MCP server. The plugin connects your agent to the Spark shared memory.

- Plugin name: `spark-mcp`

### Spark Team MCP

Spark MCP scoped to your team's shared memory.

- Plugin name: `spark-team-mcp`

### Spark CLI

Spark delivered as skills + hooks that drive the Spark CLI. The plugin provides the
instructions for using the CLI, which must be installed separately:

```bash
npm install -g @memco/spark
```

- Plugin name: `spark-cli`

### Spark Team CLI

Spark CLI scoped to your team organization. The CLI must be installed separately:

```bash
npm install -g @memco/spark
```

- Plugin name: `spark-team-cli`
