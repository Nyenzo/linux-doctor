check_battery() {
    if ! command -v upower >/dev/null 2>&1; then
        echo "upower is not installed"
        echo "Install it with: sudo apt install upower"
        return 0
    fi

    local battery
    battery="$(upower -e | grep BAT | head -n 1 || true)"

    if [[ -z "$battery" ]]; then
        echo "No battery detected"
        return 0
    fi

    upower -i "$battery" | grep -E "state|percentage|capacity|time to|energy" || true
}