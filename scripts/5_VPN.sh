function 5_VPN() {
    echo "Перевірка докера:"
    check_docker
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. Встановлення WireGuard Easy"
        echo "2. Зупинка WireGuard Easy"
        echo "3. Видалення WireGuard Easy"
        echo "4. Оновлення WireGuard Easy"
        echo -e "0. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант (1/2/3/4/5/6/7/8/9/0):" choice

        case $choice in
        1) install_wg_easy ;;
        2) stop_wg_easy ;;
        3) remove_wg_easy ;;
        4) update_wg_easy ;;
        0) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

check_docker() {
    if ! command -v docker &>/dev/null; then
        echo -e "\nДокер не встановлено на цій системі."
        read -p "Бажаєте встановити докер? (y/n): " install_docker
        if [ "$install_docker" == "y" ]; then
            curl -sSL https://get.docker.com | sh
            sudo usermod -aG docker $(whoami)
            echo -e "\nДокер успішно встановлено."
        else
            echo -e "\nВстановлення докера скасовано. Програма завершується."
            exit 1
        fi
    fi

    # Перевірка, чи демон Docker запущений
    if ! sudo service docker status | grep -q "running"; then
        echo -e "\nДемон Docker не запущений."
        read -p "\nБажаєте запустити демон Docker? (y/n): " start_docker
        if [ "$start_docker" == "y" ]; then
            sudo service docker start
            echo -e "\nДемон Docker успішно запущений."
        else
            echo -e "\nЗапуск демона Docker скасовано. Програма завершується."
            exit 1
        fi
    fi
}

get_server_ip() {
    echo "Визначення IP-адреси сервера"
    echo "Список доступних мережевих інтерфейсів та їх IP-адрес:"
    interfaces=($(ifconfig -a | grep -E '^[A-Za-z0-9]+:' | awk '{print $1}' | sed 's/://g'))

    for ((i = 0; i < ${#interfaces[@]}; i++)); do
        interface_name=${interfaces[$i]}
        ip_address=$(ifconfig "$interface_name" | awk '/inet / {print $2}')
        echo -e "$((i + 1)). Інтерфейс: \e[91m$interface_name\e[0m, IP-адреса: $ip_address"
    done

    read -p "Введіть номер інтерфейсу для використання: " choice
    index=$((choice - 1))

    if [[ $index -lt 0 || $index -ge ${#interfaces[@]} ]]; then
        echo "Невірний вибір. Спробуйте ще раз."
        exit 1
    fi

    interface=${interfaces[$index]}
    ip_address=$(ifconfig "$interface" | awk '/inet / {print $2}')

    if [ -z "$ip_address" ]; then
        echo "Не вдалося отримати IP-адресу для інтерфейсу $interface."
        exit 1
    fi

    echo "Обраний мережевий інтерфейс: $interface"
    echo "IP-адреса: $ip_address"
    server_ip="$ip_address"
}

install_wg_easy() {
    get_server_ip
    generate_random_password
    echo "Введіть пароль адміністратора:"
    read -p "> " admin_password

    docker run -d \
        --name=wg-easy \
        -e WG_HOST=$ip_address \
        -e PASSWORD=$admin_password \
        -v ~/.wg-easy:/etc/wireguard \
        -p 51820:51820/udp \
        -p 51821:51821/tcp \
        --cap-add=NET_ADMIN \
        --cap-add=SYS_MODULE \
        --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
        --sysctl="net.ipv4.ip_forward=1" \
        --restart unless-stopped \
        weejewel/wg-easy

    if [ $? -eq 0 ]; then
        echo -e "\n\e[32mWireGuard Easy успішно встановлено. Веб-інтерфейс доступний за адресою \033[33m$ip_address:51821\e[0m"
    else
        echo -e "\n\e[31mСталася помилка під час встановлення WireGuard Easy. Перевірте налаштування і спробуйте ще раз.\e[0m"
    fi
}

stop_wg_easy() {
    docker stop wg-easy
    echo "WireGuard Easy зупинено."
}

remove_wg_easy() {
    docker stop wg-easy
    docker rm wg-easy
    echo "WireGuard Easy видалено."
}

update_wg_easy() {
    docker stop wg-easy
    docker rm wg-easy
    docker pull weejewel/wg-easy
    echo "WireGuard Easy оновлено."
}
