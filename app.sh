#!/usr/bin/bash
# main application script
# ----------------------------------------------------
# ====================================================
# AUTOMATED SERVER BOOTSTRAPER
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


