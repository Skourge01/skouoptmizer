#!/bin/bash
configure_stereo_mix_51() {
    # Directories and configuration files
    pulse_conf_dir="$HOME/.config/pipewire/pipewire-pulse.conf.d"
    rt_conf_dir="$HOME/.config/pipewire/client-rt.conf.d"
    upmix_conf_file="$HOME/.config/pipewire/pipewire-pulse.conf.d/20-upmix.conf"
    rt_upmix_conf_file="$HOME/.config/pipewire/client-rt.conf.d/20-upmix.conf"

    # Check if the configuration files already exist
    if [ -f "$upmix_conf_file" ] && [ -f "$rt_upmix_conf_file" ]; then
        echo "Stereo 5.1 mix is already configured."
    else
        # Ask the user if they want to configure it
        read -p "Do you want to configure stereo mix for 5.1? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            # Create directories if they do not exist
            mkdir -p "$pulse_conf_dir" "$rt_conf_dir"

            # Copy the configuration files to the appropriate directories
            sudo cp /usr/share/pipewire/client-rt.conf.avail/20-upmix.conf "$pulse_conf_dir"
            sudo cp /usr/share/pipewire/client-rt.conf.avail/20-upmix.conf "$rt_conf_dir"

            echo "Stereo mix for 5.1 successfully configured."
        else
            echo "Operation canceled. Stereo 5.1 mix was not configured."
        fi
    fi
}
configure_stereo_mix_51
