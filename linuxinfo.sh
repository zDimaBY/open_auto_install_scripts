#!/bin/bash

# Перевірка наявності аргументу
if [ -z "$1" ]; then
    LANG_open_auto_install_scripts="en"
else
    case "$LANG_open_auto_install_scripts" in
    "en" | "ru" | "ua") ;;
    *)
        LANG_open_auto_install_scripts="en"
        ;;
    esac
fi

URL_GITHUB="https://raw.githubusercontent.com"
REPO="zDimaBY/open_auto_install_scripts"
BRANCH="main"

SCRIPT_URLS=(
    "$URL_GITHUB/$REPO/$BRANCH/scripts/functions_linux_info.sh"
    "$URL_GITHUB/$REPO/$BRANCH/lang/${LANG_open_auto_install_scripts}/messages.sh"
)

# Функція для завантаження скрипта і виконання його
load_and_source_script() {
    local downloader="$1"
    local options="$2"
    local url="$3"
    if ! source <($downloader $options "$url"); then
        exit 1
    fi
}

# Перевірка наявності wget або curl
if command -v wget &>/dev/null; then
    for url in "${SCRIPT_URLS[@]}"; do
        load_and_source_script "wget" "--timeout=4 -qO-" "$url"
    done
elif command -v curl &>/dev/null; then
    for url in "${SCRIPT_URLS[@]}"; do
        load_and_source_script "curl" "--max-time 4 -s" "$url"
    done
else
    echo "$MSG_ERROR_NO_DOWNLOAD_TOOL"
    exit 1
fi

check_compatibility_script # Функція перевірки суміснусті скрипта з сервером
distribute_ips
check_info_server "full" # Функція перевірки інформації про сервер
check_info_control_panel # Функція перевірки панелі керування
check_available_services # Функція перевірки наявних служб та портів
