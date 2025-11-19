#!/bin/bash

# <xbar.title>NPM Dev Server</xbar.title>
# <xbar.version>v1.2</xbar.version>
# <xbar.author>Pavel</xbar.author>
# <xbar.author.github>pavel</xbar.author.github>
# <xbar.desc>Start/stop npm dev server from the menu bar</xbar.desc>
# <xbar.image>https://github.com/pavel/pavels-swiftbar/raw/main/preview.png</xbar.image>
# <xbar.dependencies>npm</xbar.dependencies>
# <xbar.abouturl>https://github.com/pavel/pavels-swiftbar</xbar.abouturl>

# <xbar.var>string(VAR_PROJECT_PATH=""): Path to your project directory</xbar.var>
# <xbar.var>string(VAR_DEV_COMMAND="npm run dev"): Command to start the server</xbar.var>

# Ensure Homebrew binaries are available
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# ===== CONFIGURATION =====
# Get configuration from xbar variables or use defaults
PROJECT_PATH="${VAR_PROJECT_PATH:-$HOME/your-project-name}"
DEV_COMMAND="${VAR_DEV_COMMAND:-npm run dev}"

# Process name to search for (must match what appears in 'ps' output)
# This will be automatically derived from DEV_COMMAND if left empty
PROCESS_NAME=""
# ===== END CONFIGURATION =====

# Get script directory and files
SCRIPT_DIR="$(dirname "$0")"
PID_FILE="$SCRIPT_DIR/server.pid"
LOG_FILE="$SCRIPT_DIR/server.log"

# Function to check if the server is running
is_server_running() {
    # First check if PID file exists and process is running
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

# Action: Start Server
action_start() {
    if [ ! -d "$PROJECT_PATH" ]; then
        osascript -e "display notification \"Project path does not exist: $PROJECT_PATH\" with title \"NPM Dev Server Error\""
        exit 1
    fi
    
    # Check if already running
    if is_server_running; then
        osascript -e "display notification \"Server is already running\" with title \"NPM Dev Server\""
        exit 0
    fi

    cd "$PROJECT_PATH" || exit 1
    nohup $DEV_COMMAND > "$LOG_FILE" 2>&1 &
    SERVER_PID=$!
    
    # Save the PID
    echo "$SERVER_PID" > "$PID_FILE"
    
    # Give the server a moment to start
    sleep 2
    
    if ps -p "$SERVER_PID" > /dev/null 2>&1; then
        osascript -e "display notification \"Server started successfully (PID: $SERVER_PID)\" with title \"NPM Dev Server\""
    else
        osascript -e "display notification \"Failed to start server. Check logs for details.\" with title \"NPM Dev Server Error\""
        rm -f "$PID_FILE"
    fi
}

# Action: Stop Server
action_stop() {
    # If PROCESS_NAME is not set, derive it from DEV_COMMAND
    if [ -z "$PROCESS_NAME" ]; then
        PROCESS_NAME=$(echo "$DEV_COMMAND" | awk '{print $1}')
    fi
    
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            kill "$PID"
            sleep 2
            if ps -p "$PID" > /dev/null 2>&1; then
                kill -9 "$PID"
                sleep 1
            fi
            rm -f "$PID_FILE"
            osascript -e "display notification \"Server stopped (PID: $PID)\" with title \"NPM Dev Server\""
            return
        else
            rm -f "$PID_FILE"
        fi
    fi
    
    # Fallback to pkill if PID file didn't work or wasn't there
    if pgrep -f "$PROCESS_NAME" > /dev/null; then
        pkill -f "$PROCESS_NAME"
        osascript -e "display notification \"Server stopped (detected by process name)\" with title \"NPM Dev Server\""
    else
        osascript -e "display notification \"Server was not running\" with title \"NPM Dev Server\""
    fi
}

# Action: View Logs
action_logs() {
    if [ -f "$LOG_FILE" ]; then
        echo "Following server logs (Ctrl+C to exit):"
        tail -f "$LOG_FILE"
    else
        echo "No log file found at $LOG_FILE"
    fi
}

# Dispatcher based on argument
case "$1" in
    "start")
        action_start
        exit 0
        ;;
    "stop")
        action_stop
        exit 0
        ;;
    "logs")
        action_logs
        exit 0
        ;;
esac

# Main Menu Output
if is_server_running; then
    echo "| sfimage=circle.fill color=green tooltip=Dev Server Running"
    echo "---"
    echo "Stop Server | bash=\"$0\" param1=stop terminal=false refresh=true tooltip=\"Stop the development server\""
    echo "View Logs | bash=\"$0\" param1=logs terminal=true refresh=true tooltip=\"View server logs in Terminal\""
else
    echo "| sfimage=circle.fill color=red tooltip=Dev Server Stopped"
    echo "---"
    echo "Start Server | bash=\"$0\" param1=start terminal=false refresh=true tooltip=\"Start the development server\""
fi
