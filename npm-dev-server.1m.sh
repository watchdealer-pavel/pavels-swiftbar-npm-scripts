#!/bin/bash

# <xbar.title>NPM Dev Server</xbar.title>
# <xbar.version>v1.1</xbar.version>
# <xbar.author>Pavel</xbar.author>
# <xbar.desc>Start/stop npm dev server from the menu bar</xbar.desc>
# <xbar.dependencies>npm</xbar.dependencies>

# ===== CONFIGURATION =====
# Replace this with your project path
PROJECT_PATH="$HOME/your-project-name"

# The command that starts your dev server
DEV_COMMAND="npm run dev"

# Process name to search for (must match what appears in 'ps' output)
# This will be automatically derived from DEV_COMMAND if left empty
PROCESS_NAME=""
# ===== END CONFIGURATION =====

# Get script directory
SCRIPT_DIR="$(dirname "$0")"

# Function to check if the server is running
is_server_running() {
    # If PROCESS_NAME is not set, derive it from DEV_COMMAND
    if [ -z "$PROCESS_NAME" ]; then
        # Extract the process name from the command
        PROCESS_NAME=$(echo "$DEV_COMMAND" | awk '{print $1}')
    fi
    
    pgrep -f "$PROCESS_NAME" > /dev/null
    return $?
}

# Function to start the server
start_server() {
    if [ ! -d "$PROJECT_PATH" ]; then
        echo "Error: Project path does not exist: $PROJECT_PATH"
        exit 1
    fi
    
    cd "$PROJECT_PATH" || exit 1
    nohup $DEV_COMMAND > "$SCRIPT_DIR/server.log" 2>&1 &
    
    # Give the server a moment to start
    sleep 2
    
    if is_server_running; then
        echo "Server started successfully"
    else
        echo "Failed to start server. Check $SCRIPT_DIR/server.log for details."
    fi
}

# Function to stop the server
stop_server() {
    # If PROCESS_NAME is not set, derive it from DEV_COMMAND
    if [ -z "$PROCESS_NAME" ]; then
        PROCESS_NAME=$(echo "$DEV_COMMAND" | awk '{print $1}')
    fi
    
    if pgrep -f "$PROCESS_NAME" > /dev/null; then
        pkill -f "$PROCESS_NAME"
        echo "Server stopped"
    else
        echo "Server was not running"
    fi
}

# Check if server is running and display appropriate menu
if is_server_running; then
    echo "🟢 Dev Server Running | color=green"
    echo "---"
    echo "Stop Server | bash=$SCRIPT_DIR/stop-server.sh param1=$PROJECT_PATH param2=$DEV_COMMAND terminal=false"
    echo "View Logs | bash=$SCRIPT_DIR/view-logs.sh terminal=true"
else
    echo "🔴 Dev Server Stopped | color=red"
    echo "---"
    echo "Start Server | bash=$SCRIPT_DIR/start-server.sh param1=$PROJECT_PATH param2=$DEV_COMMAND terminal=false"
    echo "Configure Project | bash=$SCRIPT_DIR/configure.sh terminal=true"
fi
