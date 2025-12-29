#!/usr/bin/env bash

# <xbar.title>NPM Dev Server Monitor</xbar.title>
# <xbar.version>v2.1</xbar.version>
# <xbar.author>Watchdealer Pavel</xbar.author>
# <xbar.author.github>watchdealer-pavel</xbar.author.github>
# <xbar.desc>Monitor and control all node dev servers with resource tracking</xbar.desc>
# <xbar.image>https://github.com/watchdealer-pavel/pavels-swiftbar-npm-scripts/raw/main/preview.png</xbar.image>
# <xbar.dependencies>npm</xbar.dependencies>
# <xbar.abouturl>https://github.com/watchdealer-pavel/pavels-swiftbar-npm-scripts</xbar.abouturl>
# <xbar.var>string(VAR_PROJECT_PATH="$HOME/projects/my-app"): Default project path for starting new servers</xbar.var>
# <xbar.var>string(VAR_DEV_COMMAND="npm run dev"): Default command to start the server</xbar.var>

# ===== CONFIGURATION =====

# Default project path for "Start Server" action
PROJECT_PATH="${VAR_PROJECT_PATH:-$HOME/projects/my-app}"

# Default command to start the server
DEV_COMMAND="${VAR_DEV_COMMAND:-npm run dev}"

# Ensure Homebrew binaries are available
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Resource warning thresholds
CPU_WARNING_THRESHOLD=80
MEMORY_WARNING_THRESHOLD=500

# ===== END CONFIGURATION =====

# Runtime storage
DATA_DIR="$HOME/.npm-dev-server"
mkdir -p "$DATA_DIR/servers"

# ===== UTILITY FUNCTIONS =====

get_project_name() {
    basename "$1"
}

get_process_cwd() {
    local pid="$1"
    lsof -p "$pid" -a -d cwd -n -Fn 2>/dev/null | grep '^n' | sed 's/^n//'
}

get_process_stats() {
    local pid="$1"
    if ps -p "$pid" > /dev/null 2>&1; then
        local cpu mem_kb
        cpu=$(ps -p "$pid" -o %cpu= 2>/dev/null | tr -d ' ')
        mem_kb=$(ps -p "$pid" -o rss= 2>/dev/null | tr -d ' ')
        local mem_mb=$((mem_kb / 1024))
        echo "$cpu $mem_mb"
    fi
}

is_process_stuck() {
    local pid="$1"
    local state
    state=$(ps -p "$pid" -o state= 2>/dev/null | tr -d ' ')
    [[ "$state" == "D" ]] || [[ "$state" == "Z" ]]
}

path_hash() {
    echo "$1" | md5 | cut -c1-8
}

# ===== SERVER DETECTION =====

detect_all_node_servers() {
    local seen_pids=""
    while IFS= read -r line; do
        local pid port
        pid=$(echo "$line" | awk '{print $2}')
        if [[ "$seen_pids" == *"$pid"* ]]; then
            continue
        fi
        seen_pids="$seen_pids $pid"
        port=$(echo "$line" | awk '{print $9}' | grep -oE '[0-9]+' | tail -1)
        local cwd
        cwd=$(get_process_cwd "$pid")
        if [[ -n "$pid" ]] && [[ -n "$port" ]]; then
            echo "$pid $port $cwd"
        fi
    done < <(lsof -iTCP -sTCP:LISTEN -n -P 2>/dev/null | grep -E "^node")
}

# ===== LOG FILE MANAGEMENT =====

get_log_file() {
    local cwd="$1"
    echo "$DATA_DIR/servers/$(path_hash "$cwd").log"
}

get_pid_file() {
    local cwd="$1"
    echo "$DATA_DIR/servers/$(path_hash "$cwd").pid"
}

# ===== ACTION HANDLERS =====

action_start() {
    if ! command -v npm &> /dev/null; then
        osascript -e "display notification \"npm not found in PATH\" with title \"Dev Server\""
        exit 1
    fi

    if [[ ! -d "$PROJECT_PATH" ]]; then
        osascript -e "display notification \"Project not found: $PROJECT_PATH\" with title \"Dev Server\""
        exit 1
    fi

    local log_file pid_file
    log_file=$(get_log_file "$PROJECT_PATH")
    pid_file=$(get_pid_file "$PROJECT_PATH")

    if [[ -f "$pid_file" ]]; then
        local existing_pid
        existing_pid=$(cat "$pid_file")
        if ps -p "$existing_pid" > /dev/null 2>&1; then
            osascript -e "display notification \"Already running\" with title \"Dev Server\""
            exit 0
        fi
    fi

    cd "$PROJECT_PATH" || exit 1
    nohup $DEV_COMMAND > "$log_file" 2>&1 &
    local server_pid=$!
    echo "$server_pid" > "$pid_file"
    sleep 2

    if ps -p "$server_pid" > /dev/null 2>&1; then
        osascript -e "display notification \"Started $(get_project_name "$PROJECT_PATH")\" with title \"Dev Server\""
    else
        osascript -e "display notification \"Failed to start\" with title \"Dev Server\""
        rm -f "$pid_file"
    fi
}

action_stop() {
    local target_pid="$2"
    [[ -z "$target_pid" ]] && exit 1

    if ps -p "$target_pid" > /dev/null 2>&1; then
        local cwd project_name
        cwd=$(get_process_cwd "$target_pid")
        project_name=$(get_project_name "$cwd")

        kill "$target_pid" 2>/dev/null
        sleep 2
        ps -p "$target_pid" > /dev/null 2>&1 && kill -9 "$target_pid" 2>/dev/null

        rm -f "$(get_pid_file "$cwd")" 2>/dev/null
        osascript -e "display notification \"Stopped $project_name\" with title \"Dev Server\""
    fi
}

action_force_kill() {
    local target_pid="$2"
    [[ -z "$target_pid" ]] && exit 1

    if ps -p "$target_pid" > /dev/null 2>&1; then
        local cwd
        cwd=$(get_process_cwd "$target_pid")
        kill -9 "$target_pid" 2>/dev/null
        rm -f "$(get_pid_file "$cwd")" 2>/dev/null
        osascript -e "display notification \"Force killed\" with title \"Dev Server\""
    fi
}

action_logs() {
    local target_pid="$2"
    [[ -z "$target_pid" ]] && exit 1

    local cwd log_file
    cwd=$(get_process_cwd "$target_pid")

    if [[ -n "$cwd" ]]; then
        log_file=$(get_log_file "$cwd")
        if [[ -f "$log_file" ]]; then
            echo "=== $(get_project_name "$cwd") ==="
            tail -f "$log_file"
        else
            echo "No logs available (server started externally)"
        fi
    fi
}

action_open() {
    local port="$2"
    [[ -n "$port" ]] && open "http://localhost:$port"
}

# ===== COMMAND DISPATCHER =====

case "$1" in
    "start") action_start; exit 0 ;;
    "stop") action_stop "$@"; exit 0 ;;
    "force_kill") action_force_kill "$@"; exit 0 ;;
    "logs") action_logs "$@"; exit 0 ;;
    "open") action_open "$@"; exit 0 ;;
esac

# ===== MENU OUTPUT =====

servers=()
while IFS= read -r line; do
    [[ -n "$line" ]] && servers+=("$line")
done < <(detect_all_node_servers)

server_count=${#servers[@]}

# ===== MENU BAR ICON =====
# Clean, minimalistic: just an icon, count shown only when servers running
if [[ $server_count -gt 0 ]]; then
    echo "$server_count | sfimage=terminal.fill sfsize=14"
else
    echo "| sfimage=terminal sfsize=14"
fi

echo "---"

# ===== RUNNING SERVERS =====
if [[ $server_count -gt 0 ]]; then
    for server_info in "${servers[@]}"; do
        read -r pid port cwd <<< "$server_info"
        project_name=$(get_project_name "$cwd")
        stats=$(get_process_stats "$pid")
        read -r cpu mem <<< "$stats"

        # Warning check
        cpu_int=${cpu%.*}
        has_warning=false
        [[ ${cpu_int:-0} -gt $CPU_WARNING_THRESHOLD ]] || [[ ${mem:-0} -gt $MEMORY_WARNING_THRESHOLD ]] && has_warning=true
        is_process_stuck "$pid" && has_warning=true

        # Server header - clickable to open URL
        if $has_warning; then
            echo "$project_name :$port | sfimage=exclamationmark.triangle size=13 shell=\"$0\" param1=open param2=$port terminal=false"
        else
            echo "$project_name :$port | sfimage=checkmark.circle size=13 shell=\"$0\" param1=open param2=$port terminal=false"
        fi

        # Stats row
        echo "-- ${cpu:-0}% CPU · ${mem:-0}MB | sfimage=gauge.with.dots.needle.bottom.50percent size=11 disabled=true"

        # Path
        echo "-- $cwd | sfimage=folder size=10 disabled=true"

        echo "-- ---"

        # Actions
        if is_process_stuck "$pid"; then
            echo "-- Force Kill | sfimage=xmark.circle.fill shell=\"$0\" param1=force_kill param2=$pid terminal=false refresh=true"
        else
            echo "-- Stop | sfimage=stop.circle shell=\"$0\" param1=stop param2=$pid terminal=false refresh=true"
        fi
        echo "-- Logs | sfimage=text.alignleft shell=\"$0\" param1=logs param2=$pid terminal=true"

        echo "---"
    done
else
    echo "No servers running | sfimage=moon.zzz size=12 disabled=true"
    echo "---"
fi

# ===== START SERVER - Direct clickable action =====
project_name=$(get_project_name "$PROJECT_PATH")
echo "Start $project_name | sfimage=play.circle shell=\"$0\" param1=start terminal=false refresh=true"

echo "---"
echo "Refresh | sfimage=arrow.clockwise refresh=true"
