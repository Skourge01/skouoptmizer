verificar_e_perguntar_systemd_initramfs() {
    if grep -q '^HOOKS=(.*systemd.*)' /etc/mkinitcpio.conf; then
        echo "O Systemd já está configurado no initramfs. Nenhuma alteração necessária."
        return
    fi

    read -p "O Systemd não está configurado no initramfs. Deseja configurar agora? (s/n) " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        echo "Configurando o mkinitcpio para usar o Systemd..."

        # Substitui HOOKS pelo novo valor
        sudo sed -i 's/^HOOKS=.*/HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)/' /etc/mkinitcpio.conf

        echo "Atualizando initramfs..."
        sudo mkinitcpio -P

        echo "Configuração concluída!"
    else
        echo "Configuração não aplicada."
    fi
}
verificar_e_perguntar_systemd_initramfs