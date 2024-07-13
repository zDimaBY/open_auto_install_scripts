#!/bin/bash -n
# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 0_funExit() {
    echo -e "Запуск: wget -N https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/open_auto_install_scripts.sh && bash ./open_auto_install_scripts.sh && history -c && history -a\n"
    sed -i '/wget https:\/\/raw.githubusercontent.com\/zDimaBY/d' /root/.bash_history >/dev/null 2>&1
    rm -rf "${folder_script_path}" /root/open_auto_install_scripts.sh
    exit 0
}

function 0_invalid() {
    echo -e "${RED} Невірний вибір. Введіть 1, 2, 3 or 0.${RESET}"
}