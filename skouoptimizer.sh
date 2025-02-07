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
executar_multilib
executar_reflectorsync() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/reflectorsync.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script reflectorsync.sh não foi encontrado."
    fi
}
executar_reflectorsync
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
executar_trim() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/trim.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script trim.sh não foi encontrado."
    fi
}
executar_trim
executar_irqbalance() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/irqbalance.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script trim.sh não foi encontrado."
    fi
}
executar_irqbalance
executar_pipewire() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/pipewire.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script pipewire.sh não foi encontrado."
    fi
}
executar_pipewire
executar_stereo_mix_51() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/stereo_mix_51.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script pipewire.sh não foi encontrado."
    fi
}
executar_stereo_mix_51
executar_squeak_correction() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/squeak_correction.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script squeak_correction.sh não foi encontrado."
    fi
}
executar_squeak_correction
sudo pacman -Rns figlet
