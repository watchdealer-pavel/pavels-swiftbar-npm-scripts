#!/bin/bash
set -euo pipefail

# Helper script to stop the npm dev server
# Called by the SwiftBar plugin

# Ensure Homebrew binaries are available
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Get parameters from main script
PROJECT_PATH="$1"
DEV_COMMAND="$2"

# Get script directory
SCRIPT_DIR="$(dirname "$0")"
PID_FILE="$SCRIPT_DIR/server.pid"

# If parameters are not provided, use defaults (for backward compatibility)
if [ -z "$DEV_COMMAND" ]; then
    DEV_COMMAND="npm run dev"
fi

# Check if PID file exists and process is running
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        # Process is running, stop it gracefully
        kill "$PID"
        
        # Wait a moment for graceful shutdown
        sleep 2
        
        # Check if process is still running
        if ps -p "$PID" > /dev/null 2>&1; then
            # Force kill if still running
            kill -9 "$PID"
            sleep 1
        fi
        
        # Remove PID file
        rm -f "$PID_FILE"
        osascript -e "display notification \"Server stopped (PID: $PID)\" with title \"NPM Dev Server\""
    else
        # Stale PID file, remove it
        rm -f "$PID_FILE"
        osascript -e "display notification \"Server was not running (stale PID file removed)\" with title \"NPM Dev Server\""
    fi
else
    # No PID file, fall back to process name detection
    PROCESS_NAME=$(echo "$DEV_COMMAND" | awk '{print $1}')
    
    if pgrep -f "$PROCESS_NAME" > /dev/null; then
        pkill -f "$PROCESS_NAME"
        osascript -e "display notification \"Server stopped (detected by process name)\" with title \"NPM Dev Server\""
    else
        osascript -e "display notification \"Server was not running\" with title \"NPM Dev Server\""
    fi
fi
