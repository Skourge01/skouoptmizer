#!/bin/bash

verificar_multilib() {
    if grep -q '^[^#]*\[multilib\]' /etc/pacman.conf; then
        echo "Multilib: Sim"
    else
        echo "Multilib: Não"
    fi
}

verificar_reflector_rsync() {
    if command -v reflector &> /dev/null && command -v rsync &> /dev/null; then
        echo "Reflector e rsync: Sim"
    else
        echo "Reflector e rsync: Não"
    fi
}

verificar_dependencias_graficas() {
    if pacman -Q mesa &> /dev/null || pacman -Q nvidia-utils &> /dev/null; then
        echo "Dependências gráficas: Sim"
    else
        echo "Dependências gráficas: Não"
    fi
}

verificar_variaveis_gl() {
    if grep -q '__GL_THREADED_OPTIMIZATIONS=1' /etc/environment; then
        echo "Variáveis GL: Sim"
    else
        echo "Variáveis GL: Não"
    fi
}

verificar_initramfs_lz4() {
    if grep -q '^COMPRESSION="lz4"' /etc/mkinitcpio.conf && grep -q '^COMPRESSION_OPTIONS=(-9)' /etc/mkinitcpio.conf; then
        echo "Initramfs LZ4 (-9): Sim"
    else
        echo "Initramfs LZ4 (-9): Não"
    fi
}

verificar_systemd_initramfs() {
    if grep -q '^HOOKS=.*systemd.*' /etc/mkinitcpio.conf; then
        echo "Systemd no initramfs: Sim"
    else
        echo "Systemd no initramfs: Não"
    fi
}

# Executar todas as verificações
echo "Verificando otimizações aplicadas..."
verificar_multilib
verificar_reflector_rsync
verificar_dependencias_graficas
verificar_variaveis_gl
verificar_initramfs_lz4
verificar_systemd_initramfs
