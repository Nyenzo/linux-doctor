SUMMARY_STATUSES=()
SUMMARY_AREAS=()
SUMMARY_MESSAGES=()

summary_add() {
    local status="$1"
    local area="$2"
    local message="$3"

    SUMMARY_STATUSES+=("$status")
    SUMMARY_AREAS+=("$area")
    SUMMARY_MESSAGES+=("$message")
}

summary_count_status() {
    local wanted_status="$1"
    local count=0
    local index

    for index in "${!SUMMARY_STATUSES[@]}"; do
        if [[ "${SUMMARY_STATUSES[$index]}" == "$wanted_status" ]]; then
            count=$((count + 1))
        fi
    done

    echo "$count"
}

summary_print_items_for_status() {
    local wanted_status="$1"
    local index
    local found=0

    for index in "${!SUMMARY_STATUSES[@]}"; do
        if [[ "${SUMMARY_STATUSES[$index]}" == "$wanted_status" ]]; then
            found=1
            echo "${SUMMARY_AREAS[$index]}: ${SUMMARY_MESSAGES[$index]}"
        fi
    done

    if [[ "$found" -eq 0 ]]; then
        echo "None"
    fi
}

summary_print() {
    local ok_count
    local warning_count
    local critical_count
    local info_count

    ok_count="$(summary_count_status "OK")"
    warning_count="$(summary_count_status "WARNING")"
    critical_count="$(summary_count_status "CRITICAL")"
    info_count="$(summary_count_status "INFO")"

    echo
    echo "Health summary"
    echo
    echo "OK: $ok_count"
    echo "Warnings: $warning_count"
    echo "Critical: $critical_count"
    echo "Info: $info_count"

    echo
    echo "Critical issues"
    summary_print_items_for_status "CRITICAL"

    echo
    echo "Warnings"
    summary_print_items_for_status "WARNING"

    echo
    echo "Healthy checks"
    summary_print_items_for_status "OK"

    echo
    echo "Information"
    summary_print_items_for_status "INFO"
}

