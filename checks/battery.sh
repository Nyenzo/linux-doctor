check_battery() {
    if ! command -v upower >/dev/null 2>&1; then
        echo "upower is not installed"
        echo "Install it with: sudo apt install upower"
        summary_add "INFO" "Battery" "Battery check skipped because upower is not installed"
        return 0
    fi

    local battery
    battery="$(upower -e | grep BAT | head -n 1 || true)"

    if [[ -z "$battery" ]]; then
        echo "No battery detected"
        summary_add "INFO" "Battery" "No battery detected"
        return 0
    fi

    upower -i "$battery" | grep -E "state|percentage|capacity|time to|energy" || true

    local capacity
    local percentage

    capacity="$(upower -i "$battery" | awk '/capacity:/ {print $2}' | tr -d '%')"
    percentage="$(upower -i "$battery" | awk '/percentage:/ {print $2}' | tr -d '%')"

    if [[ -n "$capacity" ]]; then
        if [[ "${capacity%.*}" -lt 50 ]]; then
            summary_add "WARNING" "Battery" "Battery capacity is low at ${capacity}%"
        else
            summary_add "OK" "Battery" "Battery capacity is ${capacity}%"
        fi
    else
        summary_add "INFO" "Battery" "Battery capacity could not be read"
    fi

    if [[ -n "$percentage" ]]; then
        summary_add "INFO" "Battery charge" "Current battery charge is ${percentage}%"
    fi
}