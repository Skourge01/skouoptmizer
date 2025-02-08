#!/bin/bash
#skouoptmizer vai dizer sim ou nao para as otimizacoes mais rapidas do sistema, o verdadeiro archlinux 
verificar_figlet(){
    if ! command -v figlet &> /dev/null; then
        sudo pacman -S --noconfirm figlet &> /dev/null
    fi
}

# Função genérica para executar scripts
executar_script() {
    local nome_script="$1"
    # Obtém o diretório do script atual
    local script_dir="$(dirname "$(readlink -f "$0")")"
    # Define o caminho para o script
    local script_path="${script_dir}/${nome_script}.sh"

    if [[ -f "$script_path" ]]; then
        echo "Executando o script ${nome_script}.sh..."
        bash "$script_path"
    else
        echo "Erro: O script ${nome_script}.sh não foi encontrado em $script_path."
    fi
}

# Execução principal
verificar_figlet
figlet Skouoptmizer

# Lista de scripts para executar
scripts=(
    "multilib"
    "reflectorsync"
    "graphicaldependences"
    "glvariables"
    "initramfs_lz4"
    "systemd_initramfs"
    "systemd_oomd"
    "ananicy_cpp"
    "trim"
    "irqbalance"
    "pipewire"
    "stereo_mix_51"
    "squeak_correction"
)

# Executa cada script
for script in "${scripts[@]}"; do
    executar_script "$script"
done

sudo pacman -Rns figlet
