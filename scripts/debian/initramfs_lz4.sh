#!/bin/bash
verificar_e_perguntar_initramfs_lz4() {
    if grep -q '^COMPRESS=lz4' /etc/initramfs-tools/initramfs.conf; then
        echo "A compressão do initramfs já está configurada para lz4. Nenhuma alteração necessária."
        return
    fi

    read -p "A compressão do initramfs não está configurada para lz4. Deseja configurar agora? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        echo "Configurando o initramfs-tools para usar lz4..."
        
        # Substitui ou adiciona a configuração de compressão
        sudo sed -i 's/^COMPRESS=.*/COMPRESS=lz4/' /etc/initramfs-tools/initramfs.conf

        if ! grep -q '^COMPRESS=lz4' /etc/initramfs-tools/initramfs.conf; then
            echo 'COMPRESS=lz4' | sudo tee -a /etc/initramfs-tools/initramfs.conf > /dev/null
        fi

        echo "Atualizando initramfs..."
        sudo update-initramfs -u -k all

        echo "Configuração concluída!"
    else
        echo "Configuração não aplicada."
    fi
}

verificar_e_perguntar_initramfs_lz4
