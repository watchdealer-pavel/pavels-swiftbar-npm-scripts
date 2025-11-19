#!/usr/bin/env bash

# <xbar.title>NPM Dev Server</xbar.title>
# <xbar.version>v1.2</xbar.version>
# <xbar.author>Watchdealer Pavel</xbar.author>
# <xbar.author.github>watchdealer-pavel</xbar.author.github>
# <xbar.desc>Start/stop npm dev server from the menu bar</xbar.desc>
# <xbar.image>https://github.com/watchdealer-pavel/pavels-swiftbar-npm-scripts/raw/main/preview.png</xbar.image>
# <xbar.dependencies>npm</xbar.dependencies>
# <xbar.abouturl>https://github.com/watchdealer-pavel/pavels-swiftbar-npm-scripts</xbar.abouturl>
# <xbar.var>string(VAR_PROJECT_PATH="/Users/yourname/project"): Path to your project directory</xbar.var>
# <xbar.var>string(VAR_DEV_COMMAND="npm run dev"): Command to start the server</xbar.var>
# To configure, please edit the variables below directly.

# ===== CONFIGURATION =====

# Path to your project directory (Required)
# Example: PROJECT_PATH="/Users/username/projects/my-app"
PROJECT_PATH="${VAR_PROJECT_PATH:-$HOME/projects/my-app}"

# Ensure Homebrew binaries are available
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Command to start the server (Default: npm run dev)
DEV_COMMAND="${VAR_DEV_COMMAND:-npm run dev}"

# Process name to search for (must match what appears in 'ps' output)
# If empty, we will search for the full DEV_COMMAND string
PROCESS_NAME=""

# ===== END CONFIGURATION =====

# Get script directory and files
SCRIPT_DIR="$(dirname "$0")"

# Runtime storage
# Use SwiftBar's provided data directory if available, otherwise fallback to a hidden home dir
DATA_DIR="${SWIFTBAR_PLUGIN_DATA_PATH:-$HOME/.npm-dev-server}"
mkdir -p "$DATA_DIR"

PID_FILE="$DATA_DIR/server.pid"
LOG_FILE="$DATA_DIR/server.log"

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
    SEARCH_PATTERN="${PROCESS_NAME:-$DEV_COMMAND}"
    pgrep -f "$SEARCH_PATTERN" > /dev/null
    return $?
}

# Function to get the port of the running server
get_port() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        # Use lsof to find the TCP listen port for this PID
        PORT=$(lsof -Pan -p "$PID" -iTCP -sTCP:LISTEN | grep -oE ':[0-9]+' | head -1 | sed 's/://')
        echo "$PORT"
    fi
}

# Function to list other running node servers
list_other_servers() {
    # Find all node processes listening on TCP ports
    # Output format: COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME
    # We filter for 'node' command and LISTEN state
    
    echo "---"
    echo "Other Running Servers"
    
    # We use lsof to find all node processes listening on ports
    # We exclude the current server's PID if it's running
    CURRENT_PID=""
    if [ -f "$PID_FILE" ]; then
        CURRENT_PID=$(cat "$PID_FILE")
    fi
    
    FOUND=0
    
    # Parse lsof output
    # -n: no host names, -P: no port names, -iTCP: only TCP, -sTCP:LISTEN: only listening
    while read -r line; do
        # Extract PID and Port
        # Example line: node 12345 user ... *:3000 (LISTEN)
        PID=$(echo "$line" | awk '{print $2}')
        PORT_INFO=$(echo "$line" | awk '{print $9}') # usually *:3000 or similar
        PORT=$(echo "$PORT_INFO" | grep -oE '[0-9]+' | tail -1)
        
        # Skip if it's the current server
        if [ "$PID" == "$CURRENT_PID" ]; then
            continue
        fi
        
        if [ -n "$PID" ] && [ -n "$PORT" ]; then
            echo "Node ($PID) on :$PORT | shell=\"$0\" param1=kill_pid param2=$PID terminal=false refresh=true tooltip=\"Click to kill process $PID\""
            FOUND=1
        fi
    done < <(lsof -iTCP -sTCP:LISTEN -n -P | grep -E "^node")
    
    if [ "$FOUND" -eq 0 ]; then
        echo "None detected | disabled=true"
    fi
}

# Action: Kill specific PID
action_kill_pid() {
    TARGET_PID="$2"
    if [ -n "$TARGET_PID" ]; then
        kill -9 "$TARGET_PID"
        osascript -e "display notification \"Killed process $TARGET_PID\" with title \"NPM Dev Server\""
    fi
}

# Action: Start Server
action_start() {
    if ! command -v npm &> /dev/null; then
        osascript -e "display notification \"npm not found in PATH\" with title \"NPM Dev Server Error\""
        exit 1
    fi

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
    SEARCH_PATTERN="${PROCESS_NAME:-$DEV_COMMAND}"
    
    if pgrep -f "$SEARCH_PATTERN" > /dev/null; then
        pkill -f "$SEARCH_PATTERN"
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
    "kill_pid")
        action_kill_pid "$1" "$2"
        exit 0
        ;;
esac

# Main Menu Output
if is_server_running; then
    echo "| sfimage=checkmark.circle.fill color=green tooltip=Dev Server Running"
    echo "---"
    
    # Try to get port and show URL
    PORT=$(get_port)
    if [ -n "$PORT" ]; then
        echo "http://localhost:$PORT | href=http://localhost:$PORT"
    fi
    
    echo "Stop Server | shell=\"$0\" param1=stop terminal=false refresh=true tooltip=\"Stop the development server\""
    echo "View Logs | shell=\"$0\" param1=logs terminal=true refresh=true tooltip=\"View server logs in Terminal\""
else
    echo "| sfimage=xmark.circle.fill color=red tooltip=Dev Server Stopped"
    echo "---"
    echo "Start Server | shell=\"$0\" param1=start terminal=false refresh=true tooltip=\"Start the development server\""
fi
list_other_servers
