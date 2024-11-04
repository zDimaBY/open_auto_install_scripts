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
        print_color_message 255 255 255 "4. Відключення префікса $(print_color_message 144 238 144 '"admin_"')"
        print_color_message 255 255 255 "5. Очистка $(print_color_message 144 238 144 'логів') $(print_color_message 255 99 71 '(test)')"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) 2_updateIoncube ;;
        2) 2_install_list_CMS ;;
        3) v_sys_change_ip ;;
        4) 2_disable_prefix_on_VestaCP_HestiaCP ;;
        5) 2_logs_clear ;;
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
        echo -e "2. Встановлення ${RED}VestaCP${RESET} ${RED}(test)${RESET}"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) 2_install_hestiaCP ;;
        2) 2_install_vesta_control_panel ;;
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
    VERSIONS_CP=$("$local_temp_curl" -s "$HESITACP_GITHUB" | "$local_temp_jq" -r '.[].name' | sort -Vr)

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
    local web_admin_port=$3
    local root_password=$4

    echo "-------------------------------------------"
    check_info_control_panel
    echo ""
    print_color_message 255 255 0 "Дані для входу у $panel_name:"
    print_color_message 255 255 255 "Адреса панелі: $(print_color_message 255 0 255 "https://${server_ip}:$web_admin_port")"
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
        display_hestia_info "HestiaCP" "${server_IPv4[0]}" "$WEB_ADMIN_PORT" "<пароль від root>"
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
    VERSIONS_DB=$("$local_temp_curl" -s "$REPO_URL" | grep -oP 'href="\K[0-9]+\.[0-9]+' | sort -uVr)
    EOL_DATA=$("$local_temp_curl" -s "$EOL_URL")

    # Функція для виводу версій та дат закінчення підтримки
    print_versions() {
        local index=1
        for VERSION_DB in $VERSIONS_DB; do
            EOL_DATE=$(echo "$EOL_DATA" | "$local_temp_jq" -r --arg VERSION_DB "$VERSION_DB" '.[] | select(.cycle == $VERSION_DB) | .eol')
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
    EOL_DATE=$(echo "$EOL_DATA" | "$local_temp_jq" -r --arg SELECTED_VERSION_DB "$SELECTED_VERSION_DB" '.[] | select(.cycle == $SELECTED_VERSION_DB) | .eol')

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

2_disable_prefix_on_VestaCP_HestiaCP() {
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

    read -p "Ви впевнені, що бажаєте видалити та очистити ці файли журналів? [y/N]: " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
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
    user_dir="/usr/local/$control_panel_install/data/users/"
    CLI_dir="/usr/local/$control_panel_install/bin"
    # Виведення списку папок
    echo "Доступні користувачі панелі керування сайтами:"
    folders=($(find "$user_dir" -maxdepth 1 -mindepth 1 -type d -printf "%f\n"))

    # Перелік індексів папок
    for ((i = 0; i < ${#folders[@]}; i++)); do
        echo "$(($i + 1)). ${folders[$i]}"
    done

    # Запит на вибір папки
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

    if [ -d "/home/$CONTROLPANEL_USER/web/$WP_SITE_DOMEN" ]; then
        echo "Домен $WP_SITE_DOMEN уже є за шляхом /home/$CONTROLPANEL_USER/web/$WP_SITE_DOMEN."
        return 1
    fi

    SITE_PASSWORD=$(generate_random_part_16)
    SITE_ADMIN_MAIL="admin@$WP_SITE_DOMEN"

    WORDPRESS_URL="https://wordpress.org/latest.tar.gz"
    WP_USER="admin"
    DB_NAME="w$(generate_random_part_16)"
    DB_NAME=$(trim_to_10 "$DB_NAME")
    DB_USER="w$(generate_random_part_16)"
    DB_USER=$(trim_to_10 "$DB_USER")
    DB_PASSWORD="wp_p_$(generate_random_part_16)"
    DB_PASSWORD=$(trim_to_16 "$DB_PASSWORD")

    HTACCESS_CONTENT='RewriteEngine On
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
# END WordPress'

    # Обрана папка
    CONTROLPANEL_USER="${folders[$((choice - 1))]}"

    $CLI_dir/v-add-domain $CONTROLPANEL_USER $WP_SITE_DOMEN

    check_domain $WP_SITE_DOMEN
    if [ $? -eq 0 ]; then
        $CLI_dir/v-add-letsencrypt-domain $CONTROLPANEL_USER $WP_SITE_DOMEN '' yes
        $CLI_dir/v-schedule-letsencrypt-domain $CONTROLPANEL_USER $WP_SITE_DOMEN
    else
        WEB_DIR=/home/$CONTROLPANEL_USER/web/$WP_SITE_DOMEN
        SSL_DIR=$WEB_DIR/ssl

        create_folder "$SSL_DIR"

        # Створення самопідписаного сертифіката
        openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
            -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Example/CN=$WP_SITE_DOMEN" \
            -keyout $SSL_DIR/$WP_SITE_DOMEN.key -out $SSL_DIR/$WP_SITE_DOMEN.crt
        chown -R "$CONTROLPANEL_USER:$CONTROLPANEL_USER" "$SSL_DIR"
        # Додавання сертифіката до HestiaCP
        $CLI_dir/v-add-web-domain-ssl $CONTROLPANEL_USER $WP_SITE_DOMEN $SSL_DIR

        # Перезапуск веб-сервера
        #$CLI_dir/v-restart-web

        echo "Самопідписаний SSL сертифікат для $WP_SITE_DOMEN створено та додано до $control_panel_install."
    fi

    dir_wp_in_panel="/home/$CONTROLPANEL_USER/web/$WP_SITE_DOMEN/public_html/"

    if [ ! -d "$dir_wp_in_panel" ]; then
        echo "Папка $dir_wp_in_panel не існує. Вихід..."
        return 1
    fi

    cd $dir_wp_in_panel

    # Завантажуємо та розпаковуємо WordPress
    echo -e "${YELLOW}Завантажуємо та розпаковуємо WordPress...${RESET}"
    wget $WORDPRESS_URL -O wordpress.tar.gz
    tar -xf wordpress.tar.gz
    mv wordpress/* .
    rmdir wordpress
    rm -rf latest.tar.gz

    # Налаштовуємо файл wp-config.php
    echo -e "${YELLOW}Налаштовуємо файл wp-config.php...${RESET}"
    cp wp-config-sample.php wp-config.php
    if [ -f "/usr/local/$control_panel_install/bin/v-add-database-prefix-on" ]; then
        sed -i "s|database_name_here|${DB_NAME}|" wp-config.php
        sed -i "s|username_here|${DB_USER}|" wp-config.php
        sed -i "s|password_here|$DB_PASSWORD|" wp-config.php
    else
        echo -e "${GREEN}Вмикаємо ${YELLOW}префікс баз даних для панелі керування $control_panel_install.${RESET}"
        sed -i "s|database_name_here|${CONTROLPANEL_USER}_${DB_NAME}|" wp-config.php
        sed -i "s|username_here|${CONTROLPANEL_USER}_${DB_USER}|" wp-config.php
        sed -i "s|password_here|$DB_PASSWORD|" wp-config.php
    fi
    sed -i -e "/put your unique phrase here/{
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

    # Створюємо .htaccess, якщо його немає
    if [ ! -e .htaccess ]; then
        echo $HTACCESS_CONTENT >.htaccess
        echo -e "${YELLOW}Створено файл .htaccess.${RESET}"
    else
        echo -e "${GREEN}Файл .htaccess вже існує.${RESET}"
    fi

    # Встановлюємо права доступу
    echo -e "${YELLOW}Встановлюємо права доступу...${RESET}"
    chown -R $CONTROLPANEL_USER:$CONTROLPANEL_USER * && chown -R $CONTROLPANEL_USER:$CONTROLPANEL_USER .htaccess

    # Створюємо базу даних та користувача, якщо база даних не існує
    echo -e "${YELLOW}Створюємо базу даних та користувача...${RESET}"

    $CLI_dir/v-add-database $CONTROLPANEL_USER $DB_NAME $DB_USER $DB_PASSWORD

    # Перевірка наявності команди wp
    if ! command -v wp &>/dev/null; then
        echo -e "${RED}Команда 'wp' не знайдена. ${YELLOW}Встановлюємо WP-CLI...${RESET}"

        # Встановлюємо WP-CLI
        "$local_temp_curl" -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp

        wp --allow-root --version
    fi

    wp core install --allow-root --url=http://${WP_SITE_DOMEN} --title=${WP_SITE_DOMEN} --admin_user=${WP_USER} --admin_password=${SITE_PASSWORD} --admin_email=${SITE_ADMIN_MAIL}

    wp language core install --allow-root --activate ru_RU

    #wp theme activate ваша_тема
    #wp plugin install назва_плагіна
    #wp plugin activate назва_плагіна

    echo -e "\n\n${GREEN}Wordpress встановлено: http://${WP_SITE_DOMEN}/wp-login.php${RESET}"
    echo -e "Логін: ${WP_USER}"
    echo -e "Пароль: ${SITE_PASSWORD}\n\n"

    source /etc/os-release
}

2_install_CMS_DLE() {
    echo -e "В розробці: ..."
}
