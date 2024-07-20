#!/bin/bash
# URL скрипта для завантаження
SCRIPT_URL="https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/scripts/functions_linux_info.sh"

# Функція для завантаження скрипта і виконання його
load_and_source_script() {
    local downloader="$1"
    local options="$2"
    if source <($downloader $options "$SCRIPT_URL"); then
        echo "Loaded script using $downloader."
    else
        echo "Failed to load script using $downloader."
        exit 1
    fi
}

# Перевірка наявності wget або curl
if command -v wget &>/dev/null; then
    load_and_source_script "wget" "--timeout=4 -qO-"
elif command -v curl &>/dev/null; then
    load_and_source_script "curl" "--max-time 4 -s"
else
    echo "Error: Neither 'wget' nor 'curl' found. Please install one of them to continue."
    exit 1
fi

check_compatibility_script # Функція перевірки суміснусті скрипта з сервером
distribute_ips
check_info_server "full" # Функція перевірки інформації про сервер
check_info_control_panel # Функція перевірки панелі керування
check_available_services # Функція перевірки наявних служб та портів
