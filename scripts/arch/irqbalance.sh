#!/bin/bash

check_and_enable_irqbalance() {
    # Check if the irqbalance service is running
    if systemctl is-active --quiet irqbalance; then
        echo "irqbalance is already running."
        return
    fi
    
    # Ask the user if they want to enable irqbalance
    read -p "The irqbalance service is not running. Do you want to enable it? (y/n) " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        sudo pacman -S irqbalance
        sudo systemctl enable --now irqbalance
        echo "irqbalance has been successfully installed and enabled."
    else
        echo "Operation canceled. irqbalance was not enabled."
    fi
}

check_and_enable_irqbalance
