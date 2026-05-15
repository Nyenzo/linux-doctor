#!/usr/bin/env bash

set -u

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASE_DIR/checks/system.sh"
source "$BASE_DIR/checks/battery.sh"
source "$BASE_DIR/checks/dev_tools.sh"
source "$BASE_DIR/checks/docker.sh"
source "$BASE_DIR/checks/redis.sh"
source "$BASE_DIR/checks/input_display.sh"
source "$BASE_DIR/checks/packages.sh"

REPORTS_DIR="$BASE_DIR/reports"
REPORT_FILE="$REPORTS_DIR/linux-doctor-$(date +'%Y%m%d-%H%M%S').txt"

run_section() {
    local title="$1"
    local function_name="$2"

    echo
    echo "$title"
    "$function_name"
}

{
    echo "Linux Doctor report"
    echo "Generated on: $(date)"
    echo "Machine: $(hostname)"

    run_section "System information" check_system
    run_section "Battery information" check_battery
    run_section "Developer tools" check_dev_tools
    run_section "Docker status" check_docker
    run_section "Redis status" check_redis
    run_section "Input and display information" check_input_display
    run_section "Package health" check_packages

    echo
    echo "Report complete"
} | tee "$REPORT_FILE"