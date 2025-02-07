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