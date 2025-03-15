#!/bin/bash

check_and_prompt_initramfs_lz4() {
    if grep -q '^COMPRESSION="lz4"' /etc/mkinitcpio.conf && grep -q '^COMPRESSION_OPTIONS=(-9)' /etc/mkinitcpio.conf; then
        echo "Initramfs compression is already correctly set to lz4 (-9). No changes needed."
        return
    fi

    read -p "Initramfs compression is not set to lz4 (-9). Do you want to configure it now? (y/n) " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Configuring mkinitcpio to use lz4..."
        
        # Replace or add compression settings
        sudo sed -i 's/^COMPRESSION=.*/COMPRESSION="lz4"/' /etc/mkinitcpio.conf
        sudo sed -i 's/^COMPRESSION_OPTIONS=.*/COMPRESSION_OPTIONS=(-9)/' /etc/mkinitcpio.conf

        # If the lines do not exist, add them to the end of the file
        if ! grep -q '^COMPRESSION="lz4"' /etc/mkinitcpio.conf; then
            echo 'COMPRESSION="lz4"' | sudo tee -a /etc/mkinitcpio.conf > /dev/null
        fi
        if ! grep -q '^COMPRESSION_OPTIONS=(-9)' /etc/mkinitcpio.conf; then
            echo 'COMPRESSION_OPTIONS=(-9)' | sudo tee -a /etc/mkinitcpio.conf > /dev/null
        fi

        echo "Updating initramfs..."
        sudo mkinitcpio -P

        echo "Configuration completed!"
    else
        echo "Configuration not applied."
    fi
}

check_and_prompt_initramfs_lz4
