verificar_e_perguntar_systemd_initramfs() {
    if grep -q '^HOOKS=(.*systemd.*)' /etc/mkinitcpio.conf; then
        echo "Systemd is already configured in the initramfs. No changes needed."
        return
    fi

    read -p "Systemd is not configured in the initramfs. Do you want to configure it now? (y/n) " resposta
    if [[ "$resposta" =~ ^[Yy]$ ]]; then
        echo "Configuring mkinitcpio to use Systemd..."

        sudo sed -i 's/^HOOKS=.*/HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)/' /etc/mkinitcpio.conf || { echo "Failed to modify /etc/mkinitcpio.conf"; exit 1; }

        echo "Updating initramfs..."
        sudo mkinitcpio -P || { echo "Failed to update initramfs"; exit 1; }

        echo "Configuration completed!"
    else
        echo "Configuration not applied."
    fi
}
verificar_e_perguntar_systemd_initramfs
