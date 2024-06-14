# shellcheck disable=SC2148
# shellcheck disable=SC2154
function check_dependency() {
    local dependency_name=$1
    local package_name=$2

    if [[ -e /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
        debian | ubuntu | fedora | centos | oracle | arch | sysrescue | almalinux | rockylinux)
            operating_system="$ID"
            ;;
        *)
            echo "Схоже, ви не використовуєте цей інсталятор у системах Debian, Ubuntu, Fedora, CentOS, Oracle, AlmaLinux, Rocky Linux або Arch Linux. Ваша система: $ID"
            exit 1
            ;;
        esac
    else
        echo "Не вдалося визначити операційну систему."
        exit 1
    fi

    # Перевірка наявності залежності
    if ! command -v $dependency_name &>/dev/null; then
        echo -e "${RED}$dependency_name не встановлено. Встановлюємо...${RESET}"

        # Перевірка чи вже було виконано оновлення системи
        if ! $UPDATE_DONE; then
            case $operating_system in
            debian | ubuntu)
                apt-get update
                if ! apt-get install -y "$package_name"; then
                    echo -e "${RED}Не вдалося встановити $package_name. Будь ласка, встановіть його вручну.${RESET}"
                    exit 1
                fi
                ;;
            fedora)
                dnf update
                if ! dnf install -y "$package_name"; then
                    echo -e "${RED}Не вдалося встановити $package_name. Будь ласка, встановіть його вручну.${RESET}"
                    exit 1
                fi
                ;;
            centos | oracle | almalinux | rockylinux)
                yum update
                if ! yum install epel-release -y || ! yum install -y "$package_name"; then
                    echo -e "${RED}Не вдалося встановити $package_name. Будь ласка, встановіть його вручну.${RESET}"
                    exit 1
                fi
                ;;
            arch | sysrescue)
                pacman -Sy
                if ! pacman -Sy --noconfirm "$package_name"; then
                    echo -e "${RED}Не вдалося встановити $package_name. Будь ласка, встановіть його вручну.${RESET}"
                    exit 1
                fi
                ;;
            *)
                echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
                exit 1
                ;;
            esac

            UPDATE_DONE=true
        else
            case $operating_system in
            debian | ubuntu)
                if ! apt-get install -y "$package_name"; then
                    echo -e "${RED}Не вдалося встановити $package_name. Будь ласка, встановіть його вручну.${RESET}"
                    exit 1
                fi
                ;;
            fedora)
                if ! dnf install -y "$package_name"; then
                    echo -e "${RED}Не вдалося встановити $package_name. Будь ласка, встановіть його вручну.${RESET}"
                    exit 1
                fi
                ;;
            centos | oracle | almalinux | rockylinux)
                if ! yum install -y "$package_name"; then
                    echo -e "${RED}Не вдалося встановити $package_name. Будь ласка, встановіть його вручну.${RESET}"
                    exit 1
                fi
                ;;
            arch | sysrescue)
                if ! pacman -Sy --noconfirm "$package_name"; then
                    echo -e "${RED}Не вдалося встановити $package_name. Будь ласка, встановіть його вручну.${RESET}"
                    exit 1
                fi
                ;;
            *)
                echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
                exit 1
                ;;
            esac
        fi

        echo -e "${GREEN}$dependency_name успішно встановлено.${RESET}"
    else
        echo -e "${GREEN}$dependency_name вже встановлено.${RESET}"
    fi
}

install_package() {
    local package_name=$1

    case $operating_system in
    debian | ubuntu)
        if [ ! -x "$(command -v $package_name)" ]; then
            apt update && apt-get install -y $package_name || {
                echo -e "${RED}Не вдалося встановити ${YELLOW}$package_name${RESET}."
                return 1
            }
        else
            echo -e "$package_name вже встановлено в системі."
        fi
        ;;
    fedora)
        if [ ! -x "$(command -v $package_name)" ]; then
            dnf install -y $package_name || {
                echo -e "${RED}Не вдалося встановити ${YELLOW}$package_name${RESET}."
                return 1
            }
        else
            echo -e "$package_name вже встановлено в системі."
        fi
        ;;
    centos | oracle | almalinux | rockylinux)
        if [ ! -x "$(command -v $package_name)" ]; then
            yum install -y $package_name || {
                echo -e "${RED}Не вдалося встановити ${YELLOW}$package_name${RESET}."
                return 1
            }
        else
            echo -e "$package_name вже встановлено в системі."
        fi
        ;;
    arch | sysrescue)
        if [ ! -x "$(command -v $package_name)" ]; then
            pacman -Syu --noconfirm $package_name || {
                echo -e "${RED}Не вдалося встановити ${YELLOW}$package_name${RESET}."
                return 1
            }
        else
            echo -e "$package_name вже встановлено в системі."
        fi
        ;;
    *)
        echo -e "${RED}Не вдалося встановити ${YELLOW}$package_name${RED}. Спробуйте будь ласка, встановити його вручну.${RESET}"
        return 1
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

check_docker_availability() {
    # Перевіряємо, чи встановлений Docker
    if ! command -v docker &>/dev/null; then
        echo -e "\n${RED}Docker не встановлено у цій системі.${RESET}"
        read -p "Бажаєте встановити Docker? (y/n): " install_docker
        if [[ "$install_docker" =~ ^(yes|Yes|y|Y)$ ]]; then
            echo -e "${YELLOW}Встановлення Docker...${RESET}"
            curl -fsSL https://get.docker.com | sh
            sudo usermod -aG docker "$(whoami)"
        else
            echo -e "\n${RED}Встановлення Docker скасовано.${RESET}"
            return 1
        fi
    fi

    local docker_status=$(systemctl is-active docker)
    local active_status=""
    # Перевіряємо, чи Docker запущений
    if [ "$docker_status" != "active" ]; then
        echo -e "\n${RED}Docker не запущений. Запуск Docker...${RESET}"
        if sudo systemctl start docker; then
            echo "Команда sudo systemctl start docker виконана успішно."
        else
            echo "Помилка: Неможливо виконати команду sudo systemctl start docker."
            return 1
        fi
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
    return 0
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
        return 1
    fi
    echo "${cidr}"
}

get_public_interface() { #server_IPv4[0] selected_adapter mask gateway
    adapters=$(ip addr show | grep "^[0-9]" | awk '{print $2}' | sed 's/://')
    selected_adapter=""
    for adapter in $adapters; do
        adapter_ip=$(ip addr show dev "$adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f1)
        if [ "${adapter_ip}" == "${server_IPv4[0]}" ]; then
            selected_adapter="$adapter"
            break
        fi
    done
    if [ -z "$selected_adapter" ]; then
        echo "Не вдалося знайти адаптер з IP-адресою, яка відповідає результату команди hostname -i: ${server_IPv4[0]}"
        selected_adapter="none"
        mask="xx"
        gateway="xxx.xxx.xxx.xxx"
    else
        mask=$(ip addr show dev "$selected_adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f2)
        gateway=$(ip route show dev "$selected_adapter" | grep "default via" | awk '{print $3}')
    fi
}

get_selected_interface() { #server_IP selected_adapter mask gateway
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
        return 1
    fi

    if ((selected_index < 1 || selected_index > count)); then
        echo "Помилка: Некоректний номер адаптера."
        return 1
    fi

    selected_adapter=$(echo "$adapters" | sed -n "${selected_index}p")
    selected_ip_address=$(ip addr show dev "$selected_adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f1)
    selected_ip_mask=$(ip addr show dev "$selected_adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f2)
    selected_ip_gateway=$(ip route show dev "$selected_adapter" | grep "default via" | awk '{print $3}')

    echo "Інформація про мережний адаптер $selected_adapter:"
    echo "IP адреса: $selected_ip_address"
    echo "Маска: $selected_ip_mask"
    echo "Шлюз: $selected_ip_gateway"
}

total_free_swap_end_ram() {
    free_swap_end_ram_mb=$(free -mt | awk '/^Total:/ {print $4}')
    free_swap_end_ram_gb=$(echo "scale=2; $free_swap_end_ram_mb / 1024" | bc)
}

# Функція для виведння розміру обраного диска або розділа
calculate_size() {
    local device=$1
    local size=$(lsblk -b $device | awk 'END {print int($4/1024/1024)}')

    if ((size > 1024)); then
        echo -e "${YELLOW}$((size / 1024)) GB${RESET}"
    else
        echo -e "${YELLOW}$size MB${RESET}"
    fi
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
        return 1
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
        return 1
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

trim_to_10() {
    echo "${1:0:10}"
}

# Функція для перевірки направлений домен на сервер
check_domain() { # check_domain "example.com"
    domain="$1"

    domain_ip=$(nslookup "$domain" | awk '/^Address: / { print $2 }')

    if [ "${domain_ip}" == "${server_IPv4[0]}" ]; then
        echo "Домен $domain спрямований на цей сервер (${server_IPv4[0]})"
        return 0
    else
        echo "Домен $domain не спрямований на цей сервер"
        return 1
    fi
}

# Функція для вибору диска та розділу
select_disk_and_partition() {
    # Виведення списку дисків та їх розділів
    disks=($(fdisk -l | grep -o '^Disk /[^:]*' | cut -d ' ' -f 2))
    for ((i = 0; i < ${#disks[@]}; i++)); do
        echo "$(($i + 1)). ${disks[$i]} - $(calculate_size ${disks[$i]})"
        partitions=($(fdisk -l ${disks[$i]} | awk '$1 ~ /\/dev\/[a-z]+[0-9]+$/ {print $1}'))
        for partition in "${partitions[@]}"; do
            echo "   └─ ${partition} - $(calculate_size ${partition})"
        done
    done

    # Запит користувача на вибір диска
    read -p "Оберіть диск: " disk_choice

    # Перевірка на правильний ввід користувача
    if ! [[ "$disk_choice" =~ ^[0-9]+$ ]]; then
        echo "Невірний ввід. Будь ласка, введіть номер диска."
        return 1
    fi

    # Перевірка на існування обраного диска
    if ((disk_choice < 1 || disk_choice > ${#disks[@]})); then
        echo "Невірний вибір. Будь ласка, виберіть правильний номер зі списку."
        return 1
    fi

    selected_disk=${disks[$((disk_choice - 1))]}

    # Виведення обраного диска
    echo "Обраний диск: $selected_disk ($(calculate_size $selected_disk))"

    # Виведення списку розділів обраного диска
    partitions=($(fdisk -l $selected_disk | grep -o '^/dev/[^[:space:]]*'))
    if [ ${#partitions[@]} -eq 0 ]; then
        echo "На цьому диску немає розділів."
        selected_partition=$selected_disk
    else
        for ((i = 0; i < ${#partitions[@]}; i++)); do
            echo "$(($i + 1)). ${partitions[$i]} - $(calculate_size ${partitions[$i]})"
        done

        # Запит користувача на вибір розділу
        read -p "Оберіть розділ (або натисніть Enter, щоб пропустити): " partition_choice

        if [[ -z "$partition_choice" ]]; then
            selected_partition=$selected_disk
        else
            # Перевірка на правильний ввід користувача
            if ! [[ "$partition_choice" =~ ^[0-9]+$ ]]; then
                echo "Невірний ввід. Будь ласка, введіть номер розділу."
                return 1
            fi

            # Перевірка на існування обраного розділу
            if ((partition_choice < 1 || partition_choice > ${#partitions[@]})); then
                echo "Невірний вибір. Будь ласка, виберіть правильний номер зі списку."
                return 1
            fi

            selected_partition=${partitions[$((partition_choice - 1))]}
        fi
    fi

    # Виведення обраного диска та розділу
    echo "Обраний розділ: $selected_partition ($(calculate_size $selected_partition))"
}

# Функція для валідації домену
validate_domain() {
    local domain=$1

    # Регулярний вираз для валідації доменного імені
    local regex="^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$"

    if [[ $domain =~ $regex ]]; then
        return 0
    else
        return 1
    fi
}