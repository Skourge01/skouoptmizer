#!/bin/bash
instalar_dependencias_graficas() {
    echo "Escolha a placa gráfica para instalar as dependências:"
    echo "1. Intel"
    echo "2. AMD"
    echo "3. NVIDIA"
    read -p "Digite o número da opção desejada (1/2/3): " opcao

    case $opcao in
        1)
            echo "Instalando dependências para Intel..."
            sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel opencl-rusticl-mesa lib32-opencl-rusticl-mesa
            ;;
        2)
            echo "Instalando dependências para AMD..."
            sudo pacman -S mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-mesa-layers opencl-rusticl-mesa lib32-opencl-rusticl-mesa
            ;;
        3)
            echo "Instalando dependências para NVIDIA..."
            sudo pacman -S nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings lib32-opencl-nvidia opencl-nvidia libxnvctrl lib32-vulkan-icd-loader libva-nvidia-driver
            ;;
        *)
            echo "Opção inválida. Nenhuma dependência instalada."
            ;;
    esac
}
instalar_dependencias_graficas