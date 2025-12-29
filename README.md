# Pavel's SwiftBar npm Scripts

Monitor and control all your npm dev servers from the macOS menu bar.

![npm scripts in action](preview.png)

![SwiftBar](https://img.shields.io/badge/macOS-SwiftBar-blue?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

## Quick Start

1. Install SwiftBar: `brew install swiftbar`
2. Clone this repo to your SwiftBar plugins folder
3. Configure the script (see below)
4. Make scripts executable: `chmod +x *.sh`
5. Reload SwiftBar

## Configuration

Edit the **CONFIGURATION** section at the top of `npm-dev-server.5s.sh`:

```bash
# Default project path for "Start Server" action
PROJECT_PATH="${VAR_PROJECT_PATH:-$HOME/projects/my-app}"

# Command to start the server
DEV_COMMAND="${VAR_DEV_COMMAND:-npm run dev}"

# Resource warning thresholds
CPU_WARNING_THRESHOLD=80      # Warn if CPU > 80%
MEMORY_WARNING_THRESHOLD=500  # Warn if memory > 500MB
```

## Features

* **Auto-Detection** — Automatically finds ALL running node servers on your machine
* **Resource Monitoring** — Real-time CPU% and memory usage per server
* **One-Click Actions** — Start, stop, or force-kill servers directly from the menu
* **Quick Access** — Click any server to open `localhost:PORT` in your browser
* **Warning Indicators** — Visual alerts for high CPU/memory or stuck processes
* **Minimalist Design** — Clean monochrome SF Symbols, no distracting colors

## Menu Structure

**When idle:**
```
⌘                              ← Terminal icon (no servers)
───
  No servers running
───
▶ Start my-app                 ← Direct click to start
───
↻ Refresh
```

**When servers running:**
```
⌘ 2                            ← Terminal icon + count
───
✓ my-app :3000                 ← Click to open in browser
   2.1% CPU · 125MB
   /Users/you/projects/my-app
   ───
   ⏹ Stop
   📄 Logs
───
✓ api-server :4000
   ...
───
▶ Start my-app
───
↻ Refresh
```

## Files

- `npm-dev-server.5s.sh` — Main SwiftBar plugin
- `~/.npm-dev-server/` — Runtime data (auto-created)

## Customization

Rename the plugin file to change refresh rate:
- `npm-dev-server.30s.sh` = 30 seconds
- `npm-dev-server.1m.sh` = 1 minute

## Troubleshooting

### Error plugin appearing with "server" name
Clean up old SwiftBar data directories:
```bash
rm -rf "$HOME/Library/Application Support/SwiftBar/Plugins/npm-dev-server.5s.sh"
rm -rf "$HOME/Library/Application Support/SwiftBar/Plugins/server.log"
```

### Server won't start
- Verify `PROJECT_PATH` points to a valid npm project
- Test manually: `cd ~/your-project && npm run dev`
- Check logs: `cat ~/.npm-dev-server/servers/*.log`

### Server not detected
Only `node` processes listening on TCP ports are detected. Check manually:
```bash
lsof -iTCP -sTCP:LISTEN -n -P | grep node
```

## License

MIT
