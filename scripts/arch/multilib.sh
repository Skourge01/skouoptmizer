#!/bin/bash

enable_multilib() {
    sudo sed -i '/^\s*#\s*\[multilib\]/,/\s*#\s*Include/s/^#//' /etc/pacman.conf
    echo "Multilib repository successfully enabled!"
}

is_multilib_active() {
    grep -q '^[^#]*\[multilib\]' /etc/pacman.conf && grep -q '^[^#]*Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
}

check_and_enable_multilib() {
    if is_multilib_active; then
        echo "The multilib repository is already enabled."
        return
    fi

    read -r -p "Do you want to enable the multilib repository? (y/n): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        enable_multilib
    else
        echo "Multilib repository was not enabled."
    fi
}

check_and_enable_multilib
sudo pacman -Syu
