#!/bin/bash
# skouoptmizer vai dizer sim ou não para as otimizações mais rápidas do sistema, o verdadeiro Debian.

# Função para verificar e instalar o figlet, se necessário
verificar_figlet() {
    if ! command -v figlet &> /dev/null; then
        echo "Instalando figlet..."
        sudo apt install figlet -y
    fi
}

executar_graphicaldependences() {
    # Obtém o diretório do script atual
    local script_dir="$(dirname "$(readlink -f "$0")")"
    # Define o caminho para o script do Debian
    local script_path="${script_dir}/graphicaldependences.sh"

    # Verifica se o script existe
    if [[ -f "$script_path" ]]; then
        echo "Executando o script graphicaldependences.sh ..."
        bash "$script_path"
    else
        echo "Erro: O script graphicaldependences.sh  não foi encontrado em $script_path."
    fi
}
executar_graphicaldependences
executar_glvariables() {
    # Obtém o diretório do script atual
    local script_dir="$(dirname "$(readlink -f "$0")")"
    # Define o caminho para o script do Debian
    local script_path="${script_dir}/glvariables.sh"

    if [[ -f "$script_path" ]]; then
        echo "Executando o script glvariables.sh do Debian..."
        bash "$script_path"
    else
        echo "Erro: O script glvariables.sh do Debian não foi encontrado em $script_path."
    fi
}
executar_glvariables
executar_systemd_initramfs() {
    # Obtém o diretório do script atual
    local script_dir="$(dirname "$(readlink -f "$0")")"
    # Define o caminho para o script do Debian
    local script_path="${script_dir}/systemd_initramfs.sh"

    if [[ -f "$script_path" ]]; then
        echo "Executando o script systemd_initramfs.sh do Debian..."
        bash "$script_path"
    else
        echo "Erro: O script systemd_initramfs.sh do Debian não foi encontrado em $script_path."
    fi
}
executar_systemd_initramfs
executar_initramfs_lz4() {
    # Obtém o diretório do script atual
    local script_dir="$(dirname "$(readlink -f "$0")")"
    # Define o caminho para o script do Debian
    local script_path="${script_dir}/initramfs_lz4.sh"

    if [[ -f "$script_path" ]]; then
        echo "Executando o script initramfs_lz4.sh do Debian..."
        bash "$script_path"
    else
        echo "Erro: O script initramfs_lz4.sh do Debian não foi encontrado em $script_path."
    fi
}
executar_initramfs_lz4