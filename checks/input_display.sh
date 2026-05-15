check_input_display() {
    echo "Desktop: ${XDG_CURRENT_DESKTOP:-unknown}"
    echo "Session type: ${XDG_SESSION_TYPE:-unknown}"
    echo "Display: ${DISPLAY:-unknown}"

    echo
    echo "Input devices"

    if command -v xinput >/dev/null 2>&1; then
        xinput list
    else
        echo "xinput is not installed"
        echo "Install it with: sudo apt install xinput"
    fi

    echo
    echo "Recent input and display logs"

    journalctl --since "1 hour ago" 2>/dev/null \
        | grep -Ei "mouse|touchpad|input|xfce|display|xorg|wayland|libinput" \
        | tail -n 30 \
        || echo "No recent input or display logs found"
}