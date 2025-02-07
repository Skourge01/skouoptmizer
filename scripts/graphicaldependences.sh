#!/bin/bash

instalar_dependencias_graficas() {
    echo "Escolha a placa gráfica para instalar as dependências:"
    echo "1. Intel"
    echo "2. AMD"
    echo "3. NVIDIA"
    read -p "Digite o número da opção desejada (1/2/3): " opcao

    case $opcao in
        1)
            echo "Verificando dependências para Intel..."
            pacotes=("mesa" "lib32-mesa" "vulkan-intel" "lib32-vulkan-intel" "opencl-rusticl-mesa" "lib32-opencl-rusticl-mesa")
            ;;
        2)
            echo "Verificando dependências para AMD..."
            pacotes=("mesa" "lib32-mesa" "vulkan-radeon" "lib32-vulkan-radeon" "vulkan-mesa-layers" "opencl-rusticl-mesa" "lib32-opencl-rusticl-mesa")
            ;;
        3)
            echo "Verificando dependências para NVIDIA..."
            pacotes=("nvidia-open-dkms" "nvidia-utils" "lib32-nvidia-utils" "nvidia-settings" "lib32-opencl-nvidia" "opencl-nvidia" "libxnvctrl" "lib32-vulkan-icd-loader" "libva-nvidia-driver")
            ;;
        *)
            echo "Opção inválida. Nenhuma dependência instalada."
            return
            ;;
    esac

    # Filtrar pacotes que já estão instalados
    pacotes_faltando=()
    for pacote in "${pacotes[@]}"; do
        if ! pacman -Q "$pacote" &>/dev/null; then
            pacotes_faltando+=("$pacote")
        fi
    done

    if [[ ${#pacotes_faltando[@]} -eq 0 ]]; then
        echo "Todas as dependências já estão instaladas."
    else
        echo "Instalando os seguintes pacotes: ${pacotes_faltando[*]}"
        sudo pacman -S "${pacotes_faltando[@]}"
    fi
}

instalar_dependencias_graficas
