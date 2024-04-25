# shellcheck disable=SC2148
# shellcheck disable=SC2154
function check_dependency() {
    local dependency_name=$1
    local package_name=$2

    if [[ -e /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
        debian | ubuntu | fedora | centos | oracle | arch)
            operating_system="$ID"
            ;;
        *)
            echo "Схоже, ви не використовуєте цей інсталятор у системах Debian, Ubuntu, Fedora, CentOS, Oracle або Arch Linux. Ваша система: $ID"
            exit 1
            ;;
        esac
    else
        echo "Не вдалося визначити операційну систему."
    fi

    # Перевірка наявності залежності
    if ! command -v $dependency_name &>/dev/null; then
        echo -e "${RED}$dependency_name не встановлено. Встановлюємо...${RESET}"

        # Перевірка чи вже було виконано оновлення системи
        if ! "$UPDATE_DONE"; then
            # Встановлення залежності залежно від операційної системи
            case $operating_system in
            debian | ubuntu)
                apt-get update
                apt-get install -y "$package_name"
                ;;
            fedora)
                dnf update
                dnf install -y "$package_name"
                ;;
            centos | oracle)
                yum update
                yum install epel-release -y
                yum install -y "$package_name"
                ;;
            arch)
                pacman -Sy
                pacman -S --noconfirm "$package_name"
                ;;
            *)
                echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
                return 1
                ;;
            esac

            UPDATE_DONE=true
        else
            case $operating_system in
            debian | ubuntu)
                apt-get install -y "$package_name"
                ;;
            fedora)
                dnf install -y "$package_name"
                ;;
            centos | oracle)
                yum install -y "$package_name"
                ;;
            arch)
                pacman -S --noconfirm "$package_name"
                ;;
            *)
                echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
                return 1
                ;;
            esac
        fi

        echo -e "${GREEN}$dependency_name успішно встановлено.${RESET}"
    else
        echo -e "${GREEN}$dependency_name вже встановлено.${RESET}"
    fi
}

checkControlPanel() {
    echo -e "\n${YELLOW}Information: ${RED}$operating_system${RESET} ${CYAN}$VERSION${RESET}"
    load_average=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}')
    load_average=${load_average%,*}
    load_average=${load_average//,/.}

    if (($(echo "$load_average < 2" | bc -l))); then
        load_average="${GREEN}$load_average${RESET}"
    elif (($(echo "$load_average < 5" | bc -l))); then
        load_average="${YELLOW}$load_average${RESET}"
    else
        load_average="${RED}$load_average (!)${RESET}"
    fi

    largest_disk=$(df -h | grep '^/dev/' | sort -k 4 -hr | head -n 1)
    disk_usage=$(echo "$largest_disk" | awk '{print $5}') # Використання місця на найбільшому диску
    echo -e "Load Average: $load_average Disk Usage: $disk_usage"

    server_hostname=$(hostname)
    server_IP=$(hostname -I | awk '{print $1}')
    echo -e "Hostname:${GREEN}$server_hostname${RESET} IP: $server_IP version script: $LAST_COMMIT"

    case $operating_system in
    "debian" | "ubuntu" | "fedora" | "centos" | "oracle" | "arch")
        if [ -d "/usr/local/hestia" ]; then
            hestia_info=$(/usr/local/hestia/bin/v-list-sys-info)

            hostname=$(echo "$hestia_info" | awk 'NR==3{print $1}')
            operating_system_panel=$(echo "$hestia_info" | awk 'NR==3{print $2}')
            os_version=$(echo "$hestia_info" | awk 'NR==3{print $3}')
            hestia_version=$(echo "$hestia_info" | awk 'NR==3{print $5}')

            echo -e "HestiaCP:${MAGENTA}$hestia_version${RESET}"
        elif [ -d "/usr/local/vesta" ]; then
            vesta_info=$(/usr/local/vesta/bin/v-list-sys-info)
            source /usr/local/vesta/conf/vesta.conf
            hostname=$(echo "$vesta_info" | awk 'NR==3{print $1}')
            operating_system_panel=$(echo "$vesta_info" | awk 'NR==3{print $2}')
            os_version=$(echo "$vesta_info" | awk 'NR==3{print $3}')
            vesta_version=$(echo "$VERSION")

            echo -e "VestiaCP:${MAGENTA}$vesta_version${RESET}"
            source /etc/os-release
        elif [ -d "/usr/local/mgr5" ]; then
            echo -e "${GREEN}ISPmanager is installed.${RESET}"
            /usr/local/mgr5/sbin/licctl info ispmgr
        elif [ -f "/usr/local/cpanel/cpanel" ]; then
            echo -e "${GREEN}cPanel is installed.${RESET}"
            /usr/local/cpanel/cpanel -V
            cat /etc/*release
        else
            echo "Панель керування сайтами не знайдено."
        fi
        ;;
    *)
        echo "Для виявленої операційної системи не знайдено підтримуваної панелі керування сайтами."
        ;;
    esac
}

generate_random_password_show() {
    rand_password=$(openssl rand -base64 12)
    echo -e "\nЗгенерований випадковий пароль: ${RED}$rand_password${RESET}"
}
generate_random_password() {
    rand_password=$(openssl rand -base64 12)
}

check_docker() {
    # Перевіряємо, чи встановлений Docker
    if ! command -v docker &>/dev/null; then
        echo -e "\n${RED}Docker не встановлено на цій системі.${RESET}"
        read -p "Бажаєте встановити Docker? (y/n): " install_docker
        if [[ "$install_docker" =~ ^(yes|Yes|y|Y)$ ]]; then
            echo -e "${YELLOW}Встановлення Docker...${RESET}"
            curl -fsSL https://get.docker.com | sh
            sudo usermod -aG docker "$(whoami)"
            echo -e "\n${GREEN}Docker успішно встановлено.${RESET}"
        else
            echo -e "\n${RED}Встановлення Docker скасовано. Скрипт завершується.${RESET}"
            exit 1
        fi
    fi

    local docker_status=$(systemctl is-active docker)
    local active_status=""
    # Перевіряємо, чи Docker запущений
    if [ "$docker_status" != "active" ]; then
        echo -e "\n${RED}Docker не запущений.${RESET}"
        echo -e "${YELLOW}Запуск Docker...${RESET}"
        sudo systemctl start docker
        echo -e "\n${GREEN}Docker успішно запущений.${RESET}"
        active_status=$(systemctl status docker | grep "Active:")
    else
        active_status=$(systemctl status docker | grep "Active:")
    fi

    # Перевіряємо, чи Docker доданий до автозапуску
    if systemctl is-enabled docker &>/dev/null; then
        echo -e "\n${YELLOW}Docker вже є у автозапуску.${RESET}"
    else
        systemctl enable docker
        if systemctl is-enabled docker &>/dev/null; then
            echo -e "\n${GREEN}Docker успішно доданий до автозапуску.${RESET}"
        else
            echo -e "\n${RED}Помилка: Docker не був доданий до автозапуску.${RESET}"
        fi
    fi

    echo -e "\n${YELLOW}Статус Docker:${RESET}\n${GREEN}$active_status${RESET}"
}

create_folder() {
    path="$1"

    if [ -d "$path" ]; then
        echo -e "${YELLOW}Папка $path уже існує.${RESET}"
    else
        mkdir -p "$path"
        echo -e "${GREEN}Папка $path створена.${RESET}"
    fi
}

copy_file_from_container() {
    local container_name="$1"
    local file_path="$2"
    local target_directory="$3"

    while ! docker exec "$container_name" test -e "$file_path"; do
        echo "Очікування створення файлу $file_path в контейнері $container_name..."
        sleep 5
    done

    docker cp "$container_name":"$file_path" "$target_directory"
    echo "Файл $file_path було скопійовано в $target_directory"
}

mask_to_cidr() { #cidr
    local IFS=.
    read -r i1 i2 i3 i4 <<<"$1"
    local binary=$(echo "obase=2;$i1*256*256*256+$i2*256*256+$i3*256+$i4" | bc)
    local cidr=$(echo -n "${binary}" | tr -d 0 | wc -c)
    if [ "$cidr" -eq 0 ]; then
        echo "Недійсна маска підмережі"
        exit 1
    fi
    echo "${cidr}"
}

get_public_interface() { #hostname_ip selected_adapter mask gateway
    hostname_ip=$(hostname -I | awk '{print $1}')
    adapters=$(ip addr show | grep "^[0-9]" | awk '{print $2}' | sed 's/://')
    selected_adapter=""
    for adapter in $adapters; do
        adapter_ip=$(ip addr show dev "$adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f1)
        if [ "$adapter_ip" == "$hostname_ip" ]; then
            selected_adapter="$adapter"
            break
        fi
    done
    if [ -z "$selected_adapter" ]; then
        echo "Не вдалося знайти адаптер з IP-адресою, яка відповідає результату команди hostname -I: $hostname_ip"
        selected_adapter="none"
        mask="xx"
        gateway="xxx.xxx.xxx.xxx"
    else
        mask=$(ip addr show dev "$selected_adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f2)
        gateway=$(ip route show dev "$selected_adapter" | grep "default via" | awk '{print $3}')
    fi
}

get_selected_interface() { #hostname_ip selected_adapter mask gateway
    adapters=$(ip addr show | grep "^[0-9]" | awk '{print $2}' | sed 's/://')
    echo "Виберіть доступний мережеви адаптер:"
    count=0
    for adapter in $adapters; do
        if [[ $adapter != veth* && $adapter != br-* ]]; then
            ((count++))
            ip=$(ip addr show dev "$adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f1)
            echo "$count. $adapter: $ip"
        fi
    done
    echo ""
    read -p "Введіть номер адаптера (від 1 до $count): " selected_index
    if ! [[ "$selected_index" =~ ^[0-9]+$ ]]; then
        echo "Помилка: Потрібно ввести число."
        exit 1
    fi

    if ((selected_index < 1 || selected_index > count)); then
        echo "Помилка: Некоректний номер адаптера."
        exit 1
    fi

    selected_adapter=$(echo "$adapters" | sed -n "${selected_index}p")
    ip=$(ip addr show dev "$selected_adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f1)
    mask=$(ip addr show dev "$selected_adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f2)
    gateway=$(ip route show dev "$selected_adapter" | grep "default via" | awk '{print $3}')

    echo "Інформація про мережний адаптер $selected_adapter:"
    echo "IP адреса: $ip"
    echo "Маска: $mask"
    echo "Шлюз: $gateway"
}

total_free_swap_end_ram() {
    free_output=$(free)
    free_ram=$(echo "$free_output" | awk '/^Mem:/ {print $4}')
    free_swap=$(echo "$free_output" | awk '/^Swap:/ {print $4}')
    free_swap_end_ram=$((free_ram / 1024 + free_swap / 1024))
    free_swap_end_ram_gb=$((free_swap_end_ram / 1024))
}

# Функція для додавання правил файерволу або iptables, add_firewall_rule 80
add_firewall_rule() {
    local port="$1"
    local success=0

    if command -v firewall-cmd &>/dev/null; then
        if systemctl is-active --quiet firewalld; then
            if ! firewall-cmd --zone=public --query-port="$port/tcp"; then
                firewall-cmd --zone=public --add-port="$port/tcp" --permanent
                firewall-cmd --reload
                echo "Порт $port відкрито у firewalld."
                success=1
            else
                echo "Порт $port вже відкрито у firewalld."
                success=1
            fi
        else
            echo "firewalld не запущений або не встановлений. Якщо інший firewall встановлений, то відкрию порти у ньому."
        fi
    fi

    if command -v iptables &>/dev/null; then
        if ! iptables-save | grep "INPUT -p tcp -m tcp --dport $port -j ACCEPT\b"; then
            iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
            service iptables save
            echo "Порт $port відкрито у iptables."
            success=1
        else
            echo "Порт $port вже відкрито у iptables."
            success=1
        fi
    fi

    if command -v ufw &>/dev/null; then
        if ! ufw status | grep "$port/tcp"; then
            ufw allow "$port/tcp"
            echo "Порт $port відкрито у ufw."
            success=1
        else
            echo "Порт $port вже відкрито у ufw."
            success=1
        fi
    fi

    if [ "$success" -eq 0 ]; then
        echo "Помилка: файервол не встановлено або невідомий. Перевірте порт '$port' перед використанням"
        exit 1
    fi
}

# Функція для видалення правил з файервола та таблиці iptables, remove_firewall_rule 80
remove_firewall_rule() {
    local port="$1"
    local success=0

    if command -v firewall-cmd &>/dev/null; then
        if systemctl is-active --quiet firewalld; then
            if firewall-cmd --zone=public --query-port="$port/tcp"; then
                firewall-cmd --zone=public --remove-port="$port/tcp" --permanent
                firewall-cmd --reload
                echo "Правило для порту $port видалено з firewalld."
                success=1
            else
                echo "Правило для порту $port відсутнє у firewalld."
                success=1
            fi
        else
            echo "firewalld не запущений або не встановлений. Якщо інший firewall встановлений, то відкрию порти у ньому."
        fi
    fi

    if command -v iptables &>/dev/null; then
        if iptables-save | grep "INPUT -p tcp -m tcp --dport $port -j ACCEPT\b"; then
            iptables -D INPUT -p tcp --dport "$port" -j ACCEPT
            service iptables save
            echo "Правило для порту $port видалено з iptables."
            success=1
        else
            echo "Правило для порту $port відсутнє у таблиці iptables."
            success=1
        fi
    fi

    if command -v ufw &>/dev/null; then
        if ufw status | grep "$port/tcp"; then
            ufw delete allow "$port/tcp"
            echo "Правило для порту $port видалено з ufw."
            success=1
        else
            echo "Правило для порту $port відсутнє у ufw."
            success=1
        fi
    fi

    if [ "$success" -eq 0 ]; then
        echo "Помилка: файервол не встановлено або невідомий."
        exit 1
    fi
}

# Генерація випадкових 16 символів 
generate_random_part_16() {
    echo "$(head /dev/urandom | tr -dc 'a-z' | head -c 16)"
}

# Функція для обрізання строки до 16 символів
trim_to_16() {
    echo "${1:0:16}"
}

trim_to_12() {
    echo "${1:0:12}"
}

# Функція для перевірки направлений домен на сервер
check_domain() { # check_domain "example.com"
    domain="$1"
    
    domain_ip=$(nslookup "$domain" | awk '/^Address: / { print $2 }')

    if [ "$domain_ip" == "$server_IP" ]; then
        echo "Домен $domain спрямований на цей сервер ($server_IP)"
        return 0
    else
        echo "Домен $domain не спрямований на цей сервер"
        return 1
    fi
}