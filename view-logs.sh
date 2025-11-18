#!/bin/bash

# Helper script to view server logs
SCRIPT_DIR="$(dirname "$0")"
LOG_FILE="$SCRIPT_DIR/server.log"

if [ -f "$LOG_FILE" ]; then
    cat "$LOG_FILE"
else
    echo "No log file found."
fi
