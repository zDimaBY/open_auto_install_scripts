#!/bin/bash -n
# shellcheck disable=SC2148,SC2154
function 4_VPN() {
    statistics_scripts "4"
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        print_color_message 255 255 255 "1. $(print_color_message 255 215 0 '3X-UI') $(print_color_message 144 238 144 '(WEB, on docker install)') $(print_color_message 135 206 235 'https://github.com/MHSanaei/3x-ui') $(print_color_message 144 238 144 '(OS - Windows 64)')"
        print_color_message 255 255 255 "2. $(print_color_message 255 215 0 'X-UI') $(print_color_message 144 238 144 '(WEB, on docker install)') $(print_color_message 135 206 235 'https://github.com/alireza0/x-ui/pkgs/container/x-ui')"
        print_color_message 255 255 255 "3. $(print_color_message 255 215 0 'WireGuard Easy') $(print_color_message 144 238 144 '(WEB, on docker install)') $(print_color_message 135 206 235 'https://github.com/wg-easy/wg-easy')"
        print_color_message 255 255 255 "4. $(print_color_message 255 215 0 'IPsec/L2TP, Cisco IPsec and IKEv2') $(print_color_message 144 238 144 '(on docker install)') $(print_color_message 135 206 235 'https://github.com/hwdsl2/docker-ipsec-vpn-server')"
        print_color_message 255 255 255 "5. $(print_color_message 255 215 0 'WireGuard') $(print_color_message 255 215 0 '(locall install)') $(print_color_message 135 206 235 'https://github.com/angristan/wireguard-install')"
        print_color_message 255 255 255 "6. $(print_color_message 255 215 0 'OpenVPN') $(print_color_message 255 215 0 '(locall install)') $(print_color_message 135 206 235 'https://github.com/angristan/openvpn-install')"
        print_color_message 255 255 255 "7. $(print_color_message 255 215 0 'PPTP encryption (MPPE)') $(print_color_message 255 215 0 '(docker install)') $(print_color_message 135 206 235 'https://github.com/mobtitude/docker-vpn-pptp')"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) menu_3x_ui ;;
        2) menu_x_ui ;;
        3) menu_wireguard_easy ;;
        4) menu_IPsec_L2TP_IKEv2 ;;
        5) menu_wireguard_scriptLocal ;;
        6) menu_openVPNLocal ;;
        7) menu_PPTP ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

info_for_client_programs() {
    echo -e "${YELLOW}${MSG_VMESS_CONNECTION}${RESET}"
    echo -e "${MSG_VMESS_LINK}"
    echo -e "${MSG_VMESS_EXAMPLE}\n"

    echo -e "${YELLOW}${MSG_ANDROID_APPS}${RESET}"
    echo -e "${GREEN}${MSG_ANDROID_APP}${RESET}"
    get_latest_files_url "https://api.github.com/repos/2dust/v2rayNG" "apk"
    get_latest_files_url "https://api.github.com/repos/MatsuriDayo/NekoBoxForAndroid" "apk"

    echo -e "${GREEN}${MSG_WINDOWS_APPS}${RESET}"
    # Furious (Windows, Linux)
    get_latest_files_url "https://api.github.com/repos/MatsuriDayo/nekoray" "zip" | grep windows64.zip
    get_latest_files_url "https://api.github.com/repos/2dust/v2rayN" "zip" | grep v2rayN.zip
    get_latest_files_url "https://api.github.com/repos/LorenEteval/Furious" "zip"
    get_latest_files_url "https://api.github.com/repos/InvisibleManVPN/InvisibleMan-XRayClient" "zip"

    echo -e "${GREEN}${MSG_LINUX_APPS}${RESET}"
    get_latest_files_url "https://api.github.com/repos/MatsuriDayo/nekoray" "deb,zip" | grep -v windows64.zip

    echo -e "${GREEN}${MSG_MACOS_APPS}${RESET}"
    get_latest_files_url "https://api.github.com/repos/abbasnaqdi/nekoray-macos" "zip"

    echo -e "${GREEN}${MSG_IOS_APPS}${RESET}"
    print_color_message 135 206 235 "${MSG_IOS_APPS_LINK}"

    echo -e "\n\n${YELLOW}${MSG_ANDROID_INSTRUCTIONS}${RESET}"
    echo -e "${MSG_ANDROID_STEP_1}"
    get_latest_files_url "https://api.github.com/repos/2dust/v2rayNG" "apk" | grep universal.apk
    echo -e "\n${MSG_ANDROID_STEP_2}"
    echo -e "${MSG_ANDROID_STEP_3}"
    echo -e "${MSG_ANDROID_STEP_4}"
    echo -e "${MSG_ANDROID_STEP_5}"
    echo -e "${MSG_ANDROID_STEP_6}"
    echo -e "${MSG_ANDROID_STEP_7}"

    echo -e "${YELLOW}${MSG_WINDOWS_INSTRUCTIONS}${RESET}"
    echo -e "${MSG_WINDOWS_STEP_1}"
    get_latest_files_url "https://api.github.com/repos/MatsuriDayo/nekoray" "zip" | grep windows64.zip
    echo -e "\n${MSG_WINDOWS_STEP_2}"
    echo -e "${MSG_WINDOWS_STEP_3}"
    echo -e "${MSG_WINDOWS_STEP_4}"
    echo -e "${MSG_WINDOWS_STEP_5}"
    echo -e "${MSG_WINDOWS_STEP_6}"
    echo -e "${MSG_WINDOWS_STEP_7}"

    echo -e "${MSG_LINUX_INSTRUCTIONS}"
    echo -e "${MSG_LINUX_STEP_1}"

    echo -e "${MSG_MACOS_INSTRUCTIONS}"
    echo -e "${MSG_MACOS_STEP_1}"

    echo -e "${MSG_IOS_INSTRUCTIONS}"
    echo -e "${MSG_IOS_STEP_1}"
    
    echo -e "${YELLOW}${MSG_CLIPBOARD_STRING_HEADER}${RESET}"
    echo -e "${MSG_CLIPBOARD_STRING}"
    echo -e "${MSG_QR_CODE}\n"
    echo -e "${MSG_PROXY_DATA}"
    echo -e "${MSG_IMPORT_INSTRUCTIONS}"
    echo -e "${MSG_CONNECTION_IMPORT}"

    echo -e "https://itdog.info/klienty-vless-shadowsocks-trojan-xray-sing-box-dlya-windows-android-ios-macos-linux/"
}

#_______________________________________________________________________________________________________________________________________
menu_x_ui() {
    if ! check_docker_availability; then
        return 1
    fi
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        echo "1. Встановлення X-UI"
        echo "2. Зупинка X-UI"
        echo "3. Видалення X-UI"
        #echo "4. Оновлення X-UI"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

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
    name_docker_container="x-ui"
    create_folder "/root/VPN/x_ui/db/" && create_folder "/root/VPN/x_ui/cert/"
    docker run -itd \
        -p 54321:54321 -p 443:443 -p 80:80 \
        -e XRAY_VMESS_AEAD_FORCED=false \
        -v /root/VPN/x_ui/db/:/etc/x-ui/ \
        -v /root/VPN/x_ui/cert/:/root/cert/ \
        --name ${name_docker_container} --restart=unless-stopped \
        alireza7/x-ui:$version

    # Функція для додавання правил файерволу з скриптів functions_controller.sh
    add_firewall_rule 80
    add_firewall_rule 443
    add_firewall_rule 54321
    docker ps -a
}

list_x_ui_versions_install() {
    local versions=$(curl -s https://api.github.com/repos/alireza0/x-ui/tags | jq -r '.[].name' | grep -Eo '[0-9.]+' | sort -Vr | head -n 9)
    echo "Список доступних версій образу alireza7/x-ui:"
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
        return 1
    fi

    echo -e "${YELLOW}\n\nВстановив X-UI на сервер. Для входу в панель адміністратора, використовуйте ці дані:${RESET}"
    echo -e "http://${server_IPv4[0]}:54321"
    echo -e "Користувач: admin"
    echo -e "Пароль: admin\n"

    info_for_client_programs
}
stop_x_ui() {
    docker stop "$name_docker_container"
    echo "${name_docker_container} зупинено."
}

remove_x_ui() {
    docker stop "$name_docker_container"
    docker rm "$name_docker_container"
    #docker rmi "$name_docker_container"
    echo "${name_docker_container} видалено."
    docker ps -a
    remove_firewall_rule 80
    remove_firewall_rule 443
    remove_firewall_rule 54321
}

update_x_ui() {
    echo "Функція не реалізована"
}
#_______________________________________________________________________________________________________________________________________
menu_3x_ui() {
    if ! check_docker_availability; then
        return 1
    fi
    while true; do
        check_info_server
        check_info_control_panel

        echo -e "\nТакож 3x-ui стала доступна у Windows. Для запуска 3x-ui виконайте наступні кроки:"
        echo "1: Перейдіть за посиланням: https://github.com/MHSanaei/3x-ui/releases"
        echo "2: Виберіть необхідну версію і завантажте її з підменю 'Assets' -> x-ui-windows-amd64.zip"
        echo "3: Розпакуйте архів, завантажте та встановіть мову 'go' за посиланням: https://go.dev/dl/go1.22.1.windows-amd64.msi" як вказано у файлі readme.txt.
        echo "4: Виконайте нвступну команду у powershell: New-NetFirewallRule -DisplayName "Allow_TCP_2053" -Direction Inbound -LocalPort 2053 -Protocol TCP -Action Allow"
        echo "5: Запустіть 3x-ui.exe з папки 3x-ui та перейдіть за посиланням: http://localhost:2053"
        echo "6: Для видачі SSL сертифіката встановіть Win64OpenSSL_Light-3_2_1.exe з папки 'SSL'"
        echo "Примітка: Для в такому випадку потрібно відкривати порти для кожного нового клієнта, або відключати фаєрвол"

        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        echo "1. Встановлення 3X-UI"
        echo "2. Зупинка 3X-UI"
        echo "3. Видалення 3X-UI"
        #echo "4. Оновлення 3X-UI"

        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

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
    name_docker_container="3x-ui"
    local version="$1"
    create_folder "/root/VPN/3x_ui/db/" && create_folder "/root/VPN/3x_ui/cert/"
    docker run -itd \
        -e XRAY_VMESS_AEAD_FORCED=false \
        -v /root/VPN/3x_ui/db/:/etc/x-ui/ \
        -v /root/VPN/3x_ui/cert/:/root/cert/ \
        --network=host \
        --restart=unless-stopped \
        --name ${name_docker_container} \
        ghcr.io/mhsanaei/3x-ui:$version

    # Функція для додавання правил файерволу з скриптів functions_controller.sh
    add_firewall_rule 2053
    docker ps -a
}

list_3x_ui_versions_install() {
    local versions=$(curl -s https://api.github.com/repos/MHSanaei/3x-ui/tags | jq -r '.[].name' | head -n 9)
    echo -e "\n${GREEN}Список доступних версій образу ${YELLOW}ghcr.io/mhsanaei/3x-ui:${RESET}"
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
        return 1
    fi

    echo -e "${YELLOW}\n\nВстановив X-UI на сервер. Для входу в панель адміністратора, використовуйте ці дані:${RESET}"
    echo -e "http://${server_IPv4[0]}:2053"
    echo -e "Користувач: admin"
    echo -e "Пароль: admin\n"

    info_for_client_programs
}
stop_3x_ui() {
    docker stop "$name_docker_container"
    echo "${name_docker_container} зупинено."
}

remove_3x_ui() {
    docker stop "$name_docker_container"
    docker rm "$name_docker_container"
    #docker rmi "$name_docker_container"
    echo "${name_docker_container} видалено."
    docker ps -a

    # Функція для видалення правил з файервола з скриптів functions_controller.sh
    remove_firewall_rule 2053
}

update_3x_ui() {
    echo "Функція не реалізована"
}
#_______________________________________________________________________________________________________________________________________
menu_wireguard_easy() {
    if ! check_docker_availability; then
        return 1
    fi
    name_docker_container="wg-easy"
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        echo "1. Встановлення WireGuard Easy"
        echo "2. Зупинка WireGuard Easy"
        echo "3. Видалення WireGuard Easy"
        echo "4. Оновлення WireGuard Easy"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

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
    get_selected_interface # selected_adapter selected_ip_address selected_ip_mask selected_ip_gateway
    generate_random_password_show
    read -r -p "Введіть пароль адміністратора: " admin_password # -r: забороняє інтерпретацію backslashes, -s: не виводити введений пароль

    case $operating_system in
    debian | ubuntu) ;;
    fedora) ;;
    centos | oracle)
        if [[ "$VERSION" == "7" ]]; then
            yum install epel-release elrepo-release yum-plugin-elrepo kmod-wireguard wireguard-tools
        elif [[ "$VERSION" -gt 8 ]]; then
            dnf install epel-release kernel-modules-extra qrencode
        fi
        ;;
    arch | sysrescue) ;;
    *)
        echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac

    docker run -d \
        --name ${name_docker_container} \
        -e WG_HOST="$selected_ip_address" \
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
        echo -e "\n${GREEN}WireGuard Easy успішно встановлено. Ви можете отримати доступ до веб-інтерфейсу за адресою: ${YELLOW}http://$selected_ip_address:51821${RESET}"
        echo -e "${GREEN}Пароль для доступу до інтерфейсу:${RESET} ${YELLOW}$admin_password${RESET}"
        echo -e "${YELLOW}Інструкція для налаштування WireGuard${RESET}"
        echo -e "1. Завантажте клієнт WireGuard за посиланням: ${BLUE}https://www.wireguard.com/install/${RESET}"
        echo -e "2. Після завантаження клієнта, встановіть його на Ваш пристрій."
        echo -e "3. Перейдіть за посиланням: ${YELLOW}http://$selected_ip_address:51821${RESET} та скопіюйте файл конфігурації з серверу на Ваш пристрій."
        echo -e "4. Відкрийте клієнт WireGuard та імпортуйте файл конфігурації."
        echo -e "5. Після імпорту, Ваш VPN-профіль буде доступний для підключення."
        echo -e "\n${YELLOW}Документація за посиланням: https://github.com/wg-easy/wg-easy${RESET}"
        echo -e "Для діагностики використовуйте команди:"
        echo -e "  ${YELLOW}docker logs wg-easy${RESET} - перегляд журналів контейнера"
        echo -e "  ${YELLOW}docker exec -it wg-easy /bin/bash -c 'ls /bin'${RESET} - перегляд списку команд у контейнері"
    else
        echo -e "\n${RED}Сталася помилка під час встановлення WireGuard Easy. Перевірте, будь ласка, налаштування і спробуйте ще раз.${RESET}"
    fi
}

stop_wg_easy() {
    docker stop "$name_docker_container"
    echo "WireGuard Easy зупинено."
}

remove_wg_easy() {
    docker stop "$name_docker_container"
    docker rm "$name_docker_container"
    #docker rmi "$name_docker_container"
    echo "WireGuard Easy видалено."
}

update_wg_easy() {
    docker stop "$name_docker_container"
    docker rm "$name_docker_container"
    docker pull weejewel/wg-easy
    echo "WireGuard Easy оновлено."
}
#_______________________________________________________________________________________________________________________________________
menu_wireguard_scriptLocal() {
    while true; do
        check_info_server
        check_info_control_panel
        echo -e "\nWireGuard installer. Виберіть дію:\n"
        echo "1. Автоматичне встановлення WireGuard"
        echo "2. Меню керування WireGuard та ручне встановлення"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

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
    arch | sysrescue) ;;
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
        check_info_server
        check_info_control_panel
        echo -e "\nOpenVPN installer. Виберіть дію:\n"
        echo "1. Автоматичне встановлення OpenVPN"
        echo "2. Меню керування OpenVPN та ручне встановлення"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

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
    arch | sysrescue) ;;
    *)
        echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac

    create_folder "/root/VPN/openVPN"

    if ! curl -sS -o /root/VPN/openvpn-install.sh https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh; then
        echo "Failed to download and install openvpn-install.sh"
        return 1
    fi
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
    if ! curl -sS -o /root/VPN/openvpn-install.sh https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh; then
        echo "Failed to download and install openvpn-install.sh"
        return 1
    fi
    sed -i 's|"$homeDir|"/root/VPN/openVPN|g' /root/VPN/openvpn-install.sh
    chmod +x /root/VPN/openvpn-install.sh && export AUTO_INSTALL=n
    bash /root/VPN/openvpn-install.sh
}
#_______________________________________________________________________________________________________________________________________
menu_IPsec_L2TP_IKEv2() {
    if ! check_docker_availability; then
        return 1
    fi
    while true; do
        check_info_server
        check_info_control_panel
        echo -e "\nВиберіть дію для налаштування контейнера IPsec/L2TP, Cisco IPsec та IKEv2:\n"
        echo "1. Встановлення ipsec-vpn-server"
        echo "2. Створити нову конфігурацію для клієнта ipsec-vpn-server"
        echo "3. Зупинка ipsec-vpn-server"
        echo "4. Видалення ipsec-vpn-server"
        echo "5. Оновлення ipsec-vpn-server"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

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
        echo "VPN_USER=admin" >>/root/VPN/IPsec_L2TP/vpn.env
        generate_random_password
        echo "VPN_PASSWORD=$rand_password" >>/root/VPN/IPsec_L2TP/vpn.env
        echo -e "${GREEN}Файл /root/VPN/IPsec_L2TP/vpn.env створено та налаштовано успішно.${RESET}\n"
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

        wget -N -P /root/VPN/IPsec_L2TP/ https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/file/VPN/IPsec_and_IKEv2/IPSec_NAT_Config.bat
        wget -N -P /root/VPN/IPsec_L2TP/ https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/file/VPN/IPsec_and_IKEv2/ikev2_config_import.cmd

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

    if docker exec -it ipsec-vpn-server ls "/etc/ipsec.d/$connection_name.p12" &>/dev/null; then
        echo "Помилка: підключення \"$connection_name\" вже існує"
        return 1
    fi
    create_folder "/root/VPN/IPsec_L2TP/$connection_name"
    docker exec -it ipsec-vpn-server /opt/src/ikev2.sh --addclient "$connection_name"
    copy_file_from_container "ipsec-vpn-server" "/etc/ipsec.d/$connection_name.p12" "/root/VPN/IPsec_L2TP/$connection_name/"
    copy_file_from_container "ipsec-vpn-server" "/etc/ipsec.d/$connection_name.sswan" "/root/VPN/IPsec_L2TP/$connection_name/"
    copy_file_from_container "ipsec-vpn-server" "/etc/ipsec.d/$connection_name.mobileconfig" "/root/VPN/IPsec_L2TP/$connection_name/"
    wget -N -P /root/VPN/IPsec_L2TP/${connection_name}/ https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/file/VPN/IPsec_and_IKEv2/IPSec_NAT_Config.bat
    wget -N -P /root/VPN/IPsec_L2TP/${connection_name}/ https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/file/VPN/IPsec_and_IKEv2/ikev2_config_import.cmd

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

menu_PPTP() {
    if ! check_docker_availability; then
        return 1
    fi
    name_docker_container="VPN-PPTP-container"
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        echo "1. Встановлення VPN-PPTP"
        echo "2. Додавання нового користувача"
        echo "3. Зупинка VPN-PPTP"
        echo "4. Видалення VPN-PPTP"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) install_PPTP ;;
        2) add_user_to_pptp ;;
        3) stop_PPTP ;;
        4) remove_PPTP ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

install_PPTP() {
    create_folder "/root/VPN/PPTP"
    generate_random_password
    echo -e "# Secrets for authentication using PAP\n# client    server      secret      acceptable local IP addresses\nuser1 pptpd $rand_password *" >/root/VPN/PPTP/chap-secrets
    get_selected_interface # selected_adapter selected_ip_address selected_ip_mask selected_ip_gateway

    docker run -d --privileged --net=host --name "$name_docker_container" -v /root/VPN/PPTP/chap-secrets:/etc/ppp/chap-secrets mobtitude/vpn-pptp

    apply_iptables_rules "$selected_adapter"

    docker ps -a

    echo -e "\nVPN-PPTP успішно встановлено та запущено!"
    echo -e "\nЗгенеровані дані користувача:"
    echo -e "Користувач: user1"
    echo -e "Пароль: $rand_password"
    echo -e "\nІнструкція з підключення до VPN-PPTP:\n"

    echo -e "На Windows:"
    echo -e "1. Відкрийте 'Панель управління' > 'Мережа та інтернет' > 'Центр управління мережами та спільним доступом'."
    echo -e "2. Натисніть 'Налаштування нового підключення або мережі' > 'Підключення до робочого місця' > 'Використання VPN'."
    echo -e "3. Введіть IP-адресу сервера: $selected_ip_address."
    echo -e "4. Введіть ваше ім'я користувача та пароль."
    echo -e "5. Натисніть 'Підключитися'.\n"

    echo -e "На macOS:"
    echo -e "1. Відкрийте 'Системні налаштування' > 'Мережа'."
    echo -e "2. Натисніть '+' і виберіть 'VPN'."
    echo -e "3. Виберіть 'Тип VPN' як 'PPTP'."
    echo -e "4. Введіть IP-адресу сервера: $selected_ip_address."
    echo -e "5. Введіть ваше ім'я користувача та пароль."
    echo -e "6. Натисніть 'Підключитися'.\n"

    echo -e "На Android:"
    echo -e "1. Відкрийте 'Налаштування' > 'Бездротові мережі та мережі' > 'VPN'."
    echo -e "2. Натисніть 'Додати VPN' і виберіть 'PPTP'."
    echo -e "3. Введіть IP-адресу сервера: $selected_ip_address."
    echo -e "4. Введіть ваше ім'я користувача та пароль."
    echo -e "5. Натисніть 'Зберегти' та 'Підключитися'.\n"

    echo -e "На iOS:"
    echo -e "1. Відкрийте 'Налаштування' > 'Загальні' > 'VPN'."
    echo -e "2. Натисніть 'Додати конфігурацію VPN' і виберіть 'PPTP'."
    echo -e "3. Введіть IP-адресу сервера: $selected_ip_address."
    echo -e "4. Введіть ваше ім'я користувача та пароль."
    echo -e "5. Натисніть 'Готово' та 'Підключитися'."
}

add_user_to_pptp() {
    if ! docker ps -a | grep -q "$name_docker_container"; then
        echo "Контейнер $name_docker_container не встановлений."
        return 1
    fi
    read -p "Введіть ім'я нового користувача: " username

    generate_random_password_show
    read -p "Введіть пароль для нового користувача: " password
    echo

    # Додаємо нового користувача до файлу chap-secrets
    echo "$username pptpd $password *" >>/root/VPN/PPTP/chap-secrets

    # Оновлюємо файл в контейнері
    docker cp /root/VPN/PPTP/chap-secrets "$name_docker_container:/etc/ppp/chap-secrets"

    echo "Новий користувач $username доданий."
}

stop_PPTP() {
    docker stop "$name_docker_container" && echo "${name_docker_container} зупинено."
}

remove_PPTP() {
    docker stop "$name_docker_container" && docker rm "$name_docker_container" && echo "${name_docker_container} видалено."
    docker ps -a
    remove_firewall_rule 1723
}

apply_iptables_rules() {
    local adapter="$1"
    add_firewall_rule 1723 # Функція для додавання правил файерволу з скриптів functions_controller.sh
    if ! iptables -C INPUT -p gre -j ACCEPT 2>/dev/null; then
        iptables -A INPUT -p gre -j ACCEPT
    fi
    if ! iptables -C FORWARD -i ppp+ -o "$adapter" -j ACCEPT 2>/dev/null; then
        iptables -A FORWARD -i ppp+ -o "$adapter" -j ACCEPT
    fi
    if ! iptables -C FORWARD -i "$adapter" -o ppp+ -j ACCEPT 2>/dev/null; then
        iptables -A FORWARD -i "$adapter" -o ppp+ -j ACCEPT
    fi
    if ! iptables -t nat -C POSTROUTING -o "$adapter" -j MASQUERADE 2>/dev/null; then
        iptables -t nat -A POSTROUTING -o "$adapter" -j MASQUERADE
    fi
}
