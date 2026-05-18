check_redis() {
    if ! command -v redis-cli >/dev/null 2>&1; then
        echo "redis-cli not found"
        summary_add "INFO" "Redis" "redis-cli is not installed"
        return 0
    fi

    redis-cli --version

    if redis-cli ping >/dev/null 2>&1; then
        echo "Redis server responded with PONG"
        summary_add "OK" "Redis" "Redis server responded with PONG"
    else
        echo "Redis CLI exists but no Redis server responded"
        echo "If you use Redis in Docker, make sure the container is running"
        summary_add "WARNING" "Redis" "redis-cli exists but no Redis server responded"
    fi
}