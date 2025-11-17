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
               git clone https://github.com/watchdealer-pavel/pavels-swiftbar-npm-scripts.git ~/Documents/SwiftBar/npm-dev-server
               ```

               Or copy individual files to your plugin folder manually.

               ### Step 4: Customize (IMPORTANT!)

               Edit the main plugin file and set your project path:

               ```bash
               nano ~/Documents/SwiftBar/npm-dev-server.1m.sh
               ```

               Find and replace this line:
               ```bash
               PROJECT_PATH="$HOME/your-project-name"
               ```

               Update with your actual project path:
               ```bash
               PROJECT_PATH="$HOME/projects/my-app"
               ```

               Save (Ctrl+X, then Y, then Enter in nano).

               ### Step 5: Make Scripts Executable

               ```bash
               chmod +x ~/Documents/SwiftBar/npm-dev-server.1m.sh
               chmod +x ~/Documents/SwiftBar/start-server.sh
               chmod +x ~/Documents/SwiftBar/stop-server.sh
               ```

               ### Step 6: Reload SwiftBar

               Click SwiftBar menu → "Refresh all plugins" or restart SwiftBar.

               The npm server icon should now appear in your menu bar!

               ## Usage

               ### Starting the Server

               - Click the menu bar icon
               - - Select "Start Dev Server"
                 - - Icon turns 🟢 green when running
                  
                   - ### Stopping the Server
                  
                   - - Click the menu bar icon
                     - - Select "Stop Dev Server"
                       - - Icon turns 🔴 red
                        
                         - ### Checking Status
                        
                         - - 🟢 Green icon = Server is running
                           - - 🔴 Red icon = Server is stopped
                            
                             - ## File Structure
                            
                             - ```
                               npm-dev-server.1m.sh     → Main plugin script
                               start-server.sh          → Helper script to start server
                               stop-server.sh           → Helper script to stop server
                               README.md                → This file
                               ```

                               ## How It Works

                               **npm-dev-server.1m.sh:**
                               - Checks if "npm run dev" process is running
                               - - Displays status in menu bar with color
                                 - - Updates every 1 minute
                                  
                                   - **start-server.sh:**
                                   - - Starts npm dev server in background
                                     - - Uses nohup to keep it running
                                      
                                       - **stop-server.sh:**
                                       - - Gracefully stops the npm server process
                                        
                                         - ## Customization
                                        
                                         - ### Change Refresh Rate
                                        
                                         - Rename the plugin file to change how often it updates:
                                         - - `npm-dev-server.1m.sh` → 1 minute (default)
                                           - - `npm-dev-server.30s.sh` → 30 seconds
                                             - - `npm-dev-server.5m.sh` → 5 minutes
                                              
                                               - Then reload SwiftBar.
                                              
                                               - ### Change Server Command
                                              
                                               - If you use `npm run start` or `yarn dev` instead:
                                              
                                               - Edit the plugin and update these lines:
                                               - ```bash
                                                 if pgrep -f "npm run dev" > /dev/null; then
                                                 ```

                                                 to match your command, e.g.:
                                                 ```bash
                                                 if pgrep -f "npm run start" > /dev/null; then
                                                 ```

                                                 ## Troubleshooting

                                                 ### Icon doesn't appear

                                                 - Verify SwiftBar is running
                                                 - - Check script permissions: `chmod +x ~/Documents/SwiftBar/npm-dev-server.1m.sh`
                                                   - - Restart SwiftBar
                                                     - - Check plugin folder path in SwiftBar preferences
                                                      
                                                       - ### Status doesn't update
                                                      
                                                       - - Right-click icon → "Refresh"
                                                         - - Or: SwiftBar menu → "Refresh all plugins"
                                                          
                                                           - ### Server won't start
                                                          
                                                           - - Verify PROJECT_PATH is correct
                                                             - - Test npm command manually in terminal
                                                               - - Check SwiftBar logs: `log stream --predicate 'process == "SwiftBar"' --level debug`
                                                                
                                                                 - ### Terminal window keeps opening
                                                                
                                                                 - - Ensure `terminal=false` is in plugin commands
                                                                   - - This is already configured in provided script
                                                                    
                                                                     - ## Logs
                                                                    
                                                                     - To debug issues:
                                                                    
                                                                     - ```bash
                                                                       log stream --predicate 'process == "SwiftBar"' --level debug
                                                                       ```

                                                                       ## License

                                                                       MIT - Feel free to use and modify for your needs

                                                                       ## Contributing

                                                                       Found a bug? Want to improve? Issues and pull requests welcome!

                                                                       ---

                                                                       **Made for macOS developers who want their dev workflow a little bit smoother.** 🚀
                                                                       
