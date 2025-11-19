# Pavel's SwiftBar npm Scripts

Control your npm dev server from the macOS menu bar.

![npm scripts in action](https://img.shields.io/badge/macOS-SwiftBar-blue?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

## Quick Start

1. Install SwiftBar: `brew install swiftbar`
2. Clone this repo to your SwiftBar plugins folder
3. Configure via SwiftBar: Plugin > Plugin Settings...
4. Make scripts executable: `chmod +x *.sh`
5. Reload SwiftBar

## Configuration
 
This plugin uses SwiftBar/xbar variables for configuration. You don't need to edit the script directly.
 
1. Open SwiftBar menu
2. Go to **Plugin Settings...**
3. Set the following variables:
   - `VAR_PROJECT_PATH`: Path to your project directory (e.g. `/Users/pavel/projects/my-app`)
   - `VAR_DEV_COMMAND`: Command to start the server (default: `npm run dev`)
 
You can also optionally set a custom process name if needed by editing the script, but the default auto-detection usually works fine.

## What You Get

A minimal menu bar icon using SF Symbols that shows server status (green circle=running, red circle=stopped). Click it to start/stop your npm dev server with visual notifications.

Additional features:
- **SF Symbols integration** for a clean, minimalistic interface
- **Automatic error detection** with helpful notifications
- **Server logging** with live log viewing in Terminal
- **Native SwiftBar Configuration** using variables
- **PID-based process management** for reliable server control
- **Immediate UI refresh** after start/stop actions
- **Homebrew PATH support** for reliable npm/yarn detection

## Files

- `npm-dev-server.1m.sh` - Main SwiftBar plugin with SF Symbols
- `server.pid` - PID file for process management (auto-generated)
- `server.log` - Server output log (auto-generated)

## Customization

Rename the main file to change refresh rate:
- `npm-dev-server.30s.sh` = 30 seconds
- `npm-dev-server.5m.sh` = 5 minutes

## Advanced Usage

### Viewing Server Logs

If you're experiencing issues, you can view the server logs:

1. Right-click the menu bar item
2. Select "View Logs"
3. A Terminal window will open with live log output (Ctrl+C to exit)

The logs are also saved to `server.log` in the plugin directory.

## Troubleshooting

### Icon doesn't appear
- Check SwiftBar is running
- Verify file permissions: `chmod +x *.sh`
- Restart SwiftBar

### Server won't start
- Check `VAR_PROJECT_PATH` is correct in Plugin Settings
- Test manually: `cd ~/your-project && npm run dev`
- Check server logs for detailed error messages
- Verify Homebrew is in PATH (plugin includes this automatically)

### Wrong command?
Use Plugin Settings to change `VAR_DEV_COMMAND` to your command (e.g. `npm run start` or `yarn dev`)

### Server stops immediately
- Check if your project has all dependencies installed
- Verify your package.json has the correct script defined
- View the server logs for specific error messages

### PID file issues
- If the server status seems incorrect, delete the `server.pid` file
- The plugin will automatically recreate it on next start

## License

MIT

---
