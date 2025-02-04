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


