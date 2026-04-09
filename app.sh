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

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root" >&2
    log ERROR "Not running as root"
    exit 1
fi
