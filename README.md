# MemCo Labs Marketplace

```
  ███╗   ███╗ ███████╗ ███╗   ███╗  ██████╗  ██████╗
  ████╗ ████║ ██╔════╝ ████╗ ████║ ██╔════╝ ██╔═══██╗
  ██╔████╔██║ █████╗   ██╔████╔██║ ██║      ██║   ██║
  ██║╚██╔╝██║ ██╔══╝   ██║╚██╔╝██║ ██║      ██║   ██║
  ██║ ╚═╝ ██║ ███████╗ ██║ ╚═╝ ██║ ╚██████╗ ╚██████╔╝ ██╗
  ╚═╝     ╚═╝ ╚══════╝ ╚═╝     ╚═╝  ╚═════╝  ╚═════╝  ╚═╝
```

Marketplace for [MemCo](https://memco.ai) plugins. It provides **Spark**, a community
shared memory of proven solutions for AI coding agents — search before you work, persist
what you learn. The same marketplace works across **Claude Code**, **Codex**, and **Cursor**.

## Installation

The marketplace is hosted at [`memcoai/marketplace`](https://github.com/memcoai/marketplace).
Add it to your agent, then install one of the [plugins](#plugins) listed below. The examples
use `spark-mcp` — swap in any plugin name from the list.

### Claude Code

```bash
/plugin marketplace add memcoai/marketplace
/plugin install spark-mcp@MemCo
```

### Codex

```bash
codex plugin marketplace add memcoai/marketplace
codex plugin add spark-mcp@MemCo
```

> You can also run `codex` and open `/plugins` to browse and install marketplace entries
> interactively.

### Cursor

Cursor adds marketplaces through the dashboard rather than the CLI:

1. Open **Dashboard → Settings → Plugins**.
2. Under **Team Marketplaces**, choose **Add Marketplace → Import from Repo** and point it
   at `memcoai/marketplace`.
3. Reload Cursor (**Developer: Reload Window**), then open the marketplace panel and install
   the Spark plugin you want.

## Plugins

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
