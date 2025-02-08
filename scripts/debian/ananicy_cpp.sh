#!/bin/bash

instalar_ananicy_cpp() {
    # Verifica se o ananicy-cpp está instalado
    if dpkg -l | grep -q ananicy-cpp; then
        echo "ananicy-cpp já está instalado."
    else
        read -p "Deseja instalar o ananicy-cpp? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            sudo apt update && sudo apt install -y ananicy-cpp
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
}

instalar_ananicy_cpp