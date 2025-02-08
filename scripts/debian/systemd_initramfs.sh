#!/bin/bash
verificar_e_perguntar_systemd_initramfs() {
    # Verifica se está rodando em um sistema Debian
    if [ ! -f "/etc/debian_version" ]; then
        echo "Este script é específico para sistemas Debian."
        return 1
    fi

    # Verifica se o systemd está instalado
    if ! dpkg -l | grep -q "^ii.*systemd"; then
        echo "Instalando systemd..."
        sudo apt-get update && sudo apt-get install -y systemd
    fi

    # Verifica se initramfs-tools está instalado
    if ! dpkg -l | grep -q "^ii.*initramfs-tools"; then
        echo "Instalando initramfs-tools..."
        sudo apt-get update && sudo apt-get install -y initramfs-tools
    fi

    # Verifica configuração atual
    if grep -q "MODULES=most" /etc/initramfs-tools/initramfs.conf; then
        echo "O initramfs já está configurado com MODULES=most. Nenhuma alteração necessária."
        return 0
    fi

    read -p "Deseja configurar o initramfs com suporte systemd? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        echo "Configurando initramfs..."

        # Configura para carregar mais módulos
        sudo sed -i 's/MODULES=.*/MODULES=most/' /etc/initramfs-tools/initramfs.conf

        # Atualiza o initramfs
        echo "Atualizando initramfs..."
        sudo update-initramfs -u -k all

        echo "Configuração concluída!"
    else
        echo "Configuração não aplicada."
    fi
}

verificar_e_perguntar_systemd_initramfs