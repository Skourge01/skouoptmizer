#!/bin/bash

# Detecta o idioma do sistema
LANGUAGE="pt"
if [[ "$LANG" =~ en_.* ]]; then
    LANGUAGE="en"
fi

# Função para exibir mensagens no idioma correto
msg() {
    if [[ "$LANGUAGE" == "en" ]]; then
        case $1 in
            "checking") echo -e "\n=== Checking applied optimizations ===\n" ;;
            "end") echo -e "\n=== Check complete ===\n" ;;
            "multilib_yes") echo "Multilib: Yes" ;;
            "multilib_no") echo "Multilib: No" ;;
            "reflector_yes") echo "Reflector and rsync: Yes" ;;
            "reflector_no") echo "Reflector and rsync: No" ;;
            "graphics_yes") echo "Graphics dependencies: Yes" ;;
            "graphics_no") echo "Graphics dependencies: No" ;;
            "gl_vars_yes") echo "GL variables: Yes" ;;
            "gl_vars_no") echo "GL variables: No" ;;
            "initramfs_lz4_yes") echo "Initramfs LZ4 (-9): Yes" ;;
            "initramfs_lz4_no") echo "Initramfs LZ4 (-9): No" ;;
            "systemd_initramfs_yes") echo "Systemd in initramfs: Yes" ;;
            "systemd_initramfs_no") echo "Systemd in initramfs: No" ;;
        esac
    else
        case $1 in
            "checking") echo -e "\n=== Verificando otimizações aplicadas ===\n" ;;
            "end") echo -e "\n=== Fim da verificação ===\n" ;;
            "multilib_yes") echo "Multilib: Sim" ;;
            "multilib_no") echo "Multilib: Não" ;;
            "reflector_yes") echo "Reflector e rsync: Sim" ;;
            "reflector_no") echo "Reflector e rsync: Não" ;;
            "graphics_yes") echo "Dependências gráficas: Sim" ;;
            "graphics_no") echo "Dependências gráficas: Não" ;;
            "gl_vars_yes") echo "Variáveis GL: Sim" ;;
            "gl_vars_no") echo "Variáveis GL: Não" ;;
            "initramfs_lz4_yes") echo "Initramfs LZ4 (-9): Sim" ;;
            "initramfs_lz4_no") echo "Initramfs LZ4 (-9): Não" ;;
            "systemd_initramfs_yes") echo "Systemd no initramfs: Sim" ;;
            "systemd_initramfs_no") echo "Systemd no initramfs: Não" ;;
        esac
    fi
}

verificar_multilib() {
    if grep -q '^\[multilib\]' /etc/pacman.conf; then
        msg "multilib_yes"
    else
        msg "multilib_no"
    fi
}

verificar_reflector_rsync() {
    if command -v reflector &> /dev/null && command -v rsync &> /dev/null; then
        msg "reflector_yes"
    else
        msg "reflector_no"
    fi
}

verificar_dependencias_graficas() {
    if pacman -Q mesa &> /dev/null || pacman -Q nvidia-utils &> /dev/null; then
        msg "graphics_yes"
    else
        msg "graphics_no"
    fi
}

verificar_variaveis_gl() {
    if grep -q '__GL_THREADED_OPTIMIZATIONS=1' /etc/environment; then
        msg "gl_vars_yes"
    else
        msg "gl_vars_no"
    fi
}

verificar_initramfs_lz4() {
    if grep -q '^COMPRESSION="lz4"' /etc/mkinitcpio.conf && grep -q '^COMPRESSION_OPTIONS=(-9)' /etc/mkinitcpio.conf; then
        msg "initramfs_lz4_yes"
    else
        msg "initramfs_lz4_no"
    fi
}

verificar_systemd_initramfs() {
    if grep -q 'HOOKS=(.*systemd.*)' /etc/mkinitcpio.conf; then
        msg "systemd_initramfs_yes"
    else
        msg "systemd_initramfs_no"
    fi
}

# Executar todas as verificações
msg "checking"
verificar_multilib
verificar_reflector_rsync
verificar_dependencias_graficas
verificar_variaveis_gl
verificar_initramfs_lz4
verificar_systemd_initramfs
msg "end"
