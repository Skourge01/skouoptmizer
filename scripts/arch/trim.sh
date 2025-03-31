#!/bin/bash
check_and_configure_trim() {
    # Check if the BTRFS file system is NOT in use
    if lsblk -f | grep -q 'btrfs'; then
        echo "BTRFS file system detected. Manual TRIM is not necessary, as kernel 6.2 or later manages it automatically."
        return
    fi
    
    # Check the kernel version
    kernel_version=$(uname -r | cut -d'.' -f1,2)
    
    if [[ "$kernel_version" < "6.2" ]]; then
        # Non-BTRFS file system and kernel version 6.2 or lower
        echo "Non-BTRFS file system or kernel version below 6.2. Proceeding with fstrim configuration."
        
        # Check if fstrim.timer is already running
        if systemctl is-active --quiet fstrim.timer; then
            echo "fstrim.timer is already running. No action needed."
            return
        fi
        
        # Ask the user if they want to enable fstrim.timer or run it manually
        read -p "Do you want to enable fstrim.timer for automatic weekly SSD trimming? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            sudo systemctl enable --now fstrim.timer
            echo "fstrim.timer enabled for automatic weekly execution."
        else
            read -p "Do you want to run fstrim manually now? (y/n) " response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                sudo fstrim -v /
                echo "fstrim executed manually."
            else
                echo "Operation canceled."
            fi
        fi
    else
        echo "Kernel 6.2 or later detected. TRIM is managed automatically by the kernel."
    fi
}
check_and_configure_trim
