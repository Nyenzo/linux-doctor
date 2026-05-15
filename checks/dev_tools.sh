check_dev_tools() {
    echo "Git"
    git --version 2>/dev/null || echo "Git not found"

    echo
    echo "Python"
    python3 --version 2>/dev/null || echo "python3 not found"
    python3 -m pip --version 2>/dev/null || echo "pip for python3 not found"

    echo
    echo "Node"
    node --version 2>/dev/null || echo "node not found"
    npm --version 2>/dev/null || echo "npm not found"

    echo
    echo "VS Code"
    code --version 2>/dev/null | head -n 1 || echo "VS Code command not found"
}