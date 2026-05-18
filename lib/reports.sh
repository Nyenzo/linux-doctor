report_create_path() {
    local timestamp

    timestamp="$(date +"%Y%m%d-%H%M%S")"

    mkdir -p "$BASE_DIR/reports"

    echo "$BASE_DIR/reports/linux-doctor-$timestamp.txt"
}

report_latest_path() {
    find "$BASE_DIR/reports" -maxdepth 1 -type f -name "linux-doctor-*.txt" 2>/dev/null \
        | sort \
        | tail -n 1
}

report_list() {
    if [[ ! -d "$BASE_DIR/reports" ]]; then
        echo "No reports folder found"
        return 0
    fi

    find "$BASE_DIR/reports" -maxdepth 1 -type f -name "linux-doctor-*.txt" 2>/dev/null \
        | sort
}

report_view_file() {
    local report_file="$1"

    if [[ -z "$report_file" ]]; then
        echo "No report file found"
        return 0
    fi

    if [[ ! -f "$report_file" ]]; then
        echo "Report file does not exist: $report_file"
        return 0
    fi

    if command -v less >/dev/null 2>&1; then
        less "$report_file"
    else
        cat "$report_file"
    fi
}
