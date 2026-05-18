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

    local available_memory_mb
    local swap_used_mb

    available_memory_mb="$(free -m | awk '/^Mem:/ {print $7}')"
    swap_used_mb="$(free -m | awk '/^Swap:/ {print $3}')"

    if [[ "$available_memory_mb" -lt 1000 ]]; then
        summary_add "WARNING" "Memory" "Available memory is below 1GB"
    else
        summary_add "OK" "Memory" "Available memory is ${available_memory_mb}MB"
    fi

    if [[ "$swap_used_mb" -gt 1024 ]]; then
        summary_add "WARNING" "Swap" "Swap usage is above 1GB at ${swap_used_mb}MB"
    else
        summary_add "OK" "Swap" "Swap usage is ${swap_used_mb}MB"
    fi

    echo
    echo "Disk usage"
    df -h /

    local disk_percent

    disk_percent="$(df / | awk 'NR==2 {print $5}' | tr -d '%')"

    if [[ "$disk_percent" -ge 95 ]]; then
        summary_add "CRITICAL" "Disk" "Root partition is ${disk_percent} percent full"
    elif [[ "$disk_percent" -ge 85 ]]; then
        summary_add "WARNING" "Disk" "Root partition is ${disk_percent} percent full"
    else
        summary_add "OK" "Disk" "Root partition is ${disk_percent} percent full"
    fi
}