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

# Функція для вибору мови
function select_language() {
    clear
    echo -e "${YELLOW}Select a language:${RESET}"
    echo "1. English"
    echo "2. Українська"
    echo "3. Русский"

    read -p "Select a language pack number (1/2/3): " lang_choice

    case $lang_choice in
    1) LANG_open_auto_install_scripts="en" ;;
    3) LANG_open_auto_install_scripts="ru" ;;
    2) LANG_open_auto_install_scripts="ua" ;;
    *)
        echo -e "${RED}Wrong choice. Set by default: 'en'.${RESET}"
        LANG_open_auto_install_scripts="en"
        ;;
    esac
}

# Вибір мови
select_language

# Каталог для скриптів
rand_head=$(head /dev/urandom | tr -dc 'a-z' | head -c 6)
folder_script_path="/root/scripts_${rand_head}"
mkdir -p "$folder_script_path"

URL_GITHUB="https://raw.githubusercontent.com"
REPO="zDimaBY/open_auto_install_scripts"
BRANCH="main"

urls=(
    "$URL_GITHUB/$REPO/$BRANCH/lang/${LANG_open_auto_install_scripts}/messages.sh"
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
    wget -qO "$folder_script_path/$filename" --timeout=4 "$url" || {
        echo -e "${RED}Failed to download${RESET}"
        rm -rf "$folder_script_path"
        exit 1
    }
done

# Підключення усіх файлів з папки
for file in "$folder_script_path"/*; do
    if [[ -f "$file" && -r "$file" ]]; then
        source "$file" && rm -f "$file"
    fi
done
rm -rf "$folder_script_path" /root/open_auto_install_scripts.sh

dependencies=(
    "grep grep"
    "sh dash"
    "awk gawk"
    "sed sed"
    "sort coreutils"
    "uniq coreutils"
    "cut coreutils"
    "timeout coreutils"
    "tail coreutils"
    "head coreutils"
    "basename coreutils"
)

# Викликаємо функцію перевірки dependencies пакетів, передаючи масив.
check_and_install_dependencies "${dependencies[@]}"

# Отримуємо шляхи до бінарників
local_temp_curl_path=$(download_latest_tool "moparisthebest/static-curl" "curl" "curl-amd64")
local_temp_jq_path=$(download_latest_tool "jqlang/jq" "jq" "jq-linux64")

COMMIT=$("$local_temp_curl_path" -s "https://api.github.com/repos/$REPO/commits/$BRANCH")
LAST_COMMIT=$(echo "$COMMIT" | "$local_temp_jq_path" -r '.commit.message')
LAST_COMMIT_DATE=$(echo "$COMMIT" | "$local_temp_jq_path" -r '.commit.author.date')

#  ================= Start Script ==================
function selectionFunctions() {
    distribute_ips
    clear
    echo -e "${MSG_LAST_COMMIT_MESSAGE}: ${YELLOW}${LAST_COMMIT}${RESET}, ${MSG_LAST_COMMIT_DATE_LABEL}: $(print_color_message 255 0 0 "$LAST_COMMIT_DATE")${RESET}"
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_ACTION_SELECTION}\n"
        print_color_message 255 255 255 "1. ${MSG_INSTALL_SOFTWARE} ($(print_color_message 218 165 32 'Composer'), $(print_color_message 255 140 0 'Docker'), $(print_color_message 0 128 128 'RouterOS 7.5'), $(print_color_message 148 0 211 'Elasticsearch'), $(print_color_message 0 190 0 'proxy nginx'), $(print_color_message 0 100 0 'OpenSSH'))"
        print_color_message 255 255 255 "2. ${MSG_CONTROL_PANEL_FUNCTIONS} $(print_color_message 255 69 0 '(test)')"
        print_color_message 255 255 255 "3. $(print_color_message 220 20 60 "${MSG_DDOS_ANALYSIS}")"
        print_color_message 255 255 255 "4. ${MSG_VPN_CONFIGURATION} ($(print_color_message 255 215 0 "$MSG_3X_UI"), $(print_color_message 0 191 255 "$MSG_XUI"), $(print_color_message 210 0 90 "$MSG_WIREGUARD_EASY"), $(print_color_message 0 255 127 "$MSG_NAME_OPENVPN"), $(print_color_message 169 169 169 'IPsec/L2TP, Cisco IPsec, IKEv2'), $(print_color_message 173 216 230 "$MSG_VPN_PPTP"))"
        print_color_message 255 255 255 "5. ${MSG_FTP_CONFIGURATION} $(print_color_message 255 69 0 '(test)')"
        print_color_message 255 255 255 "6. ${MSG_DATABASE_CONFIGURATION} ($(print_color_message 255 99 71 'MySQL'), $(print_color_message 0 255 0 'MariaDB'), $(print_color_message 255 20 147 'MongoDB'), $(print_color_message 30 144 255 'PostgreSQL')) $(print_color_message 255 69 0 '(test)')"
        print_color_message 255 255 255 "7. ${MSG_OPERATING_SYSTEMS_INSTALLATION} $(print_color_message 255 69 0 '(test)')"
        print_color_message 255 255 255 "8. ${MSG_SERVER_TESTING}: ($(print_color_message 255 215 0 "${MSG_SERVER_TESTING_PORT_SPEED},") $(print_color_message 100 149 237 "${MSG_SERVER_TESTING_PORT_MAIL}"))"
        print_color_message 255 255 255 "0. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

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

statistics_scripts "0"
selectionFunctions
