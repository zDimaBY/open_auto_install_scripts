# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 2_site_control_panel() {
    #Перевіряємо яка панель керування встановлена
    if [ -e "/usr/local/vesta" ]; then
        control_panel_install="vesta"
    elif [ -e "/usr/local/hestia" ]; then
        control_panel_install="hestia"
    else
        echo -e "${RED}Не вдалося визначити панель управління сайтами.${RESET}"
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
    
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Встановлення/апгрейд ${RED}ioncube${RESET} для всіх php версії (Hestiacp + php-fpm) ${RED}(test)${RESET}"
        echo -e "2. Встановлення ${RED}CMS${RESET} ${RED}(test)${RESET}"
        echo -e "3. Заміна IP-адреси з old на new ${RED}(test)${RESET}"
        echo -e "4. Відключення префікса ${GREEN}\"admin_\"${RESET}"
        echo -e "5. Очистка логів ${GREEN}\"логів\"${RESET} ${RED}(test)${RESET}"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

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

function 2_updateIoncube() {
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
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. WordPress ${RED}(test)${RESET}"
        echo -e "2. DLE ${RED}(test)${RESET}"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

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
    fi
    rm -rf /var/log/$COMMAND_WEB_SERVER/domains/*.log-*
    truncate -s 0 /var/log/$COMMAND_WEB_SERVER/domains/*.log
    du -ahx /var/log/$COMMAND_WEB_SERVER/domains/ | grep "\.log" | sort -rh
}

2_install_CMS_wordpress() {
    #Перевіряємо сумісніть системи
    case $operating_system in
    debian | ubuntu)
        echo -e "${RED}$operating_system ...${RESET}"
        ;;
    fedora)
        echo -e "${RED}$operating_system ...${RESET}"
        ;;
    centos | oracle)
        echo -e "${RED}$operating_system ...${RESET}"
        ;;
    arch | sysrescue)
        echo -e "${RED}$operating_system ...${RESET}"
        ;;
    *)
        echo -e "${RED}Не вдалося визначити систему.${RESET}"
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
        echo -e "${RED}Не вдалося визначити панель управління сайтами.${RESET}"
        return 1
    fi

    # Шлях до директорії з користувачами
    user_dir="/usr/local/$control_panel_install/data/users/"

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
        echo "Недійсний номер папки."
        return 1
    fi

    read -p "Вкажіть домен для wordpress: " WP_SITE_DOMEN

    if [ -z "$WP_SITE_DOMEN" ]; then
        echo "Домен не було вказано."
        return 1
    fi

    if [ -d "/home/$CONTROLPANEL_USER/web/$WP_SITE_DOMEN" ]; then
        echo "Домен $DOMAIN уже є за шляхом /home/$CONTROLPANEL_USER/web/."
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

    HTACCESS_CONTENT="# BEGIN WordPress\n<IfModule mod_rewrite.c>\nRewriteEngine On\nRewriteBase /\nRewriteRule ^index\.php$ - [L]\nRewriteCond %{REQUEST_FILENAME} !-f\nRewriteCond %{REQUEST_FILENAME} !-d\nRewriteRule . /index.php [L]\n</IfModule>\n# END WordPress"

    # Обрана папка
    CONTROLPANEL_USER="${folders[$((choice - 1))]}"
    echo "Ви обрали користувача: $CONTROLPANEL_USER"

    /usr/local/$control_panel_install/bin/v-add-domain $CONTROLPANEL_USER $WP_SITE_DOMEN

    check_domain $WP_SITE_DOMEN
    if [ $? -eq 0 ]; then
        /usr/local/$control_panel_install/bin/v-schedule-letsencrypt-domain $CONTROLPANEL_USER $WP_SITE_DOMEN
    else
        /usr/local/$control_panel_install/bin/v-generate-ssl-cert $WP_SITE_DOMEN $SITE_ADMIN_MAIL USA California Monterey ACME.COM IT
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
    if [ ! -f "/usr/local/$control_panel_install/bin/v-add-database-prefix-on" ]; then
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

    /usr/local/$control_panel_install/bin/v-add-database $CONTROLPANEL_USER $DB_NAME $DB_USER $DB_PASSWORD

    # Перевірка наявності команди wp
    if ! command -v wp &>/dev/null; then
        echo -e "${RED}Команда 'wp' не знайдена. ${YELLOW}Встановлюємо WP-CLI...${RESET}"

        # Встановлюємо WP-CLI
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
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
}

2_install_CMS_DLE() {
    echo -e "В розробці: ..."
}