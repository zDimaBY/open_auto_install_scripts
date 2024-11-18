#!/bin/bash -n
# shellcheck disable=SC2148,SC2154

# Основна функція для управління панеллю
function 2_site_control_panel() {
    panel_name=$(check_info_control_panel_for_functions)

    if [ $? -eq 0 ]; then
        echo "Виявлено панель керування: $panel_name"
    else
        echo -e "${RED}Не вдалося визначити панель керування сайтами, запускаю скрипт для встановлення.${RESET}"
        2_install_control_panel
    fi

    #Перевіряємо яка панель керування встановлена
    if [ -e "/usr/local/vesta" ]; then
        control_panel_install="vesta"
    elif [ -e "/usr/local/hestia" ]; then
        control_panel_install="hestia"
    else
        echo -e "${RED}Не вдалося визначити панель керування сайтами.${RESET}"
        return 1
    fi
    CLI_dir="/usr/local/$control_panel_install/bin"

    # Перевірка типу веб-сервера Apache2 або HTTPD
    if [ -d "/etc/apache2" ]; then
        DIR_APACHE="/etc/apache2"
        install_web_server="apache2"
    elif [ -d "/etc/httpd" ]; then
        DIR_APACHE="/etc/httpd"
        install_web_server="httpd"
    else
        echo -e "${RED}Не вдалося визначити тип веб-сервера Apache2 або HTTPD.${RESET}"
        return 1
    fi

    statistics_scripts "2"
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        print_color_message 255 255 255 "1. Встановлення/апгрейд $(print_color_message 255 215 0 'ioncube') для всіх php версій (Hestiacp + php-fpm) $(print_color_message 255 99 71 '(test)')"
        print_color_message 255 255 255 "2. Встановлення $(print_color_message 255 215 0 'CMS') $(print_color_message 255 99 71 '(test)')"
        print_color_message 255 255 255 "3. Заміна IP-адреси з old на new $(print_color_message 255 99 71 '(test)')"
        print_color_message 255 255 255 "4. Вимкнення/увімкнення префікса $(print_color_message 144 238 144 'admin_') у базах даних панелі керування"
        print_color_message 255 255 255 "5. Очистка $(print_color_message 144 238 144 'логів') $(print_color_message 255 99 71 '(test)')"
        print_color_message 255 255 255 "6. Пренесення $(print_color_message 144 238 144 'сайтів') з віддаленого сервера на $(print_color_message 255 0 255 "${server_IPv4[0]}") $(print_color_message 255 99 71 '(test)')"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) 2_updateIoncube ;;
        2) 2_install_list_CMS ;;
        3) v_sys_change_ip ;;
        4) 2_switch_prefix_for_VestaCP_HestiaCP ;;
        5) 2_logs_clear ;;
        6) 2_migrate_hestia_vesta ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

2_install_control_panel() {
    while true; do
        statistics_scripts "2"
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        echo -e "1. Встановлення ${RED}HestiaCP${RESET} ${RED}(test)${RESET}"
        echo -e "2. Встановлення ${RED}ISPmanager${RESET} ${RED}(test)${RESET}"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) 2_install_hestiaCP ;;
        2) 2_install_ISPmanager_control_panel ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

2_install_hestiaCP() {
    case $operating_system in
    debian | ubuntu) ;;
    *)
        echo -e "${RED}Система $operating_system для встановлення HestiaCP не підтримується.${RESET}"
        return 1
        ;;
    esac

    # URL до репозиторію HestiaCP
    HESITACP_GITHUB="https://api.github.com/repos/hestiacp/hestiacp/tags"
    hst_backups="/root/hst_install_backups/$(date +%d%m%Y%H%M)"

    # Перевірка, чи встановлено curl та jq
    if ! command -v curl &>/dev/null || ! command -v wget &>/dev/null; then
        echo "curl та/або wget не встановлено. Встановіть їх і повторіть спробу."
        exit 1
    fi

    # Завантаження списку доступних версій
    VERSIONS_CP=$("$local_temp_curl_path" -s "$HESITACP_GITHUB" | "$local_temp_jq_path" -r '.[].name' | sort -Vr)

    print_versions_cp() {
        local index=1
        for VERSION_CP in $VERSIONS_CP; do
            echo "$index) Версія: $VERSION_CP"
            ((index++))
            if [ $index -gt 9 ]; then
                break
            fi
        done
    }

    echo "Доступні версії HestiaCP:"
    print_versions_cp

    # Запит вибору користувача
    read -p "Виберіть варіант для завантаження: " VERSION_NUMBER

    # Перевірка введеного номера версії
    if ! [[ "$VERSION_NUMBER" =~ ^[0-9]+$ ]] || ((VERSION_NUMBER < 1 || VERSION_NUMBER > 9)); then
        echo "Невірний номер версії. Будь ласка, введіть номер із доступного діапазону."
        exit 1
    fi

    # Обираємо версію за номером
    SELECTED_VERSION_HESTIA=$(echo "$VERSIONS_CP" | sed -n "${VERSION_NUMBER}p")

    # URL до скрипту встановлення для вибраної версії
    INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/hestiacp/hestiacp/${SELECTED_VERSION_HESTIA}/install/hst-install-ubuntu.sh"

    wget --timeout=4 -qO hst-install-ubuntu.sh "$INSTALL_SCRIPT_URL" || {
        echo "Не вдалося завантажити скрипт для версії $SELECTED_VERSION_HESTIA."
        exit 1
    }

    echo "Скрипт для версії $SELECTED_VERSION_HESTIA завантажено як hst-install-ubuntu.sh"

    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        echo -e "1. Автоматичне встановлення ${RED}HestiaCP $SELECTED_VERSION_HESTIA${RESET} ${RED}(test)${RESET}"
        echo -e "2. Вибіркове встановлення ${RED}HestiaCP $SELECTED_VERSION_HESTIA${RESET} ${RED}(test)${RESET}"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) 2_avto_install_hestiaCP ;;
        2) 2_custom_install_hestiaCP ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

2_install_ISPmanager_control_panel() {
    print_color_message 255 255 0 "\nПочинаємо встановлення ISPmanager...\n"
    
    if ! command -v wget &> /dev/null; then
        print_color_message 255 0 0 "Встановлюємо wget..."
        apt-get update && apt-get install -y wget
    fi

    print_color_message 255 255 255 "Завантаження інсталяційного скрипта ISPmanager..."
    wget https://download.ispsystem.com/install.sh -O /tmp/install_ispmanager.sh
    chmod +x /tmp/install_ispmanager.sh
    /tmp/install_ispmanager.sh

    if [ $? -eq 0 ]; then
        print_color_message 0 255 0 "\nВстановлення ISPmanager успішно завершено."
    else
        print_color_message 255 0 0 "\nВстановлення ISPmanager завершилось з помилкою."
    fi
}

2_check_install_hestiaCP() {
    # Перевірка та встановлення домену
    echo -e "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    if validate_domain "$server_hostname"; then
        print_color_message 0 200 0 "Домен hostname валідний. Буде застосована приставка: $(print_color_message 255 255 0 "hestia.$server_hostname")"
        cp_install_domen="hestia.$server_hostname"
    else
        print_color_message 200 0 0 "Домен hostname не валідний, буде використано: $(print_color_message 255 255 0 "hestia.example.com")"
        cp_install_domen="hestia.example.com"
    fi
    echo -e "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------${RESET}"

    # Перевірка вільної пам'яті
    echo -e "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    total_free_swap_end_ram
    if ((free_swap_end_ram_mb < 2048)); then
        echo -e "Недостатньо вільної пам'яті для $(print_color_message 255 255 0 "clamav"). Вільно: $(print_color_message 255 255 0 "${free_swap_end_ram_gb} ГБ (${free_swap_end_ram_mb} МБ)"), а потрібно 2048мб. В такому разі він не буде встановлений."
        clamav_available="no"
    else
        echo -e "Достатньо вільної пам'яті: $(print_color_message 255 255 0 "${free_swap_end_ram_gb} ГБ (${free_swap_end_ram_mb} МБ)") для $(print_color_message 255 255 0 "clamav"), в такому разі він буде встановлений."
        clamav_available="yes"
    fi

    # Повідомлення про видалення користувача admin
    if [ -n "$(grep ^admin: /etc/passwd)" ]; then
        print_color_message 255 0 0 "Користувача $(print_color_message 255 255 0 "\"admin\"") буде видалено, а всі поточні його файли будуть перенесені у папку $(print_color_message 255 255 0 "$hst_backups")"
    fi
    # Оновлення скрипта встановлення HestiaCP
    echo -e "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    print_color_message 0 255 255 "До виконання hst-install-ubuntu.sh:"
    echo -e "${YELLOW}Видаляю останій рядок що містить "reboot" та "Press any key to continue" з файлу.${RESET}"
    sed -i '/read -n 1 -s -r -p "Press any key to continue"/d' hst-install-ubuntu.sh
    last_line=$(grep -n 'reboot' hst-install-ubuntu.sh | tail -n 1 | cut -d: -f1)
    sed -i "${last_line}d" hst-install-ubuntu.sh

    print_color_message 0 255 255 "Після виконання hst-install-ubuntu.sh:"
    echo -e "${YELLOW}Виконую команду для зміни пакету з system на default, для користувача admin${RESET}"
    echo -e "${YELLOW}Змінюю пароль admin на root, налаштовую права доступу для Roundcube та phpMyAdmin.${RESET}"
    echo -e "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------${RESET}"
}

display_hestia_info() {
    local panel_name=$1
    local server_ip=$2
    local root_password=$3

    echo "-------------------------------------------"
    check_info_control_panel
    echo ""
    print_color_message 255 255 0 "Дані для входу у $panel_name:"
    print_color_message 255 255 255 "Адреса панелі: $(print_color_message 255 0 255 "https://${server_ip}:$WEB_ADMIN_PORT")"
    print_color_message 255 255 255 "Логін: admin"
    print_color_message 255 255 255 "Пароль: $root_password"
    echo ""

    # Інформація про FTP доступ
    echo "-------------------------------------------"
    print_color_message 0 255 255 "FTP доступ користувача root:"
    print_color_message 255 255 255 "Хост: ${server_ip}"
    print_color_message 255 255 255 "Користувач: root"
    print_color_message 255 255 255 "Пароль: $root_password"
    print_color_message 255 255 255 "Порт: 22"
    echo ""

    print_color_message 0 255 255 "FTP доступ користувача admin:"
    print_color_message 255 255 255 "Хост: ${server_ip}"
    print_color_message 255 255 255 "Користувач: admin"
    print_color_message 255 255 255 "Пароль: $root_password"
    print_color_message 255 255 255 "Порт: 21"
    echo ""

    echo "-------------------------------------------"
    print_color_message 255 0 0 "Рекомендується змінити пароль після першого входу для безпеки."
}

2_end_avto_install_hestiaCP() {
    echo "admin:$(sudo grep '^root:' /etc/shadow | cut -d: -f2)" | sudo chpasswd -e
    /usr/local/hestia/bin/v-change-user-package admin default
    if [[ $SELECTED_VERSION_HESTIA == "1.8.11" ]]; then
        find /etc/roundcube/ -type f -iname "*php" -exec chmod 640 {} \;
        chown -R hestiamail:www-data /etc/roundcube/
        chown -R root:www-data /etc/phpmyadmin/
        chown -R www-data:www-data /usr/share/phpmyadmin/tmp/
    elif [[ $SELECTED_VERSION_HESTIA == "1.8.12" ]]; then
        chown -R root:www-data /etc/phpmyadmin/
        chown -R www-data:www-data /usr/share/phpmyadmin/tmp/
        display_hestia_info "HestiaCP" "${server_IPv4[0]}" "<пароль від root>"
    else
        echo "Version not supported"
    fi
    reboot
}

2_avto_install_hestiaCP() {
    2_check_install_hestiaCP

    # Меню вибору обробників
    while true; do
        print_color_message 255 255 0 "\nОберіть таблетку:\n"
        print_color_message 30 30 255 "1. PHP-FPM and nginx + apache"
        print_color_message 255 30 30 "2. PHP-FPM and nginx"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1)
            deleting_old_admin_user
            bash hst-install-ubuntu.sh --hostname "$cp_install_domen" --email "admin@$cp_install_domen" --apache "yes" --clamav "$clamav_available"
            2_end_avto_install_hestiaCP
            ;;
        2)
            deleting_old_admin_user
            bash hst-install-ubuntu.sh --hostname "$cp_install_domen" --email "admin@$cp_install_domen" --apache "no" --clamav "$clamav_available"
            2_end_avto_install_hestiaCP
            ;;
        0) break ;;
        00) exit 0 ;;
        *) echo "Невірний вибір. Спробуйте ще раз." ;;
        esac
    done
}

2_custom_install_hestiaCP() {
    # Перевірка, чи встановлено curl, wget
    if ! command -v curl &>/dev/null || ! command -v wget &>/dev/null; then
        echo "curl та/або wget не встановлено. Встановіть їх і повторіть спробу."
        return 1
    fi

    # URL до репозиторію MariaDB та API з датами закінчення підтримки
    REPO_URL="https://mirror.mariadb.org/repo/"
    EOL_URL="https://endoflife.date/api/mariadb.json"

    # Завантаження сторінки та пошук доступних версій
    VERSIONS_DB=$("$local_temp_curl_path" -s "$REPO_URL" | grep -oP 'href="\K[0-9]+\.[0-9]+' | sort -uVr)
    EOL_DATA=$("$local_temp_curl_path" -s "$EOL_URL")

    # Функція для виводу версій та дат закінчення підтримки
    print_versions() {
        local index=1
        for VERSION_DB in $VERSIONS_DB; do
            EOL_DATE=$(echo "$EOL_DATA" | "$local_temp_jq_path" -r --arg VERSION_DB "$VERSION_DB" '.[] | select(.cycle == $VERSION_DB) | .eol')
            echo "$index) Версія: $(print_color_message 255 255 0 "${VERSION_DB}") - Закінчення підтримки: $(print_color_message 200 0 0 "${EOL_DATE:-не визначено}")"
            ((index++))
        done
    }

    # Виведення доступних версій MariaDB
    echo "Доступні версії MariaDB:"
    print_versions

    read -p "Введіть номер версії для перевірки закінчення підтримки: " VERSION_NUMBER

    # Перевірка введеного номера версії
    if ! [[ "$VERSION_NUMBER" =~ ^[0-9]+$ ]] || ((VERSION_NUMBER < 1 || VERSION_NUMBER > $(echo "$VERSIONS_DB" | wc -l))); then
        echo "Невірний номер версії. Будь ласка, введіть номер із доступного діапазону."
        return 1
    fi

    # Обираємо версію за номером
    SELECTED_VERSION_DB=$(echo "$VERSIONS_DB" | sed -n "${VERSION_NUMBER}p")
    EOL_DATE=$(echo "$EOL_DATA" | "$local_temp_jq_path" -r --arg SELECTED_VERSION_DB "$SELECTED_VERSION_DB" '.[] | select(.cycle == $SELECTED_VERSION_DB) | .eol')

    echo "Версія: $(print_color_message 255 255 0 "${SELECTED_VERSION_DB}") - Закінчення підтримки: $(print_color_message 200 0 0 "${EOL_DATE:-не визначено}")"
    sed -i "s/mariadb_v=\".*\"/mariadb_v=\"$SELECTED_VERSION_DB\"/" hst-install-ubuntu.sh
    sed -i '/read -n 1 -s -r -p "Press any key to continue"/a \
/usr/local/hestia/bin/v-change-user-package admin default' hst-install-ubuntu.sh

    if [[ $SELECTED_VERSION_HESTIA == "1.8.11" ]]; then
        sed -i '/read -n 1 -s -r -p "Press any key to continue"/a \
chown -R root:www-data /etc/phpmyadmin/ \
chown -R hestiamail:www-data /usr/share/phpmyadmin/tmp/' hst-install-ubuntu.sh
    fi

    2_check_install_hestiaCP
    while true; do
        print_color_message 255 255 0 "\nОберіть таблетку:\n"
        print_color_message 30 30 255 "1. PHP-FPM and nginx + apache"
        print_color_message 255 30 30 "2. PHP-FPM and nginx"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1)
            deleting_old_admin_user
            bash hst-install-ubuntu.sh --hostname "$cp_install_domen" --email "admin@$cp_install_domen" --apache "yes" --clamav "$clamav_available"
            ;;
        2)
            deleting_old_admin_user
            bash hst-install-ubuntu.sh --hostname "$cp_install_domen" --email "admin@$cp_install_domen" --apache "no" --clamav "$clamav_available"
            ;;
        0) break ;;
        00) exit 0 ;;
        *) echo "Невірний вибір. Спробуйте ще раз." ;;
        esac
    done
}

deleting_old_admin_user() {
    if [ -n "$(grep ^admin: /etc/passwd)" ]; then
        chattr -i /home/admin/conf >/dev/null 2>&1
        userdel -f admin >/dev/null 2>&1
        mv -f /home/admin $hst_backups/home/ >/dev/null 2>&1
        rm -f /tmp/sess_* >/dev/null 2>&1
    fi
    if [ -n "$(grep ^admin: /etc/group)" ]; then
        groupdel admin >/dev/null 2>&1
    fi
}

2_updateIoncube() {
    # Instals Ioncube on all  existing and supported php versions
    if [ -f "/etc/hestiacp/hestia.conf" ]; then
        source /etc/hestiacp/hestia.conf
    else
        echo "Помилка: Файл /etc/hestiacp/hestia.conf не знайдено"
    fi

    # Look up what version is used x86_64 needs to become x86-64 instead
    # Only tested for aarch and x86_64
    arc=$(arch)
    if [ "$arc" = "x86_64" ]; then
        arc="x86-64"
    fi

    # Download url
    url="https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_$arc.tar.gz"
    wget "$url" -O - | tar -xz

    for php_version in $("$HESTIA"/bin/v-list-sys-php plain); do
        # Check if ioncube version is supported for example 8.0 is not availble!
        if [ ! -f "./ioncube/ioncube_loader_lin_$php_version.so" ]; then
            echo "PHP$php_version наразі не підтримується Ioncube"
            continue
        fi
        # Get extension dir and don't depend on user input
        extension_dir=$(/usr/bin/php"$php_version" -i | grep extension_dir | cut -d' ' -f5)

        # Copy ioncube file to extension dir
        cp ./ioncube/ioncube_loader_lin_"$php_version"* "$extension_dir"
        echo "Ioncube встановлена для PHP$php_version"
        # Add to conf.d folder for php-fpm and cli
        echo "zend_extension=ioncube_loader_lin_$php_version.so" >/etc/php/"$php_version"/fpm/conf.d/00-ioncube-loader.ini
        echo "zend_extension=ioncube_loader_lin_$php_version.so" >/etc/php/"$php_version"/cli/conf.d/00-ioncube-loader.ini
    done

    "$HESTIA"/bin/v-restart-service 'php-fpm' yes
    #clean up the trash
    rm -fr ioncube
}

#--------------------------------------------------------------------------------------------------------------------------------
2_install_list_CMS() {
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        echo -e "1. WordPress ${RED}(test)${RESET}"
        echo -e "2. DLE ${RED}(test)${RESET}"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) 2_install_CMS_wordpress ;;
        2) 2_install_CMS_DLE ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

2_switch_prefix_for_VestaCP_HestiaCP() {
    # Створити копію v-add-database якщо не існує
    if [ ! -f "/usr/local/$control_panel_install/bin/v-add-database-prefix-on" ]; then
        echo -e "${RED}Вимкнення ${YELLOW}префікса баз даних для панелі керування $control_panel_install.${RESET}"
        cp "/usr/local/$control_panel_install/bin/v-add-database" "/usr/local/$control_panel_install/bin/v-add-database-prefix-on"
        sed -i 's/database="$user"_"$2"/database=$2/' "/usr/local/$control_panel_install/bin/v-add-database"
        sed -i 's/dbuser="$user"_"$3"/dbuser=$3/' "/usr/local/$control_panel_install/bin/v-add-database"
    else # Видалити копію v-add-database, якщо існує
        echo -e "${GREEN}Вмикаємо ${YELLOW}префікс баз даних для панелі керування $control_panel_install.${RESET}"
        rm "/usr/local/$control_panel_install/bin/v-add-database-prefix-on"
        sed -i 's/database=$2/database="$user"_"$2"/' "/usr/local/$control_panel_install/bin/v-add-database"
        sed -i 's/dbuser=$3/dbuser="$user"_"$3"/' "/usr/local/$control_panel_install/bin/v-add-database"
    fi
}

2_logs_clear() {
    if [ -d "/etc/apache2" ]; then
        DIR_APACHE="/etc/apache2"
        COMMAND_WEB_SERVER="apache2"
    elif [ -d "/etc/httpd" ]; then
        DIR_APACHE="/etc/httpd"
        COMMAND_WEB_SERVER="httpd"
    else
        print_color_message 255 0 0 "Каталог Apache не знайдено."
        return 1
    fi

    delete_files=$(ls -1 /var/log/$COMMAND_WEB_SERVER/domains/*.log-* 2>/dev/null)
    delete_files2=$(ls -1 /var/log/$COMMAND_WEB_SERVER/domains/*.log.* 2>/dev/null)
    truncate_files=$(ls -1 /var/log/$COMMAND_WEB_SERVER/domains/*.log 2>/dev/null)

    print_color_message 255 0 0 "Файли, які будуть видалені:"
    if [ -n "$delete_files" ]; then
        echo "$delete_files"
    else
        print_color_message 255 165 0 "Не знайдено файлів, які відповідають: rm -rf /var/log/$COMMAND_WEB_SERVER/domains/*.log-*"
    fi
    if [ -n "$delete_files2" ]; then
        echo "$delete_files2"
    else
        print_color_message 255 165 0 "Не знайдено файлів, які відповідають: rm -rf /var/log/$COMMAND_WEB_SERVER/domains/*.log.*"
    fi

    print_color_message 0 255 0 "Файли, які будуть очищені: truncate -s 0 /var/log/$COMMAND_WEB_SERVER/domains/*.log"
    if [ -n "$truncate_files" ]; then
        du -sh $truncate_files
    else
        print_color_message 255 165 0 "Не знайдено файлів, які відповідають *.log."
    fi

    before=$(du -ahx /var/log/$COMMAND_WEB_SERVER/domains/ | grep "\.log" | sort -rh | head -n 1 | awk '{print $1}')
    print_color_message 0 255 0 "Поточно використане місце: $(print_color_message 255 165 0 "$before")"

    read -p "Ви впевнені, що бажаєте видалити або очистити ці файли журналів? [y/N]: " confirm
    if [[ "$confirm" =~ ^[YyYyes]+$ ]]; then
        print_color_message 0 255 0 "Операція виконана."
    else
        print_color_message 255 0 0 "Операція скасована."
        return 1
    fi

    # Виконання видалення та очищення
    if [ -n "$delete_files" ]; then
        rm -rf /var/log/$COMMAND_WEB_SERVER/domains/*.log-*
    fi
    if [ -n "$delete_files2" ]; then
        rm -rf /var/log/$COMMAND_WEB_SERVER/domains/*.log.*
    fi
    if [ -n "$truncate_files" ]; then
        truncate -s 0 /var/log/$COMMAND_WEB_SERVER/domains/*.log
    fi
}

2_install_CMS_wordpress() {
    #Перевіряємо сумісніть системи
    case $operating_system in
    debian | ubuntu) ;;
    centos | oracle) ;;
    *)
        echo -e "${RED}Система $operating_system не підтримується.${RESET}"
        return 1
        ;;
    esac

    #Перевіряємо яка панель керування встановлена
    if [ -e "/usr/local/vesta" ]; then
        echo -e "${YELLOW}Використовується VestaCP.${RESET}"
        control_panel_install="vesta"
        source /etc/profile
        source $VESTA/func/main.sh
        source $VESTA/conf/vesta.conf
    elif [ -e "/usr/local/hestia" ]; then
        echo -e "${YELLOW}Використовується HestiaCP.${RESET}"
        control_panel_install="hestia"
        source /etc/profile
        source $HESTIA/func/main.sh
        source $HESTIA/conf/hestia.conf
    else
        echo -e "${RED}Не вдалося визначити панель керування сайтами.${RESET}"
        return 1
    fi

    # Шлях до директорії з користувачами
    USERS_dir="/usr/local/$control_panel_install/data/users/"

    # Виведення списку папок
    echo "Доступні користувачі панелі керування сайтами:"
    folders=($(find "$USERS_dir" -maxdepth 1 -mindepth 1 -type d -printf "%f\n"))

    # Перелік індексів папок
    for ((i = 0; i < ${#folders[@]}; i++)); do
        echo "$(($i + 1)). ${folders[$i]}"
    done

    read -p "Виберіть користувача: " choice

    # Перевірка правильності вводу
    if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
        echo "Будь ласка, виберіть користувача."
        return 1
    fi

    # Перевірка чи номер вибраної папки в діапазоні
    if ((choice < 1 || choice > ${#folders[@]})); then
        echo "Недійсний номер."
        return 1
    fi

    # Збереження імені вибраної папки в змінну
    CONTROLPANEL_USER="${folders[$((choice - 1))]}"
    USER_dir="/home/$CONTROLPANEL_USER"

    read -p "Вкажіть домен для wordpress: " WP_SITE_DOMEN

    if [ -z "$WP_SITE_DOMEN" ]; then
        echo "Домен не було вказано."
        return 1
    fi

    if validate_domain "$WP_SITE_DOMEN"; then
        print_color_message 0 200 0 "Домен $WP_SITE_DOMEN валідний."
    else
        print_color_message 200 0 0 "Домен $WP_SITE_DOMEN не валідний."
    fi

    if [ -d "$USER_dir/web/$WP_SITE_DOMEN" ]; then
        echo "Домен $WP_SITE_DOMEN уже є за шляхом $USER_dir/web/$WP_SITE_DOMEN."
        return 1
    fi

    # Збереження імені вибраного домена за шляхом
    WEB_DIR="$USER_dir/web/$WP_SITE_DOMEN"
    WEB_PUBLIC_DIR="$WEB_DIR/public_html"

    $CLI_dir/v-add-web-domain $CONTROLPANEL_USER $WP_SITE_DOMEN "" "yes" "none"

    # Функція для перевірки направлений домен на сервер check_domain "example.com"
    check_domain $WP_SITE_DOMEN

    if [ $? -eq 0 ]; then
        $CLI_dir/v-add-letsencrypt-domain $CONTROLPANEL_USER $WP_SITE_DOMEN '' yes
        $CLI_dir/v-schedule-letsencrypt-domain $CONTROLPANEL_USER $WP_SITE_DOMEN
    else
        SSL_DIR="$WEB_DIR/ssl"

        create_folder "$SSL_DIR"

        # Створення самопідписаного сертифіката
        openssl req -new -newkey rsa:4096 -sha256 -days 825 -nodes -x509 \
            -subj "/C=NL/ST=North Holland/L=Amsterdam/O=SecureNet Inc./CN=$WP_SITE_DOMEN" \
            -keyout $SSL_DIR/$WP_SITE_DOMEN.key -out $SSL_DIR/$WP_SITE_DOMEN.crt

        chown -R "$CONTROLPANEL_USER:$CONTROLPANEL_USER" "$SSL_DIR"
        # Додавання сертифіката до HestiaCP
        $CLI_dir/v-add-web-domain-ssl $CONTROLPANEL_USER $WP_SITE_DOMEN $SSL_DIR

        # Перезапуск веб-сервера
        #$CLI_dir/v-restart-web

        echo "Самопідписаний SSL сертифікат для $WP_SITE_DOMEN створено та додано до $control_panel_install."
    fi

    SITE_PASSWORD=$(generate_random_part_16)
    SITE_ADMIN_MAIL="admin@$WP_SITE_DOMEN"

    WORDPRESS_URL="https://wordpress.org/latest.tar.gz"
    WP_USER="$CONTROLPANEL_USER"
    DB_NAME="w$(generate_random_part_16)"
    DB_NAME=$(trim_to_10 "$DB_NAME")
    DB_USER="w$(generate_random_part_16)"
    DB_USER=$(trim_to_10 "$DB_USER")
    DB_PASSWORD="wp_p_$(generate_random_part_16)"
    DB_PASSWORD=$(trim_to_16 "$DB_PASSWORD")

    if [ ! -d "$WEB_PUBLIC_DIR" ]; then
        echo "Папка $WEB_PUBLIC_DIR не існує. Вихід..."
        return 1
    fi

    cd $WEB_PUBLIC_DIR

    # Перевірка, що директорія порожня або містить лише приховані файли
    if [ "$(ls -A $WEB_PUBLIC_DIR | grep -v '^\.\|^\.\.$' | wc -l)" -ne 0 ]; then
        # Якщо директорія не порожня, виводимо всі файли
        echo -e "${YELLOW}У директорії $WEB_PUBLIC_DIR знайдено наступні файли:${RESET}"
        ls -A $WEB_PUBLIC_DIR

        # Запит на видалення всіх файлів
        read -p "Ви хочете видалити всі файли в цій директорії? (y/n): " confirm
        if [[ "$confirm" =~ ^[YyYyes]+$ ]]; then
            echo -e "${GREEN}Видаляю файли...${RESET}"
            rm -rf $WEB_PUBLIC_DIR/*
            echo -e "${RED}Файли видалено.${RESET}"
        else
            echo -e "${RED}Операція скасована. Скрипт не буде виконаний.${RESET}"
            return
        fi
    fi

    # Завантаження та розпаковка WordPress
    if wget $WORDPRESS_URL -O - | tar -xzf - --strip-components=1; then
        echo -e "${GREEN}WordPress успішно завантажено та розпаковано!${RESET}"
    else
        echo -e "${RED}Помилка: Не вдалося завантажити або розпакувати WordPress.${RESET}"
        return 1
    fi

    if chown -R $CONTROLPANEL_USER:$CONTROLPANEL_USER $WEB_PUBLIC_DIR; then
        echo -e "${GREEN}Права доступу $CONTROLPANEL_USER:$CONTROLPANEL_USER успішно встановлені!${RESET}"
    else
        echo -e "${RED}Помилка: Не вдалося встановити права доступу $CONTROLPANEL_USER:$CONTROLPANEL_USER.${RESET}"
    fi

    # Перевірка існування файлу .htaccess
    if [ -f "$WEB_PUBLIC_DIR/.htaccess" ]; then
        echo -e "${YELLOW}Файл .htaccess вже існує. Пропускаємо створення.${RESET}"
    else
        echo -e "${GREEN}Створюємо файл .htaccess...${RESET}"
        cat <<EOL >$WEB_PUBLIC_DIR/.htaccess
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteCond %{HTTP:X-Forwarded-Proto} !https
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress

# File protection .htaccess та .htpasswd
<FilesMatch "^\.ht">
    Require all denied
</FilesMatch>

# Disabling the display of the directory list
Options -Indexes

# Protection wp-config.php
<Files wp-config.php>
    Require all denied
</Files>
EOL

        # Надаємо права $CONTROLPANEL_USER:$CONTROLPANEL_USER на .htaccess
        if chown $CONTROLPANEL_USER:$CONTROLPANEL_USER $WEB_PUBLIC_DIR/.htaccess; then
            echo -e "${GREEN}Права доступу $CONTROLPANEL_USER:$CONTROLPANEL_USER успішно встановлені для .htaccess!${RESET}"
        else
            echo -e "${RED}Помилка: Не вдалося встановити права доступу для .htaccess.${RESET}"
        fi

        # Надаємо права 644 для .htaccess
        chmod 644 $WEB_PUBLIC_DIR/.htaccess
        echo -e "${GREEN}Файл .htaccess успішно створено та налаштовано!${RESET}"
    fi

    # Налаштовуємо файл wp-config.php
    echo -e "${YELLOW}Налаштовуємо файл wp-config.php...${RESET}"
    sudo -u "$CONTROLPANEL_USER" cp wp-config-sample.php wp-config.php
    if [ -f "/usr/local/$control_panel_install/bin/v-add-database-prefix-on" ]; then
        sudo -u "$CONTROLPANEL_USER" sed -i "s|database_name_here|${DB_NAME}|" wp-config.php
        sudo -u "$CONTROLPANEL_USER" sed -i "s|username_here|${DB_USER}|" wp-config.php
        sudo -u "$CONTROLPANEL_USER" sed -i "s|password_here|$DB_PASSWORD|" wp-config.php
    else
        echo -e "${GREEN}Вмикаємо ${YELLOW}префікс баз даних для панелі керування $control_panel_install.${RESET}"
        sudo -u "$CONTROLPANEL_USER" sed -i "s|database_name_here|${CONTROLPANEL_USER}_${DB_NAME}|" wp-config.php
        sudo -u "$CONTROLPANEL_USER" sed -i "s|username_here|${CONTROLPANEL_USER}_${DB_USER}|" wp-config.php
        sudo -u "$CONTROLPANEL_USER" sed -i "s|password_here|$DB_PASSWORD|" wp-config.php
    fi
    sudo -u "$CONTROLPANEL_USER" sed -i -e "/put your unique phrase here/{
    s|put your unique phrase here|$(openssl rand -base64 64 | tr -d '\n' | tr -d '\r')|;
    n;
    s|put your unique phrase here|$(openssl rand -base64 64 | tr -d '\n' | tr -d '\r')|;
    n;
    s|put your unique phrase here|$(openssl rand -base64 64 | tr -d '\n' | tr -d '\r')|;
    n;
    s|put your unique phrase here|$(openssl rand -base64 64 | tr -d '\n' | tr -d '\r')|;
    n;
    s|put your unique phrase here|$(openssl rand -base64 64 | tr -d '\n' | tr -d '\r')|;
    n;
    s|put your unique phrase here|$(openssl rand -base64 64 | tr -d '\n' | tr -d '\r')|;
    n;
    s|put your unique phrase here|$(openssl rand -base64 64 | tr -d '\n' | tr -d '\r')|;
    n;
    s|put your unique phrase here|$(openssl rand -base64 64 | tr -d '\n' | tr -d '\r')|;
}" wp-config.php

    # Створюємо базу даних та користувача, якщо база даних не існує
    echo -e "${YELLOW}Створюємо базу даних та користувача...${RESET}"
    
    $CLI_dir/v-add-database $CONTROLPANEL_USER $DB_NAME $DB_USER $DB_PASSWORD

    # Завантажуємо WP-CLI
    local_temp_wp_cli_path=$(download_latest_tool "wp-cli/wp-cli" "wp-cli" "wp-cli.phar")
    
    # Встановлюємо WordPress
    sudo -u "$CONTROLPANEL_USER" "$local_temp_wp_cli_path" core install --url=http://${WP_SITE_DOMEN} --title=${WP_SITE_DOMEN} --admin_user=${WP_USER} --admin_password=${SITE_PASSWORD} --admin_email=${SITE_ADMIN_MAIL}

    # Встановлюємо мови в залежності від налаштувань
    case "$LANG_open_auto_install_scripts" in
    "en")
        sudo -u "$CONTROLPANEL_USER" "$local_temp_wp_cli_path" language core install --activate en_US
        ;;
    "ru")
        sudo -u "$CONTROLPANEL_USER" "$local_temp_wp_cli_path" language core install --activate ru_RU
        ;;
    "ua")
        sudo -u "$CONTROLPANEL_USER" "$local_temp_wp_cli_path" language core install --activate uk
        ;;
    *)
        print_color_message 255 0 0 "Unsupported language."
        ;;
    esac

    #"$local_temp_wp_cli_path" theme activate ваша_тема
    #"$local_temp_wp_cli_path" plugin install назва_плагіна
    #"$local_temp_wp_cli_path" plugin activate назва_плагіна

    display_wordpress_info "$WP_SITE_DOMEN" "$WP_USER" "$SITE_PASSWORD" "${server_IPv4[0]}"

    source /etc/os-release
}

display_wordpress_info() {
    local wp_site_domen=$1
    local wp_site_user=$2
    local wp_site_password=$3
    local server_ip=$4

    echo "-------------------------------------------"
    print_color_message 255 255 0 "Дані для входу у Wordpress:"
    print_color_message 255 255 255 "Адреса панелі: $(print_color_message 255 0 255 "http://${wp_site_domen}/wp-login.php")"
    print_color_message 255 255 255 "Логін: ${wp_site_user}"
    print_color_message 255 255 255 "Пароль: ${wp_site_password}"
    echo ""

    # Інформація про FTP доступ
    echo "-------------------------------------------"
    print_color_message 0 255 255 "Загальний FTP доступ користувача $CONTROLPANEL_USER:"
    print_color_message 255 255 255 "Хост: $server_ip"
    print_color_message 255 255 255 "Користувач: $CONTROLPANEL_USER"
    print_color_message 255 255 255 "Пароль: < пароль $CONTROLPANEL_USER >"
    print_color_message 255 255 255 "Порт: 21"
    echo ""

    echo "-------------------------------------------"
    print_color_message 255 0 0 "Рекомендується змінити пароль після першого входу для безпеки."
}

2_install_CMS_DLE() {
    echo -e "В розробці: ..."
}

#--------------------------------------------------------------------------------------------------------
# Функція для перевірки наявності інструментів
check_tools() {
    for tool in sshpass rsync openssl; do
        if ! command -v $tool &>/dev/null; then
            echo "Інструмент $tool не встановлений."
            read -p "Бажаєте встановити $tool? [Y/N]: " confirm
            if [[ "$confirm" =~ ^[YyYyes]+$ ]]; then
                echo "Встановлюємо $tool..."
                sudo apt update && sudo apt install -y $tool
                if [ $? -ne 0 ]; then
                    echo "Помилка: Не вдалося встановити $tool. Завершуємо скрипт."
                    exit 1
                else
                    echo "$tool успішно встановлено."
                fi
            else
                echo "Без $tool робота скрипта неможлива. Завершуємо скрипт."
                exit 1
            fi
        else
            echo "$tool вже встановлений."
        fi
    done
}

# Функція для підключення до віддаленого сервера
remote_ssh_command() {
    sshpass -p "$PASSWORD_ROOT_USER" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $REMOTE_ROOT_USER@$REMOTE_SERVER "$1"
}

# Функція перевірки користувача
check_or_create_user() {
    local user="$1"

    # Перевірка чи існує користувач у системі HestiaCP
    if $CLI_dir/v-list-users | grep -qw "^$user"; then
        print_color_message 0 255 0 "Користувач $user вже існує."
    else
        print_color_message 255 255 0 "Користувач $user не знайдений. Створюємо користувача..."
        
        # Додаємо користувача за допомогою HestiaCP CLI v-add-user
        if ! $CLI_dir/v-add-user $user "$(generate_random_part_16)" "$user@example.com" "default" "en"; then
            print_color_message 255 0 0 "Помилка створення користувача $user."
            return 1
        fi
        
        print_color_message 0 255 0 "Користувача $user успішно створено."
    fi
}


# Функція додавання домену
add_web_domain() {
    local domain="$1"
    
    # Перевірка наявності домену та змінної REMOTE_CONTROL_PANEL_USER
    if [[ -z "$domain" || -z "$REMOTE_CONTROL_PANEL_USER" ]]; then
        print_color_message 255 0 0 "Помилка: Домен або користувач не вказані."
        return 1
    fi

    # Перевірка наявності CLI інструменту
    if ! command -v $CLI_dir/v-list-web-domains &>/dev/null; then
        print_color_message 255 0 0 "Помилка: CLI інструмент HestiaCP не знайдено."
        return 1
    fi

    # Перевірка наявності домену
    if $CLI_dir/v-list-web-domains $REMOTE_CONTROL_PANEL_USER | grep -E "^\s*$domain\s" &>/dev/null; then
        print_color_message 255 0 0 "Домен $(print_color_message 0 255 255 "$domain") вже існує, пропускаємо..."
        return 1
    fi


    # Додаємо веб-домен
    print_color_message 255 255 0 "Обробка домену: $(print_color_message 0 255 255 "$domain")"
    $CLI_dir/v-add-web-domain $REMOTE_CONTROL_PANEL_USER $domain
    if [ $? -ne 0 ]; then
        print_color_message 255 0 0 "Помилка додавання домену $(print_color_message 0 255 255 "$domain")."
        return 1
    fi
    print_color_message 0 255 0 "Домен $(print_color_message 0 255 255 "$domain") успішно додано."
    return 0
}

# Функція встановлення SSL сертифікату
install_ssl() {
    local domain="$1"
    local ssl_dir="/home/$REMOTE_CONTROL_PANEL_USER/web/$domain/ssl"

    # Перевірка наявності домену та змінної REMOTE_CONTROL_PANEL_USER
    if [[ -z "$domain" || -z "$REMOTE_CONTROL_PANEL_USER" ]]; then
        print_color_message 255 0 0 "Помилка: Домен або користувач не вказані."
        return 1
    fi

    # Створення директорії SSL
    create_folder "$ssl_dir"

    # Генерація SSL сертифікату
    if ! openssl req -new -newkey rsa:4096 -sha256 -days 825 -nodes -x509 \
            -subj "/C=NL/ST=North Holland/L=Amsterdam/O=SecureNet Inc./CN=$domain" \
            -keyout "$ssl_dir/$domain.key" -out "$ssl_dir/$domain.crt" &>/dev/null; then
        print_color_message 255 0 0 "Помилка генерації SSL сертифікату для $(print_color_message 0 255 255 "$domain")."
        return 1
    fi


    # Зміна прав доступу
    chown -R "$REMOTE_CONTROL_PANEL_USER:$REMOTE_CONTROL_PANEL_USER" "$ssl_dir"
    
    # Додавання SSL до домену
    if ! $CLI_dir/v-add-web-domain-ssl $REMOTE_CONTROL_PANEL_USER $domain $ssl_dir; then
        print_color_message 255 0 0 "Помилка додавання SSL до домену $(print_color_message 0 255 255 "$domain")."
        return 1
    fi
    print_color_message 0 255 0 "SSL сертифікат успішно встановлено для $(print_color_message 0 255 255 "$domain")."
    return 0
}

# Функція переносу файлів сайту
sync_files() {
    local domain="$1"

    # Перевірка наявності домену та змінних
    if [[ -z "$domain" || -z "$REMOTE_CONTROL_PANEL_USER" || -z "$REMOTE_ROOT_USER" || -z "$REMOTE_SERVER" || -z "$PASSWORD_ROOT_USER" ]]; then
        print_color_message 255 0 0 "Помилка: Відсутні необхідні змінні для переносу файлів."
        return 1
    fi

    print_color_message 255 0 0 "Перенесення файлів сайту $(print_color_message 0 255 255 "$domain") за допомогою rsync..."
    # Перенос файлів сайту за допомогою rsync
    if ! sshpass -p "$PASSWORD_ROOT_USER" rsync -azh --info=progress2 --stats -e "ssh -o StrictHostKeyChecking=no" \
        "$REMOTE_ROOT_USER@$REMOTE_SERVER:/home/$REMOTE_CONTROL_PANEL_USER/web/$domain/public_html/" \
        "/home/$REMOTE_CONTROL_PANEL_USER/web/$domain/public_html/"; then
        print_color_message 255 0 0 "Помилка переносу файлів для домену $(print_color_message 0 255 255 "$domain")."
        return 1
    fi

    # Зміна прав доступу
    chown -R "$REMOTE_CONTROL_PANEL_USER:$REMOTE_CONTROL_PANEL_USER" "/home/$REMOTE_CONTROL_PANEL_USER/web/$domain/public_html"
    print_color_message 0 255 0 "Файли для домену $(print_color_message 0 255 255 "$domain") успішно перенесені."
    return 0
}

# Функція переносу баз даних
sync_database() {
    local db="$1"
    if mysql -u root -e "use $db;" 2>/dev/null; then
        print_color_message 255 255 0 "База даних $(print_color_message 0 255 255 "$db") вже існує, пропускаємо..."
        return 0
    else
        print_color_message 255 255 0 "Перенесення бази даних: $(print_color_message 0 255 255 "$db")"
        $CLI_dir/v-add-database $REMOTE_CONTROL_PANEL_USER $db $db 'p@$$wOrd_q(AbnWP}6|H!3X))'
        sshpass -p "$PASSWORD_ROOT_USER" ssh -o StrictHostKeyChecking=no $REMOTE_ROOT_USER@$REMOTE_SERVER "mysqldump -uroot $db" | mysql -uroot $db
    fi
}

# Основна функція переносу доменів
transfer_domains() {
    local domains=$(remote_ssh_command "ls -1 /home/$REMOTE_CONTROL_PANEL_USER/web/")
    # Цикл обробки доменів
    for domain in $domains; do 

        if ! add_web_domain "$domain"; then
            continue
        fi

        if $CLI_dir/v-change-web-domain-backend-tpl $REMOTE_CONTROL_PANEL_USER $domain $VerPHP; then
            print_color_message 0 255 0 "Зміни backend для $(print_color_message 0 255 255 "$domain") успішно застосовано."
        else
            print_color_message 255 0 0 "Помилка зміни backend шаблону для $(print_color_message 0 255 255 "$domain")."
        fi

        install_ssl "$domain"

        sync_files "$domain"
        
    done
}

# Основна функція переносу баз даних sshpass -p "pass" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 root@xxx.xx.xxx.xx "mysql -uroot -B -e 'show databases;'" | grep -Ev "Database|sys|information_schema|mysql|performance_schema|phpmyadmin|roundcube"
transfer_databases() {
    local databases=$(remote_ssh_command "mysql -uroot -B -e 'show databases;'" | grep -Ev "Database|sys|information_schema|mysql|performance_schema|phpmyadmin|roundcube" | grep "$REMOTE_CONTROL_PANEL_USER")
    2_switch_prefix_for_VestaCP_HestiaCP
    for db in $databases; do
        sync_database "$db"
    done
    2_switch_prefix_for_VestaCP_HestiaCP
}

# Отримуємо список користувачів HestiaCP
get_users() {
    v-list-users | awk 'NR>2 {print $1}'  # Пропускаємо перші 2 рядки заголовків
}

# Виводимо меню вибору користувача
select_user() {
    print_color_message 255 255 255 "Виберіть користувача панелі керування на віддаленому сервері (наприклад, admin):"
    users_list=($(remote_ssh_command "$CLI_dir/v-list-users | awk 'NR>2 {print \$1}'")) # Записуємо всіх користувачів в масив

    print_color_message 255 255 255 "0) Вибрати всіх користувачів"
    for i in "${!users_list[@]}"; do
        echo "$((i + 1))) ${users_list[$i]}"
    done

    read -r -p "$(print_color_message 255 255 0 'Введіть номер користувача або 0 для всіх: ')" user_choice

    # Перевірка вибору користувача
    if [[ $user_choice -eq 0 ]]; then
        REMOTE_CONTROL_PANEL_USER="${users_list[@]}"
    elif [[ $user_choice -ge 1 && $user_choice -le ${#users_list[@]} ]]; then
        REMOTE_CONTROL_PANEL_USER="${users_list[$((user_choice - 1))]}"
    else
        print_color_message 255 0 0 "Невірний вибір. Спробуйте ще раз."
        return
    fi
}

2_migrate_hestia_vesta() {
    # Перевірка ПО
    check_tools

    # Запитуємо у користувача дані для віддаленого сервера
    echo
    read -p "Введіть IP адресу або домен віддаленого сервера: " REMOTE_SERVER
    REMOTE_ROOT_USER="root"
    read -p "Введіть пароль користувача root: " PASSWORD_ROOT_USER
    echo

    # Перевіряємо введені дані на віддаленому сервері
    print_color_message 0 255 0 "Перевірка підключення до віддаленого сервера..."
    if remote_ssh_command "whoami"; then
        print_color_message 0 255 0 "Підключення успішне."
        if remote_ssh_command "$CLI_dir/v-list-users"; then
            print_color_message 0 255 0 "Користувачі виявлені."
        else
            print_color_message 255 0 0 "Помилка підключення."
            return
        fi
    else
        print_color_message 255 0 0 "Помилка підключення. Перевірте введені дані та спробуйте ще раз."
        return
    fi

    # Викликаємо функцію вибору користувача
    if select_user; then
        print_color_message 255 255 0 "Вибраний користувач: $REMOTE_CONTROL_PANEL_USER"
    else
        return
    fi

    VerPHP="PHP-8_2"

    # Виконуємо основні функції скрипта
    check_or_create_user "$REMOTE_CONTROL_PANEL_USER"
    transfer_domains
    transfer_databases
    print_color_message 0 255 0 "Перенесення завершено успішно."
}