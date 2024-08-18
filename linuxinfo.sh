#!/bin/bash

URL_GITHUB="https://raw.githubusercontent.com"
REPO="zDimaBY/open_auto_install_scripts"
BRANCH="main"

case "$LANG_open_auto_install_scripts" in
"en" | "ru" | "ua") ;;
*)
    LANG_open_auto_install_scripts="en"
    ;;
esac

SCRIPT_URLS=(
    "$URL_GITHUB/$REPO/$BRANCH/scripts/functions_linux_info.sh"
    "$URL_GITHUB/$REPO/$BRANCH/lang/${LANG_open_auto_install_scripts}/messages.sh"
)

# Функція для завантаження скрипта і виконання його
load_and_source_script() {
    local downloader="$1"
    local options="$2"
    local url="$3"
    if source <($downloader $options "$url"); then
        echo "Loaded script from $url using $downloader."
    else
        echo "Failed to load script from $url using $downloader."
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
    echo "Error: Neither 'wget' nor 'curl' found. Please install one of them to continue."
    exit 1
fi


check_compatibility_script # Функція перевірки суміснусті скрипта з сервером
distribute_ips
check_info_server "full" # Функція перевірки інформації про сервер
check_info_control_panel # Функція перевірки панелі керування
check_available_services # Функція перевірки наявних служб та портів
