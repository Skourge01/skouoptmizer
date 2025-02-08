#!/bin/bash
detect_distro_and_run() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        distro=${ID:-$ID_LIKE}  # Usa ID, mas se não existir, tenta ID_LIKE

        script_dir="$(dirname "$(realpath "$0")")"  # Obtém o diretório do script

        case "$distro" in
            arch)
                bash "$script_dir/scripts/arch/arch.sh"
                ;;
            debian)
                bash "$script_dir/scripts/debian/debian.sh"
                ;;
            *)
                echo "Distro não suportada: $distro"
                return 1
                ;;
        esac
    else
        echo "Arquivo /etc/os-release não encontrado. Não foi possível detectar a distro."
        return 1
    fi
}

detect_distro_and_run
