#!/bin/bash

install_pipewire() {
    # Check if the packages are already installed
    if pacman -Qs pipewire-jack lib32-pipewire gst-plugin-pipewire realtime-privileges rtkit > /dev/null; then
        echo "Pipewire and its components are already installed."
    else
        read -p "Do you want to install Pipewire and its additional components? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            sudo pacman -S pipewire-jack lib32-pipewire gst-plugin-pipewire realtime-privileges rtkit
            echo "Pipewire and its components have been successfully installed."
        else
            echo "Operation canceled."
            return
        fi
    fi

    # Check if the services are already enabled and running
    if systemctl --user is-enabled --quiet pipewire && systemctl --user is-active --quiet pipewire && \
       systemctl --user is-enabled --quiet pipewire-pulse && systemctl --user is-active --quiet pipewire-pulse && \
       systemctl --user is-enabled --quiet wireplumber && systemctl --user is-active --quiet wireplumber; then
        echo "Pipewire services are already enabled and running."
    else
        read -p "Do you want to enable Pipewire services? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            systemctl --user enable --now pipewire pipewire-pulse wireplumber
            echo "Pipewire services enabled."
        else
            echo "Operation canceled."
        fi
    fi

    # Check if the user is already in the realtime group
    if groups "$USER" | grep -qw "realtime"; then
        echo "The user is already part of the realtime group."
    else
        read -p "Do you want to add the user to the realtime group for better performance? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            sudo usermod -aG realtime "$USER"
            echo "User added to the realtime group. Log out or restart to apply changes."
        else
            echo "Operation canceled."
        fi
    fi
}

configure_pipewire() {
    # Configuration directory and file path
    conf_dir="$HOME/.config/pipewire/pipewire.conf.d"
    conf_file="$conf_dir/10-no-resampling.conf"

    # Create directory if it does not exist
    if [ ! -d "$conf_dir" ]; then
        mkdir -p "$conf_dir"
    fi

    # Check if the configuration file already contains the correct properties
    if [ -f "$conf_file" ] && grep -q "default.clock.rate = 48000" "$conf_file" && grep -q "default.clock.allowed-rates = \[ 44100 48000 96000 192000 \]" "$conf_file"; then
        echo "Pipewire settings are already applied."
    else
        read -p "Do you want to improve Pipewire sound quality? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo -e "context.properties = {\n   default.clock.rate = 48000\n   default.clock.allowed-rates = [ 44100 48000 96000 192000 ]\n}" > "$conf_file"
            echo "Pipewire sound quality settings applied."
        else
            echo "Operation canceled."
        fi
    fi
}

install_pipewire
configure_pipewire
