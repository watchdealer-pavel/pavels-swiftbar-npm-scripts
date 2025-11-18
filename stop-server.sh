#!/bin/bash

# Helper script to stop the npm dev server
# Called by the SwiftBar plugin

# Get parameters from main script
PROJECT_PATH="$1"
DEV_COMMAND="$2"

# If parameters are not provided, use defaults (for backward compatibility)
if [ -z "$DEV_COMMAND" ]; then
    DEV_COMMAND="npm run dev"
fi

# Extract process name from command
PROCESS_NAME=$(echo "$DEV_COMMAND" | awk '{print $1}')

# Check if process is running
if pgrep -f "$PROCESS_NAME" > /dev/null; then
    pkill -f "$PROCESS_NAME"
    osascript -e "display notification \"Server stopped\" with title \"NPM Dev Server\""
else
    osascript -e "display notification \"Server was not running\" with title \"NPM Dev Server\""
fi
