#!/bin/bash 
verificar_e_perguntar_initramfs_lz4() {
    if grep -q '^COMPRESSION="lz4"' /etc/mkinitcpio.conf && grep -q '^COMPRESSION_OPTIONS=(-9)' /etc/mkinitcpio.conf; then
        echo "A compressão do initramfs já está configurada corretamente para lz4 (-9). Nenhuma alteração necessária."
        return
    fi

    read -p "A compressão do initramfs não está configurada para lz4 (-9). Deseja configurar agora? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        echo "Configurando o mkinitcpio para usar lz4..."
        
        # Substitui ou adiciona as configurações de compressão
        sudo sed -i 's/^COMPRESSION=.*/COMPRESSION="lz4"/' /etc/mkinitcpio.conf
        sudo sed -i 's/^COMPRESSION_OPTIONS=.*/COMPRESSION_OPTIONS=(-9)/' /etc/mkinitcpio.conf

        # Caso as linhas não existam, adiciona ao final do arquivo
        if ! grep -q '^COMPRESSION="lz4"' /etc/mkinitcpio.conf; then
            echo 'COMPRESSION="lz4"' | sudo tee -a /etc/mkinitcpio.conf > /dev/null
        fi
        if ! grep -q '^COMPRESSION_OPTIONS=(-9)' /etc/mkinitcpio.conf; then
            echo 'COMPRESSION_OPTIONS=(-9)' | sudo tee -a /etc/mkinitcpio.conf > /dev/null
        fi

        echo "Atualizando initramfs..."
        sudo mkinitcpio -P

        echo "Configuração concluída!"
    else
        echo "Configuração não aplicada."
    fi
}
verificar_e_perguntar_initramfs_lz4 