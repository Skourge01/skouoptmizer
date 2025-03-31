#!/bin/bash
enable_systemd_oomd() {
    # Check if systemd-oomd is already active
    if systemctl is-active --quiet systemd-oomd; then
        echo "systemd-oomd is already active."
        return
    fi

    # Ask the user if they want to enable systemd-oomd
    read -p "Do you want to enable systemd-oomd? (y/n) " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        sudo systemctl enable --now systemd-oomd
        echo "systemd-oomd successfully enabled."
    else
        echo "Operation canceled."
    fi
}
enable_systemd_oomd
