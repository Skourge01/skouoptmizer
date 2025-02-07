#!/bin/bash
instalar_ananicy_cpp() {
    # Verifica se o ananicy-cpp está instalado
    if pacman -Qs ananicy-cpp > /dev/null; then
        echo "ananicy-cpp já está instalado."
    else
        read -p "Deseja instalar o ananicy-cpp? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            sudo pacman -S ananicy-cpp
            echo "ananicy-cpp instalado com sucesso."
        else
            echo "Operação cancelada."
            return
        fi
    fi

    # Verifica se o serviço ananicy-cpp está habilitado e ativo
    if systemctl is-enabled --quiet ananicy-cpp && systemctl is-active --quiet ananicy-cpp; then
        echo "O serviço ananicy-cpp já está habilitado e ativo."
    else
        read -p "Deseja ativar o serviço ananicy-cpp? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            sudo systemctl enable --now ananicy-cpp
            echo "O serviço ananicy-cpp foi ativado com sucesso."
        else
            echo "Operação cancelada."
        fi
    fi

    # Verifica se as regras adicionais já estão instaladas
    if pacman -Qs cachyos-ananicy-rules-git > /dev/null; then
        echo "As regras adicionais do ananicy-cpp já estão instaladas."
    else
        read -p "Deseja instalar as regras adicionais do ananicy-cpp? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            git clone https://aur.archlinux.org/cachyos-ananicy-rules-git.git
            cd cachyos-ananicy-rules-git
            makepkg -sric
            cd ..
            rm -rf cachyos-ananicy-rules-git
            sudo systemctl restart ananicy-cpp
            echo "Regras adicionais do ananicy-cpp instaladas e serviço reiniciado."
        else
            echo "Operação cancelada."
        fi
    fi
}

instalar_ananicy_cpp
