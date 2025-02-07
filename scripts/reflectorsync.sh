verificar_reflector_rsync() {
    if ! command -v reflector &> /dev/null; then
        echo "O pacote 'reflector' não está instalado."
    fi
# duas funções de verificação de: reflector, e rsync
    if ! command -v rsync &> /dev/null; then
        echo "O pacote 'rsync' não está instalado."
    fi

    if ! command -v reflector &> /dev/null || ! command -v rsync &> /dev/null; then
        read -r -p "Deseja instalar e habilitar a aceleração da atualização do sistema? (S/N): " resposta
        if [[ "$resposta" =~ ^[Ss]$ ]]; then # antes era ultilizado Sim/Não, agora e Ss/Nn 
            acelerar_atualizacao
        else
            echo "Aceleração da atualização não será habilitada."
        fi
    else
        echo "A aceleração do sistema já está habilitada."
    fi
}
acelerar_atualizacao() {
    echo "Instalando o reflector e rsync..."
    sudo pacman -S --noconfirm reflector rsync

    read -r -p "Digite o nome do país para selecionar os espelhos mais rápidos (ex: Germany, Brazil, etc.): " pais
    echo "Classificando os espelhos mais rápidos de $pais..."
    sudo reflector --verbose --country "$pais" -l 25 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    sudo pacman -Sy

    echo "Espelhos atualizados para $pais com sucesso!"
}
verificar_reflector_rsync