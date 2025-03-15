#!/bin/bash

install_graphics_dependencies() {
    echo "Choose the graphics card to install dependencies:"
    echo "1. Intel"
    echo "2. AMD"
    echo "3. NVIDIA"
    read -p "Enter the number of the desired option (1/2/3): " option

    case $option in
        1)
            echo "Checking dependencies for Intel..."
            packages=("mesa" "lib32-mesa" "vulkan-intel" "lib32-vulkan-intel" "opencl-rusticl-mesa" "lib32-opencl-rusticl-mesa")
            ;;
        2)
            echo "Checking dependencies for AMD..."
            packages=("mesa" "lib32-mesa" "vulkan-radeon" "lib32-vulkan-radeon" "vulkan-mesa-layers" "opencl-rusticl-mesa" "lib32-opencl-rusticl-mesa")
            ;;
        3)
            echo "Checking dependencies for NVIDIA..."
            packages=("nvidia-open-dkms" "nvidia-utils" "lib32-nvidia-utils" "nvidia-settings" "lib32-opencl-nvidia" "opencl-nvidia" "libxnvctrl" "lib32-vulkan-icd-loader" "libva-nvidia-driver")
            ;;
        *)
            echo "Invalid option. No dependencies installed."
            return
            ;;
    esac

    # Filter packages that are not installed
    missing_packages=()
    for package in "${packages[@]}"; do
        if ! pacman -Q "$package" &>/dev/null; then
            missing_packages+=("$package")
        fi
    done

    if [[ ${#missing_packages[@]} -eq 0 ]]; then
        echo "All dependencies are already installed."
    else
        echo "Installing the following packages: ${missing_packages[*]}"
        sudo pacman -S "${missing_packages[@]}"
    fi
}

install_graphics_dependencies
