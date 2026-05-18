check_packages() {
    echo "APT health"

    if ! command -v apt-get >/dev/null 2>&1; then
        echo "apt-get command not found"
        summary_add "INFO" "APT" "apt-get command not found"
        return 0
    fi

    local apt_command
    local apt_output
    local apt_status

    if [[ "$EUID" -eq 0 ]]; then
        apt_command="apt-get check"
    elif command -v sudo >/dev/null 2>&1; then
        apt_command="sudo apt-get check"
    else
        echo "APT dependency check needs elevated privileges"
        echo "sudo command not found"
        echo "Run this manually as root:"
        echo "apt-get check"
        summary_add "WARNING" "APT" "APT check needs elevated privileges"
        return 0
    fi

    apt_output="$($apt_command 2>&1)"
    apt_status=$?

    if [[ "$apt_status" -eq 0 ]]; then
        echo "APT dependency check passed"
        echo "$apt_output"
        summary_add "OK" "APT" "APT dependency check passed"
    else
        echo "APT dependency check failed"
        echo
        echo "$apt_output"
        echo
        echo "Suggested debugging commands"
        echo "sudo apt-get update"
        echo "sudo apt-get check"
        echo "sudo dpkg --audit"
        echo "sudo apt-get -f install"
        summary_add "CRITICAL" "APT" "APT dependency check failed"
    fi

    echo
    echo "DPKG audit"

    local dpkg_output
    local dpkg_status

    if [[ "$EUID" -eq 0 ]]; then
        dpkg_output="$(dpkg --audit 2>&1)"
    elif command -v sudo >/dev/null 2>&1; then
        dpkg_output="$(sudo dpkg --audit 2>&1)"
    else
        dpkg_output="$(dpkg --audit 2>&1)"
    fi

    dpkg_status=$?

    if [[ "$dpkg_status" -eq 0 && -z "$dpkg_output" ]]; then
        echo "DPKG audit passed"
        summary_add "OK" "DPKG" "DPKG audit passed"
    elif [[ "$dpkg_status" -eq 0 ]]; then
        echo "$dpkg_output"
        summary_add "WARNING" "DPKG" "DPKG audit returned messages"
    else
        echo "DPKG audit reported a problem"
        echo "$dpkg_output"
        summary_add "WARNING" "DPKG" "DPKG audit reported a problem"
    fi
}