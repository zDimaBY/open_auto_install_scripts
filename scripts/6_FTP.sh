# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 4_FTP() {
    check_docker
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. Встановлення alpine-ftp-server"
        echo "2. Зупинка alpine-ftp-server"
        echo "3. Видалення alpine-ftp-server"
        echo "4. Оновлення alpine-ftp-server"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

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
    read -r -p "> " ftp_password  # -r: забороняє інтерпретацію backslashes, -s: не виводити введений пароль

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
        echo -e "\n${GREEN}alpine-ftp-server успішно встановлено. Дані доступу до FTP:\nHost: ${YELLOW}$ip${RESET}\nUser: ${YELLOW}$ftp_user${RESET}\nPassword: ${YELLOW}$ftp_password${RESET}"
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