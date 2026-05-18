check_dev_tools() {
    echo "Git"

    if git --version 2>/dev/null; then
        summary_add "OK" "Git" "Git is installed"
    else
        echo "Git not found"
        summary_add "WARNING" "Git" "Git not found"
    fi

    echo
    echo "Python"

    if python3 --version 2>/dev/null; then
        summary_add "OK" "Python" "python3 is installed"
    else
        echo "python3 not found"
        summary_add "WARNING" "Python" "python3 not found"
    fi

    if python3 -m pip --version 2>/dev/null; then
        summary_add "OK" "pip" "pip for python3 is installed"
    else
        echo "pip for python3 not found"
        summary_add "WARNING" "pip" "pip for python3 not found"
    fi

    echo
    echo "Node"

    if node --version 2>/dev/null; then
        summary_add "OK" "Node" "Node is installed"
    else
        echo "node not found"
        summary_add "WARNING" "Node" "node not found"
    fi

    if npm --version 2>/dev/null; then
        summary_add "OK" "npm" "npm is installed"
    else
        echo "npm not found"
        summary_add "WARNING" "npm" "npm not found"
    fi

    echo
    echo "VS Code"

    if code --version 2>/dev/null | head -n 1; then
        summary_add "OK" "VS Code" "VS Code command is available"
    else
        echo "VS Code command not found"
        summary_add "INFO" "VS Code" "VS Code command not found in PATH"
    fi
}