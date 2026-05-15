# Linux Doctor

`linux-doctor` is a lightweight Bash-based diagnostics tool for Linux systems. It aggregates health and status checks across system state, battery, developer tooling, Docker, Redis, Python/Node.js ecosystems, and input/display issues.

## What it does

- Reports core system information and overall environment health.
- Inspects battery status and power-related diagnostics.
- Checks for installed development tools and common runtime support.
- Verifies Docker installation and daemon availability.
- Checks Redis service availability and configuration status.
- Detects input and display-related issues such as keyboard, mouse, and screen subsystem problems.
- Evaluates package health for installed software dependencies.

## Project structure

- `linux-doctor.sh` - main entrypoint and report generator.
- `checks/` - modular health check scripts.
  - `system.sh`
  - `battery.sh`
  - `dev_tools.sh`
  - `docker.sh`
  - `redis.sh`
  - `input_display.sh`
  - `packages.sh`

Each `checks/*.sh` file is sourced by `linux-doctor.sh` and exposes a check function used to render that report section.

## Requirements

- Linux-based OS
- `bash`

## Usage

Make the script executable and run it:

```bash
chmod +x linux-doctor.sh
./linux-doctor.sh
```

The script prints a report with separate sections for system information, battery status, developer tools, Docker status, Redis status, input/display diagnostics, and package health.

## Extending the tool

To add or update checks:

1. Edit or create a `checks/*.sh` module.
2. Define a function such as `check_system`, `check_battery`, `check_dev_tools`, etc.
3. Ensure the function prints any diagnostics and recommendations.
4. Add the new module to `linux-doctor.sh` and call it via `run_section "Title" function_name`.

## Notes

This project is intentionally modular so new Linux health checks can be added quickly. The current `checks/` directory is designed to support deeper Python and Node.js environment checks, along with expanded developer tooling diagnostics.

## License

Use this project freely and extend it to fit your Linux health monitoring workflow.
