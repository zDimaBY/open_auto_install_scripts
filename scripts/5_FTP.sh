#!/bin/bash -n
# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 5_FTP() {
    if ! check_docker_availability; then
        return 1
    fi
    statistics_scripts "5"
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\nВиберіть дію:\n"
        print_color_message 255 255 255 "1. Встановлення $(print_color_message 255 215 0 'alpine-ftp-server')"
        print_color_message 255 255 255 "2. Зупинка $(print_color_message 255 215 0 'alpine-ftp-server')"
        print_color_message 255 255 255 "3. Видалення $(print_color_message 255 215 0 'alpine-ftp-server')"
        print_color_message 255 255 255 "4. Оновлення $(print_color_message 255 215 0 'alpine-ftp-server')"
        print_color_message 255 255 255 "\n0. Вийти з цього підменю!"
        print_color_message 255 255 255 "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) install_alpine_ftp_server ;;
        2) stop_alpine_ftp_server ;;
        3) remove_alpine_ftp_server ;;
        4) update_alpine_ftp_server ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

install_alpine_ftp_server() {
    get_selected_interface
    echo "Введіть імя користувача FTP:"
    read -r -p "> " ftp_user
    echo "Введіть пароль користувача FTP:"
    generate_random_password_show
    read -r -p "> " ftp_password # -r: забороняє інтерпретацію backslashes, -s: не виводити введений пароль

    docker run -d \
        --name=alpine-ftp-server \
        -p 21:21 \
        -p 21000-21010:21000-21010 \
        -e USERS="$ftp_user|$ftp_password|/|10000" \
        -e ADDRESS=localhost \
        -v /home:/ \
        delfer/alpine-ftp-server

    docker run -d \
        --name=alpine-ftp-server \
        -p 21:21 \
        -p 21000-21010:21000-21010 \
        -e USERS="user|1234|/home|10000" \
        -e ADDRESS=localhost \
        -v /home:/home \
        delfer/alpine-ftp-server

    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}alpine-ftp-server успішно встановлено. Дані доступу до FTP:\nHost: ${YELLOW}$selected_ip_address${RESET}\nUser: ${YELLOW}$ftp_user${RESET}\nPassword: ${YELLOW}$ftp_password${RESET}"
    else
        echo -e "\n${RED}Сталася помилка під час встановлення alpine-ftp-server. Перевірте налаштування і спробуйте ще раз.${RESET}"
    fi
}

stop_alpine_ftp_server() {
    docker stop alpine-ftp-server
    echo "alpine-ftp-server зупинено."
}

remove_alpine_ftp_server() {
    docker stop alpine-ftp-server
    docker rm alpine-ftp-server
    echo "alpine-ftp-server видалено."
}

update_alpine_ftp_server() {
    docker stop alpine-ftp-server
    docker rm alpine-ftp-server
    docker pull delfer/alpine-ftp-server
    echo "alpine-ftp-server оновлено."
}
