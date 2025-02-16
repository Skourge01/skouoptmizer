#!/bin/bash
ativar_multilib() {
    sudo sed -i '/^\s*#\s*\[multilib\]/,/\s*#\s*Include/s/^#//' /etc/pacman.conf
    echo "Repositório multilib ativado com sucesso!"
}

multilib_esta_ativo() {
    grep -q '^[^#]*\[multilib\]' /etc/pacman.conf && grep -q '^[^#]*Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
}

verificar_e_ativar_multilib() {
    if multilib_esta_ativo; then
        echo "O repositório multilib já está ativado."
        return
    fi

    read -r -p "Deseja ativar o repositório multilib? (S/N): " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        ativar_multilib
    else
        echo "Repositório multilib não foi ativado."
    fi
}

verificar_e_ativar_multilib
sudo pacman -Syu