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

Edit the main plugin file and change these lines:

```bash
PROJECT_PATH="$HOME/your-project-name"
DEV_COMMAND="npm run dev"
```

To your actual project path and command:

```bash
PROJECT_PATH="$HOME/projects/my-app"
DEV_COMMAND="npm run start"  # or "yarn dev", etc.
```

You can also optionally set a custom process name if needed:

```bash
PROCESS_NAME="node"  # Leave empty to auto-detect from DEV_COMMAND
```

## What You Get

A menu bar icon that shows server status (green=running, red=stopped). Click it to start/stop your npm dev server with visual notifications.

Additional features:
- **Automatic error detection** with helpful notifications
- **Server logging** to help troubleshoot issues
- **Configuration helper** for easy setup
- **Process auto-detection** for more reliable server management

## Files

- `npm-dev-server.1m.sh` - Main SwiftBar plugin
- `start-server.sh` - Starts the server with error handling
- `stop-server.sh` - Stops the server with confirmation
- `view-logs.sh` - Displays server logs for troubleshooting
- `configure.sh` - Interactive configuration helper

## Customization

Rename the main file to change refresh rate:
- `npm-dev-server.30s.sh` = 30 seconds
- `npm-dev-server.5m.sh` = 5 minutes

## Advanced Usage

### Using the Configuration Helper

Instead of manually editing the main script, you can use the configuration helper:

1. Right-click the menu bar item
2. Select "Configure Project"
3. Follow the prompts to update your settings

### Viewing Server Logs

If you're experiencing issues, you can view the server logs:

1. Right-click the menu bar item
2. Select "View Logs"
3. Check for any error messages

## Troubleshooting

### Icon doesn't appear
- Check SwiftBar is running
- Verify file permissions: `chmod +x *.sh`
- Restart SwiftBar

### Server won't start
- Check PROJECT_PATH is correct using the configuration helper
- Test manually: `cd ~/your-project && npm run dev`
- Check server logs for detailed error messages

### Wrong command?
Use the configuration helper or edit the plugin and change `DEV_COMMAND="npm run dev"` to your command (e.g. `npm run start` or `yarn dev`)

### Server stops immediately
- Check if your project has all dependencies installed
- Verify your package.json has the correct script defined
- View the server logs for specific error messages

## License

MIT

---
