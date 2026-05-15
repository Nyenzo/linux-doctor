check_packages() {
    echo "APT health"

    if ! command -v apt-get >/dev/null 2>&1; then
        echo "apt-get command not found"
        return 0
    fi

    if [[ "$EUID" -ne 0 ]]; then
        echo "APT dependency check needs elevated privileges on this system"
        echo "Run this command manually for a deeper check:"
        echo "sudo apt-get check"
    else
        local apt_output
        local apt_status

        apt_output="$(apt-get check 2>&1)"
        apt_status=$?

        if [[ "$apt_status" -eq 0 ]]; then
            echo "APT dependency check passed"
            echo "$apt_output"
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
        fi
    fi

    echo
    echo "DPKG audit"

    local dpkg_output
    local dpkg_status

    dpkg_output="$(dpkg --audit 2>&1)"
    dpkg_status=$?

    if [[ "$dpkg_status" -eq 0 && -z "$dpkg_output" ]]; then
        echo "DPKG audit passed"
    elif [[ "$dpkg_status" -eq 0 ]]; then
        echo "$dpkg_output"
    else
        echo "DPKG audit reported a problem"
        echo "$dpkg_output"
    fi
}