#!/bin/bash
#skouoptmizer vai dizer sim ou nao para as otimizacoes mais rapidas do sistema, o verdadeiro archlinux 
# primeiro, perguntar se desejo ativar o multilib, caso ja estiver ativo, ele nem faz a pergunta
ativar_multilib() {
    sudo sed -i '/\[multilib\]/,/^$/s/^#//g' /etc/pacman.conf
    sudo pacman -Sy
    echo "Repositório multilib ativado com sucesso!"
}

# Função para verificar se o repositório multilib está ativado
multilib_esta_ativo() {
    grep -q '^\[multilib\]' /etc/pacman.conf && \
    grep -q 'Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
}

# Perguntar ao usuário se deseja ativar o multilib, caso não esteja ativo
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
    # Verificar se o reflector está instalado
    if ! command -v reflector &> /dev/null || ! command -v rsync &> /dev/null; then
        echo "O reflector ou rsync não estão instalados no sistema."
        read -p "Deseja instalar e habilitar a aceleração da atualização do sistema? (sim/nao): " resposta
        if [[ "$resposta" == "sim" ]]; then
            acelerar_atualizacao
        else
            echo "Aceleração da atualização não será habilitada."
        fi
    else
        echo "a aceleração do sistema já esta habilitada."
    fi
}
acelerar_atualizacao() {
    # Perguntar ao usuário se deseja habilitar a aceleração das atualizações do sistema
    read -p "Deseja habilitar a aceleração da atualização do sistema? (sim/nao): " resposta
    if [[ "$resposta" == "sim" ]]; then
        # Instalar o reflector e rsync se não estiverem instalados
        echo "Instalando o reflector e rsync..."
        sudo pacman -S --noconfirm reflector rsync

        # Perguntar ao usuário qual país ele prefere usar para os espelhos
        read -p "Digite o nome do país para selecionar os espelhos mais rápidos (ex: Germany, Russia, etc.): " pais

        # Rodar o reflector para configurar os espelhos
        echo "Classificando os espelhos mais rápidos de $pais..."
        sudo reflector --verbose --country "$pais" -l 25 --sort rate --save /etc/pacman.d/mirrorlist

        # Atualizar o banco de dados do pacman com os novos espelhos
        sudo pacman -Sy

        echo "Espelhos atualizados para $pais com sucesso!"
    else
        echo "Aceleração da atualização do sistema não foi habilitada."
    fi
}
