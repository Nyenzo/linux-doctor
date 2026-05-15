check_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "Docker command not found"
        return 0
    fi

    docker --version

    if command -v systemctl >/dev/null 2>&1; then
        echo "Docker service: $(systemctl is-active docker 2>/dev/null || echo unknown)"
    fi

    if docker info >/dev/null 2>&1; then
        echo "Docker engine is reachable"
    else
        echo "Docker is installed but the engine is not reachable"
        echo "Possible causes: Docker is stopped, your user lacks permission, or Docker Desktop is not running"
    fi
}