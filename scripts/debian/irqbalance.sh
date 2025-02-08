#!/bin/bash
verificar_e_ativar_irqbalance() {
    # Verificar se o serviço irqbalance está em execução
    if systemctl is-active --quiet irqbalance; then
        echo "irqbalance já está em execução."
        return
    fi
    
    # Perguntar ao usuário se deseja ativar o irqbalance
    read -p "O serviço irqbalance não está em execução. Deseja ativá-lo? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        sudo apt update && sudo apt install -y irqbalance
        sudo systemctl enable --now irqbalance
        echo "irqbalance foi instalado e ativado com sucesso."
    else
        echo "Operação cancelada. irqbalance não foi ativado."
    fi
}
verificar_e_ativar_irqbalance
