#!/usr/bin/env bash

set -u

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASE_DIR/lib/summary.sh"
source "$BASE_DIR/lib/reports.sh"

source "$BASE_DIR/checks/system.sh"
source "$BASE_DIR/checks/battery.sh"
source "$BASE_DIR/checks/dev_tools.sh"
source "$BASE_DIR/checks/docker.sh"
source "$BASE_DIR/checks/redis.sh"
source "$BASE_DIR/checks/input_display.sh"
source "$BASE_DIR/checks/packages.sh"

run_section() {
    local title="$1"
    local function_name="$2"

    echo
    echo "$title"
    "$function_name"
}

print_header() {
    echo "Linux Doctor report"
    echo "Generated on: $(date)"
    echo "Machine: $(hostname)"
}

check_root_warning() {
    if [[ "$EUID" -eq 0 ]]; then
        summary_add "WARNING" "Execution" "Linux Doctor is running as root, so user-level tools may appear missing"

        echo
        echo "Warning: Linux Doctor is running as root"
        echo "Some user-level tools may not appear because root has a different environment"
        echo "Recommended: run ./linux-doctor.sh normally unless you are doing a privileged check"
    else
        summary_add "OK" "Execution" "Linux Doctor is running as a normal user"
    fi
}

run_all_checks() {
    print_header
    check_root_warning

    run_section "System information" check_system
    run_section "Battery information" check_battery
    run_section "Developer tools" check_dev_tools
    run_section "Docker status" check_docker
    run_section "Redis status" check_redis
    run_section "Input and display information" check_input_display
    run_section "Package health" check_packages

    echo
    echo "Report complete"
}

run_and_save_report() {
    local report_file

    report_file="$(report_create_path)"

    {
        run_all_checks
    } > "$report_file"

    summary_print

    echo
    echo "Full report saved to:"
    echo "$report_file"
}

run_and_show_full_report() {
    local report_file

    report_file="$(report_create_path)"

    {
        run_all_checks
    } > "$report_file"

    report_view_file "$report_file"
}

show_latest_report() {
    local latest_report

    latest_report="$(report_latest_path)"
    report_view_file "$latest_report"
}

show_help() {
    echo "Linux Doctor"
    echo
    echo "Usage:"
    echo "./linux-doctor.sh"
    echo "./linux-doctor.sh run"
    echo "./linux-doctor.sh full"
    echo "./linux-doctor.sh latest"
    echo "./linux-doctor.sh list"
    echo "./linux-doctor.sh help"
    echo
    echo "Commands:"
    echo "run     Save a full report and show a health summary"
    echo "full    Save a full report and open it"
    echo "latest  Open the latest saved report"
    echo "list    List saved reports"
    echo "help    Show this help message"
}

main() {
    local command="${1:-run}"

    case "$command" in
        run)
            run_and_save_report
            ;;
        full)
            run_and_show_full_report
            ;;
        latest)
            show_latest_report
            ;;
        list)
            report_list
            ;;
        help)
            show_help
            ;;
        *)
            echo "Unknown command: $command"
            echo
            show_help
            return 1
            ;;
    esac
}

main "$@"