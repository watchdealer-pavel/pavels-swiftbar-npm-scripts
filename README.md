# Pavel's SwiftBar npm Scripts

A collection of SwiftBar plugins to easily start and stop your npm dev server from the macOS menu bar.

## Overview

These scripts provide a convenient menu bar interface to manage your npm development server with just one click. The menu bar icon shows the current status (running or stopped) with color indicators.

## Features

✅ **Status Display** - Shows if your dev server is running or stopped  
✅ **One-Click Control** - Start/stop your server directly from the menu bar  
✅ **Color Indicators** - 🟢 Green when running, 🔴 Red when stopped  
✅ **Auto-Refresh** - Updates status every minute  
✅ **Background Execution** - No terminal windows popping up

## Prerequisites

- **SwiftBar** installed on macOS (get it [here](https://github.com/swiftbar/SwiftBar))
- - **Node.js and npm** installed
  - - A project with `npm run dev` command
   
    - ## Installation
   
    - ### Step 1: Install SwiftBar
   
    - If you haven't already:
    - ```bash
      brew install swiftbar
      ```

      Or download from [GitHub Releases](https://github.com/swiftbar/SwiftBar/releases)

      ### Step 2: Find Your Plugin Folder

      1. Open SwiftBar
      2. 2. Click the SwiftBar icon in the menu bar → Preferences
         3. 3. Note the "Plugin Folder" path (usually `~/Documents/SwiftBar` or similar)
           
            4. ### Step 3: Add the Plugin
           
            5. Clone this repo or download the scripts:
           
            6. ```bash
               # Option A: Clone the entire repo to your plugins folder
               git clone https://github.com/watchdealer-pavel/pavels-swiftbar-npm-scripts.git ~/Documents/SwiftBar/npm-dev-server

               # Option B: Copy individual files manually
               # Download npm-dev-server.1m.sh to your plugin folder
               ```

               ### Step 4: Customize (IMPORTANT!)

               Edit the plugin file and replace the path to your project:

               ```bash
               nano ~/Documents/SwiftBar/npm-dev-server.1m.sh
               ```

               Find this line:
               ```bash
               PROJECT_PATH="/path/to/your/project"
               ```

               Replace `/path/to/your/project` with your actual project path. For example:
               ```bash
               PROJECT_PATH="$HOME/projects/my-app"
               ```

               Or if your project is in your home directory:
               ```bash
               PROJECT_PATH="~/my-app"
               ```

               Save the file (Ctrl+X, then Y, then Enter in nano).

               ### Step 5: Make Scripts Executable

               ```bash
               chmod +x ~/Documents/SwiftBar/npm-dev-server.1m.sh
               chmod +x ~/Documents/SwiftBar/start-server.sh
               chmod +x ~/Documents/SwiftBar/stop-server.sh
               ```

               ### Step 6: Reload SwiftBar

               - Click SwiftBar menu icon → "Refresh all plugins"
               - - OR restart SwiftBar
                 - - The npm server icon should now appear in your menu bar!
                  
                   - ## Usage
                  
                   - ### Starting the Server
                  
                   - - Click the menu bar icon
                     - - Select "Start Dev Server"
                       - - The icon turns 🟢 green when running
                        
                         - ### Stopping the Server
                        
                         - - Click the menu bar icon
                           - - Select "Stop Dev Server"
                             - - The icon turns 🔴 red
                              
                               - ### Checking Status
                              
                               - - Look at the icon:
                                 -   - 🟢 Green = Server is running
                                     -   - 🔴 Red = Server is stopped
                                      
                                         - ## File Structure
                                      
                                         - ```
                                           npm-dev-server.1m.sh     → Main plugin script
                                           start-server.sh          → Helper script to start the server
                                           stop-server.sh           → Helper script to stop the server
                                           README.md                → This file
                                           ```

                                           ## How It Works

                                           **Plugin File** (`npm-dev-server.1m.sh`):
                                           - Checks if a process matching "npm run dev" is running
                                           - - Displays status in the menu bar
                                             - - Updates every 1 minute
                                              
                                               - **Helper Scripts**:
                                               - - `start-server.sh`: Starts npm dev server in the background
                                                 - - `stop-server.sh`: Gracefully kills the server process
                                                  
                                                   - ## Customization
                                                  
                                                   - ### Change Refresh Rate
                                                  
                                                   - Edit the filename of the main plugin:
                                                   - - `npm-dev-server.1m.sh` → Updates every 1 minute
                                                     - - `npm-dev-server.30s.sh` → Updates every 30 seconds
                                                       - - `npm-dev-server.5m.sh` → Updates every 5 minutes
                                                        
                                                         - Then reload SwiftBar.
                                                        
                                                         - ### Change the Server Command
                                                        
                                                         - If your dev command is different (e.g., `npm run start` or `yarn dev`):
                                                        
                                                         - Edit the plugin and change:
                                                         - ```bash
                                                           if pgrep -f "npm run dev" > /dev/null; then
                                                           ```

                                                           To your command:
                                                           ```bash
                                                           if pgrep -f "npm run start" > /dev/null; then
                                                           ```

                                                           Also update the start script accordingly.

                                                           ## Troubleshooting

                                                           ### Icon doesn't appear

                                                           - Verify SwiftBar is running
                                                           - - Check that the plugin file has execute permissions: `chmod +x ~/Documents/SwiftBar/npm-dev-server.1m.sh`
                                                             - - Restart SwiftBar
                                                              
                                                               - ### Status doesn't update
                                                              
                                                               - - Right-click the icon → "Refresh"
                                                                 - - Or: SwiftBar menu → "Refresh all plugins"
                                                                  
                                                                   - ### Server won't start/stop
                                                                  
                                                                   - - Check the `PROJECT_PATH` is correct and your project exists
                                                                     - - Verify the npm command works manually in terminal
                                                                       - - Check SwiftBar logs: Open Console.app and search for "SwiftBar"
                                                                        
                                                                         - ### Terminal window keeps popping up
                                                                        
                                                                         - - Make sure `terminal=false` is in the plugin command parameters
                                                                           - - This is already configured in the provided script
                                                                            
                                                                             - ## Logs and Debugging
                                                                            
                                                                             - To debug issues, check SwiftBar logs:
                                                                            
                                                                             - ```bash
                                                                               log stream --predicate 'process == "SwiftBar"' --level debug
                                                                               ```

                                                                               ## License

                                                                               MIT - Feel free to use and modify for your needs

                                                                               ## Contributing

                                                                               Found a bug or want to improve these scripts? Issues and pull requests are welcome!

                                                                               ---

                                                                               **Made for macOS developers who want their dev workflow a little bit smoother.** 🚀
                                                                               
