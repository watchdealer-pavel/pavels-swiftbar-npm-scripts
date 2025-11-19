#!/bin/bash

# <xbar.title>NPM Dev Server</xbar.title>
# <xbar.version>v1.1</xbar.version>
# <xbar.author>Pavel</xbar.author>
# <xbar.desc>Start/stop npm dev server from the menu bar</xbar.desc>
# <xbar.dependencies>npm</xbar.dependencies>

# Ensure Homebrew binaries are available
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

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
    # First check if PID file exists and process is running
    PID_FILE="$SCRIPT_DIR/server.pid"
    
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            return 0  # Server is running
        else
            # Stale PID file, remove it
            rm -f "$PID_FILE"
        fi
    fi
    
    # Fallback to process name detection
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
    echo "| sfimage=circle.fill color=green tooltip=Dev Server Running"
    echo "---"
    echo "Stop Server | bash=$SCRIPT_DIR/stop-server.sh param1=$PROJECT_PATH param2=$DEV_COMMAND terminal=false refresh=true tooltip=Stop the development server"
    echo "View Logs | bash=$SCRIPT_DIR/view-logs.sh terminal=true refresh=true tooltip=View server logs in Terminal"
else
    echo "| sfimage=circle.fill color=red tooltip=Dev Server Stopped"
    echo "---"
    echo "Start Server | bash=$SCRIPT_DIR/start-server.sh param1=$PROJECT_PATH param2=$DEV_COMMAND terminal=false refresh=true tooltip=Start the development server"
    echo "Configure Project | bash=$SCRIPT_DIR/configure.sh terminal=true refresh=true tooltip=Configure project settings"
fi
