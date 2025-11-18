#!/bin/bash

# Helper script to start the npm dev server
# Called by the SwiftBar plugin

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

# Check if project path exists
if [ ! -d "$PROJECT_PATH" ]; then
    osascript -e "display notification \"Project path does not exist: $PROJECT_PATH\" with title \"NPM Dev Server Error\""
    exit 1
fi

# Start the server
cd "$PROJECT_PATH" || exit 1
nohup $DEV_COMMAND > "$SCRIPT_DIR/server.log" 2>&1 &

# Give the server a moment to start
sleep 2

# Check if server started successfully
if pgrep -f "$DEV_COMMAND" > /dev/null; then
    osascript -e "display notification \"Server started successfully\" with title \"NPM Dev Server\""
else
    osascript -e "display notification \"Failed to start server. Check logs for details.\" with title \"NPM Dev Server Error\""
fi
