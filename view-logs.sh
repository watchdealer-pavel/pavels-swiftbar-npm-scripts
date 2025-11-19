#!/bin/bash
set -euo pipefail

# Helper script to view server logs
SCRIPT_DIR="$(dirname "$0")"
LOG_FILE="$SCRIPT_DIR/server.log"

if [ -f "$LOG_FILE" ]; then
    echo "Following server logs (Ctrl+C to exit):"
    tail -f "$LOG_FILE"
else
    echo "No log file found at $LOG_FILE"
fi
