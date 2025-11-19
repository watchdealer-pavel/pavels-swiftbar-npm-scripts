#!/bin/bash
set -euo pipefail

# Helper script to start the npm dev server
# Called by the SwiftBar plugin

# Ensure Homebrew binaries are available
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Get parameters from main script
PROJECT_PATH="$1"
DEV_COMMAND="$2"

# If parameters are not provided, use defaults (for backward compatibility)
if [ -z "$PROJECT_PATH" ]; then
    PROJECT_PATH="$HOME/your-project-name"
fi

if [ -z "$DEV_COMMAND" ]; then
    DEV_COMMAND="npm run dev"
fi

# Get script directory
SCRIPT_DIR="$(dirname "$0")"
PID_FILE="$SCRIPT_DIR/server.pid"

# Check if project path exists
if [ ! -d "$PROJECT_PATH" ]; then
    osascript -e "display notification \"Project path does not exist: $PROJECT_PATH\" with title \"NPM Dev Server Error\""
    exit 1
fi

# Check if server is already running
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        osascript -e "display notification \"Server is already running (PID: $PID)\" with title \"NPM Dev Server\""
        exit 0
    else
        # Stale PID file, remove it
        rm -f "$PID_FILE"
    fi
fi

# Start the server
cd "$PROJECT_PATH" || exit 1
nohup $DEV_COMMAND > "$SCRIPT_DIR/server.log" 2>&1 &
SERVER_PID=$!

# Save the PID
echo "$SERVER_PID" > "$PID_FILE"

# Give the server a moment to start
sleep 2

# Check if server started successfully by checking the PID
if ps -p "$SERVER_PID" > /dev/null 2>&1; then
    osascript -e "display notification \"Server started successfully (PID: $SERVER_PID)\" with title \"NPM Dev Server\""
else
    osascript -e "display notification \"Failed to start server. Check logs for details.\" with title \"NPM Dev Server Error\""
    # Clean up PID file if server didn't start
    rm -f "$PID_FILE"
fi
