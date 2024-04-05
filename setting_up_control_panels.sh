#!/bin/bash
# Коди кольорів
BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
lIGHT_GREEN="\e[92m"
BROWN='\033[0;33m'
RESET="\e[0m"
# Розгортаєм скрипт
folder_script_path="/root/controlPanelFiles/scripts"
mkdir -p $folder_script_path
urls=(
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/0_exit.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/1_user_domains.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/2_update_ioncube.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/3_install_composer.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/4_DDos.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/5_VPN.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/6_FTP.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/7_MySQL.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/functions_controller.sh"
)
echo -e "${LIGHT_GREEN}Loading script, please wait.${RESET}"
# Завантажуєм скрипти
for url in "${urls[@]}"; do
    filename=$(basename "$url")
    wget -qO- "$url" >"$folder_script_path/$filename"
done
# Підключаєм усі файли з папки
for file in $folder_script_path/*; do
    if [ -f "$file" ] && [ -r "$file" ]; then
        source "$file"
    fi
done

UPDATE_DONE=false
dependencies=(
    "grep grep"
    "sh dash"
    "awk gawk"
    "sed sed"
    "sort coreutils"
    "uniq coreutils"
    "cut coreutils"
    "iptables iptables"
    "timeout coreutils"
    "bc bc"
    "curl curl"
    "tail coreutils"
    "head coreutils"
    "ifconfig net-tools"
    "basename coreutils"
    "jq jq"
)

for dependency in "${dependencies[@]}"; do
    check_dependency $dependency
done

#  ================= Start Script ==================
function selectionFunctions() {
    clear
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. Домени користувача панелі керування"
        echo -e "2. Встановлення/апгрейд ${RED}ioncube${RESET} для всіх php версії (Hestiacp + Ubuntu + php-fpm)"
        echo -e "3. Встановлення ПЗ (${BROWN}Composer${RESET}, ${YELLOW}Docker${RESET}, ${BLUE}RouterOS 7.5${RESET})"
        echo -e "4. DDos"
        echo -e "5. Втановлення ${MAGENTA}VPN${RESET}"
        echo -e "6. Організування ${BLUE}FTP${RESET} доступу(test)"
        echo -e "7. Організування ${MAGENTA}баз данних${RESET}(test)"
        echo -e "0. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) 1_outputOfAllDomains ;;
        2) 2_updateIoncubeHestiacpUbuntu ;;
        3) 3_list_install_programs ;;
        4) 4_DDos ;;
        5) 5_VPN ;;
        6) 6_FTP ;;
        7) 7_DB ;;
        0) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

selectionFunctions
