#!/bin/bash
configurar_correção_chiado() {
    # Caminho para o arquivo de configuração
    conf_file="$HOME/.config/pipewire/pipewire.conf.d/10-sound.conf"

    # Verificar se o arquivo já contém as configurações necessárias
    if grep -q "default.clock.quantum = 4096" "$conf_file"; then
        echo "A correção de chiado em carga já está configurada."
    else
        # Perguntar ao usuário se deseja configurar
        read -p "Deseja corrigir o chiado em carga ajustando o buffer do Pipewire? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            # Criar diretório se não existir
            mkdir -p "$HOME/.config/pipewire/pipewire.conf.d"

            # Criar ou editar o arquivo com as configurações necessárias
            cat <<EOF > "$conf_file"
context.properties = {
    default.clock.rate = 48000
    default.clock.allowed-rates = [ 44100 48000 88200 96000 ]
    default.clock.min-quantum = 512
    default.clock.quantum = 4096
    default.clock.max-quantum = 8192
}
EOF

            echo "Correção de chiado em carga configurada com sucesso."
        else
            echo "Operação cancelada. Correção de chiado em carga não foi configurada."
        fi
    fi
}
configurar_correção_chiado