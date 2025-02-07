instalar_ananicy_cpp() {
    # Verifica se o ananicy-cpp está instalado
    if pacman -Qs ananicy-cpp > /dev/null; then
        echo "ananicy-cpp já está instalado."
    else
        # Pergunta ao usuário se deseja instalar o ananicy-cpp
        read -p "Deseja instalar o ananicy-cpp? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            sudo pacman -S ananicy-cpp
            echo "ananicy-cpp instalado com sucesso."
        else
            echo "Operação cancelada."
            return
        fi
    fi

    # Verifica se o serviço ananicy-cpp está ativo
    if systemctl is-active --quiet ananicy-cpp; then
        echo "O serviço ananicy-cpp já está ativo."
    else
        # Pergunta ao usuário se deseja ativar o serviço
        read -p "Deseja ativar o serviço ananicy-cpp? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            sudo systemctl enable --now ananicy-cpp
            echo "O serviço ananicy-cpp foi ativado com sucesso."
        else
            echo "Operação cancelada."
        fi
    fi

    # Instalando as regras adicionais
    read -p "Deseja instalar as regras adicionais do ananicy-cpp? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        git clone https://aur.archlinux.org/cachyos-ananicy-rules-git.git
        cd cachyos-ananicy-rules-git
        makepkg -sric
        sudo systemctl restart ananicy-cpp
        echo "Regras adicionais do ananicy-cpp instaladas e serviço reiniciado."
    else
        echo "Operação cancelada."
    fi
}
instalar_ananicy_cpp