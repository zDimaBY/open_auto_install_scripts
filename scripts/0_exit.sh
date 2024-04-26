# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 0_funExit() {
    echo -e "Exit. Приберіть за собою! \nВикориставши:${RED} rm -rf ${folder_script_path} /root/setting_up_control_panels.sh && history -c && history -a ${RESET}"
    echo -e "${GREEN} Якщо таких папок та файла нема, то все okay${RESET}\n"
    echo -e "Запуск: wget -N https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/setting_up_control_panels.sh && bash ./setting_up_control_panels.sh && history -c && history -a\n"
    sed -i '/wget https:\/\/raw.githubusercontent.com\/zDimaBY/d' /root/.bash_history
    rm -rf "${folder_script_path}" /root/setting_up_control_panels.sh
    exit 0
}

function 0_invalid() {
    echo -e "${RED} Невірний вибір. Введіть 1, 2, 3 or 0.${RESET}"
}