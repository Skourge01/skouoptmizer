#!/bin/bash
verificar_e_configurar_aparar() {
    # Verificar se o sistema de arquivos BTRFS NÃO está em uso
    if lsblk -f | grep -q 'btrfs'; then
        echo "Sistema de arquivos BTRFS detectado. Não será necessário executar o TRIM manualmente, pois o kernel 6.2 ou superior gerencia automaticamente."
        return
    fi
    
    # Verificar a versão do kernel
    kernel_version=$(uname -r | cut -d'.' -f1,2)
    
    if [[ "$kernel_version" < "6.2" ]]; then
        # Sistema de arquivos não BTRFS e kernel 6.2 ou inferior
        echo "Sistema de arquivos não BTRFS ou kernel inferior a 6.2. Continuando com a configuração do fstrim."
        
        # Verificar se o fstrim.timer já está em execução
        if systemctl is-active --quiet fstrim.timer; then
            echo "fstrim.timer já está em execução. Nenhuma ação necessária."
            return
        fi
        
        # Pergunta se o usuário deseja habilitar o fstrim.timer ou executar manualmente
        read -p "Deseja habilitar o fstrim.timer para limpeza automática semanal do SSD? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            sudo systemctl enable --now fstrim.timer
            echo "fstrim.timer habilitado para execução automática semanal."
        else
            read -p "Deseja executar o comando fstrim agora? (s/n) " resposta
            if [[ "$resposta" =~ ^[Ss]$ ]]; then
                sudo fstrim -v /
                echo "fstrim executado manualmente."
            else
                echo "Operação cancelada."
            fi
        fi
    else
        echo "Kernel 6.2 ou superior detectado. TRIM é gerenciado automaticamente pelo kernel."
    fi
}
verificar_e_configurar_aparar
