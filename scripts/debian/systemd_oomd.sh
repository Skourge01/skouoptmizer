#!/bin/bash

ativar_systemd_oomd() {
    # Verifica se o systemd-oomd já está ativo
    if systemctl is-active --quiet systemd-oomd; then
        echo "systemd-oomd já está ativo."
        return
    fi

    # Pergunta se o usuário deseja ativar o systemd-oomd
    read -p "Deseja ativar o systemd-oomd? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        sudo systemctl enable --now systemd-oomd
        echo "systemd-oomd ativado com sucesso."
    else
        echo "Operação cancelada."
    fi
}

ativar_systemd_oomd
