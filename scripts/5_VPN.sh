function 5_VPN() {
    check_docker
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. WireGuard Easy (WEB)"
        echo "2. VPN server, with IPsec/L2TP, Cisco IPsec and IKEv2 (в процесі реалізації)"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант (1/2/3/4/5/6/7/8/9/0):" choice

        case $choice in
        1) menu_wg_easy ;;
        2) menu_IPsec_L2TP_IKEv2 ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

menu_wg_easy() {
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. Встановлення WireGuard Easy"
        echo "2. Зупинка WireGuard Easy"
        echo "3. Видалення WireGuard Easy"
        echo "4. Оновлення WireGuard Easy"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант (1/2/3/4/5/6/7/8/9/0):" choice

        case $choice in
        1) install_wg_easy ;;
        2) stop_wg_easy ;;
        3) remove_wg_easy ;;
        4) update_wg_easy ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

install_wg_easy() {
    get_server_ip
    generate_random_password
    echo "Введіть пароль адміністратора:"
    read -r -s -p "> " admin_password # -r: забороняє інтерпретацію backslashes, -s: не виводити введений пароль

    case $operating_system in
    debian | ubuntu) ;;
    fedora) ;;
    centos | oracle)
        yum install epel-release elrepo-release yum-plugin-elrepo kmod-wireguard wireguard-tools
        ;;
    arch) ;;
    *)
        echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac

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
        echo -e "\n${GREEN}WireGuard Easy успішно встановлено. Веб-інтерфейс доступний за адресою ${YELLOW}$ip_address:51821${RESET}"
    else
        echo -e "\n${RED}Сталася помилка під час встановлення WireGuard Easy. Перевірте налаштування і спробуйте ще раз.${RESET}"
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

menu_IPsec_L2TP_IKEv2() {
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію для налаштування контейнера IPsec/L2TP, Cisco IPsec and IKEv2:\n"
        echo "1. Встановлення ipsec-vpn-server"
        echo "2. Зупинка ipsec-vpn-server"
        echo "3. Видалення ipsec-vpn-server"
        echo "4. Оновлення ipsec-vpn-server"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант (1/2/3/4/5/6/7/8/9/0):" choice

        case $choice in
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}