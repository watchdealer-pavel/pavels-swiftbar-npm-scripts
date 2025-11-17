

# Pavel's SwiftBar npm Scripts

Control your npm dev server from the macOS menu bar.

![npm scripts in action](https://img.shields.io/badge/macOS-SwiftBar-blue?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

## Quick Start

1. Install SwiftBar: `brew install swiftbar`
2. Clone this repo to your SwiftBar plugins folder
3. Edit `npm-dev-server.1m.sh` and set your project path
4. Make scripts executable: `chmod +x *.sh`
5. Reload SwiftBar

## Setup

Edit the main plugin file and change this line:

```bash
PROJECT_PATH="$HOME/your-project-name"
```

To your actual project path:

```bash
PROJECT_PATH="$HOME/projects/my-app"
```

## What You Get

A menu bar icon that shows server status (green=running, red=stopped). Click it to start/stop your npm dev server.

## Files

- `npm-dev-server.1m.sh` - Main SwiftBar plugin
- `start-server.sh` - Starts the server
- `stop-server.sh` - Stops the server

## Customization

Rename the main file to change refresh rate:
- `npm-dev-server.30s.sh` = 30 seconds
- `npm-dev-server.5m.sh` = 5 minutes

## Troubleshooting

### Icon doesn't appear
- Check SwiftBar is running
- Verify file permissions: `chmod +x npm-dev-server.1m.sh`
- Restart SwiftBar

### Server won't start
- Check PROJECT_PATH is correct
- Test manually: `cd ~/your-project && npm run dev`

### Wrong command?
Edit the plugin and change `npm run dev` to your command (e.g. `npm run start` or `yarn dev`)

## License

MIT

---

Made for developers who want a smoother workflow.
