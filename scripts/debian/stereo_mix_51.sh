#!/bin/bash
instalar_pipewire() {
    # Verifica se os pacotes já estão instalados
    if dpkg -l | grep -E 'pipewire-jack|libpipewire-.*|gstreamer1.0-pipewire|rtkit' > /dev/null; then
        echo "Pipewire e seus componentes já estão instalados."
    else
        read -p "Deseja instalar o Pipewire e seus componentes adicionais? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            sudo apt update && sudo apt install -y pipewire pipewire-audio-client-libraries pipewire-pulse pipewire-jack libspa-0.2-bluetooth libspa-0.2-jack gstreamer1.0-pipewire rtkit
            echo "Pipewire e seus componentes foram instalados com sucesso."
        else
            echo "Operação cancelada."
            return
        fi
    fi

    # Verifica se os serviços já estão ativos e habilitados
    if systemctl --user is-enabled --quiet pipewire && systemctl --user is-active --quiet pipewire && \
       systemctl --user is-enabled --quiet pipewire-pulse && systemctl --user is-active --quiet pipewire-pulse; then
        echo "Os serviços do Pipewire já estão ativos e habilitados."
    else
        read -p "Deseja ativar os serviços do Pipewire? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            systemctl --user enable --now pipewire pipewire-pulse
            echo "Serviços do Pipewire ativados."
        else
            echo "Operação cancelada."
        fi
    fi

    # Verifica se o usuário já está no grupo realtime
    if groups "$USER" | grep -qw "realtime"; then
        echo "O usuário já faz parte do grupo realtime."
    else
        read -p "Deseja adicionar o usuário ao grupo realtime para melhor desempenho? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            sudo usermod -aG realtime "$USER"
            echo "Usuário adicionado ao grupo realtime. Faça logout ou reinicie para aplicar as mudanças."
        else
            echo "Operação cancelada."
        fi
    fi
}

configurar_pipewire() {
    # Diretório e caminho do arquivo de configuração
    conf_dir="$HOME/.config/pipewire/pipewire.conf.d"
    conf_file="$conf_dir/10-no-resampling.conf"

    # Criar diretório caso não exista
    if [ ! -d "$conf_dir" ]; then
        mkdir -p "$conf_dir"
    fi

    # Verifica se o arquivo de configuração já contém as propriedades corretas
    if [ -f "$conf_file" ] && grep -q "default.clock.rate = 48000" "$conf_file" && grep -q "default.clock.allowed-rates = \[ 44100 48000 96000 192000 \]" "$conf_file"; then
        echo "As configurações do Pipewire já estão aplicadas."
    else
        read -p "Deseja melhorar a qualidade do som do Pipewire? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            echo -e "context.properties = {\n   default.clock.rate = 48000\n   default.clock.allowed-rates = [ 44100 48000 96000 192000 ]\n}" > "$conf_file"
            echo "Configurações de qualidade do Pipewire aplicadas."
        else
            echo "Operação cancelada."
        fi
    fi
}

configurar_mistura_estereo_51() {
    # Diretórios e arquivos de configuração
    pulse_conf_dir="$HOME/.config/pipewire/pipewire-pulse.conf.d"
    rt_conf_dir="$HOME/.config/pipewire/client-rt.conf.d"
    upmix_conf_file="$HOME/.config/pipewire/pipewire-pulse.conf.d/20-upmix.conf"
    rt_upmix_conf_file="$HOME/.config/pipewire/client-rt.conf.d/20-upmix.conf"

    # Verificar se os arquivos de configuração já existem
    if [ -f "$upmix_conf_file" ] && [ -f "$rt_upmix_conf_file" ]; then
        echo "Mistura estéreo 5.1 já está configurada."
    else
        read -p "Deseja configurar a mistura estéreo para 5.1? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            # Criar diretórios, caso não existam
            mkdir -p "$pulse_conf_dir" "$rt_conf_dir"

            # Copiar os arquivos de configuração para os diretórios adequados
            sudo cp /usr/share/pipewire/client-rt.conf.avail/20-upmix.conf "$pulse_conf_dir"
            sudo cp /usr/share/pipewire/client-rt.conf.avail/20-upmix.conf "$rt_conf_dir"

            echo "Mistura estéreo para 5.1 configurada com sucesso."
        else
            echo "Operação cancelada. Mistura estéreo 5.1 não foi configurada."
        fi
    fi
}

instalar_pipewire
configurar_pipewire
configurar_mistura_estereo_51
