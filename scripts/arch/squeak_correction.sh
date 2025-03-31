#!/bin/bash
configure_static_fix() {
    # Path to the configuration file
    conf_file="$HOME/.config/pipewire/pipewire.conf.d/10-sound.conf"

    # Check if the file already contains the necessary configurations
    if grep -q "default.clock.quantum = 4096" "$conf_file"; then
        echo "Static noise fix under load is already configured."
    else
        # Ask the user if they want to configure it
        read -p "Do you want to fix the static noise under load by adjusting the Pipewire buffer? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            # Create directory if it doesn't exist
            mkdir -p "$HOME/.config/pipewire/pipewire.conf.d"

            # Create or edit the file with the necessary settings
            cat <<EOF > "$conf_file"
context.properties = {
    default.clock.rate = 48000
    default.clock.allowed-rates = [ 44100 48000 88200 96000 ]
    default.clock.min-quantum = 512
    default.clock.quantum = 4096
    default.clock.max-quantum = 8192
}
EOF

            echo "Static noise fix under load successfully configured."
        else
            echo "Operation canceled. Static noise fix was not configured."
        fi
    fi
}
configure_static_fix
