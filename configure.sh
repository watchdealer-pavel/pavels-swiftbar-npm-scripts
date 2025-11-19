#!/bin/bash
set -euo pipefail

# Helper script to configure the project path and command
SCRIPT_DIR="$(dirname "$0")"
MAIN_SCRIPT="$SCRIPT_DIR/npm-dev-server.1m.sh"

# Get current values
CURRENT_PATH=$(grep "PROJECT_PATH=" "$MAIN_SCRIPT" | cut -d'"' -f2)
CURRENT_COMMAND=$(grep "DEV_COMMAND=" "$MAIN_SCRIPT" | cut -d'"' -f2)

# Prompt for new values
echo "Current project path: $CURRENT_PATH"
read -p "Enter new project path (or press Enter to keep current): " NEW_PATH

echo "Current dev command: $CURRENT_COMMAND"
read -p "Enter new dev command (or press Enter to keep current): " NEW_COMMAND

# Update the script if values changed
if [ -n "$NEW_PATH" ]; then
    sed -i '' "s|PROJECT_PATH=\"$CURRENT_PATH\"|PROJECT_PATH=\"$NEW_PATH\"|g" "$MAIN_SCRIPT"
fi

if [ -n "$NEW_COMMAND" ]; then
    sed -i '' "s|DEV_COMMAND=\"$CURRENT_COMMAND\"|DEV_COMMAND=\"$NEW_COMMAND\"|g" "$MAIN_SCRIPT"
fi

echo "Configuration updated. Please reload SwiftBar to see changes."
