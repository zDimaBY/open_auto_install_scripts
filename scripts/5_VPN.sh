function 5_VPN() {
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. X-UI (WEB, on docker install) https://github.com/alireza0/x-ui/pkgs/container/x-ui"
        echo -e "2. 3X-UI (WEB, on docker install) https://github.com/MHSanaei/3x-ui"
        echo -e "3. WireGuard Easy (WEB, on docker install) https://github.com/wg-easy/wg-easy"
        echo -e "4. IPsec/L2TP, Cisco IPsec and IKEv2 (on docker install) https://github.com/hwdsl2/docker-ipsec-vpn-server"
        echo -e "5. WireGuard (locall install) https://github.com/angristan/wireguard-install"
        echo -e "6. OpenVPN (locall install) https://github.com/angristan/openvpn-install"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) menu_x_ui ;;
        2) menu_3x_ui ;;
        3) menu_wireguard_easy ;;
        4) menu_IPsec_L2TP_IKEv2 ;;
        5) menu_wireguard_scriptLocal ;;
        6) menu_openVPNLocal ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

#_______________________________________________________________________________________________________________________________________
menu_x_ui() {
    check_docker
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. Встановлення X-UI"
        echo "2. Зупинка X-UI"
        echo "3. Видалення X-UI"
        #echo "4. Оновлення X-UI"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) list_x_ui_versions_install ;;
        2) stop_x_ui ;;
        3) remove_x_ui ;;
        4) update_x_ui ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}
install_x_ui() {
    local version="$1"
    create_folder "/root/VPN/x_ui/db/" && create_folder "/root/VPN/x_ui/cert/"
    docker run -itd \
        -p 54321:54321 -p 443:443 -p 80:80 \
        -e XRAY_VMESS_AEAD_FORCED=false \
        -v /root/VPN/x_ui/db/:/etc/x-ui/ \
        -v /root/VPN/x_ui/cert/:/root/cert/ \
        --name x-ui --restart=unless-stopped \
        alireza7/x-ui:$version

    ports=(54321 443 80)
    for port in "${ports[@]}"; do
        if ! iptables -C INPUT -p tcp --dport "$port" -j ACCEPT &>/dev/null; then
            iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
        fi
    done
    docker ps -a
}

list_x_ui_versions_install() {
    local versions=$(curl -s https://api.github.com/repos/alireza0/x-ui/tags | jq -r '.[].name' | grep -Eo '[0-9.]+' | sort -Vr | head -n 9)
    echo "Список доступних версій образу ghcr.io/mhsanaei/3x-ui:"
    local i=1
    for ver in $versions; do
        echo "$i. $ver"
        ((i++))
    done
    read -p "Введіть номер версії, яку ви хочете встановити (1-9): " choice
    if ((choice >= 1 && choice <= 9)); then
        install_x_ui "$(curl -s https://api.github.com/repos/alireza0/x-ui/tags | jq -r '.[].name' | grep -Eo '[0-9.]+' | sort -Vr | head -n 9 | sed -n "${choice}p")"
    else
        echo "Неправильний вибір. Будь ласка, виберіть номер від 1 до 9."
        exit 1
    fi

    echo -e "${YELLOW}\n\nВстановив X-UI на сервер. Для входу в панель адміністратора, використовуйте ці дані:${RESET}"
    echo -e "http://${server_IP}:54321"
    echo -e "Користувач: admin"
    echo -e "Пароль: admin\n"

    echo -e "${YELLOW}Також, налаштував vmess підключення:${RESET}"
    echo -e "- QR-код (знімок екрану додаю)"
    echo -e "- посилання: "
    echo -e "vmess://XXXXXXXXXX\n"

    echo -e "${YELLOW}Для підключення, можете використати ці додатки:${RESET}"
    echo -e "${GREEN}Android: ${RESET}https://github.com/2dust/v2rayNG/releases/download/1.8.6/v2rayNG_1.8.6.apk"
    echo -e "${GREEN}Windows: ${RESET}https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-windows64.zip"
    echo -e "${GREEN}Linux: ${RESET}https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-debian-x64.deb ; https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-linux64.zip"
    echo -e "${GREEN}MacOS (Intel + Apple): ${RESET}https://github.com/abbasnaqdi/nekoray-macos/releases/download/3.18/nekoray_amd64.zip"
    echo -e "${GREEN}iOS: ${RESET}https://apps.apple.com/us/app/napsternetv/id1629465476 , https://apps.apple.com/us/app/v2box-v2ray-client/id6446814690 \n"

    echo -e "${YELLOW}Для підключення через програму nekoray (для Windows, посилання: https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-windows64.zip), натисніть на Program -> Scan QR code. Перед цим, скопіюйте посилання для підключення.${RESET}"
    echo -e "${YELLOW}Після цього, увімкніть Tune Mode і System Proxy, натисніть ПКМ на нове підключення, і виберіть Start. Після цього, VPN повинен стати активним.${RESET}"

}
stop_x_ui() {
    docker stop 'x-ui'
    echo "x-ui зупинено."
}

remove_x_ui() {
    docker stop 'x-ui'
    docker rm 'x-ui'
    echo "x-ui Easy видалено."
    docker ps -a
}

update_x_ui() {
    echo "Функція не реалізована"
}
#_______________________________________________________________________________________________________________________________________
menu_3x_ui() {
    check_docker
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. Встановлення 3X-UI"
        echo "2. Зупинка 3X-UI"
        echo "3. Видалення 3X-UI"
        #echo "4. Оновлення 3X-UI"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) list_3x_ui_versions_install ;;
        2) stop_3x_ui ;;
        3) remove_3x_ui ;;
        4) update_3x_ui ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}
install_3x_ui() {
    local version="$1"
    create_folder "/root/VPN/3x_ui/db/" && create_folder "/root/VPN/3x_ui/cert/"
    docker run -itd \
        -e XRAY_VMESS_AEAD_FORCED=false \
        -v /root/VPN/3x_ui/db/:/etc/x-ui/ \
        -v /root/VPN/3x_ui/cert/:/root/cert/ \
        --network=host \
        --restart=unless-stopped \
        --name 3x-ui \
        ghcr.io/mhsanaei/3x-ui:$version

    if ! iptables -C INPUT -p tcp --dport 2053 -j ACCEPT &>/dev/null; then
        iptables -A INPUT -p tcp --dport 2053 -j ACCEPT
    fi
    docker ps -a
}

list_3x_ui_versions_install() {
    local versions=$(curl -s https://api.github.com/repos/MHSanaei/3x-ui/tags | jq -r '.[].name' | head -n 9)
    echo "Список доступних версій образу ghcr.io/mhsanaei/3x-ui:"
    local i=1
    for ver in $versions; do
        echo "$i. $ver"
        ((i++))
    done
    read -p "Введіть номер версії, яку ви хочете встановити (1-9): " choice
    if ((choice >= 1 && choice <= 9)); then
        version=$(curl -s https://api.github.com/repos/MHSanaei/3x-ui/tags | jq -r '.[].name' | head -n 9 | sed -n "${choice}p")
        install_3x_ui "$version"
    else
        echo "Неправильний вибір. Будь ласка, виберіть номер від 1 до 9."
        exit 1
    fi

    echo -e "${YELLOW}\n\nВстановив X-UI на сервер. Для входу в панель адміністратора, використовуйте ці дані:${RESET}"
    echo -e "http://${server_IP}:2053"
    echo -e "Користувач: admin"
    echo -e "Пароль: admin\n"

    echo -e "${YELLOW}Також, налаштував vmess підключення:${RESET}"
    echo -e "- QR-код (знімок екрану додаю)"
    echo -e "- посилання: "
    echo -e "vmess://XXXXXXXXXX\n"

    echo -e "${YELLOW}Для підключення, можете використати ці додатки:${RESET}"
    echo -e "${GREEN}Android: ${RESET}https://github.com/2dust/v2rayNG/releases/download/1.8.6/v2rayNG_1.8.6.apk"
    echo -e "${GREEN}Windows: ${RESET}https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-windows64.zip"
    echo -e "${GREEN}Linux: ${RESET}https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-debian-x64.deb ; https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-linux64.zip"
    echo -e "${GREEN}MacOS (Intel + Apple): ${RESET}https://github.com/abbasnaqdi/nekoray-macos/releases/download/3.18/nekoray_amd64.zip"
    echo -e "${GREEN}iOS: ${RESET}https://apps.apple.com/us/app/napsternetv/id1629465476 , https://apps.apple.com/us/app/v2box-v2ray-client/id6446814690 \n"

    echo -e "${YELLOW}Для підключення через програму nekoray (для Windows, посилання: https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-windows64.zip), натисніть на Program -> Scan QR code. Перед цим, скопіюйте посилання для підключення.${RESET}"
    echo -e "${YELLOW}Після цього, увімкніть Tune Mode і System Proxy, натисніть ПКМ на нове підключення, і виберіть Start. Після цього, VPN повинен стати активним.${RESET}"

}
stop_3x_ui() {
    docker stop '3x-ui'
    echo "3x-ui зупинено."
}

remove_3x_ui() {
    docker stop '3x-ui'
    docker rm '3x-ui'
    echo "3x-ui Easy видалено."
    docker ps -a
}

update_3x_ui() {
    echo "Функція не реалізована"
}
#_______________________________________________________________________________________________________________________________________
menu_wireguard_easy() {
    check_docker
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo "1. Встановлення WireGuard Easy"
        echo "2. Зупинка WireGuard Easy"
        echo "3. Видалення WireGuard Easy"
        echo "4. Оновлення WireGuard Easy"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

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
    read -r -p "Введіть пароль адміністратора: " admin_password # -r: забороняє інтерпретацію backslashes, -s: не виводити введений пароль

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
        echo -e "\n${GREEN}WireGuard Easy успішно встановлено. ${YELLOW}Документація за посиланням: https://github.com/wg-easy/wg-easy${RESET}"
        echo -e "Ви можете отримати доступ до веб-інтерфейсу за адресою: ${YELLOW}http://$ip_address:51821${RESET}"
        echo -e "${GREEN}Пароль для доступу до інтерфейсу:${RESET} ${YELLOW}$admin_password${RESET}"
        echo -e "Для діагностики використовуйте команди:"
        echo -e "  ${YELLOW}docker logs wg-easy${RESET} - перегляд журналів контейнера"
        echo -e "  ${YELLOW}docker exec -it wg-easy /bin/bash -c 'ls /bin'${RESET} - перегляд списку команд у контейнері"
    else
        echo -e "\n${RED}Сталася помилка під час встановлення WireGuard Easy. Перевірте, будь ласка, налаштування і спробуйте ще раз.${RESET}"
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

    create_folder "/root/VPN/wireguard"

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
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}__________________________________________________________________________WireGuard успішно встановлено!${RESET}"
        echo -e "${YELLOW}Інструкція для налаштування WireGuard${RESET}"
        echo -e "1. Завантажте клієнт WireGuard за посиланням: ${BLUE}https://www.wireguard.com/install/${RESET}"
        echo "2. Після завантаження клієнта, встановіть його на Ваш пристрій."
        echo "3. Перейдіть до каталогу /root/VPN/wireguard/ на Вашому сервері."
        echo "4. Скопіюйте файл конфігурації з серверу на Ваш пристрій."
        echo "5. Відкрийте клієнт WireGuard та імпортуйте файл конфігурації."
        echo "6. Після імпорту, Ваш VPN-профіль буде доступний для підключення."
        echo "Документація за посиланням: https://github.com/angristan/openvpn-install"

    else
        echo -e "\n${RED}Сталася помилка під час встановлення WireGuard. Перевірте, будь ласка, налаштування і спробуйте ще раз.${RESET}"
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

    create_folder "/root/VPN/openVPN"

    curl -sS -o /root/VPN/openvpn-install.sh https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    sed -i 's|"$homeDir|"/root/VPN/openVPN|g' /root/VPN/openvpn-install.sh
    chmod +x /root/VPN/openvpn-install.sh && export AUTO_INSTALL=y
    bash /root/VPN/openvpn-install.sh
    echo -e "${GREEN}__________________________________________________________________________OpenVPN успішно встановлено!${RESET}"
    echo -e "Документація за посиланням: https://github.com/angristan/openvpn-install"
    # Інструкція для платформи Windows
    echo -e "${YELLOW}Інструкція для платформи Windows${RESET}"
    echo "1. Завантажте встановлювач OpenVPN для Windows з офіційного сайту OpenVPN."
    echo "2. Встановіть програму, використовуючи стандартний інсталяційний процес."
    echo "3. Запустіть OpenVPN."
    echo "4. Після запуску програми, перейдіть до 'Файл' -> 'Імпорт файлу конфігурації'."
    echo "5. Виберіть конфігураційний файл, який отримали від свого сервера VPN."
    echo "6. Після імпорту, з'явиться новий профіль під назвою Вашого VPN. Клацніть на нього, щоб підключитися."

    # Інструкція для платформи Android
    echo -e "\n${YELLOW}Інструкція для платформи Android${RESET}"
    echo "1. Завантажте та встановіть додаток OpenVPN для Android з Google Play Store."
    echo "2. Перенесіть конфігураційний файл (з розширенням .ovpn) на Ваш пристрій Android."
    echo "3. У додатку OpenVPN натисніть на значок '+' для додавання нового профілю."
    echo "4. Виберіть опцію 'Імпорт із файлу' та оберіть свій конфігураційний файл."
    echo "5. Після імпорту, профіль буде доступний для підключення."

    # Інструкція для платформи macOS (OS X)
    echo -e "\n${YELLOW}Інструкція для платформи macOS (OS X)${RESET}"
    echo "1. Встановіть Tunnelblick, безкоштовний клієнт OpenVPN для macOS, завантаживши його з офіційного сайту."
    echo "2. Відкрийте інсталятор та слідуйте інструкціям для завершення процесу встановлення."
    echo "3. Після встановлення, перенесіть конфігураційний файл (з розширенням .ovpn) в теку 'configurations' у Вашій домашній теки."
    echo "4. Запустіть Tunnelblick та виберіть 'Connect' для Вашого VPN-профілю."

    # Інструкція для Linux
    echo -e "\n${YELLOW}Інструкція для Linux${RESET}"
    echo "1. Встановіть пакунок OpenVPN за допомогою менеджера пакунків Вашої дистрибуції (наприклад, apt для Ubuntu або yum для CentOS)."
    echo "2. Перенесіть конфігураційний файл (з розширенням .ovpn) в теку /etc/openvpn."
    echo "3. В терміналі введіть 'sudo openvpn назва_конфігураційного_файлу.ovpn' для підключення до VPN."

    # Інструкція для iOS (iPhone та iPad)
    echo -e "\n${YELLOW}Інструкція для iOS (iPhone та iPad)${RESET}"
    echo "1. Встановіть програму OpenVPN Connect з App Store на Вашому пристрої iOS."
    echo "2. Перенесіть конфігураційний файл (з розширенням .ovpn) на Ваш пристрій через iTunes або інші доступні методи."
    echo "3. У програмі OpenVPN Connect, відкрийте розділ 'Настройки' та оберіть 'Імпорт файлу OpenVPN'."
    echo "4. Оберіть свій конфігураційний файл та дотримуйтесь інструкцій для імпорту."
    echo "5. Після імпорту, Ваш VPN-профіль буде доступний для підключення."
}

menu_openVPN_installer() {
    curl -sS -o /root/VPN/openvpn-install.sh https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    sed -i 's|"$homeDir|"/root/VPN/openVPN|g' /root/VPN/openvpn-install.sh
    chmod +x /root/VPN/openvpn-install.sh && export AUTO_INSTALL=n
    bash /root/VPN/openvpn-install.sh
}
#_______________________________________________________________________________________________________________________________________
menu_IPsec_L2TP_IKEv2() {
    check_docker
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію для налаштування контейнера IPsec/L2TP, Cisco IPsec та IKEv2:\n"
        echo "1. Встановлення ipsec-vpn-server"
        echo "2. Створити нову конфігурацію для клієнта ipsec-vpn-server"
        echo "3. Зупинка ipsec-vpn-server"
        echo "4. Видалення ipsec-vpn-server"
        echo "5. Оновлення ipsec-vpn-server"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) install_ipsec_vpn_server ;;
        2) add_client_ipsec_vpn_server ;;
        3) stop_ipsec_vpn_server ;;
        4) remove_ipsec_vpn_server ;;
        5) update_ipsec_vpn_server ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

install_ipsec_vpn_server() {
    create_folder "/root/VPN/IPsec_L2TP"
    generate_vpn_env_file() {
        generate_random_password
        echo "VPN_IPSEC_PSK=$rand_password" >/root/VPN/IPsec_L2TP/vpn.env
        read -p "Введіть ім'я користувача для VPN: " vpn_username
        echo "VPN_USER=$vpn_username" >>/root/VPN/IPsec_L2TP/vpn.env
        generate_random_password
        echo "VPN_PASSWORD=$rand_password" >>/root/VPN/IPsec_L2TP/vpn.env
        echo -e "${GREEN}Файл vpn.env створено та налаштовано успішно.${RESET}\n"
    }

    if [ -f /root/VPN/IPsec_L2TP/vpn.env ]; then
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
            --env-file /root/VPN/IPsec_L2TP/vpn.env \
            --restart=always \
            -v ikev2-vpn-data:/etc/ipsec.d \
            -v /lib/modules:/lib/modules:ro \
            -p 500:500/udp \
            -p 4500:4500/udp \
            -d --privileged \
            hwdsl2/ipsec-vpn-server

        wget https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/file/VPN/IPsec_and_IKEv2/IPSec_NAT_Config.bat -P /root/VPN/IPsec_L2TP
        wget https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/file/VPN/IPsec_and_IKEv2/ikev2_config_import.cmd -P /root/VPN/IPsec_L2TP

        copy_file_from_container "ipsec-vpn-server" "/etc/ipsec.d/vpnclient.p12" "/root/VPN/IPsec_L2TP"
        copy_file_from_container "ipsec-vpn-server" "/etc/ipsec.d/vpnclient.sswan" "/root/VPN/IPsec_L2TP"
        copy_file_from_container "ipsec-vpn-server" "/etc/ipsec.d/vpnclient.mobileconfig" "/root/VPN/IPsec_L2TP"

        if [ $? -eq 0 ]; then
            echo -e "\n${GREEN}Файли для налаштуваня клієнта успішно скопійовано до /root/VPN/IPsec_L2TP${RESET}"
        else
            echo -e "\n${RED}Помилка під час копіювання файлів.${RESET}"
            echo -e "Спробуйте, будь ласка, виконати команди вручну:"
            echo -e "\n${YELLOW}docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.p12 /root/VPN/IPsec_L2TP${RESET}"
            echo -e "${YELLOW}docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.sswan /root/VPN/IPsec_L2TP${RESET}"
            echo -e "${YELLOW}docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.mobileconfig /root/VPN/IPsec_L2TP${RESET}"
        fi

        echo -e "\n${GREEN}Контейнер ipsec-vpn-server встановлено та налаштовано успішно. Документація за посиланням: https://github.com/hwdsl2/setup-ipsec-vpn${RESET}\n"

        # Підключення через протокол IKEv2 на Windows 10/11/8
        echo -e "${YELLOW}Підключення через протокол IKEv2 на Windows 10/11/8${RESET}"
        echo "1. Перенесіть згенерований файл .p12 у бажану теку на вашому комп'ютері."
        echo "1.1. Завантажте файли ikev2_config_import.cmd і IPSec_NAT_Config.bat. Переконайтеся, що обидва файли знаходяться у тій самій текі, що й файл .p12."
        echo "2. Налаштування VPN:"
        echo "2.1. Клацніть правою кнопкою миші на файлі IPSec_NAT_Config.bat."
        echo "2.2. У контекстному меню виберіть 'Запустити від імені адміністратора'."
        echo "2.3. Підтвердіть дію, якщо з'явиться запит UAC (Контроль облікових записів користувачів)."
        echo "3. Імпорт конфігурації:"
        echo "3.1. Клацніть правою кнопкою миші на файлі ikev2_config_import.cmd."
        echo "3.2. У контекстному меню виберіть 'Запустити від імені адміністратора'."
        echo "3.3. Дотримуйтесь інструкцій на екрані, щоб завершити імпорт конфігурації."
        echo "4. Перезавантажте Ваш комп'ютер, щоб переконатися, що всі зміни набрали чинності."
        echo "5. Тепер Ви можете спробувати підключитися до Вашого VPN-серверу, використовуючи налаштування IKEv2."

        # Підключення через Android
        echo -e "\n${YELLOW}Підключення через Android${RESET}"
        echo "1. Перенесіть згенерований файл .sswan на Ваш пристрій Android."
        echo "2. Завантажте і встановіть програму strongSwan VPN Client з Google Play, F-Droid або безпосередньо з сервера strongSwan."
        echo "3. Запустіть клієнт strongSwan VPN на вашому пристрої."
        echo "4. Імпорт профілю VPN:"
        echo "4.1. Натисніть на іконку 'Інші параметри' (зазвичай зображена трема вертикальними крапками) у правому верхньому куті."
        echo "4.2. У випадаючому меню виберіть 'Імпорт профілю VPN'."
        echo "4.3. Для пошуку файлу .sswan натисніть на іконку трьох горизонтальних ліній або кнопку меню, і перейдіть до теки, де збережений файл."
        echo "4.4. Виберіть файл .sswan, який Ви отримали з VPN-сервера."
        echo "5. Імпорт сертифіката:"
        echo "5.1. На екрані 'Імпорт профілю VPN' виберіть 'ІМПОРТ СЕРТИФІКАТА З ПРОФІЛЯ VPN' і дотримуйтесь вказівок на екрані."
        echo "5.2. На наступному екрані 'Виберіть сертифікат' виберіть щойно імпортований сертифікат клієнта і натисніть 'Вибрати'."
        echo "5.3. Потім натисніть 'ІМПОРТ'."
        echo "5.4. Підключення до VPN: Натисніть на новий VPN-профіль, щоб розпочати підключення."

        # Для налаштування OS X (macOS) / iOS використовується файл .mobileconfig
        echo -e "\n${YELLOW}Для налаштування OS X (macOS) / iOS використовується файл .mobileconfig${RESET}"
        echo "Спочатку безпечно передайте згенерований файл .mobileconfig на ваш Mac, а потім двічі клацніть по ньому й дотримуйтесь інструкцій для імпорту як профілю macOS."
        echo "Якщо на вашому Mac встановлено macOS Big Sur або новіше, відкрийте Системні налаштування й перейдіть до розділу Профілі, щоб завершити імпорт."
        echo "Для macOS Ventura і новіших відкрийте Системні налаштування й знайдіть Профілі."
        echo "Після завершення перевірте, щоб 'IKEv2 VPN' відображалося в Системні налаштування -> Профілі."
        echo "Для підключення до VPN:"
        echo "1. Відкрийте Системні налаштування і перейдіть до розділу Мережа."
        echo "2. Виберіть VPN-підключення з Вашим IP-адресою VPN-сервера (або DNS-іменем)."
        echo "3. Поставте галочку 'Показувати статус VPN у рядку меню'. Для macOS Ventura і новіших цю настройку можна налаштувати в Системні налаштування -> Контрольний центр -> Тільки рядок меню."
        echo "4. Натисніть Підключити або перемикніть VPN у положення ВКЛ."
        echo "5. (Додаткова функція) Увімкніть VPN за вимогою, щоб автоматично запускати VPN-підключення, коли ваш Mac підключений до Wi-Fi."
        echo "   Щоб увімкнути, поставте галочку 'Підключати за вимогою' для VPN-підключення і натисніть Застосувати."
        echo "   Щоб знайти цю настройку на macOS Ventura і новіших, клацніть на значок 'i' праворуч від VPN-підключення."
    else
        echo -e "\n${YELLOW}Контейнер ipsec-vpn-server вже встановлено..${RESET}\n"
    fi
}

add_client_ipsec_vpn_server() {
    read -p "Введіть ім'я підключення: " connection_name
    
    if [ -z "$connection_name" ]; then
        echo "Помилка: не вказано ім'я підключення"
        return 1
    fi
    
    if docker exec -it ipsec-vpn-server ls "/etc/ipsec.d/$connection_name.p12" &> /dev/null; then
        echo "Помилка: підключення \"$connection_name\" вже існує"
        return 1
    fi
    
    docker exec -it ipsec-vpn-server /opt/src/ikev2.sh --addclient "$connection_name"

    copy_file_from_container "ipsec-vpn-server" "/etc/ipsec.d/$connection_name.p12" "/root/VPN/IPsec_L2TP/$connection_name/"
    copy_file_from_container "ipsec-vpn-server" "/etc/ipsec.d/$connection_name.sswan" "/root/VPN/IPsec_L2TP/$connection_name/"
    copy_file_from_container "ipsec-vpn-server" "/etc/ipsec.d/$connection_name.mobileconfig" "/root/VPN/IPsec_L2TP/$connection_name/"
    
    echo -e "${GREEN}Файли конфігурації скопійовано за шляхом /root/VPN/IPsec_L2TP/$connection_name ${RESET}"
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
