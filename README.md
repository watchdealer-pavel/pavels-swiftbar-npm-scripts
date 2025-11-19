# Pavel's SwiftBar npm Scripts

Control your npm dev server from the macOS menu bar.

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
 
1. Open the plugin script (`npm-dev-server.5s.sh`) in your text editor.
2. Edit the **CONFIGURATION** section at the top of the file:

```bash
# Path to your project directory (Required)
PROJECT_PATH="$HOME/projects/my-app"

# Command to start the server (Default: npm run dev)
DEV_COMMAND="npm run dev"
```

3. Save the file and refresh SwiftBar (Plugin > Refresh All).

## What You Get

A minimal menu bar icon using SF Symbols that shows server status (green circle=running, red circle=stopped).

### Features

*   **Start/Stop Server**: Control your npm dev server directly from the menu bar.
*   **Live URL**: When running, the menu displays the clickable server URL (e.g., `http://localhost:3000`).
*   **Other Servers**: Detects and lists other running `node` servers on your machine with their ports.
*   **Kill Process**: Easily kill any "stuck" or other running node processes directly from the menu.
*   **SF Symbols**: Clean, native macOS aesthetic.
*   **Logging**: View live server logs in Terminal.

## Files

- `npm-dev-server.5s.sh` - Main SwiftBar plugin with SF Symbols
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
