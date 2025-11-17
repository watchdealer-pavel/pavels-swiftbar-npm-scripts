 Pavel's SwiftBar npm Scripts

 A collection of SwiftBar plugins to easily start and stop your npm dev server from the macOS menu bar.

 ## Overview

 These scripts provide a convenient menu bar interface to manage your npm development server with just one click. The menu bar icon shows the current status (running or stopped) with color indicators.

 ## Features

 - Status Display - Shows if your dev server is running or stopped
 - - One-Click Control - Start/stop your server directly from the menu bar
   - - Color Indicators - Green when running, Red when stopped
     - - Auto-Refresh - Updates status every minute
       - - Background Execution - No terminal windows popping up
        
         - ## Prerequisites
        
         - - SwiftBar installed on macOS
           - - Node.js and npm installed
             - - A project with npm run dev command
              
               - ## Installation
              
               - ### Step 1: Install SwiftBar
              
               - Install with Homebrew:
              
               - ```
                 brew install swiftbar
                 ```

                 Or download from GitHub Releases: https://github.com/swiftbar/SwiftBar/releases

                 ### Step 2: Find Your Plugin Folder

                 Open SwiftBar and go to Preferences via the menu bar icon. Note the Plugin Folder path (usually ~/Documents/SwiftBar or similar).

                 ### Step 3: Add the Plugin

                 Clone this repo to your plugin folder:

                 ```
                 git clone https://github.com/watchdealer-pavel/pavels-swiftbar-npm-scripts.git ~/Documents/SwiftBar/npm-dev-server
                 ```

                 Or copy individual files to your plugin folder manually.

                 ### Step 4: Customize Your Project Path

                 Edit the main plugin file:

                 ```
                 nano ~/Documents/SwiftBar/npm-dev-server.1m.sh
                 ```

                 Find and replace:

                 ```
                 PROJECT_PATH="$HOME/your-project-name"
                 ```

                 With your actual project path, for example:

                 ```
                 PROJECT_PATH="$HOME/projects/my-app"
                 ```

                 Save with Ctrl+X, then Y, then Enter.

                 ### Step 5: Make Scripts Executable

                 ```
                 chmod +x ~/Documents/SwiftBar/npm-dev-server.1m.sh
                 chmod +x ~/Documents/SwiftBar/start-server.sh
                 chmod +x ~/Documents/SwiftBar/stop-server.sh
                 ```

                 ### Step 6: Reload SwiftBar

                 Click the SwiftBar menu and select "Refresh all plugins" or restart SwiftBar completely. The npm server icon should now appear in your menu bar!

                 ## Usage

                 ### Starting the Server

                 Click the menu bar icon and select "Start Dev Server". The icon will turn green when your server is running.

                 ### Stopping the Server

                 Click the menu bar icon and select "Stop Dev Server". The icon will turn red.

                 ### Checking Status

                 Green icon means the server is running. Red icon means the server is stopped.

                 ## File Structure

                 npm-dev-server.1m.sh - Main plugin script
                 start-server.sh - Helper script to start server
                 stop-server.sh - Helper script to stop server
                 README.md - This file

                 ## How It Works

                 npm-dev-server.1m.sh is the main SwiftBar plugin. It checks if the "npm run dev" process is running, displays colored status in the menu bar, and updates every 1 minute.

                 start-server.sh starts the npm dev server in the background using nohup.

                 stop-server.sh gracefully stops the npm server process using pkill.

                 ## Customization

                 ### Change Refresh Rate

                 Rename the plugin file to change update frequency:

                 npm-dev-server.1m.sh = Updates every 1 minute (default)
                 npm-dev-server.30s.sh = Updates every 30 seconds
                 npm-dev-server.5m.sh = Updates every 5 minutes

                 Then reload SwiftBar.

                 ### Change the Server Command

                 If you use npm run start or yarn dev instead of npm run dev, edit the plugin and update these lines:

                 ```
                 if pgrep -f "npm run dev" > /dev/null; then
                 ```

                 Change to your command:

                 ```
                 if pgrep -f "npm run start" > /dev/null; then
                 ```

                 ## Troubleshooting

                 ### Icon doesn't appear

                 Check that SwiftBar is running. Make sure the script has execute permissions:

                 ```
                 chmod +x ~/Documents/SwiftBar/npm-dev-server.1m.sh
                 ```

                 Restart SwiftBar and verify the plugin folder path in SwiftBar preferences is correct.

                 ### Status doesn't update

                 Right-click the icon and select "Refresh", or go to SwiftBar menu and select "Refresh all plugins".

                 ### Server won't start or stop

                 Verify PROJECT_PATH in the plugin file is correct and the project exists. Test the npm command manually:

                 ```
                 cd ~/your-project && npm run dev
                 ```

                 Check SwiftBar logs for errors:

                 ```
                 log stream --predicate 'process == "SwiftBar"' --level debug
                 ```

                 ### Terminal window keeps popping up

                 Make sure terminal=false is in the plugin command parameters. This is already configured in the provided script.

                 ## Debugging

                 To see SwiftBar activity and debug issues:

                 ```
                 log stream --predicate 'process == "SwiftBar"' --level debug
                 ```

                 ## License

                 MIT - Feel free to use and modify for your needs

                 ## Contributing

                 Found a bug or want to improve these scripts? Issues and pull requests are welcome!

                 ---

                 Made for macOS developers who want their dev workflow a little bit smoother.
                 
