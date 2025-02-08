#!/bin/bash
#skouoptmizer vai dizer sim ou nao para as otimizacoes mais rapidas do sistema, o verdadeiro debian
verificar_figlet(){
    if ! command -v figlet &> /dev/null; then
        sudo apt install figlet &> /dev/null
    fi
}
verificar_figlet
figlet skouoptmizer
executar_graphicaldependences() {
    local script_path="$(dirname "${BASH_SOURCE[0]}")/scripts/debian/(deb)graphicaldependences.sh"

    if [[ -f "$script_path" ]]; then
        bash "$script_path"
    else
        echo "O script (deb)graphicaldependences.sh não foi encontrado."
    fi
}
executar_graphicaldependences