#!/bin/bash

# <xbar.title>NPM Dev Server</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Pavel</xbar.author>
# <xbar.desc>Start/stop npm dev server from the menu bar</xbar.desc>
# <xbar.dependencies>npm</xbar.dependencies>

# ===== CONFIGURATION =====
# Replace this with your project path
PROJECT_PATH="$HOME/your-project-name"

# The command that starts your dev server
DEV_COMMAND="npm run dev"

# Process name to search for (must match what appears in 'ps' output)
PROCESS_NAME="npm run dev"
# ===== END CONFIGURATION =====

# Function to check if the server is running
is_server_running() {
    pgrep -f "$PROCESS_NAME" > /dev/null
        return $?
        }

        # Function to start the server
        start_server() {
            cd "$PROJECT_PATH" || exit 1
                nohup $DEV_COMMAND > /dev/null 2>&1 &
                }

                # Function to stop the server
                stop_server() {
                    pkill -f "$PROCESS_NAME"
                    }

                    # Check if server is running and display appropriate menu
                    if is_server_running; then
                        echo "🟢 Dev Server Running | color=green"
                            echo "---"
                                echo "Stop Server | bash=$(dirname "$0")/stop-server.sh terminal=false"
                                else
                                    echo "🔴 Dev Server Stopped | color=red"
                                        echo "---"
                                            echo "Start Server | bash=$(dirname "$0")/start-server.sh terminal=false"
                                            fi
                                            
