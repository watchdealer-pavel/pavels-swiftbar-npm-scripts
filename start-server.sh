#!/bin/bash

# Helper script to start the npm dev server
# Called by the SwiftBar plugin

PROJECT_PATH="$HOME/your-project-name"
DEV_COMMAND="npm run dev"

cd "$PROJECT_PATH" || exit 1
nohup $DEV_COMMAND > /dev/null 2>&1 &
