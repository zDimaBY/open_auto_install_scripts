#!/bin/bash -n
# shellcheck disable=SC2148,SC2154
function check_dependency() {
    local dependency_name=$1
    local package_name=$2

    if [[ -e /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
        debian | ubuntu | fedora | centos | oracle | arch | sysrescue | almalinux)
            operating_system="$ID"
            ;;
        *)
            echo "${MSG_ERROR_INFO_UNSUPPORTED_OS}$ID"
            exit 1
            ;;
        esac
    else
        echo "$MSG_ERROR_OS_DETECTION_FAILED"
        exit 1
    fi

    # Перевірка наявності залежності
    if ! command -v $dependency_name &>/dev/null; then
        echo -e "${RED}${dependency_name}${MSG_DEPENDENCY_NOT_INSTALLED}${RESET}"

        # Перевірка чи вже було виконано оновлення системи
        if ! $UPDATE_DONE; then
            case $operating_system in
            debian | ubuntu)
                apt-get update
                if ! apt-get install -y "$package_name"; then
                    echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$package_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                    exit 1
                fi
                ;;
            fedora)
                dnf update
                if ! dnf install -y "$package_name"; then
                    echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$package_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                    exit 1
                fi
                ;;
            centos | oracle | almalinux | rocky)
                yum update
                if ! yum install epel-release -y || ! yum install -y "$package_name"; then
                    echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$package_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                    exit 1
                fi
                ;;
            arch | sysrescue)
                pacman -Sy
                if ! pacman -Sy --noconfirm "$package_name"; then
                    echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$package_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                    exit 1
                fi
                ;;
            *)
                echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$dependency_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                exit 1
                ;;
            esac

            UPDATE_DONE=true
        else
            case $operating_system in
            debian | ubuntu)
                if ! apt-get install -y "$package_name"; then
                    echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$package_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                    exit 1
                fi
                ;;
            fedora)
                if ! dnf install -y "$package_name"; then
                    echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$package_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                    exit 1
                fi
                ;;
            centos | oracle | almalinux | rocky)
                if ! yum install -y "$package_name"; then
                    echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$package_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                    exit 1
                fi
                ;;
            arch | sysrescue)
                if ! pacman -Sy --noconfirm "$package_name"; then
                    echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$package_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                    exit 1
                fi
                ;;
            *)
                echo -e "${RED}${MSG_ERROR_INSTALL_FAILED}$dependency_name. ${MSG_ERROR_MANUAL_INSTALL_REQUIRED}${RESET}"
                exit 1
                ;;
            esac
        fi

        echo -e "${GREEN}${dependency_name}${MSG_DEPENDENCY_SUCCESSFULLY_INSTALLED}${RESET}"
    else
        echo -e "${GREEN}${dependency_name}${MSG_DEPENDENCY_INSTALLED}${RESET}"
    fi
}

function install_package() {
    local package_name=$1
    local command_name=${2:-$package_name} # Використовуємо ім'я пакету, якщо ім'я команди не вказано

    case $operating_system in
    debian | ubuntu)
        if [ ! -x "$(command -v $command_name)" ]; then
            apt-get install -y $package_name || {
                echo -e "${RED}${MSG_PACKAGE_INSTALL_FAILED}${YELLOW}$package_name${RESET}."
                return 1
            }
        else
            echo -e "${GREEN}$command_name${MSG_PACKAGE_ALREADY_INSTALLED}${RESET}"
        fi
        ;;
    fedora)
        if [ ! -x "$(command -v $command_name)" ]; then
            dnf install -y $package_name || {
                echo -e "${RED}${MSG_PACKAGE_INSTALL_FAILED}${YELLOW}$package_name${RESET}."
                return 1
            }
        else
            echo -e "${GREEN}$command_name${MSG_PACKAGE_ALREADY_INSTALLED}${RESET}"
        fi
        ;;
    centos | oracle | almalinux | rocky)
        if [ ! -x "$(command -v $command_name)" ]; then
            yum install -y $package_name || {
                echo -e "${RED}${MSG_PACKAGE_INSTALL_FAILED}${YELLOW}$package_name${RESET}."
                return 1
            }
        else
            echo -e "${GREEN}$command_name${MSG_PACKAGE_ALREADY_INSTALLED}${RESET}"
        fi
        ;;
    arch | sysrescue)
        if [ ! -x "$(command -v $command_name)" ]; then
            pacman -Syu --noconfirm $package_name || {
                echo -e "${RED}${MSG_PACKAGE_INSTALL_FAILED}${YELLOW}$package_name${RESET}."
                return 1
            }
        else
            echo -e "${GREEN}$command_name${MSG_PACKAGE_ALREADY_INSTALLED}${RESET}"
        fi
        ;;
    *)
        echo -e "${RED}${MSG_PACKAGE_INSTALL_TRY_MANUAL}${YELLOW}$package_name${RED}. ${MSG_PACKAGE_INSTALL_MANUAL_PROMPT}${RESET}"
        return 1
        ;;
    esac
}

function generate_random_password_show() {
    rand_password=$(openssl rand -base64 12)
    echo -e "\n${MSG_GENERATED_RANDOM_PASSWORD} ${RED}$rand_password${RESET}"
}

generate_random_password() {
    rand_password=$(openssl rand -base64 12)
}

function check_docker_availability() {
    # Перевіряємо, чи встановлений Docker
    if ! command -v docker &>/dev/null; then
        echo -e "\n${RED}${MSG_DOCKER_NOT_INSTALLED_THIS}${RESET}"
        read -p "${MSG_PROMPT_INSTALL_DOCKER}" install_docker
        if [[ "$install_docker" =~ ^(yes|Yes|y|Y)$ ]]; then
            echo -e "${YELLOW}${MSG_INSTALLING_DOCKER}${RESET}"
            curl -fsSL https://get.docker.com | sh
            sudo usermod -aG docker "$(whoami)"
        else
            echo -e "\n${RED}${MSG_DOCKER_INSTALLATION_CANCELED}${RESET}"
            return 1
        fi
    fi

    local docker_status=$(systemctl is-active docker)
    local active_status=""
    # Перевіряємо, чи Docker запущений
    if [ "$docker_status" != "active" ]; then
        echo -e "\n${RED}${MSG_DOCKER_NOT_STARTED}${RESET}"
        if sudo systemctl start docker; then
            echo "${MSG_DOCKER_START_SUCCESS}"
        else
            echo "${MSG_DOCKER_START_FAILED}"
            return 1
        fi
        active_status=$(systemctl status docker | grep "Active:")
    else
        active_status=$(systemctl status docker | grep "Active:")
    fi

    # Перевіряємо, чи Docker доданий до автозапуску
    if systemctl is-enabled docker &>/dev/null; then
        echo -e "\n${YELLOW}${MSG_DOCKER_ALREADY_AUTOSTART}${RESET}"
    else
        systemctl enable docker
        if systemctl is-enabled docker &>/dev/null; then
            echo -e "\n${GREEN}${MSG_DOCKER_ADDED_AUTOSTART}${RESET}"
        else
            echo -e "\n${RED}${MSG_DOCKER_FAILED_AUTOSTART}${RESET}"
        fi
    fi

    echo -e "\n${YELLOW}${MSG_DOCKER_STATUS}${RESET}\n${GREEN}$active_status${RESET}"
    return 0
}

function create_folder() {
    path="$1"
    if [ -d "$path" ]; then
        echo -e "${YELLOW}${MSG_FOLDER_ALREADY_EXISTS} ${path}.${RESET}"
    else
        mkdir -p "$path"
        echo -e "${GREEN}${MSG_FOLDER_CREATED} ${path}.${RESET}"
    fi
}

function copy_file_from_container() {
    local container_name="$1"
    local file_path="$2"
    local target_directory="$3"

    while ! docker exec "$container_name" test -e "$file_path"; do
        echo "${MSG_WAITING_FOR_FILE} $file_path in container $container_name..."
        sleep 5
    done

    docker cp "$container_name":"$file_path" "$target_directory"
    echo "${MSG_FILE_COPIED} $file_path to $target_directory"
}


function mask_to_cidr() { # cidr
    local IFS=.
    read -r i1 i2 i3 i4 <<<"$1"
    local binary=$(echo "obase=2;$i1*256*256*256+$i2*256*256+$i3*256+$i4" | bc)
    local cidr=$(echo -n "${binary}" | tr -d 0 | wc -c)
    if [ "$cidr" -eq 0 ]; then
        echo "$MSG_INVALID_SUBNET_MASK"
        return 1
    fi
    echo "${cidr}"
}

function get_public_interface() { #server_IPv4[0] selected_adapter mask gateway
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
        echo "${MSG_NO_ADAPTER_FOUND} ${server_IPv4[0]}"
        selected_adapter="none"
        mask="xx"
        gateway="xxx.xxx.xxx.xxx"
    else
        mask=$(ip addr show dev "$selected_adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f2)
        gateway=$(ip route show dev "$selected_adapter" | grep "default via" | awk '{print $3}')
    fi
}

function get_selected_interface() { #server_IP selected_adapter mask gateway
    adapters=$(ip addr show | grep "^[0-9]" | awk '{print $2}' | sed 's/://')
    echo "$MSG_SELECT_NETWORK_ADAPTER"
    count=0
    for adapter in $adapters; do
        if [[ $adapter != veth* && $adapter != br-* ]]; then
            ((count++))
            ip=$(ip addr show dev "$adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f1)
            echo "$count. $adapter: $ip"
        fi
    done
    echo ""
    read -p "$MSG_ENTER_ADAPTER_NUMBER $count): " selected_index
    if ! [[ "$selected_index" =~ ^[0-9]+$ ]]; then
        echo "$MSG_ERROR_NOT_A_NUMBER"
        return 1
    fi

    if ((selected_index < 1 || selected_index > count)); then
        echo "$MSG_ERROR_INVALID_ADAPTER_NUMBER"
        return 1
    fi

    selected_adapter=$(echo "$adapters" | sed -n "${selected_index}p")
    selected_ip_address=$(ip addr show dev "$selected_adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f1)
    selected_ip_mask=$(ip addr show dev "$selected_adapter" | grep "inet " | awk '{print $2}' | cut -d'/' -f2)
    selected_ip_gateway=$(ip route show dev "$selected_adapter" | grep "default via" | awk '{print $3}')

    echo "$MSG_ADAPTER_INFO $selected_adapter:"
    echo "$MSG_IP_ADDRESS $selected_ip_address"
    echo "$MSG_SUBNET_MASK $selected_ip_mask"
    echo "$MSG_GATEWAY $selected_ip_gateway"
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
function add_firewall_rule() {
    local port="$1"
    local success=0

    if command -v firewall-cmd &>/dev/null; then
        if systemctl is-active --quiet firewalld; then
            if ! firewall-cmd --zone=public --query-port="$port/tcp" &>/dev/null; then
                firewall-cmd --zone=public --add-port="$port/tcp" --permanent
                firewall-cmd --reload
                echo -e "${MSG_PORT}${port} ${MSG_FIREWALLD_NOT_RUNNING_PART1}"
                success=1
            else
                echo -e "${MSG_PORT}${port} ${MSG_FIREWALLD_NOT_RUNNING_PART1}"
                success=1
            fi
        else
            echo -e "${MSG_FIREWALLD_NOT_RUNNING_PART1}"
        fi
    fi

    if command -v iptables &>/dev/null; then
        if ! iptables-save | grep "INPUT -p tcp -m tcp --dport $port -j ACCEPT\b"; then
            iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
            service iptables save
            echo "Порт $port відкрито у iptables."
            success=1
        else
            echo -e "${MSG_PORT}${port} ${MSG_IPTABLES_NOT_INSTALLED_PART1}"
            success=1
        fi
    fi

    if command -v ufw &>/dev/null; then
        if ! ufw status | grep "$port/tcp" &>/dev/null; then
            ufw allow "$port/tcp"
            echo -e "${MSG_PORT}${port} ${MSG_UFW_NOT_INSTALLED_PART1}"
            success=1
        else
            echo -e "${MSG_PORT}${port} ${MSG_UFW_NOT_INSTALLED_PART1}"
            success=1
        fi
    fi

    if [ "$success" -eq 0 ]; then
        echo -e "${MSG_FIREWALL_NOT_INSTALLED_PART1}${port}"
        return 1
    fi
}

# Функція для видалення правил з файервола та таблиці iptables, remove_firewall_rule 80
function remove_firewall_rule() {
    local port="$1"
    local success=0

    if command -v firewall-cmd &>/dev/null; then
        if systemctl is-active --quiet firewalld; then
            if firewall-cmd --zone=public --query-port="$port/tcp"; then
                firewall-cmd --zone=public --remove-port="$port/tcp" --permanent
                firewall-cmd --reload
                echo -e "${MSG_RULE_FOR_PORT}${port} ${MSG_FIREWALLD_NOT_RUNNING_PART2}"
                success=1
            else
                echo -e "${MSG_RULE_FOR_PORT}${port} ${MSG_FIREWALLD_NOT_RUNNING_PART2}"
                success=1
            fi
        else
            echo -e "${MSG_FIREWALLD_NOT_RUNNING_PART2}"
        fi
    fi
    
    if command -v iptables &>/dev/null; then
        if iptables-save | grep "INPUT -p tcp -m tcp --dport $port -j ACCEPT\b"; then
            iptables -D INPUT -p tcp --dport "$port" -j ACCEPT
            service iptables save
            echo -e "${MSG_RULE_FOR_PORT}${port} ${MSG_IPTABLES_NOT_INSTALLED_PART2}"
            success=1
        else
            echo -e "${MSG_RULE_FOR_PORT}${port} ${MSG_IPTABLES_NOT_INSTALLED_PART2}"
            success=1
        fi
    fi

    if command -v ufw &>/dev/null; then
        if ufw status | grep "$port/tcp"; then
            ufw delete allow "$port/tcp"
            echo -e "${MSG_RULE_FOR_PORT}${port} ${MSG_UFW_NOT_INSTALLED_PART2}"
            success=1
        else
            echo -e "${MSG_RULE_FOR_PORT}${port} ${MSG_UFW_NOT_INSTALLED_PART2}"
            success=1
        fi
    fi

    if [ "$success" -eq 0 ]; then
        echo -e "${MSG_FIREWALL_NOT_INSTALLED_PART2}"
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
function check_domain() { # check_domain "example.com"
    domain="$1"

    domain_ip=$(nslookup "$domain" | awk '/^Address: / { print $2 }')

    if [ "${domain_ip}" == "${server_IPv4[0]}" ]; then
        echo -e "${MSG_DOMAIN_POINTED}${domain}${MSG_DOMAIN_TARGET_SERVER}${server_IPv4[0]})"
        return 0
    else
        echo -e "${MSG_DOMAIN_POINTED}${domain}${MSG_DOMAIN_NOT_TARGET_SERVER}"
        return 1
    fi
}

# Функція для вибору диска та розділу
function select_disk_and_partition() {
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
    read -p "${MSG_SELECT_DISK} " disk_choice

    # Перевірка правильності вводу користувача
    if ! [[ "$disk_choice" =~ ^[0-9]+$ ]]; then
        echo "${MSG_INVALID_INPUT_DISK}"
        return 1
    fi

    # Перевірка існування обраного диска
    if ((disk_choice < 1 || disk_choice > ${#disks[@]})); then
        echo "${MSG_INVALID_CHOICE_DISK}"
        return 1
    fi

    selected_disk=${disks[$((disk_choice - 1))]}

    # Виведення інформації про обраний диск
    echo "${MSG_SELECTED_DISK}${selected_disk} ($(calculate_size $selected_disk))"

    # Виведення списку розділів обраного диска
    partitions=($(fdisk -l $selected_disk | grep -o '^/dev/[^[:space:]]*'))
    if [ ${#partitions[@]} -eq 0 ]; then
        echo "${MSG_NO_PARTITIONS}"
        selected_partition=$selected_disk
    else
        for ((i = 0; i < ${#partitions[@]}; i++)); do
            echo "$(($i + 1)). ${partitions[$i]} - $(calculate_size ${partitions[$i]})"
        done

        # Запит користувача на вибір розділу
        read -p "${MSG_SELECT_PARTITION} " partition_choice

        if [[ -z "$partition_choice" ]]; then
            selected_partition=$selected_disk
        else
            # Перевірка правильності вводу користувача
            if ! [[ "$partition_choice" =~ ^[0-9]+$ ]]; then
                echo "${MSG_INVALID_INPUT_PARTITION}"
                return 1
            fi

            # Перевірка існування обраного розділу
            if ((partition_choice < 1 || partition_choice > ${#partitions[@]})); then
                echo "${MSG_INVALID_CHOICE_PARTITION}"
                return 1
            fi

            selected_partition=${partitions[$((partition_choice - 1))]}
        fi
    fi

    # Виведення інформації про обраний розділ
    echo "${MSG_SELECTED_PARTITION}${selected_partition} ($(calculate_size $selected_partition))"
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

load_and_check_script() {
    local url="$1"

    # Перевірка наявності wget або curl та завантаження скрипта
    if command -v curl &>/dev/null; then
        if curl -L --max-time 1 -s "$url" >/dev/null 2>&1; then
            return 0
        fi
    elif command -v wget &>/dev/null; then
        if wget --max-redirect=10 --timeout=1 -qO- "$url" >/dev/null 2>&1; then
            return 0
        fi
    else
        return 1
    fi
    return 1
}

statistics_scripts() {
    load_and_check_script "https://statistics.zdimaby.pp.ua/increment.php?counter=$1"
}

function get_latest_files_url() {
    local repo_url="$1"
    local file_types="$2"

    # Формуємо URL для отримання останнього релізу
    local api_url="${repo_url}/releases/latest"
    local release_data=$(curl -s "$api_url")
    
    # Перевіряємо, чи JSON-дані не порожні
    if [ -z "$release_data" ]; then
        echo -e "${RED}Не вдалося отримати дані релізу з ${repo_url}${RESET}"
        return 1
    fi

    # Формуємо jq вираз для пошуку необхідних типів файлів
    local jq_filter=$(echo "$file_types" | tr ',' '|' | sed 's/\./\\./g')  # Конвертуємо список типів у формат для jq
    local jq_expression=".assets[] | select(.name | test(\"(${jq_filter})$\")) | .browser_download_url"

    # Отримуємо URL для всіх файлів з вказаними розширеннями
    local file_urls=$(echo "$release_data" | jq -r "$jq_expression")

    # Перевіряємо, чи URL не порожній
    if [ -z "$file_urls" ]; then
        echo -e "${RED}Не вдалося знайти файли типу ${file_types} у релізах ${repo_url}${RESET}"
        return 1
    fi

    # Виводимо всі URL
    echo "$file_urls" | while read -r url; do
        print_color_message 135 206 235 "$url"
    done

    return 0
}