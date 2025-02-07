#!/bin/bash
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
        # Perguntar ao usuário se deseja configurar
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
configurar_mistura_estereo_51