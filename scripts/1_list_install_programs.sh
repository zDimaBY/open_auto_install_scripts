# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 1_list_install_programs() {
    while true; do
        check_info_server
        check_info_control_panel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Встановлення ${BROWN}Composer${RESET}"
        echo -e "2. Встановлення ${BROWN}Docker${RESET}"
        echo -e "3. Встановлення ${BLUE}RouterOS від Mikrotik${RESET}"
        echo -e "4. Встановлення ${BLUE}Elasticsearch${RESET} ${RED}(test)${RESET}"
        echo -e "5. Встановлення ${GREEN}Nginx proxy server${RESET} портів 80 та 443 з ${RED}${server_IPv4[0]}${RESET} на ххх.ххх.ххх.ххх"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) 1_installComposer ;;
        2) check_docker_availability ;;
        3) 1_installRouterOSMikrotik ;;
        4) 1_installElasticsearch ;;
        5) 1_installNginxProxyServer ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

function 1_installComposer() {
    case $operating_system in
    debian | ubuntu)
        if ! command -v php &>/dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            install_package "php-cli" "php"
        fi
        ;;
    fedora)
        if ! command -v php &>/dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            install_package "php-cli" "php"
        fi
        ;;
    centos | oracle)
        if ! command -v php &>/dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            install_package "epel-release"
            install_package "php-cli" "php"
        fi
        ;;
    arch | sysrescue)
        if ! command -v php &>/dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            install_package "php"
        fi
        ;;
    *)
        echo -e "${RED}Не вдалося встановити Composer. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac

    if ! command -v composer &>/dev/null; then
        echo -e "${RED}Composer не знайдено. Встановлюємо...${RESET}"
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
        if [ $? -eq 0 ]; then
            echo -e "\n${GREEN}Composer встановлено успішно.${RESET}\n"
            yes | composer -V
        else
            echo -e "\n${RED}Помилка під час встановлення Composer.${RESET}\n"
        fi
    else
        echo -e "\n${YELLOW}Composer вже встановлено. Продовжуємо...${RESET}\n"
    fi
}

function 1_installRouterOSMikrotik() {
    echo -e "${RED}Бажаєте встановити систему RouterOS від MikroTik? Після цієї операції диск буде перезаписаний${RESET}"
    read -p "Ви згодні, що система перезапише дані та виконає перезапуск? (y/n): " answer
    if [[ "$answer" =~ ^(yes|Yes|y|Y)$ ]]; then
        echo -e "${GREEN}Встановлення системи RouterOS... https://mikrotik.com/download${RESET}"
        read -p "Вкажіть версію для RouterOS (наприклад 7.5, 7.12. default: 7.14): " version_routeros
        version_routeros=${version_routeros:-7.14}
    else
        echo -e "\n${RED}Встановлення RouterOS від MikroTik скасовано.${RESET}"
        return 1
    fi
    generate_random_password_show
    read -p "Вкажіть пароль користувача admin для RouterOS: " passwd_routeros
    echo -e "${RED}Вам потрібно обрати лише диск, вибір розділів пропустити.${RESET}"
    select_disk_and_partition
    passwd_routeros=${passwd_routeros:-$rand_password}
    case $operating_system in
    debian | ubuntu)
        if ! command -v qemu-img &>/dev/null || ! command -v pv &>/dev/null; then
            echo -e "${RED}qemu-utils або pv не знайдено. Встановлюємо...${RESET}"
            apt install -y qemu-utils pv parted
        fi
        ;;
    fedora)
        if ! command -v qemu-img &>/dev/null || ! command -v pv &>/dev/null; then
            echo -e "${RED}qemu-utils або pv не знайдено. Встановлюємо...${RESET}"
            dnf install -y qemu-img pv nbd libaio
        fi
        ;;
    centos | oracle)
        if ! command -v qemu-img &>/dev/null || ! command -v pv &>/dev/null; then
            echo -e "${RED}qemu-img або pv не знайдено. Встановлюємо...${RESET}"
            yum install -y qemu-img pv nbd libaio
            if modprobe nbd &>/dev/null; then
                echo "Модуль nbd успішно завантажено"
            else
                echo -e "${RED}Помилка:${RESET} модуль nbd, у ядрі ${YELLOW}$(uname -r)${RESET} системи ${RED}${NAME} ${VERSION}${RESET} не увімкнено."
                echo "Скористайтеся інструкціями та повторіть спробу:"
                echo "https://blog.csdn.net/lv0918_qian/article/details/117651096"
                echo "https://gist.github.com/Thodorhs/76edc2acd4d89bbb0b4d2cd4908fec97 - Перезбір модулів ядра може зайняти понад 2 години."
                echo -e "Також вам знадобляться пакети: yum install gcc ncurses ncurses-devel elfutils-libelf-devel openssl-devel kernel-devel kernel-headers\n\n"
                echo -e "Ви можите встановти CentOS 8, ubuntu 20.04, Debian 11 і вище, щоб виконати встановлення корректно\n\n"
                return 1
            fi
        fi
        ;;
    arch)
        if ! command -v qemu-img &>/dev/null || ! command -v pv &>/dev/null; then
            echo -e "${RED}qemu-utils або pv не знайдено. Встановлюємо...${RESET}"
            pacman -Sy qemu-utils pv
        fi
        ;;
    *)
        echo -e "${RED}Не вдалося встановити RouterOS Mikrotik. Не підтримувана система $operating_system. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac

    if [[ ! $version_routeros =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Помилка: Введено неправильне значення версії. Будь ласка, введіть числове значення (наприклад 7.12, 7.14)."
        echo "Для посилання: https://download.mikrotik.com/routeros/${version_routeros}/chr-${version_routeros}.img.zip."
        return 1
    fi

    echo -e "Обраний диск: ${RED}${selected_partition}${RESET}"
    wget https://download.mikrotik.com/routeros/${version_routeros}/chr-${version_routeros}.img.zip -O chr.img.zip
    if [ $? -ne 0 ]; then
        echo -e "${RED}Помилка $?:${RESET} не вдалося завантажити файл chr.img.zip."
        return 1
    fi
    gunzip -c chr.img.zip >chr.img

    delay_command=3
    fdisk -l
    echo -e "${RED}______________________________________________________________________________________________________________1${RESET}"
    # Монтування образу
    qemu-img convert chr.img -O qcow2 chr.qcow2 && sleep "$delay_command"
    qemu-img resize chr.qcow2 1073741824 && sleep "$delay_command" # Розширюєм образ диска до 1G
    modprobe nbd && qemu-nbd -c /dev/nbd0 chr.qcow2 && sleep "$delay_command"
    partprobe /dev/nbd0 && sleep "$delay_command"
    mount /dev/nbd0p2 /mnt && sleep "$delay_command"
    fdisk -l
    echo -e "${RED}______________________________________________________________________________________________________________2${RESET}"
    # Отримання налаштувань мережі ip, mask, gateway
    get_public_interface
    #date_start_install=$(date)

    # Налаштування мережі та інших параметрів
    cat <<EOF >/mnt/rw/autorun.scr
/user set [find name=admin] password=${passwd_routeros}
/ip service disable telnet
/ip address add address=${server_IPv4[0]}/${mask} network=${gateway} interface=ether1
/ip route add dst-address=0.0.0.0/0 gateway=${gateway}
EOF
    #/system package update install

    # Розмонтування образу
    umount /mnt && sleep "$delay_command"

    fdisk -l
    echo -e "${RED}______________________________________________________________________________________________________________3${RESET}"
    # Створення нового розділу
    echo -e 'd\n2\nn\np\n2\n65537\n\nw\n' | fdisk /dev/nbd0 && sleep "$delay_command"
    fdisk -l
    echo -e "${RED}______________________________________________________________________________________________________________4${RESET}"

    # Виконання перевірки файлової системи і зміна її розміру
    e2fsck -f -y /dev/nbd0p2 || true && resize2fs /dev/nbd0p2 && sleep "$delay_command"
    fdisk -l
    echo -e "${RED}______________________________________________________________________________________________________________5${RESET}"
    # Копіювання образу та збереження його на тимчасове сховище
    pv /dev/nbd0 | gzip >/mnt/chr-extended.gz && sleep "$delay_command"
    fdisk -l
    echo -e "${RED}______________________________________________________________________________________________________________6${RESET}"
    # Завершення роботи qemu-nbd
    killall qemu-nbd && sleep "$delay_command"
    echo u >/proc/sysrq-trigger && sleep "$delay_command"
    # Розпакування образу та копіювання його на пристрій ${selected_partition}
    zcat /mnt/chr-extended.gz | pv >${selected_partition} && sleep "$delay_command"
    fdisk -l
    echo -e "${RED}______________________________________________________________________________________________________________7${RESET}"
    echo -e "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    echo -e "${YELLOW}Система RouterOS встановлена. Перейдіть за посиланням http://${server_IPv4[0]}/webfig/ для доступу до WEB-інтерфейсу.\nЛогін: admin\nПароль: ${passwd_routeros}${RESET}"
    echo -e "\nВиконайте наступні команди, якщо мережа не налаштована:"
    echo -e "ip address add address=${server_IPv4[0]}/${mask} network=${gateway} interface=ether1"
    echo -e "ip route add dst-address=0.0.0.0/0 gateway=${gateway}"
    echo -e "Перевірте мережу: \nping ${gateway} \nping 8.8.8.8"
    echo -e "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------${RESET}"

    # Синхронізація даних на диску і перезавантаження системи
    echo "sync disk" && sleep "$delay_command" && echo s >/proc/sysrq-trigger && sleep "$delay_command"
    echo b >/proc/sysrq-trigger
}

1_installElasticsearch() {
    case $operating_system in
    debian | ubuntu)
        if dpkg -l | grep -q '^ii.*apt-transport-https'; then
            echo -e "${GREEN}apt-transport-https встановлено.${RESET}"
        else
            echo -e "${RED}apt-transport-https не встановлений. Виконую встановлення...${RESET}"
            apt-get -y install apt-transport-https
        fi
        if dpkg -l | grep -q gnupg; then
            echo -e "${GREEN}gnupg вже встановлений.${RESET}"
        else
            echo -e "${RED}gnupg не встановлений. Виконую встановлення...${RESET}"
            apt-get install -y gnupg
        fi

        echo -e "${GREEN}Завантаження ключа GPG Elasticsearch...${RESET}"
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

        echo -e "${GREEN}Додавання репозиторію Elasticsearch до списку джерел APT...${RESET}"
        echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
        echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

        echo -e "${GREEN}Оновлення списку пакунків APT...${RESET}"
        if apt-get update; then
            echo -e "${GREEN}Список пакунків APT оновлено.${RESET}"
        else
            echo -e "${RED}Помилка під час оновлення списку пакунків APT. Можна спробувати продовжити не вибираючи репозиторій з помилкою оновлення.${RESET}"
        fi

        # Отримати доступні головні версії Elasticsearch
        main_versions=$(apt policy elasticsearch | grep -E "^[[:space:]]+[0-9]+\..*\." | awk '{print $1}' | cut -d'.' -f1 | sort -ru)
        if [[ -z "$main_versions" ]]; then
            echo "Не вдалося знайти жодної версії Elasticsearch"
            return 1
        fi
        PS3="Оберіть версію Elasticsearch: " # змінна оболонки (shell), яка використовується в разі використання команди select в bash для введення меню.
        select main_version in $main_versions; do
            if [ -n "$main_version" ]; then
                echo -e "${GREEN}Ви обрали версію $main_version.${RESET}"
                break
            else
                echo -e "${RED}Невірний вибір. Будь ласка, спробуйте ще раз.${RESET}"
            fi
        done

        # Отримати версії, що відповідають обраній головній версії
        sub_versions=$(apt policy elasticsearch | grep -E "^[[:space:]]+[0-9]+\..*\." | grep "^ *$main_version\." | awk '{print $1}')

        PS3="Оберіть підверсію Elasticsearch для встановлення: " # змінна оболонки (shell), яка використовується в разі використання команди select в bash для введення меню.
        select sub_version in $sub_versions; do
            if [ -n "$sub_version" ]; then
                echo "Ви обрали версію $sub_version для встановлення."
                apt install elasticsearch=$sub_version
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}\nElasticsearch версії ${YELLOW}$sub_version${GREEN} успішно встановлено.${RESET}"
                else
                    echo -e "${RED}Помилка при встановленні Elasticsearch версії $sub_version.${RESET}"
                    return 1
                fi
                break
            else
                echo "Невірний вибір. Будь ласка, спробуйте ще раз."
            fi
        done

        ;;
    fedora)
        echo -e "${RED}Функція не реалізована... \nhttps://www.elastic.co/guide/en/elasticsearch/reference/8.13/rpm.html \nhttps://www.elastic.co/guide/en/elasticsearch/reference/7.17/rpm.html${RESET}"
        ;;
    centos | oracle)
        echo -e "${RED}Функція не реалізована... \nhttps://www.elastic.co/guide/en/elasticsearch/reference/8.13/rpm.html \nhttps://www.elastic.co/guide/en/elasticsearch/reference/7.17/rpm.html${RESET}"

        ;;
    arch)
        echo -e "${RED}Функція не реалізована... \nhttps://www.elastic.co/guide/en/elasticsearch/reference/8.13/rpm.html \nhttps://www.elastic.co/guide/en/elasticsearch/reference/7.17/rpm.html${RESET}"

        ;;
    *)
        echo -e "${RED}Не вдалося встановити Elasticsearch. Будь ласка, встановіть його вручну. Перевірте, будь ласка, чи сумісна ваша система${RESET}"
        return 1
        ;;
    esac
    # Перевіряємо вільну память swap та ram
    total_free_swap_end_ram
    if ((free_swap_end_ram_mb < 2048)); then
        echo -e "${RED}Недостатньо вільної пам'яті. Поточно доступно більше: ${YELLOW}${free_swap_end_ram_gb} ГБ (${free_swap_end_ram_mb} МБ)${RESET}"
        echo -e "Можна підключити SWAP файл, але швидкість вузла може зменшиться, з документації рекомандуть не використовувати SWAP."
        echo -e "Детальніше за посиланням: https://www.elastic.co/guide/en/elasticsearch/reference/8.13/setup-configuration-memory.html"
        echo -e "\nЩоб запустити службу Elasticsearch виконайте наступні команди: systemctl enable elasticsearch && systemctl start elasticsearch"
        echo -e "Перевірка доступності: curl -X GET \"localhost:9200\""
    else
        echo -e "${GREEN}Доступно достатньо вільної пам'яті, більше: ${YELLOW}${free_swap_end_ram_gb} ГБ (${free_swap_end_ram_mb} МБ)${RESET}"
        systemctl enable elasticsearch && systemctl start elasticsearch
    fi

}

1_installNginxProxyServer() {
    read -p "Введіть ІР-адресу сервера на який будуть надходити запити через цей сервер: " proxy_address
    if ! install_package "nginx"; then
        return 1
    fi
    create_folder "/etc/nginx/ssl"
    create_folder "/etc/nginx/conf.d"

    nginx_conf="/etc/nginx/nginx.conf"

    # Перевірка, чи існує файл nginx.conf
    if [ -f "$nginx_conf" ]; then
        echo "Файл nginx.conf знайдено: $nginx_conf"
        cp "$nginx_conf" "$nginx_conf.original_backup"
    else
        echo "Файл nginx.conf не знайдено: $nginx_conf"
        return 1
    fi

    cp "$nginx_conf" "$nginx_conf.original_backup"
    cat <<EOF >"$nginx_conf"
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;

    # Збільшуємо розмір types_hash_max_size та вказуємо розмір types_hash_bucket_size
    types_hash_max_size 4096;
    types_hash_bucket_size 128;

    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root /usr/share/nginx/html;
        }
    }

    include /etc/nginx/conf.d/*.conf;
}
EOF

    # Створити SSL-сертифікат та приватний ключ, якщо вони відсутні
    if [ ! -f "$ssl_dir/certificate.crt" ] || [ ! -f "$ssl_dir/privatekey.key" ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$ssl_dir/privatekey.key" -out "$ssl_dir/certificate.crt" \
            -subj "/C=NL/ST=North Holland/L=Amsterdam/O=MyCompany/OU=IT Department/CN=example.com/emailAddress=admin@example.com"
    fi

    nginx_conf="/etc/nginx/conf.d/default.conf"
    if [ -f "$nginx_conf" ]; then
        for file in /etc/nginx/conf.d/*.conf; do
            echo -e "${GREEN}File: ${RED}$file${GREEN} ------------------------------------------------------------------${RESET}"
            cat "$file"
        done
        read -p "Файл '$nginx_conf' вже існує. Бажаєте перезаписати його? (y/n): " overwrite_conf
        [[ "$overwrite_conf" =~ ^[Yy]$ ]] && echo "Записуємо конфігурацію..." && cat <<EOF >"$nginx_conf"
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    location / {
        proxy_pass http://$proxy_address;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    
    ssl_certificate $ssl_dir/certificate.crt;
    ssl_certificate_key $ssl_dir/privatekey.key;

    location / {
        proxy_pass https://$proxy_address;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
    else
        echo "Створюємо новий файл конфігурації..."
        cat <<EOF >"$nginx_conf"
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    location / {
        proxy_pass http://$proxy_address;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    
    ssl_certificate $ssl_dir/certificate.crt;
    ssl_certificate_key $ssl_dir/privatekey.key;

    location / {
        proxy_pass http://$proxy_address;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
    fi

    nginx -t
    # Перезапустити nginx, якщо конфігурація коректна
    if [ $? -eq 0 ]; then
        systemctl restart nginx
    else
        echo "Помилка: конфігурація nginx некоректна. Перевірте конфігураційний файл."
    fi

}
