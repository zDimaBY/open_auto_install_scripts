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
    echo -e "${MSG_QR_CODE}\n"
    echo -e "${MSG_PROXY_DATA}"
    echo -e "${MSG_IMPORT_INSTRUCTIONS}"
    echo -e "${MSG_CONNECTION_IMPORT}"

    print_color_message 135 206 235 "https://itdog.info/klienty-vless-shadowsocks-trojan-xray-sing-box-dlya-windows-android-ios-macos-linux/"
}

#_______________________________________________________________________________________________________________________________________
menu_3x_ui() {
    if ! check_docker_availability; then
        return 1
    fi
    name_docker_container="3x-ui"
    while true; do
        check_info_server
        check_info_control_panel

        echo -e "${YELLOW}${MSG_3X_UI_AVAILABLE_WINDOWS}${RESET}"
        echo -e "${MSG_3X_UI_STEP_1}"
        echo -e "${MSG_3X_UI_STEP_2}"
        echo -e "${MSG_3X_UI_STEP_3}"
        echo -e "${MSG_3X_UI_STEP_4}"
        echo -e "${MSG_3X_UI_STEP_5}"
        echo -e "${MSG_3X_UI_STEP_6}"
        echo -e "${YELLOW}${MSG_3X_UI_NOTE}${RESET}"

        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        echo -e "${MSG_INSTALL_3X_UI}"
        echo -e "${MSG_STOP_3X_UI}"
        echo -e "${MSG_REMOVE_3X_UI}"
        #echo "4. Оновлення 3X-UI"

        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) list_3x_ui_versions_install ;;
        2) stop_docker_container "$name_docker_container" "$MSG_XUI_STOPPED" ;;
        3)
            remove_docker_container "$name_docker_container" "$MSG_XUI_REMOVED"
            remove_firewall_rule 2053
            ;;
        4) update_3x_ui ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}
install_3x_ui() {
    local version="$1"

    generate_random_password_show
    read -p "Вкажіть пароль користувача admin для ${name_docker_container} (за замовчуванням випадковий): " X_UI_PASSWORD

    X_UI_USERNAME="admin"  # Встановіть нове ім'я користувача
    X_UI_PASSWORD=${X_UI_PASSWORD:-$rand_password}  # Встановіть новий пароль
    X_UI_PORT=2053  # Встановіть новий порт
    X_UI_WEB_BASE_PATH="/$(trim_to_10 "$(generate_random_part_16)")"  # Встановіть новий webBasePath

    create_folder "/root/VPN/3x_ui/db/" && create_folder "/root/VPN/3x_ui/cert/"
    docker run -itd \
        -e XRAY_VMESS_AEAD_FORCED=false \
        -v /root/VPN/3x_ui/db/:/etc/x-ui/ \
        -v /root/VPN/3x_ui/cert/:/root/cert/ \
        --network=host \
        --name ${name_docker_container} --restart=unless-stopped \
        ghcr.io/mhsanaei/3x-ui:$version

    update_xui_settings "$X_UI_USERNAME" "$X_UI_PASSWORD" "$X_UI_PORT" "$X_UI_WEB_BASE_PATH" "$name_docker_container"

    # Функція для додавання правил файерволу з скриптів functions_controller.sh
    add_firewall_rule 2053
    docker ps -a
}

list_3x_ui_versions_install() {
    local versions=$("$local_temp_curl" -s https://api.github.com/repos/MHSanaei/3x-ui/tags | "$local_temp_jq" -r '.[].name' | head -n 9)
    echo -e "${MSG_AVAILABLE_3X_UI_VERSIONS}"
    local i=1
    for ver in $versions; do
        echo "$i. $ver"
        ((i++))
    done
    read -p "${MSG_SELECT_VERSION}" choice
    if ((choice >= 1 && choice <= 9)); then
        version=$("$local_temp_curl" -s https://api.github.com/repos/MHSanaei/3x-ui/tags | "$local_temp_jq" -r '.[].name' | head -n 9 | sed -n "${choice}p")
        install_3x_ui "$version"
    else
        echo "${MSG_INVALID_CHOICE}"
        return 1
    fi

    echo -e "${MSG_X_UI_INSTALLED}"
    echo -e "http://${server_IPv4[0]}:2053"
    echo -e "${MSG_ADMIN_USERNAME}"
    echo -e "${MSG_ADMIN_PASSWORD}"

    info_for_client_programs
}

update_3x_ui() {
    echo "${MSG_UPDATE_FUNCTION_NOT_IMPLEMENTED}"
}

#_______________________________________________________________________________________________________________________________________
menu_x_ui() {
    if ! check_docker_availability; then
        return 1
    fi
    name_docker_container="x-ui"
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        echo "${MSG_INSTALL_XUI}"
        echo "${MSG_STOP_XUI}"
        echo "${MSG_REMOVE_XUI}"
        #echo "4. Оновлення X-UI"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) list_x_ui_versions_install ;;
        2) stop_docker_container "$name_docker_container" "$MSG_XUI_STOPPED" ;;
        3)
            remove_docker_container "$name_docker_container" "$MSG_XUI_REMOVED"
            remove_firewall_rule 80
            remove_firewall_rule 443
            remove_firewall_rule 54321
            ;;
        4) update_x_ui ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}
install_x_ui() {
    local version="$1"

    generate_random_password_show
    read -p "Вкажіть пароль користувача admin для ${name_docker_container} (за замовчуванням випадковий): " X_UI_PASSWORD

    X_UI_USERNAME="admin"  # Встановіть нове ім'я користувача
    X_UI_PASSWORD=${X_UI_PASSWORD:-$rand_password}  # Встановіть новий пароль
    X_UI_PORT=54321  # Встановіть новий порт
    X_UI_WEB_BASE_PATH="/$(trim_to_10 "$(generate_random_part_16)")"  # Встановіть новий webBasePath

    create_folder "/root/VPN/x_ui/db/" && create_folder "/root/VPN/x_ui/cert/"
    docker run -itd \
        -e XRAY_VMESS_AEAD_FORCED=false \
        -v /root/VPN/x_ui/db/:/etc/x-ui/ \
        -v /root/VPN/x_ui/cert/:/root/cert/ \
        --network=host \
        --name ${name_docker_container} --restart=unless-stopped \
        alireza7/x-ui:$version

    update_xui_settings "$X_UI_USERNAME" "$X_UI_PASSWORD" "$X_UI_PORT" "$X_UI_WEB_BASE_PATH" "$name_docker_container"

    # Функція для додавання правил файерволу з скриптів functions_controller.sh
    add_firewall_rule 80
    add_firewall_rule 443
    add_firewall_rule 54321
    docker ps -a
}

list_x_ui_versions_install() {
    local versions=$("$local_temp_curl" -s https://api.github.com/repos/alireza0/x-ui/tags | "$local_temp_jq" -r '.[].name' | grep -Eo '[0-9.]+' | sort -Vr | head -n 9)
    echo -e "${YELLOW}${MSG_XUI_AVAILABLE_VERSIONS}${RESET}"
    local i=1
    for ver in $versions; do
        echo "$i. $ver"
        ((i++))
    done
    read -p "${MSG_XUI_SELECT_VERSION}" choice
    if ((choice >= 1 && choice <= 9)); then
        install_x_ui "$("$local_temp_curl" -s https://api.github.com/repos/alireza0/x-ui/tags | "$local_temp_jq" -r '.[].name' | grep -Eo '[0-9.]+' | sort -Vr | head -n 9 | sed -n "${choice}p")"
    else
        echo -e "${RED}${MSG_XUI_INVALID_SELECTION}${RESET}"
        return 1
    fi

    echo -e "${YELLOW}\n\n${MSG_XUI_INSTALLED}${RESET}"
    echo -e "http://${server_IPv4[0]}:${X_UI_PORT}${X_UI_WEB_BASE_PATH}/xui/"
    echo -e "${GREEN}${MSG_XUI_USERNAME}${X_UI_USERNAME}${RESET}"
    echo -e "${GREEN}${MSG_XUI_PASSWORD}${X_UI_PASSWORD}${RESET}\n"

    info_for_client_programs
}

update_x_ui() {
    echo -e "${YELLOW}${MSG_XUI_UPDATE_NOT_IMPLEMENTED}${RESET}"
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
        echo "${MSG_INSTALL_WIREGUARD_EASY}"
        echo "${MSG_STOP_WIREGUARD_EASY}"
        echo "${MSG_REMOVE_WIREGUARD_EASY}"
        echo "${MSG_UPDATE_WIREGUARD_EASY}"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) install_wg_easy ;;
        2) stop_docker_container "$name_docker_container" "$MSG_STOP_WG_EASY" ;;
        3) remove_docker_container "$name_docker_container" "$MSG_REMOVE_WG_EASY" ;;
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
    read -r -p "${MSG_ENTER_ADMIN_PASSWORD} " admin_password

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
        echo -e "${RED}${MSG_INSTALL_FAILURE1}${dependency_name}${MSG_INSTALL_FAILURE1}${RESET}"
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
        echo -e "\n${GREEN}${MSG_INSTALL_WG_EASY_SUCCESS} ${YELLOW}http://$selected_ip_address:51821${RESET}"
        echo -e "${GREEN}${MSG_INSTALL_WG_EASY_PASSWORD}${RESET} ${YELLOW}$admin_password${RESET}"
        echo -e "${YELLOW}${MSG_INSTALL_WG_EASY_INSTRUCTIONS}${RESET}"
        echo -e "${MSG_INSTALL_WG_EASY_STEP_1} ${BLUE}https://www.wireguard.com/install/${RESET}"
        echo -e "${MSG_INSTALL_WG_EASY_STEP_2}"
        echo -e "${MSG_INSTALL_WG_EASY_STEP_3} ${YELLOW}http://$selected_ip_address:51821${RESET}"
        echo -e "${MSG_INSTALL_WG_EASY_STEP_4}"
        echo -e "${MSG_INSTALL_WG_EASY_STEP_5}"
        echo -e "\n${YELLOW}${MSG_INSTALL_WG_EASY_DOC} https://github.com/wg-easy/wg-easy${RESET}"
        echo -e "${MSG_INSTALL_WG_EASY_DIAG}"
        echo -e "  ${YELLOW}${MSG_INSTALL_WG_EASY_LOGS} docker logs wg-easy${RESET}"
        echo -e "  ${YELLOW}${MSG_INSTALL_WG_EASY_COMMANDS} docker exec -it wg-easy /bin/bash -c 'ls /bin'${RESET}"
    else
        echo -e "\n${RED}${MSG_INSTALL_WG_EASY_ERROR}${RESET}"
    fi
}

update_wg_easy() {
    docker stop "$name_docker_container"
    docker rm "$name_docker_container"
    docker pull weejewel/wg-easy
    echo "${MSG_UPDATE_WG_EASY}"
}

#_______________________________________________________________________________________________________________________________________
menu_wireguard_scriptLocal() {
    while true; do
        check_info_server
        check_info_control_panel
        echo -e "${MSG_WIREGUARD_INSTALLER_HEADER}"
        echo "${MSG_WIREGUARD_AUTO_INSTALL}"
        echo "${MSG_WIREGUARD_MANUAL_MENU}"

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

    create_folder "/root/VPN/wireguard"

    sed -i 's/^#\$nrconf{restart} = '\''i'\'';/$nrconf{restart} = '\''a'\'';/g' /etc/needrestart/needrestart.conf

    "$local_temp_curl" -sS -o /root/VPN/wireguard-install.sh https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
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
        echo -e "${GREEN}${MSG_WIREGUARD_INSTALL_SUCCESS}${RESET}"
        echo -e "${YELLOW}${MSG_WIREGUARD_SETUP_INSTRUCTIONS}${RESET}"
        echo -e "${MSG_WIREGUARD_CLIENT_DOWNLOAD}"
        echo -e "${MSG_WIREGUARD_INSTALL_CLIENT}"
        echo -e "${MSG_WIREGUARD_COPY_CONFIG}"
        echo -e "${MSG_WIREGUARD_COPY_FILE}"
        echo -e "${MSG_WIREGUARD_IMPORT_CONFIG}"
        echo -e "${MSG_WIREGUARD_PROFILE_ACCESS}"
        echo -e "${MSG_WIREGUARD_DOCUMENTATION}"
    else
        echo -e "\n${RED}${MSG_WIREGUARD_INSTALL_ERROR}${RESET}"
    fi

}

menu_wireguard_installer() {
    "$local_temp_curl" -sS -o /root/VPN/wireguard-install.sh https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
    chmod +x /root/VPN/wireguard-install.sh
    bash /root/VPN/wireguard-install.sh
}
#_______________________________________________________________________________________________________________________________________
menu_openVPNLocal() {
    while true; do
        check_info_server
        check_info_control_panel
        echo -e "\n${MSG_OPENVPN_INSTALLER_HEADER}\n"
        echo -e "${MSG_OPENVPN_AUTO_INSTALL}"
        echo -e "${MSG_OPENVPN_MANUAL_MENU}"
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

    if ! "$local_temp_curl" -sS -o /root/VPN/openvpn-install.sh https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh; then
        echo -e "${RED}${MSG_DOWNLOAD_INSTALL_SCRIPT_FAILED}${RESET}"
        return 1
    fi
    sed -i 's|"$homeDir|"/root/VPN/openVPN|g' /root/VPN/openvpn-install.sh
    chmod +x /root/VPN/openvpn-install.sh && export AUTO_INSTALL=y
    bash /root/VPN/openvpn-install.sh

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}__________________________________________________________________________${MSG_OPENVPN_INSTALL_SUCCESS}${RESET}"
        echo -e "${MSG_OPENVPN_DOCUMENTATION}"

        # Instructions for Windows
        echo -e "\n${YELLOW}${MSG_OPENVPN_WINDOWS_INSTRUCTIONS_HEADER}${RESET}"
        echo -e "${MSG_OPENVPN_WINDOWS_INSTRUCTIONS}"

        # Instructions for Android
        echo -e "\n${YELLOW}${MSG_OPENVPN_ANDROID_INSTRUCTIONS_HEADER}${RESET}"
        echo -e "${MSG_OPENVPN_ANDROID_INSTRUCTIONS}"

        # Instructions for macOS
        echo -e "\n${YELLOW}${MSG_OPENVPN_MACOS_INSTRUCTIONS_HEADER}${RESET}"
        echo -e "${MSG_OPENVPN_MACOS_INSTRUCTIONS}"

        # Instructions for Linux
        echo -e "\n${YELLOW}${MSG_OPENVPN_LINUX_INSTRUCTIONS_HEADER}${RESET}"
        echo -e "${MSG_OPENVPN_LINUX_INSTRUCTIONS}"

        # Instructions for iOS
        echo -e "\n${YELLOW}${MSG_OPENVPN_IOS_INSTRUCTIONS_HEADER}${RESET}"
        echo -e "${MSG_OPENVPN_IOS_INSTRUCTIONS}"
    else
        echo -e "\n${RED}${MSG_INSTALLATION_ERROR}${RESET}"
    fi
}

menu_openVPN_installer() {
    if ! "$local_temp_curl" -sS -o /root/VPN/openvpn-install.sh https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh; then
        echo -e "${RED}${MSG_DOWNLOAD_INSTALL_SCRIPT_FAILED}${RESET}"
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
    name_docker_container="ipsec-vpn-server"
    while true; do
        check_info_server
        check_info_control_panel
        echo -e "\n${MSG_CHOOSE_ACTION_IPSEC}\n"
        echo "1. ${MSG_INSTALL_IPSEC}"
        echo "2. ${MSG_CREATE_NEW_CONFIG}"
        echo "3. ${MSG_STOP_IPSEC}"
        echo "4. ${MSG_REMOVE_IPSEC}"
        echo "5. ${MSG_UPDATE_IPSEC}"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice
        case $choice in
        1) install_ipsec_vpn_server ;;
        2) add_client_ipsec_vpn_server ;;
        3) stop_docker_container "$name_docker_container" "$MSG_IPSEC_STOPPED" ;;
        4) remove_docker_container "$name_docker_container" "$MSG_IPSEC_REMOVED" ;;
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
        echo -e "${GREEN}${MSG_VPN_ENV_FILE_CREATED}${RESET}\n"
    }

    if [ -f /root/VPN/IPsec_L2TP/vpn.env ]; then
        echo -e "${GREEN}${MSG_EXISTING_VPN_ENV_FILE}${RESET}"
        read -p "(y/n): " create_new_vpn_env
        if [[ "$create_new_vpn_env" =~ ^(y|Y|yes)$ ]]; then
            echo -e "${YELLOW}${MSG_USE_EXISTING_FILE}\n${RESET}"
        else
            echo "${MSG_CREATE_NEW_FILE}"
            generate_vpn_env_file
        fi
    else
        generate_vpn_env_file
    fi

    if ! docker ps -a --format '{{.Names}}' | grep -q "^ipsec-vpn-server$"; then
        docker run \
            --name "$name_docker_container" \
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

        copy_file_from_container "$name_docker_container" "/etc/ipsec.d/vpnclient.p12" "/root/VPN/IPsec_L2TP"
        copy_file_from_container "$name_docker_container" "/etc/ipsec.d/vpnclient.sswan" "/root/VPN/IPsec_L2TP"
        copy_file_from_container "$name_docker_container" "/etc/ipsec.d/vpnclient.mobileconfig" "/root/VPN/IPsec_L2TP"

        if [ $? -eq 0 ]; then
            echo -e "\n${GREEN}${MSG_FILES_COPIED_SUCCESS}${RESET}"
        else
            echo -e "\n${RED}${MSG_COPY_FILES_ERROR}${RESET}"
            echo -e "\n${YELLOW}${MSG_COPY_COMMAND_1}${RESET}"
            echo -e "${YELLOW}${MSG_COPY_COMMAND_2}${RESET}"
            echo -e "${YELLOW}${MSG_COPY_COMMAND_3}${RESET}"
        fi

        echo -e "\n${GREEN}${MSG_CONTAINER_SETUP_SUCCESS}${RESET}\n"

        # IKEv2 Connection on Windows 10/11/8
        echo -e "${YELLOW}${MSG_IKEV2_WINDOWS}${RESET}"

        # Android Connection
        echo -e "\n${YELLOW}${MSG_ANDROID_CONNECTION}${RESET}"

        # For OS X (macOS) / iOS using the .mobileconfig file
        echo -e "\n${YELLOW}${MSG_MAC_IOS_CONNECTION}${RESET}"

    else
        echo -e "\n${YELLOW}${MSG_CONTAINER_INSTALLED}${RESET}\n"
    fi
}

add_client_ipsec_vpn_server() {
    read -p "${MSG_PROMPT_CONNECTION_NAME}" connection_name

    if [ -z "$connection_name" ]; then
        echo "${RED}${MSG_NO_CONNECTION_NAME}${RESET}"
        return 1
    fi

    if docker exec -it "$name_docker_container" ls "/etc/ipsec.d/$connection_name.p12" &>/dev/null; then
        echo "${RED}${MSG_CONNECTION_EXISTS1}${connection_name}${MSG_CONNECTION_EXISTS2}${RESET}"
        return 1
    fi
    create_folder "/root/VPN/IPsec_L2TP/$connection_name"
    docker exec -it "$name_docker_container" /opt/src/ikev2.sh --addclient "$connection_name"
    copy_file_from_container "$name_docker_container" "/etc/ipsec.d/$connection_name.p12" "/root/VPN/IPsec_L2TP/$connection_name/"
    copy_file_from_container "$name_docker_container" "/etc/ipsec.d/$connection_name.sswan" "/root/VPN/IPsec_L2TP/$connection_name/"
    copy_file_from_container "$name_docker_container" "/etc/ipsec.d/$connection_name.mobileconfig" "/root/VPN/IPsec_L2TP/$connection_name/"
    wget -N -P /root/VPN/IPsec_L2TP/${connection_name}/ https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/file/VPN/IPsec_and_IKEv2/IPSec_NAT_Config.bat
    wget -N -P /root/VPN/IPsec_L2TP/${connection_name}/ https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/file/VPN/IPsec_and_IKEv2/ikev2_config_import.cmd

    echo -e "${GREEN}${MSG_CONFIG_FILES_COPIED}${connection_name}${RESET}"
}

update_ipsec_vpn_server() {
    docker stop "$name_docker_container"
    docker rm "$name_docker_container"
    docker pull hwdsl2/ipsec-vpn-server
    echo "${MSG_IPSEC_UPDATED}"
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
        echo -e "\n${MSG_INSTALL_VPN_PPTP}"
        echo "${MSG_ADD_USER}"
        echo "${MSG_STOP_VPN_PPTP}"
        echo "${MSG_REMOVE_VPN_PPTP}"

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
    echo -e "${MSG_SECRETS_HEADER}\n${MSG_SECRETS_FORMAT}\nuser1 pptpd $rand_password *" >/root/VPN/PPTP/chap-secrets
    get_selected_interface # selected_adapter selected_ip_address selected_ip_mask selected_ip_gateway

    docker run -d --privileged --net=host --name "$name_docker_container" -v /root/VPN/PPTP/chap-secrets:/etc/ppp/chap-secrets mobtitude/vpn-pptp

    apply_iptables_rules "$selected_adapter"

    docker ps -a

    echo -e "\n$MSG_VPN_SUCCESS"
    echo -e "\n$MSG_USER_DATA"
    echo -e "$MSG_USERNAME"
    echo -e "${MSG_PASSWORD}${rand_password}"
    echo -e "\n$MSG_INSTRUCTIONS"

    echo -e "$MSG_WINDOWS"
    echo -e "$MSG_WINDOWS_STEP1"
    echo -e "$MSG_WINDOWS_STEP2"
    echo -e "${MSG_WINDOWS_STEP3}${selected_ip_address}"
    echo -e "$MSG_WINDOWS_STEP4"
    echo -e "$MSG_WINDOWS_STEP5"

    echo -e "$MSG_MACOS"
    echo -e "$MSG_MACOS_STEP1"
    echo -e "$MSG_MACOS_STEP2"
    echo -e "$MSG_MACOS_STEP3"
    echo -e "${MSG_MACOS_STEP4}${selected_ip_address}"
    echo -e "$MSG_MACOS_STEP5"
    echo -e "$MSG_MACOS_STEP6"

    echo -e "$MSG_ANDROID"
    echo -e "$MSG_ANDROID_STEP1"
    echo -e "$MSG_ANDROID_STEP2"
    echo -e "${MSG_ANDROID_STEP3}${selected_ip_address}"
    echo -e "$MSG_ANDROID_STEP4"
    echo -e "$MSG_ANDROID_STEP5"

    echo -e "$MSG_IOS"
    echo -e "$MSG_IOS_STEP1"
    echo -e "$MSG_IOS_STEP2"
    echo -e "${MSG_IOS_STEP3}${selected_ip_address}"
    echo -e "$MSG_IOS_STEP4"
    echo -e "$MSG_IOS_STEP5"
}

add_user_to_pptp() {
    if ! docker ps -a | grep -q "$name_docker_container"; then
        echo "${MSG_CONTAINER_NOT_FOUND1}${name_docker_container}${MSG_CONTAINER_NOT_FOUND2}"
        return 1
    fi

    read -p "$MSG_ENTER_USERNAME" username

    generate_random_password_show
    read -p "$MSG_ENTER_PASSWORD" password
    echo

    # Add new user to chap-secrets file
    echo "$username pptpd $password *" >>/root/VPN/PPTP/chap-secrets

    # Update file in the container
    docker cp /root/VPN/PPTP/chap-secrets "$name_docker_container:/etc/ppp/chap-secrets"

    echo "${MSG_USER_ADDED1}${username}${MSG_USER_ADDED2}"
}

stop_PPTP() {
    docker stop "$name_docker_container" && echo "$name_docker_container $MSG_CONTAINER_STOPPED"
}

remove_PPTP() {
    docker stop "$name_docker_container" && docker rm "$name_docker_container" && echo "$name_docker_container $MSG_CONTAINER_REMOVED"
    docker ps -a
    remove_firewall_rule 1723
    echo "$MSG_FIREWALL_RULE_REMOVED"
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
