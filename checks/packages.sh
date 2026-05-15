check_packages() {
    echo "APT health"

    apt check 2>/dev/null || echo "APT reported a problem"

    echo
    echo "DPKG audit"

    dpkg --audit 2>/dev/null || true
}