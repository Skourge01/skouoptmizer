#!/bin/bash
#skouoptmizer vai dizer sim ou nao para as otimizacoes mais rapidas do sistema, o verdadeiro archlinux 
# primeiro, perguntar se desejo ativar o multilib, caso ja estiver ativo, ele nem faz a pergunta
#!/bin/bash
ativar_multilib() {
    sudo sed -i '/\[multilib\]/,/^$/s/^#//g' /etc/pacman.conf
    sudo pacman -Sy
    echo "Repositório multilib ativado com sucesso!"
}
multilib_esta_ativo() {
    grep -q '^\[multilib\]' /etc/pacman.conf && \
    grep -q 'Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
}
if ! multilib_esta_ativo; then
    read -p "Deseja ativar o repositório multilib? (sim/nao): " resposta
    if [[ "$resposta" == "sim" ]]; then
        ativar_multilib
    else
        echo "Repositório multilib não foi ativado."
    fi
else
    echo "O repositório multilib já está ativado."
fi
verificar_reflector_rsync() {
    if ! command -v reflector &> /dev/null || ! command -v rsync &> /dev/null; then
        echo "O reflector ou rsync não estão instalados no sistema."
        read -p "Deseja instalar e habilitar a aceleração da atualização do sistema? (sim/nao): " resposta
        if [[ "$resposta" == "sim" ]]; then
            acelerar_atualizacao
        else
            echo "Aceleração da atualização não será habilitada."
        fi
    else
        echo "A aceleração do sistema já está habilitada."
    fi
}
acelerar_atualizacao() {
    read -p "Deseja habilitar a aceleração da atualização do sistema? (sim/nao): " resposta
    if [[ "$resposta" == "sim" ]]; then
        echo "Instalando o reflector e rsync..."
        sudo pacman -S --noconfirm reflector rsync
        read -p "Digite o nome do país para selecionar os espelhos mais rápidos (ex: Germany, Russia, etc.): " pais
        echo "Classificando os espelhos mais rápidos de $pais..."
        sudo reflector --verbose --country "$pais" -l 25 --sort rate --save /etc/pacman.d/mirrorlist
        sudo pacman -Sy

        echo "Espelhos atualizados para $pais com sucesso!"
    else
        echo "Aceleração da atualização do sistema não foi habilitada."
    fi
}
verificar_reflector_rsync
# Função para instalar dependências de placas gráficas
instalar_dependencias_graficas() {
    echo "Escolha a placa gráfica para instalar as dependências:"
    echo "1. Intel"
    echo "2. AMD"
    echo "3. NVIDIA"
    read -p "Digite o número da opção desejada (1/2/3): " opcao

    case $opcao in
        1)
            echo "Instalando dependências para Intel..."
            sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel opencl-rusticl-mesa lib32-opencl-rusticl-mesa
            ;;
        2)
            echo "Instalando dependências para AMD..."
            sudo pacman -S mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-mesa-layers opencl-rusticl-mesa lib32-opencl-rusticl-mesa
            ;;
        3)
            echo "Instalando dependências para NVIDIA..."
            sudo pacman -S nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings lib32-opencl-nvidia opencl-nvidia libxnvctrl lib32-vulkan-icd-loader libva-nvidia-driver
            ;;
        *)
            echo "Opção inválida. Nenhuma dependência instalada."
            ;;
    esac
}
verificar_e_adicionar_variaveis_gl() {
    # Verifica se todas as variáveis já estão no arquivo
    if grep -q "__GL_THREADED_OPTIMIZATIONS=1" /etc/environment && \
       grep -q "__GL_MaxFramesAllowed=1" /etc/environment && \
       grep -q '__GL_YIELD="USLEEP"' /etc/environment && \
       grep -q "__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1" /etc/environment && \
       grep -q "__GL_SYNC_DISPLAY_DEVICE=" /etc/environment; then
        echo "As variáveis de ambiente já estão configuradas."
        return
    fi

    # Se não estiverem, perguntar se deseja adicionar
    read -p "Deseja adicionar as variáveis de ambiente para otimização gráfica? (sim/nao): " resposta
    if [[ "$resposta" == "sim" ]]; then
        echo "Adicionando variáveis ao /etc/environment..."

        sudo bash -c 'cat << EOF >> /etc/environment
__GL_THREADED_OPTIMIZATIONS=1
__GL_MaxFramesAllowed=1
__GL_YIELD="USLEEP"
__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
EOF'

        # Detectar a saída do monitor principal automaticamente
        monitor=$(xrandr --query | grep " connected" | awk '{print $1}' | head -n 1)
        
        if [[ -n "$monitor" ]]; then
            echo "Detectado monitor principal: $monitor"
            echo "__GL_SYNC_DISPLAY_DEVICE=$monitor" | sudo tee -a /etc/environment > /dev/null
        else
            echo "Não foi possível detectar o monitor automaticamente. Configure manualmente se necessário."
        fi

        echo "Variáveis de ambiente adicionadas com sucesso!"
    else
        echo "As variáveis de ambiente não foram adicionadas."
    fi
}
verificar_e_adicionar_variaveis_gl
verificar_e_perguntar_initramfs_lz4() {
    if grep -q '^COMPRESSION="lz4"' /etc/mkinitcpio.conf && grep -q '^COMPRESSION_OPTIONS=(-9)' /etc/mkinitcpio.conf; then
        echo "A compressão do initramfs já está configurada corretamente para lz4 (-9). Nenhuma alteração necessária."
        return
    fi

    read -p "A compressão do initramfs não está configurada para lz4 (-9). Deseja configurar agora? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        echo "Configurando o mkinitcpio para usar lz4..."
        
        # Substitui ou adiciona as configurações de compressão
        sudo sed -i 's/^COMPRESSION=.*/COMPRESSION="lz4"/' /etc/mkinitcpio.conf
        sudo sed -i 's/^COMPRESSION_OPTIONS=.*/COMPRESSION_OPTIONS=(-9)/' /etc/mkinitcpio.conf

        # Caso as linhas não existam, adiciona ao final do arquivo
        if ! grep -q '^COMPRESSION="lz4"' /etc/mkinitcpio.conf; then
            echo 'COMPRESSION="lz4"' | sudo tee -a /etc/mkinitcpio.conf > /dev/null
        fi
        if ! grep -q '^COMPRESSION_OPTIONS=(-9)' /etc/mkinitcpio.conf; then
            echo 'COMPRESSION_OPTIONS=(-9)' | sudo tee -a /etc/mkinitcpio.conf > /dev/null
        fi

        echo "Atualizando initramfs..."
        sudo mkinitcpio -P

        echo "Configuração concluída!"
    else
        echo "Configuração não aplicada."
    fi
}
verificar_e_perguntar_initramfs_lz4 
verificar_e_perguntar_systemd_initramfs() {
    if grep -q '^HOOKS=(.*systemd.*)' /etc/mkinitcpio.conf; then
        echo "O Systemd já está configurado no initramfs. Nenhuma alteração necessária."
        return
    fi

    read -p "O Systemd não está configurado no initramfs. Deseja configurar agora? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        echo "Configurando o mkinitcpio para usar o Systemd..."

        # Substitui HOOKS pelo novo valor
        sudo sed -i 's/^HOOKS=.*/HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)/' /etc/mkinitcpio.conf

        echo "Atualizando initramfs..."
        sudo mkinitcpio -P

        echo "Configuração concluída!"
    else
        echo "Configuração não aplicada."
    fi
}
verificar_e_perguntar_systemd_initramfs 
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

