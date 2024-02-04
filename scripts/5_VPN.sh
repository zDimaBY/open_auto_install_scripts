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
        echo -e "\n${GREEN}WireGuard Easy успішно встановлено.${RESET}"
        echo -e "Ви можете отримати доступ до веб-інтерфейсу за адресою: ${YELLOW}$ip_address:51821${RESET}"
        echo -e "${GREEN}Пароль для доступу до інтерфейсу:${RESET} ${YELLOW}$admin_password${RESET}"
        echo -e "${GREEN}Документація за посиланням:${RESET} https://github.com/wg-easy/wg-easy"
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
        echo "1. Завантажте клієнт WireGuard за посиланням: ${BLUE}https://www.wireguard.com/install/${RESET}"
        echo "2. Після завантаження клієнта, встановіть його на Ваш пристрій."
        echo "3. Перейдіть до каталогу /root/VPN/wireguard/ на Вашому сервері."
        echo "4. Скопіюйте файл конфігурації з серверу на Ваш пристрій."
        echo "5. Відкрийте клієнт WireGuard та імпортуйте файл конфігурації."
        echo "6. Після імпорту, Ваш VPN-профіль буде доступний для підключення."

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
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію для налаштування контейнера IPsec/L2TP, Cisco IPsec та IKEv2:\n"
        echo "1. Встановлення ipsec-vpn-server"
        echo "2. Зупинка ipsec-vpn-server"
        echo "3. Видалення ipsec-vpn-server"
        echo "4. Оновлення ipsec-vpn-server"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

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

        wait_for_container_command ipsec-vpn-server "true"

        docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.p12 /root/VPN/IPsec_L2TP
        docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.sswan /root/VPN/IPsec_L2TP
        docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.mobileconfig /root/VPN/IPsec_L2TP

        if [ $? -eq 0 ]; then
            echo -e "\n${GREEN}Файли для налаштуваня успішно скопійовано до /root/VPN/IPsec_L2TP${RESET}"
        else
            echo -e "\n${RED}Помилка під час копіювання файлів.${RESET}"
            echo -e "Спробуйте, будь ласка, виконати команди вручну:"
            echo -e "\n${YELLOW}docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.p12 /root/VPN/IPsec_L2TP${RESET}"
            echo -e "${YELLOW}docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.sswan /root/VPN/IPsec_L2TP${RESET}"
            echo -e "${YELLOW}docker cp ipsec-vpn-server:/etc/ipsec.d/vpnclient.mobileconfig /root/VPN/IPsec_L2TP${RESET}"
        fi

        echo -e "\n${GREEN}Контейнер ipsec-vpn-server встановлено та налаштовано успішно.${RESET}\n"
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
