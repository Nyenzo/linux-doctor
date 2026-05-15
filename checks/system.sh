check_system() {
    echo "Hostname: $(hostname)"
    echo "User: ${USER:-unknown}"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"

    echo
    echo "Operating system"

    if command -v lsb_release >/dev/null 2>&1; then
        lsb_release -a 2>/dev/null
    else
        cat /etc/os-release
    fi

    echo
    echo "Memory usage"
    free -h

    echo
    echo "Disk usage"
    df -h /
}