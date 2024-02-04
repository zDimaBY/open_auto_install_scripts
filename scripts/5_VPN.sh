function 5_VPN() {
    check_docker
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. WireGuard Easy (WEB, on docker)"
        echo "2. WireGuard script (install local)"
        echo "3. OpenVPN (install local)"
        echo "4. VPN server, with IPsec/L2TP, Cisco IPsec and IKEv2 (on docker) (в процесі реалізації)"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) menu_wireguard_easy ;;
        2) menu_wireguard_scriptLocal ;;
        3) menu_openVPNLocal ;;
        4) menu_IPsec_L2TP_IKEv2 ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}
#_______________________________________________________________________________________________________________________________________
menu_wireguard_easy() {
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
    generate_random_password_show
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
        -e WG_HOST="$ip_address" \
        -e PASSWORD="$admin_password" \
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
#_______________________________________________________________________________________________________________________________________
menu_wireguard_scriptLocal() {
    while true; do
        checkControlPanel
        echo -e "\nWireGuard installer. Виберіть дію:\n"
        echo "1. Автоматичне встановлення WireGuard"
        echo "2. Меню керування WireGuard та ручне встановлення"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) install_wireguard_scriptLocal ;;
        2) menu_wireguard_installer ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

install_wireguard_scriptLocal() {
    case $operating_system in
    debian | ubuntu) ;;
    fedora) ;;
    centos | oracle) ;;
    arch) ;;
    *)
        echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac

    mkdir -p /root/VPN && mkdir -p /root/VPN/wireguard || {
        echo "Failure"
        exit 1
    }

    sed -i 's/^#\$nrconf{restart} = '\''i'\'';/$nrconf{restart} = '\''a'\'';/g' /etc/needrestart/needrestart.conf

    curl -sS -o /root/VPN/wireguard-install.sh https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
    chmod +x /root/VPN/wireguard-install.sh
    sed -i 's|"${HOME_DIR}|"/root/VPN/wireguard|g' /root/VPN/wireguard-install.sh
    sed -i 's|10.66.66.1|10.0.0.1|g' /root/VPN/wireguard-install.sh
    sed -i 's|${RANDOM_PORT}|65530|g' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "IPv4 .*|echo "IPv4 or IPv6 public address $SERVER_PUB_IP"|' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "Publi.*|SERVER_PUB_NIC="${SERVER_NIC}"|' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "WireGuar.*|SERVER_WG_NIC="wg0"|' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "Server WireGuard IPv4: ".*|SERVER_WG_IPV4="10.0.0.1"|' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "Server WireGuard IPv6: ".*|SERVER_WG_IPV6="fd42:42:42::1"|' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "Server WireGuard port.*|SERVER_PORT="65530"|' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "First DNS resolv.*|CLIENT_DNS_1="1.1.1.1"|' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "Second DNS resolver to u|#read -rp "Second DNS resolver to u"|' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "Allowed IPs list fo|#read -rp "Allowed IPs list fo|' /root/VPN/wireguard-install.sh
    sed -i 's|read -n1 -r -p "Press any key to continue.*||' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "Client name:.*|CLIENT_NAME="proxy"|' /root/VPN/wireguard-install.sh
    sed -i 's|read -rp "Client WireGuard IPv|#read -rp "Client WireGuard IPv|' /root/VPN/wireguard-install.sh
    bash /root/VPN/wireguard-install.sh
    sed -i 's|CLIENT_NAME="proxy"|#read -rp "Client name: " -e CLIENT_NAME|' /root/VPN/wireguard-install.sh
    echo -e "${GREEN}__________________________________________________________________________WireGuard script done!${RESET}"
    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}WireGuard Easy успішно встановлено. Веб-інтерфейс доступний за адресою ${YELLOW}$ip_address:51821${RESET}"
    else
        echo -e "\n${RED}Сталася помилка під час встановлення WireGuard Easy. Перевірте налаштування і спробуйте ще раз.${RESET}"
    fi
}

menu_wireguard_installer() {
    curl -sS -o /root/VPN/wireguard-install.sh https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
    chmod +x /root/VPN/wireguard-install.sh
    bash /root/VPN/wireguard-install.sh
}
#_______________________________________________________________________________________________________________________________________
menu_openVPNLocal() {
    while true; do
        checkControlPanel
        echo -e "\nOpenVPN installer. Виберіть дію:\n"
        echo "1. Автоматичне встановлення OpenVPN"
        echo "2. Меню керування OpenVPN та ручне встановлення"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) avtoInstall_openVPN ;;
        2) menu_openVPN_installer ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}
avtoInstall_openVPN() {
    case $operating_system in
    debian | ubuntu) ;;
    fedora) ;;
    centos | oracle) ;;
    arch) ;;
    *)
        echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac

    mkdir -p /root/VPN || mkdir -p /root/VPN/openVPN || {
        echo "Failure"
        exit 1
    }

    curl -sS -o /root/VPN/openvpn-install.sh https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    sed -i "s|$homeDir|/root/VPN/openVPN|g" /root/VPN/openvpn-install.sh
    chmod +x /root/VPN/openvpn-install.sh && export AUTO_INSTALL=y
    bash /root/VPN/openvpn-install.sh
    echo -e "${GREEN}__________________________________________________________________________openVPN script done!${RESET}"
}

menu_openVPN_installer() {
    curl -sS -o /root/VPN/openvpn-install.sh https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    sed -i "s|$homeDir|/root/VPN/openVPN|g" /root/VPN/openvpn-install.sh
    chmod +x /root/VPN/openvpn-install.sh && export AUTO_INSTALL=n
    bash /root/VPN/openvpn-install.sh
}
#_______________________________________________________________________________________________________________________________________
menu_IPsec_L2TP_IKEv2() {
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію для налаштування контейнера IPsec/L2TP, Cisco IPsec та IKEv2:\n"
        echo "1. Встановлення ipsec-vpn-server"
        echo "2. Зупинка ipsec-vpn-server"
        echo "3. Видалення ipsec-vpn-server"
        echo "4. Оновлення ipsec-vpn-server"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант (1/2/3/4/5/6/7/8/9/0):" choice

        case $choice in
        1) install_ipsec_vpn_server ;;
        2) stop_ipsec_vpn_server ;;
        3) remove_ipsec_vpn_server ;;
        4) update_ipsec_vpn_server ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

install_ipsec_vpn_server() {
    generate_vpn_env_file() {
        generate_random_password
        echo "VPN_IPSEC_PSK=$rand_password" >./vpn.env
        read -p "Введіть ім'я користувача для VPN: " vpn_username
        echo "VPN_USER=$vpn_username" >>./vpn.env
        generate_random_password
        echo "VPN_PASSWORD=$rand_password" >>./vpn.env
        echo -e "${GREEN}Файл vpn.env створено та налаштовано успішно.${RESET}\n"
    }

    if [ -f ./vpn.env ]; then
        echo -e "${GREEN}Файл vpn.env для кнфігурації вже існує. Ви хочете створити новий чи використовувати той що є ?${RESET}"
        read -p "(y/n): " create_new_vpn_env
        if [[ "$create_new_vpn_env" =~ ^(y|Y|yes)$ ]]; then
            echo -e "${YELLOW}Використовуємо існуючий файл vpn.env.\n${RESET}"
        else
            echo "Вибрано створення нового vpn.env."
            generate_vpn_env_file
        fi
    else
        generate_vpn_env_file
    fi

    if ! docker ps -a --format '{{.Names}}' | grep -q "^ipsec-vpn-server$"; then
        docker run \
            --name ipsec-vpn-server \
            --env-file ./vpn.env \
            --restart=always \
            -v ikev2-vpn-data:/etc/ipsec.d \
            -v /lib/modules:/lib/modules:ro \
            -p 500:500/udp \
            -p 4500:4500/udp \
            -d --privileged \
            hwdsl2/ipsec-vpn-server

        create_folder "/root/VPN/IPsec_L2TP"

        wait_for_container_docker "ipsec-vpn-server"

        docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.p12 /root/VPN/IPsec_L2TP
        docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.sswan /root/VPN/IPsec_L2TP
        docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.mobileconfig /root/VPN/IPsec_L2TP

        if [ $? -eq 0 ]; then
            echo -e "\n${GREEN}Файли для налаштуваня успішно скопійовано до /root/VPN/IPsec_L2TP${RESET}"
        else
            echo -e "\n${RED}Помилка під час копіювання файлів.${RESET}"
            echo -e "Спробуйте, будь ласка, виконати команди вручну:"
            echo -e "\n${YELLOW}docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.p12 /root/VPN/IPsec_L2TP${RESET}"
            echo -e "\n${YELLOW}docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.sswan /root/VPN/IPsec_L2TP${RESET}"
            echo -e "\n${YELLOW}docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.mobileconfig /root/VPN/IPsec_L2TP${RESET}"
        fi

        echo -e "\n${GREEN}Контейнер ipsec-vpn-server встановлено та налаштовано успішно.${RESET}\n"
    else
        echo -e "\n${YELLOW}Контейнер ipsec-vpn-server вже встановлено. Продовжуємо...${RESET}\n"
    fi
}

stop_ipsec_vpn_server() {
    docker stop ipsec-vpn-server
    echo "ipsec-vpn-server зупинено."
}

remove_ipsec_vpn_server() {
    docker stop ipsec-vpn-server
    docker rm ipsec-vpn-server
    echo "ipsec-vpn-server видалено."
}

update_ipsec_vpn_server() {
    docker stop ipsec-vpn-server
    docker rm ipsec-vpn-server
    docker pull hwdsl2/ipsec-vpn-server
    echo "ipsec-vpn-server оновлено."
}
