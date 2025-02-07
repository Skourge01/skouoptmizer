verificar_e_adicionar_variaveis_gl() {
    local env_file="/etc/environment"
    declare -A variaveis=(
        ["__GL_THREADED_OPTIMIZATIONS"]="1"
        ["__GL_MaxFramesAllowed"]="1"
        ["__GL_YIELD"]='"USLEEP"'
        ["__GL_SHADER_DISK_CACHE_SKIP_CLEANUP"]="1"
    )

    # Verifica quais variáveis já existem
    faltando=()
    for var in "${!variaveis[@]}"; do
        if ! grep -q "^$var=" "$env_file"; then
            faltando+=("$var=${variaveis[$var]}")
        fi
    done

    # Se todas as variáveis já existem, sai da função
    if [[ ${#faltando[@]} -eq 0 ]]; then
        echo "gl variables: configurado"
        return
    fi

    # Pergunta antes de adicionar
    read -p "Deseja adicionar as variáveis de ambiente para otimização gráfica? (sim/nao): " resposta
    if [[ "$resposta" == "sim" ]]; then
        echo "Adicionando variáveis ao /etc/environment..."
        for var in "${faltando[@]}"; do
            echo "$var" | sudo tee -a "$env_file" > /dev/null
        done

        # Detecta o monitor e adiciona "__GL_SYNC_DISPLAY_DEVICE" se ainda não existir
        if ! grep -q "^__GL_SYNC_DISPLAY_DEVICE=" "$env_file"; then
            monitor=$(xrandr --query | grep " connected" | awk '{print $1}' | head -n 1)
            if [[ -n "$monitor" ]]; then
                echo "Detectado monitor principal: $monitor"
                echo "__GL_SYNC_DISPLAY_DEVICE=$monitor" | sudo tee -a "$env_file" > /dev/null
            else
                echo "Não foi possível detectar o monitor automaticamente. Configure manualmente se necessário."
            fi
        fi

        echo "Variáveis de ambiente adicionadas com sucesso!"
    else
        echo "As variáveis de ambiente não foram adicionadas."
    fi
}

verificar_e_adicionar_variaveis_gl
