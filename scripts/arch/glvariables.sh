verificar_e_adicionar_variaveis_gl() { # verify and add glvariables
    local env_file="/etc/environment"
    declare -A variaveis=(
        ["__GL_THREADED_OPTIMIZATIONS"]="1"
        ["__GL_MaxFramesAllowed"]="1"
        ["__GL_YIELD"]='"USLEEP"'
        ["__GL_SHADER_DISK_CACHE_SKIP_CLEANUP"]="1"
    )

    faltando=()
    for var in "${!variaveis[@]}"; do
        if ! grep -q "^$var=" "$env_file"; then
            faltando+=("$var=${variaveis[$var]}")
        fi
    done

    # If all variables already exist, exit the function 
    if [[ ${#faltando[@]} -eq 0 ]]; then
        echo "glvariables configured"
        return
    fi

    # Question before adding 
    read -p "Do you want to add environment variables for graphics optimization? (y/n): " resposta
    if [[ "$resposta" == "y" ]]; then
        echo "adding varibles to /etc/environment..."
        for var in "${faltando[@]}"; do
            echo "$var" | sudo tee -a "$env_file" > /dev/null
        done

        # Detects the monitor and adds "__GL_SYNC_DISPLAY_DEVICE" if it doesn't already exist
        if ! grep -q "^__GL_SYNC_DISPLAY_DEVICE=" "$env_file"; then
            monitor=$(xrandr --query | grep " connected" | awk '{print $1}' | head -n 1)
            if [[ -n "$monitor" ]]; then
                echo "Primary monitor detected: $monitor"
                echo "__GL_SYNC_DISPLAY_DEVICE=$monitor" | sudo tee -a "$env_file" > /dev/null
            else
                echo "Unable to detect monitor automatically. Please configure manually if necessary."
            fi
        fi

        echo "Environment variables added successfully!"
    else
        echo "Environment variables not added."
    fi
}

verificar_e_adicionar_variaveis_gl
