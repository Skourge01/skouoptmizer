verificar_e_adicionar_variaveis_gl() {
    # Verifica se está rodando em um sistema Debian
    if [ ! -f "/etc/debian_version" ]; then
        echo "Este script é específico para sistemas Debian."
        return 1
    fi

    local env_file="/etc/environment"
    declare -A variaveis=(
        ["__GL_THREADED_OPTIMIZATIONS"]="1"
        ["__GL_MaxFramesAllowed"]="1"
        ["__GL_YIELD"]='"USLEEP"'
        ["__GL_SHADER_DISK_CACHE_SKIP_CLEANUP"]="1"
    )

    # Verifica se o xrandr está instalado
    if ! command -v xrandr >/dev/null 2>&1; then
        echo "Instalando x11-xserver-utils para suporte ao xrandr..."
        sudo apt-get update && sudo apt-get install -y x11-xserver-utils
    fi

    # Verifica quais variáveis já existem
    faltando=()
    for var in "${!variaveis[@]}"; do
        if ! grep -q "^$var=" "$env_file"; then
            faltando+=("$var=${variaveis[$var]}")
        fi
    done

    # Se todas as variáveis já existem, sai da função
    if [[ ${#faltando[@]} -eq 0 ]]; then
        echo "Variáveis GL: já configuradas no Debian"
        return
    fi

    # Pergunta antes de adicionar
    read -p "Deseja adicionar as variáveis de ambiente para otimização gráfica no Debian? (sim/nao): " resposta
    if [[ "$resposta" == "sim" ]]; then
        echo "Adicionando variáveis ao /etc/environment..."
        for var in "${faltando[@]}"; do
            echo "$var" | sudo tee -a "$env_file" > /dev/null
        done

        # Detecta o monitor e adiciona "__GL_SYNC_DISPLAY_DEVICE" se ainda não existir
        if ! grep -q "^__GL_SYNC_DISPLAY_DEVICE=" "$env_file"; then
            monitor=$(xrandr --query | grep " connected" | awk '{print $1}' | head -n 1)
            if [[ -n "$monitor" ]]; then
                echo "Detectado monitor principal no Debian: $monitor"
                echo "__GL_SYNC_DISPLAY_DEVICE=$monitor" | sudo tee -a "$env_file" > /dev/null
            else
                echo "Não foi possível detectar o monitor automaticamente no Debian. Configure manualmente se necessário."
            fi
        fi

        echo "Variáveis de ambiente adicionadas com sucesso no sistema Debian!"
    else
        echo "As variáveis de ambiente não foram adicionadas."
    fi
}

verificar_e_adicionar_variaveis_gl
