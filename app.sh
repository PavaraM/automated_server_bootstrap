#!/usr/bin/bash
# main application script
# ----------------------------------------------------
# ====================================================
# AUTOMATED SERVER BOOTSTRAPER
# ABOUT: A comprehensive bash script to automate the setup and configuration of a server environment, including package installation, user management, and security hardening.
# ====================================================

set -euo pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly START_TIME=$(date +%s%3N)

# loading logging script and initializing logger
if ! source "$SCRIPT_DIR/lib/logger.sh" &>>/dev/null ; then
    echo "Failed to load logger.sh. Exiting."
    exit 1
fi
logger_init
trap log_footer EXIT
log DEBUG "Starting application script"

# Check for arguments first
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments provided. Use --help for usage information." >&2
    log ERROR "No arguments provided"
    exit 2
fi

rootcheck() {
    if [[ $EUID -ne 0 ]]; then
        echo "Error: This script must be run as root" >&2
        log ERROR "Not running as root"
        exit 1
    fi
}

# Load package installer functions
if ! source "$SCRIPT_DIR/lib/package_installer.sh" &>>/dev/null ; then
    log ERROR "Failed to load package_installer.sh. Exiting."
    exit 1
else
    log INFO "Package installer functions loaded successfully"
fi

main_execution() {
    log INFO "Starting main execution of the server bootstrapper"
    rootcheck
    log INFO "Running as root user"
    installing_pkg
    # Additional setup functions can be called here
    log INFO "Main execution completed successfully"
}

#parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Automated Server Bootstrapper - A comprehensive bash script to automate the setup and configuration of a server environment."
            echo
            echo "Options:"
            echo "  --help        Show this help message and exit"
            exit 0
            ;;
        
        run)
            main_execution
            shift
            ;;
        
        *)
            echo "Error: Unknown option: $1" >&2
            log ERROR "Unknown option: $1"
            exit 2
            ;;
    esac
done 
