#!/bin/bash

install_ananicy_cpp() {
    # Check if ananicy-cpp is installed
    if pacman -Qs ananicy-cpp > /dev/null; then
        echo "ananicy-cpp is already installed."
    else
        read -p "Do you want to install ananicy-cpp? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            sudo pacman -S ananicy-cpp
            echo "ananicy-cpp installed successfully."
        else
            echo "Operation canceled."
            return
        fi
    fi

    # Check if the ananicy-cpp service is enabled and active
    if systemctl is-enabled --quiet ananicy-cpp && systemctl is-active --quiet ananicy-cpp; then
        echo "The ananicy-cpp service is already enabled and active."
    else
        read -p "Do you want to enable the ananicy-cpp service? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            sudo systemctl enable --now ananicy-cpp
            echo "The ananicy-cpp service has been successfully activated."
        else
            echo "Operation canceled."
        fi
    fi

    # Check if additional rules are installed
    if pacman -Qs cachyos-ananicy-rules-git > /dev/null; then
        echo "Additional ananicy-cpp rules are already installed."
    else
        read -p "Do you want to install additional ananicy-cpp rules? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            git clone https://aur.archlinux.org/cachyos-ananicy-rules-git.git
            if [[ -d cachyos-ananicy-rules-git ]]; then
                cd cachyos-ananicy-rules-git
                makepkg -sric
                cd ..
                rm -rf cachyos-ananicy-rules-git
                sudo systemctl restart ananicy-cpp
                echo "Additional ananicy-cpp rules installed and service restarted."
            else
                echo "Error: Failed to clone repository."
            fi
        else
            echo "Operation canceled."
        fi
    fi
}

# Run the function
install_ananicy_cpp
