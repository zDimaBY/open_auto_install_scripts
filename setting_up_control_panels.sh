#!/bin/bash
# Розгортаєм скрипт

folder_script_path="scripts"
mkdir -p $folder_script_path
urls=(
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/0_exit.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/1_user_domains.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/2_update_ioncube.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/3_install_composer.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/4_DDos.sh"
    "https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/scripts/functions_controller.sh"
)
echo -e "\e[92mLoading script, please wait.\e[0m"
# Завантажуєм скрипти
for url in "${urls[@]}"; do
    filename=$(basename "$url")
    wget -qO- "$url" >"./$folder_script_path/$filename"
done
# Підключаєм усі файли з папки
for file in ./$folder_script_path/*; do
    if [ -f "$file" ] && [ -r "$file" ]; then
        source "$file"
    fi
done

#  ================= Start Script ==================
function selectionFunctions() {
    clear
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. Домени користувача панелі керування"
        echo "2. Встановлення/апгрейд ioncube для всіх php версії"
        echo "3. Встановлення Composer"
        echo "4. DDos"
        echo -e "0. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант (1/2/3/4/5/6/7/8/9/0):" choice

        case $choice in
        1) 1_outputOfAllDomains ;;
        2) 2_updateIoncube ;;
        3) 3_installComposer ;;
        4) 4_DDos ;;
        0) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}
selectionFunctions
