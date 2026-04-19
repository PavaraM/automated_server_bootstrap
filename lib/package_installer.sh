apt_update() {
    log INFO "Updating APT package lists..."
    if apt update -y &> /dev/null; then
        log INFO "APT update successful"
    else
        log ERROR "APT update failed"
        return 5
    fi
    
    log INFO "Upgrading installed packages..."
    if apt upgrade -y &> /dev/null; then
        log INFO "APT upgrade successful"
    else
        log ERROR "APT upgrade failed"
        return 5
    fi
}

# A generic helper for standard packages
check_and_install_apt() {
    local pkg_name=$1
    local aptlog="$SCRIPT_DIR/logs/apt/apt_$TIMESTAMP-$pkg_name.log"
    
    log DEBUG "Checking if $pkg_name is installed on this system..."
    if dpkg -s $pkg_name &> /dev/null; then
        echo "$pkg_name is already available."
        log INFO "$pkg_name already installed on this system."
        return 0
    fi
    echo "$pkg_name is not installed, installing now..."
    log INFO "$pkg_name not installed"
    log DEBUG "Running apt install $pkg_name"
    if apt install "$pkg_name" -y >> "$aptlog" 2>&1; then
        # Fix ownership of the apt log file
        if [[ -n "$SUDO_USER" ]]; then
            chown "$SUDO_USER:$SUDO_USER" "$aptlog"
        fi
        echo "$pkg_name installed successfully."
        log INFO "$pkg_name installation successful"
    else
        # Fix ownership of the apt log file
        if [[ -n "$SUDO_USER" ]]; then
            chown "$SUDO_USER:$SUDO_USER" "$aptlog"
        fi
        echo "$pkg_name installation failed (check $aptlog for details)"
        log ERROR "$pkg_name installation failed (see apt log: apt_$TIMESTAMP-$pkg_name.log)"
        return 5
    fi
}

installing_pkg() {
    log DEBUG "Loading the packages list from \"$SCRIPT_DIR/conf/packages.conf\"."
    if source "$SCRIPT_DIR/conf/packages.conf" &> /dev/null; then
        log INFO "Package list has been successfully loaded"
        log INFO "These packages will be installed: ${package_name[@]}"
    else
        log ERROR "Package list cannot be loaded. Please check if the file \"$SCRIPT_DIR/conf/packages.conf\" exists."
        return 1
    fi

    
    for pkg in ${package_name[@]}; do
        if ! check_and_install_apt "$pkg" "$pkg"; then
            log ERROR "Failed to install package: $pkg"
            failed_packages+="$pkg"
        else
            log INFO "Package $pkg installed successfully"
        fi
    done
    
}