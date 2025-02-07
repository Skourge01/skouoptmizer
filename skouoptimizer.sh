#!/bin/bash
#skouoptmizer vai dizer sim ou nao para as otimizacoes mais rapidas do sistema, o verdadeiro archlinux 
# primeiro, perguntar se desejo ativar o multilib, caso ja estiver ativo, ele nem faz a pergunta
#!/bin/bash
verificar_figlet(){
    if ! command -v figlet &> /dev/null; then
        sudo pacman -S --noconfirm figlet &> /dev/null
    fi
}
verificar_figlet
figlet Skouoptmizer

executar_multilib() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/multilib.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script multilib.sh não foi encontrado."
    fi
}

executar_reflectorsync() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/reflectorsync.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script reflectorsync.sh não foi encontrado."
    fi
}

executar_graphicaldependences() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/graphicaldependences.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script graphicaldependences.sh não foi encontrado."
    fi
}
executar_graphicaldependences
executar_glvariables() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/glvariables.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script glbariables.sh não foi encontrado."
    fi
}
executar_glvariables
executar_initramfs_lz4() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/initramfs_lz4.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script initramfs_lz4.sh não foi encontrado."
    fi
}
executar_initramfs_lz4
executar_systemd_initramfs() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/systemd_initramfs.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script systemd_initramfs.sh não foi encontrado."
    fi
}
executar_systemd_initramfs

executar_systemd_oomd() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/systemd_oomd.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script systemd_oomd.sh não foi encontrado."
    fi
}
executar_systemd_oomd
executar_ananicy_cpp() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/ananicy_cpp.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script ananicy_cpp.sh não foi encontrado."
    fi
}
executar_ananicy_cpp


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
verificar_e_ativar_irqbalance() {
    # Verificar se o serviço irqbalance está em execução
    if systemctl is-active --quiet irqbalance; then
        echo "irqbalance já está em execução."
        return
    fi
    
    # Perguntar ao usuário se deseja ativar o irqbalance
    read -p "O serviço irqbalance não está em execução. Deseja ativá-lo? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        sudo pacman -S irqbalance
        sudo systemctl enable --now irqbalance
        echo "irqbalance foi instalado e ativado com sucesso."
    else
        echo "Operação cancelada. irqbalance não foi ativado."
    fi
}
verificar_e_ativar_irqbalance
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
sudo pacman -Rns figlet
iniciar_verificador(){
    echo "Iniciando o verificador global"
    
    if [[ -f ~/skouoptmizer/verificador.sh ]]; then
        ~/skouoptmizer/verificador.sh
    else
        echo "Erro: ~/skouoptmizer/verificador.sh não encontrado."
    fi
}
