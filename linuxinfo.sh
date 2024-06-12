#!/bin/bash
# Autorun for MobaXterm: 
# [ ! -f ~/.vimrc ] && echo -e "set number\nsyntax on" > ~/.vimrc && trap 'rm ~/.vimrc' EXIT && echo "Settings applied for the current session." || echo "File .vimrc already exists, no changes made."; (command -v curl &> /dev/null && curl -sSL https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/linuxinfo.sh | bash) || (command -v wget &> /dev/null && wget -qO- https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/linuxinfo.sh | bash) || { echo "Error: Neither 'curl' nor 'wget' found. Please install one of them to continue."; exit 1; }
# Run in terminal:
# curl -sSL https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/linuxinfo.sh | bash
# or
# wget -qO- https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/linuxinfo.sh | bash
if ! source <(wget --timeout=4 -qO- https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/functions_linux_info.sh); then
    echo "wget failed, trying curl..."
    if ! source <(curl --max-time 4 -s https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/functions_linux_info.sh); then
        echo "curl failed. Exiting script."
        exit 1
    else
        echo "Loaded script using curl."
    fi
fi
check_compatibility_script # Функція перевірки суміснусті скрипта з сервером
distribute_ips
check_info_server "full" # Функція перевірки інформації про сервер
check_info_control_panel # Функція перевірки панелі керування
check_available_services # Функція перевірки наявних служб та портів
