#!/bin/bash -n
# shellcheck disable=SC2148,SC2154
function 0_funExit() {
    echo -e "${MSG_EXIT_STARTUP_MESSAGE}\n"
    sed -i '/wget https:\/\/raw.githubusercontent.com\/zDimaBY/d' /root/.bash_history >/dev/null 2>&1
    rm -rf "${folder_script_path}" /root/open_auto_install_scripts.sh "$local_temp_jq"
    exit 0
}

function 0_invalid() {
    echo -e "${RED} ${MSG_EXIT_INVALID_SELECTION} ${RESET}"
}
