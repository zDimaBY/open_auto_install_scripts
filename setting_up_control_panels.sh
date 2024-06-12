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
BROWN='\033[0;33m'
RESET="\e[0m"

# Каталог для скриптів
rand_head=$(head /dev/urandom | tr -dc 'a-z' | head -c 6)
folder_script_path="/root/scripts_${rand_head}"
mkdir -p "$folder_script_path"

URL_GITHUB="https://raw.githubusercontent.com"
REPO="zDimaBY/setting_up_control_panels"
BRANCH="main"

urls=(
    "$URL_GITHUB/$REPO/$BRANCH/scripts/0_exit.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/1_list_install_programs.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/2_site_control_panel.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/3_DDos.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/4_VPN.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/5_FTP.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/6_MySQL.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/7_list_install_OS.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/8_server_testing.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/functions_controller.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/functions_linux_info.sh"
    "$URL_GITHUB/$REPO/$BRANCH/scripts/hestiaCP_and_vestaCP_scripts/command/v-sys-change-ip"
)

# Завантаження та розгортання скриптів
for url in "${urls[@]}"; do
    filename=$(basename "$url")
    wget -qO "$folder_script_path/$filename" "$url" || {
        echo -e "${RED}Не вдалося завантажити $filename${RESET}"
        exit 1
    }
done

# Підключення усіх файлів з папки
for file in "$folder_script_path"/*; do
    if [[ -f "$file" && -r "$file" ]]; then
        source "$file" && rm -f "$file"
    fi
done
rm -rf "$folder_script_path" /root/setting_up_control_panels.sh

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
    "basename coreutils"
    "jq jq"
)

for dependency in "${dependencies[@]}"; do
    check_dependency $dependency
done

COMMIT=$(curl -s "https://api.github.com/repos/$REPO/commits/$BRANCH")
LAST_COMMIT=$(echo "$COMMIT" | jq -r '.commit.message')
LAST_COMMIT_DATE=$(echo "$COMMIT" | jq -r '.commit.author.date')

#  ================= Start Script ==================
function selectionFunctions() {
    distribute_ips
    clear
    echo -e "Останнє повідомлення з комітів: ${YELLOW}${LAST_COMMIT}${RESET}, дата останньої фіксації: ${RED}${LAST_COMMIT_DATE}${RESET}"
    while true; do
        check_info_server
        check_info_control_panel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Встановлення ПЗ (${BROWN}Composer${RESET}, ${YELLOW}Docker${RESET}, ${BLUE}RouterOS 7.5${RESET}, ${BLUE}Elasticsearch${RESET}, proxy nginx)"
        echo -e "2. Функції для панелей керування сайтами ${RED}(test)${RESET}"
        echo -e "3. DDos"
        echo -e "4. Організування ${MAGENTA}VPN${RESET} серверів"
        echo -e "5. Організування ${BLUE}FTP${RESET} доступу ${RED}(test)${RESET}"
        echo -e "6. Організування ${MAGENTA}баз данних ${RED}(test)${RESET}"
        echo -e "7. Встановлення ${YELLOW}операційних систем. ${RED}(test)${RESET}"
        echo -e "8. Тестування серверів: ${YELLOW}швидкості порта,${BLUE} пошти${RED}${RESET}"
        echo -e "0. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) 1_list_install_programs ;;
        2) 2_site_control_panel ;;
        3) 3_DDos ;;
        4) 4_VPN ;;
        5) 5_FTP ;;
        6) 6_manage_docker_databases ;;
        7) 7_Installation_operating_systems ;;
        8) 8_server_testing ;;
        0) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

selectionFunctions
