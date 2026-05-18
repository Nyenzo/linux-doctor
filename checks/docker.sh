check_docker() {
    echo "Docker CLI"

    if ! command -v docker >/dev/null 2>&1; then
        echo "Docker command not found"
        return 0
    fi

    docker --version

    echo
    echo "Docker CLI context"

    local current_context
    current_context="$(docker context show 2>&1 || true)"

    echo "Current context: ${current_context:-unknown}"

    echo
    echo "Current context reachability"

    local context_output
    local context_status

    context_output="$(docker info 2>&1)"
    context_status=$?

    if [[ "$context_status" -eq 0 ]]; then
        echo "Current Docker context is reachable"
    else
        echo "Current Docker context is not reachable"
        echo "$context_output"
    fi

    echo
    echo "Docker Engine service"

    if command -v systemctl >/dev/null 2>&1; then
        local service_status
        local service_enabled

        service_status="$(systemctl is-active docker 2>/dev/null || true)"
        service_enabled="$(systemctl is-enabled docker 2>/dev/null || true)"

        echo "Service active state: ${service_status:-unknown}"
        echo "Service enabled state: ${service_enabled:-unknown}"
    else
        echo "systemctl not available"
    fi

    echo
    echo "Docker daemon process"

    if pgrep -x dockerd >/dev/null 2>&1; then
        echo "dockerd process is running"
    else
        echo "dockerd process not found"
    fi

    echo
    echo "Docker socket"

    if [[ -S "/var/run/docker.sock" ]]; then
        ls -l /var/run/docker.sock
    else
        echo "Docker socket not found at /var/run/docker.sock"
    fi

    echo
    echo "Docker user access"

    if groups "$USER" | grep -qw docker; then
        echo "User is in the docker group"
    else
        echo "User is not in the docker group"
    fi

    echo
    echo "System Docker Engine reachability"

    local engine_output
    local engine_status

    engine_output="$(docker --host unix:///var/run/docker.sock info 2>&1)"
    engine_status=$?

        if [[ "$engine_status" -eq 0 ]]; then
        echo "System Docker Engine is reachable through /var/run/docker.sock"
        summary_add "OK" "Docker Engine" "System Docker Engine is reachable"
    else
        echo "System Docker Engine is not reachable through /var/run/docker.sock"
        echo
        echo "$engine_output"
        echo
        echo "Useful debugging commands"
        echo "systemctl status docker"
        echo "sudo systemctl start docker"
        echo "ls -l /var/run/docker.sock"
        echo "groups"
        echo "docker context ls"
        echo "docker context use default"
        echo "docker --host unix:///var/run/docker.sock ps"

        summary_add "CRITICAL" "Docker Engine" "System Docker Engine is not reachable"
    fi

    if [[ "$context_status" -eq 0 ]]; then
        summary_add "OK" "Docker context" "Current Docker context is reachable"
    else
        summary_add "WARNING" "Docker context" "Current Docker context is not reachable"
    fi

    if [[ "$current_context" != "default" && "$engine_status" -eq 0 ]]; then
        echo
        echo "Docker note"
        echo "System Docker Engine works, but your current Docker context is: $current_context"
        echo "To use system Docker Engine by default, run:"
        echo "docker context use default"

        summary_add "INFO" "Docker context" "System Engine works, but current context is $current_context"
    fi
}