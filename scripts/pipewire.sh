#!/bin/bash
instalar_pipewire() {
    # Perguntar ao usuário se deseja instalar o Pipewire
    read -p "Deseja instalar o Pipewire e seus componentes adicionais? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        # Instalar os pacotes do Pipewire e seus componentes adicionais
        sudo pacman -S pipewire-jack lib32-pipewire gst-plugin-pipewire realtime-privileges rtkit

        # Ativar os serviços necessários do Pipewire
        systemctl --user enable --now pipewire pipewire-pulse wireplumber

        # Adicionar o usuário ao grupo realtime
        sudo usermod -aG realtime "$USER"

        echo "Pipewire e seus componentes foram instalados e configurados com sucesso."
    else
        echo "Operação cancelada. Pipewire não foi instalado."
    fi
}
instalar_pipewire
configurar_pipewire() {
    # Verificar se o diretório existe
    if [ ! -d "$HOME/.config/pipewire/pipewire.conf.d" ]; then
        mkdir -p "$HOME/.config/pipewire/pipewire.conf.d"
    fi

    # Caminho do arquivo de configuração
    conf_file="$HOME/.config/pipewire/pipewire.conf.d/10-no-resampling.conf"

    # Verificar se o arquivo de configuração já existe e contém as propriedades necessárias
    if grep -q "default.clock.rate = 48000" "$conf_file" && grep -q "default.clock.allowed-rates = \[ 44100 48000 96000 192000 \]" "$conf_file"; then
        echo "As configurações de qualidade do Pipewire já estão aplicadas. Nenhuma alteração será feita."
    else
        # Perguntar ao usuário se deseja melhorar a qualidade do Pipewire
        read -p "Deseja melhorar a qualidade do som do Pipewire? (s/n) " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then
            # Adicionar as configurações ao arquivo
            echo -e "context.properties = {\n   default.clock.rate = 48000\n   default.clock.allowed-rates = [ 44100 48000 96000 192000 ]\n}" > "$conf_file"

            echo "Configurações de qualidade do Pipewire aplicadas com sucesso."
        else
            echo "Operação cancelada. O Pipewire não foi configurado."
        fi
    fi
}
configurar_pipewire