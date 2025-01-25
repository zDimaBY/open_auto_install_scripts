#!/bin/bash -n
# shellcheck disable=SC2148,SC2154
# Функція для перевірки та встановлення пакетів
function check_and_install_dependencies() {
    local dependencies=("$@")  # Приймаємо пакети як аргументи
    local missing_packages=()    # Масив для зберігання відсутніх пакетів

    # Перевіряємо кожну залежність
    for dependency in "${dependencies[@]}"; do
        # Отримуємо команду і назву пакета
        command_name=$(echo "$dependency" | awk '{print $1}')
        package_name=$(echo "$dependency" | awk '{print $2}')
        
        # Перевірка наявності залежності
        if ! command -v "$command_name" &>/dev/null; then
            echo -e "${RED}${command_name}${MSG_DEPENDENCY_NOT_INSTALLED}${RESET}"
            missing_packages+=("$package_name")  # Додаємо пакет до списку відсутніх
        else
            echo -e "${GREEN}${command_name}${MSG_DEPENDENCY_INSTALLED}${RESET}"
        fi
    done

    # Якщо є відсутні пакети, запитуємо користувача про встановлення
    if [ ${#missing_packages[@]} -gt 0 ]; then
        echo -e "\n${MSG_MISSING_PACKAGES}"
        for pkg in "${missing_packages[@]}"; do
            echo "- $pkg"
        done

        read -p "${MSG_INSTALL_PROMPT}" answer

        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            case $operating_system in
                debian | ubuntu)
                    sudo apt-get update
                    sudo apt-get install -y "${missing_packages[@]}"
                    ;;
                fedora)
                    sudo dnf install -y "${missing_packages[@]}"
                    ;;
                centos | oracle | almalinux | rocky)
                    sudo yum install -y "${missing_packages[@]}"
                    ;;
                arch | sysrescue)
                    sudo pacman -Sy --noconfirm "${missing_packages[@]}"
                    ;;
                *)
                    echo -e "${RED}${MSG_UNSUPPORTED_INSTALL_METHOD}${RESET}"
                    exit 1
                    ;;
            esac

            echo -e "${GREEN}${MSG_ALL_PACKAGES_SUCCESSFULLY_INSTALLED}${RESET}"
        else
            echo "${MSG_INSTALLATION_CANCELLED}"
        fi
    else
        echo "${MSG_ALL_PACKAGES_INSTALLED}"
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

# Функція для перевірки наявності панелей керування
check_info_control_panel_for_functions() { 
    for panel_dir in "${all_control_panels[@]}"; do
        if [ -d "$panel_dir" ]; then
            case $panel_dir in
            "/usr/local/hestia")
                echo "hestia"
                return 0
                ;;
            "/usr/local/vesta")
                echo "vesta"
                return 0
                ;;
            "/usr/local/mgr5")
                echo "mgr5"
                return 0
                ;;
            "/usr/local/cpanel")
                echo "cpanel"
                return 0
                ;;
            "/usr/local/fastpanel2")
                echo "fastpanel2"
                return 0
                ;;
            "/usr/local/brainycp")
                echo "brainycp"
                return 0
                ;;
            "/www/server/panel/BTPanel/")
                echo "BTPanel"
                return 0
                ;;
            "/usr/local/CyberCP/")
                echo "CyberCP"
                return 0
                ;;
            "/usr/local/CyberPanel/")
                echo "CyberPanel"
                return 0
                ;;
            esac
            return
        fi
    done
    return 1  # Повертає 1, якщо жодна панель не знайдена
}

# Функція для генерації випадкового пароля та виведення його на екран
function generate_random_password_show() {
    local length=${1:-12} # Довжина пароля (за замовчуванням 12 символів)
    rand_password=$(openssl rand -base64 $((length * 3 / 4)) | cut -c1-"$length")
    echo -e "\n${MSG_GENERATED_RANDOM_PASSWORD} ${RED}$rand_password${RESET}"
}

# Функція для генерації випадкового пароля без виведення
function generate_random_password() {
    local length=${1:-12} # Довжина пароля (за замовчуванням 12 символів)
    rand_password=$(openssl rand -base64 $((length * 3 / 4)) | cut -c1-"$length")
}

# Функція для генерації випадкових символів a-z заданої довжини
function generate_random_part() {
    local length=${1:-16} # Довжина пароля (за замовчуванням 16 символів)
    echo "$(head /dev/urandom | tr -dc 'a-z' | head -c "$length")"
}

# Функція для обрізання строки до 16 символів
function trim_to_16() {
    echo "${1:0:16}"
}

function trim_to_10() {
    echo "${1:0:10}"
}

function install_docker() {
    echo -e "${YELLOW}${MSG_INSTALLING_DOCKER}${RESET}"
    if curl -fsSL https://get.docker.com | sh &>/dev/null; then
        echo -e "${GREEN}${MSG_DOCKER_INSTALLATION_SUCCESS}${RESET}"
        if ! sudo usermod -aG docker "$(whoami)" &>/dev/null; then
            echo -e "${RED}${MSG_DOCKER_ADD_GROUP_FAILED}${RESET}"
            return 1
        fi
    else
        echo -e "${RED}${MSG_DOCKER_INSTALLATION_FAILED}${RESET}"
        return 1
    fi
}

function check_docker_availability() {
    # Перевірка наявності Docker
    if ! command -v docker &>/dev/null; then
        echo -e "\n${RED}${MSG_DOCKER_NOT_INSTALLED_THIS}${RESET}"
        read -p "${MSG_PROMPT_INSTALL_DOCKER}" install_docker_prompt
        if [[ "$install_docker_prompt" =~ ^(yes|Yes|y|Y)$ ]]; then
            install_docker
        else
            echo -e "\n${RED}${MSG_DOCKER_INSTALLATION_CANCELED}${RESET}"
            return 1
        fi
    fi

    # Перевірка статусу Docker
    if ! systemctl is-active --quiet docker; then
        echo -e "\n${RED}${MSG_DOCKER_NOT_STARTED}${RESET}"
        if sudo systemctl start docker; then
            echo -e "${GREEN}${MSG_DOCKER_START_SUCCESS}${RESET}"
        else
            echo -e "${RED}${MSG_DOCKER_START_FAILED}${RESET}"
            return 1
        fi
    fi

    # Автозапуск Docker
    if ! systemctl is-enabled --quiet docker; then
        sudo systemctl enable docker
        if systemctl is-enabled --quiet docker; then
            echo -e "\n${GREEN}${MSG_DOCKER_ADDED_AUTOSTART}${RESET}"
        else
            echo -e "\n${RED}${MSG_DOCKER_FAILED_AUTOSTART}${RESET}"
        fi
    else
        echo -e "\n${YELLOW}${MSG_DOCKER_ALREADY_AUTOSTART}${RESET}"
    fi

    # Виведення статусу Docker
    echo -e "\n${YELLOW}${MSG_DOCKER_STATUS}${RESET}"
    echo -e "${GREEN}$(systemctl status docker | grep "Active:")${RESET}"
}

function create_folder() {
    local path="$1"
    if [ -d "$path" ]; then
        echo -e "${YELLOW}${MSG_FOLDER_ALREADY_EXISTS}: ${path}${RESET}"
        return 1  # Папка вже існує
    else
        mkdir -p "$path" && echo -e "${GREEN}${MSG_FOLDER_CREATED}: ${path}${RESET}"
        return 0  # Папка створена
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
    free_swap_end_ram_gb=$(awk -v mb="$free_swap_end_ram_mb" 'BEGIN { printf "%.2f", mb / 1024 }')
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

# Функція для пошуку випадкового вільного порту в заданому діапазоні
find_random_free_port() {
    local min_port=$1
    local max_port=$2
    local random_port

    # Функція для перевірки, чи порт зайнятий
    is_port_used() {
        local port=$1
        (echo > /dev/tcp/127.0.0.1/$port) &>/dev/null
        return $?  # 0 - порт зайнятий, 1 - порт вільний
    }

    while true; do
        # Генеруємо випадковий порт у вказаному діапазоні
        random_port=$(shuf -i $min_port-$max_port -n 1)

        # Перевіряємо, чи порт вільний
        if ! is_port_used $random_port; then
            echo "$random_port"  # Виводимо вільний порт
            return
        fi
    done
}

# Функція для додавання правил файерволу або iptables, add_firewall_rule 80
function add_firewall_rule() {
    local port="$1"
    local comment="$2"
    local success=0

    panel_name=$(check_info_control_panel_for_functions)

    if [ $? -eq 0 ]; then
        case $panel_name in
            "hestia")
                echo "Виявлено панель керування Hestia, додаю правило для $port"
                # Options: ACTION IP PORT [PROTOCOL] [COMMENT] [RULE]
                /usr/local/hestia/bin/v-add-firewall-rule "ACCEPT" "0.0.0.0/0" "$port" "tcp" "$comment"
                return 1
                ;;
            "vesta")
                echo "Виявлено панель керування Vesta, додаю правило для $port"
                # Options: ACTION IP PORT [PROTOCOL] [COMMENT] [RULE]
                /usr/local/vesta/bin/v-add-firewall-rule "ACCEPT" "0.0.0.0/0" "$port" "tcp" "$comment"
                return 1
                ;;
            "mgr5")
                echo "Виявлено панель керування: ISPmanager, відкрийте порт $port вручну у панелі керування."
                # Додаткові дії для ISPmanager
                return 1
                ;;
            "cpanel")
                echo "Виявлено панель керування: cPanel, відкрийте порт $port вручну у панелі керування."
                # Додаткові дії для cPanel
                return 1
                ;;
            "fastpanel2")
                echo "Виявлено панель керування: FastPanel, відкрийте порт $port вручну у панелі керування."
                # Додаткові дії для FastPanel
                return 1
                ;;
            "brainycp")
                echo "Виявлено панель керування: BrainyCP, відкрийте порт $port вручну у панелі керування."
                # Додаткові дії для BrainyCP
                return 1
                ;;
            "BTPanel")
                echo "Виявлено панель керування: BTPanel, відкрийте порт $port вручну у панелі керування."
                # Додаткові дії для BTPanel
                return 1
                ;;
            "CyberCP")
                echo "Виявлено панель керування: CyberCP, відкрийте порт $port вручну у панелі керування."
                # Додаткові дії для CyberCP
                return 1
                ;;
            "CyberPanel")
                echo "Виявлено панель керування: CyberPanel, відкрийте порт $port вручну у панелі керування."
                # Додаткові дії для CyberPanel
                return 1
                ;;
            *)
                echo "Не можу виявити панель керування. $panel_name додаю правила для порта $port у iptables"
                ;;
        esac
    else
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
                echo "${MSG_PORT} $port ${MSG_PORT_OPEN}"
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
    fi
}

# Функція для видалення правил з файервола та таблиці iptables
function remove_firewall_rule() {
    local port="$1"
    local success=0

    # Функція для видалення правила за портом у панелях Hestia та Vesta
    function delete_firewall_rule_by_port() {
        local target_port="$1"
        local rule_id

        # Знаходимо ID правила, пов'язаного з портом
        rule_id=$(v-list-firewall | awk -v port="$target_port" '$4 == port {print $1}')

        if [ -n "$rule_id" ]; then
            v-delete-firewall-rule "$rule_id"
            if [ $? -eq 0 ]; then
                # Виводимо повідомлення успішного видалення
                echo "$MSG_RULE_DELETED_PART1 $target_port $MSG_RULE_DELETED_PART2 $rule_id $MSG_RULE_DELETED_PART3"
                return 0
            else
                # Виводимо повідомлення про помилку видалення
                echo "$MSG_RULE_DELETE_FAILED_PART1 $rule_id $MSG_RULE_DELETE_FAILED_PART2"
                return 1
            fi
        else
            # Виводимо повідомлення про відсутність правила
            echo "$MSG_RULE_NOT_FOUND_PART1 $target_port $MSG_RULE_NOT_FOUND_PART2"
            return 1
        fi
    }

    panel_name=$(check_info_control_panel_for_functions)

    if [ $? -eq 0 ]; then
        case $panel_name in
            "hestia"|"vesta")
                echo "Виявлено панель керування: $panel_name"
                delete_firewall_rule_by_port "$port"
                return $?
                ;;
            "mgr5")
                echo "Виявлено панель керування: ISPmanager, видаліть відкритий порт "$port" у панелі керування."
                # Додаткові дії для ISPmanager
                return 1
                ;;
            "cpanel")
                echo "Виявлено панель керування: cPanel, видаліть відкритий порт "$port" у панелі керування."
                # Додаткові дії для cPanel
                return 1
                ;;
            "fastpanel2")
                echo "Виявлено панель керування: FastPanel, видаліть відкритий порт "$port" у панелі керування."
                # Додаткові дії для FastPanel
                return 1
                ;;
            "brainycp")
                echo "Виявлено панель керування: BrainyCP, видаліть відкритий порт "$port" у панелі керування."
                # Додаткові дії для BrainyCP
                return 1
                ;;
            "BTPanel")
                echo "Виявлено панель керування: BTPanel, видаліть відкритий порт "$port" у панелі керування."
                # Додаткові дії для BTPanel
                return 1
                ;;
            "CyberCP"|"CyberPanel")
                echo "Виявлено панель керування: $panel_name, видаліть відкритий порт "$port" у панелі керування."
                # Додаткові дії для CyberCP/CyberPanel
                return 1
                ;;
            *)
    
                ;;
        esac
    else

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
    fi
}

# Функція для перевірки направлений домен на сервер check_domain "example.com"
function check_domain() {
    domain="$1"
    
    # Перевірка для IPv4
    for ip in "${server_IPv4[@]}"; do
        domain_ips_v4=$(dig +short A "$domain")
        for domain_ip in $domain_ips_v4; do
            if [ "$domain_ip" == "$ip" ]; then
                echo -e "${GREEN}Домен ${domain} направлений на сервер за IPv4 (${ip}).${RESET}"
                return 0
            fi
        done
    done

    # Перевірка для IPv6
    for ip in "${server_IPv6[@]}"; do
        domain_ips_v6=$(dig +short AAAA "$domain")
        for domain_ip in $domain_ips_v6; do
            if [ "$domain_ip" == "$ip" ]; then
                echo -e "${GREEN}Домен ${domain} направлений на сервер за IPv6 (${ip}).${RESET}"
                return 0
            fi
        done
    done

    # Якщо жодна з IP-адрес не збігається
    echo -e "${RED}Домен ${domain} не направлений на сервер.${RESET}"
    return 1
}

# Функція для отримання NS-записів за допомогою dig та отримання NS-записів у ns_servers[@]
get_ns_records() {
    local domain=$1

    # Перевірка наявності інструменту dig
    if ! command -v dig &> /dev/null; then
        echo "Помилка: Інструмент dig не встановлено. Встановіть його для роботи скрипта."
        exit 1
    fi

    # Отримання NS-записів за допомогою dig
    echo "Отримання NS-записів для $domain за допомогою dig:"
    local result=$(dig NS $domain +noall +answer)

    if [ -z "$result" ]; then
        print_color_message 0 200 0 "ANSWER NS-записи не знайдено. ANSWER — це прямий результат запиту, який повертає точні записи NS для заданого домену."
        print_color_message 0 200 0 "Перевіряю секцію AUTHORITY. AUTHORITY — це вказівка на 'старшого' керуючого доменом (зазвичай для зон, які не мають явних записів)."
        result=$(dig $domain NS +noall +authority | awk '/SOA/ {print $5, $6}')
    fi

    # Якщо NS-записи знайдені
    if [ -n "$result" ]; then
        # Розділення записів на окремі рядки
        IFS=$' \n' read -r -a ns_servers <<< "$result"
        
        # Видалення крапки в кінці кожного NS-запису
        for i in "${!ns_servers[@]}"; do
            ns_servers[$i]=$(echo "${ns_servers[$i]}" | sed 's/\.$//')
        done
        
        print_color_message 255 255 255 "Знайдено NS-сервери:"
        
        # Виведення кожного NS окремо
        for ns in "${ns_servers[@]}"; do
            print_color_message 255 255 0 "$ns"
        done
    else
        print_color_message 255 0 0 "NS-записи не знайдено."
    fi
}

check_mail_domain_hestiaCP() { #для hestiaCP чи існує повна конфігурація домена.
    local domain=$1
    $CLI_dir/v-list-mail-domain $CONTROLPANEL_USER $domain > /dev/null 2>&1
    return $? # Повертає 0, якщо поштовий домен існує, і 1, якщо ні
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
    local release_data=$("$local_temp_curl_path" -s "$api_url")
    
    # Перевіряємо, чи JSON-дані не порожні
    if [ -z "$release_data" ]; then
        echo -e "${RED}${MSG_RELEASE_DATA_ERROR} ${repo_url}${RESET}"
        return 1
    fi

    # Формуємо jq вираз для пошуку необхідних типів файлів
    local jq_filter=$(echo "$file_types" | tr ',' '|' | sed 's/\./\\./g')  # Конвертуємо список типів у формат для jq
    local jq_expression=".assets[] | select(.name | test(\"(${jq_filter})$\")) | .browser_download_url"

    # Отримуємо URL для всіх файлів з вказаними розширеннями
    local file_urls=$(echo "$release_data" | "$local_temp_jq_path" -r "$jq_expression")

    # Перевіряємо, чи URL не порожній
    if [ -z "$file_urls" ]; then
        echo -e "${RED}${MSG_FILE_TYPES_ERROR} ${file_types} ${MSG_IN_RELEASES_FROM} ${repo_url}${RESET}"
        return 1
    fi

    # Виводимо всі URL
    echo "$file_urls" | while read -r url; do
        print_color_message 135 206 235 "$url"
    done

    return 0
}


remove_docker_container() { # Видалення контейнера
    local container_name="$1"
    local removal_message="$2"

    if [ -z "$container_name" ]; then
        echo "$MSG_ERROR_CONTAINER_NAME"
        return 1
    fi

    docker stop "$container_name" && docker rm "$container_name" > /dev/null 2>&1
    #docker rmi "$container_name"
    echo -e "${RED}${container_name} ${removal_message}${RESET}"
    docker ps -a
}

stop_docker_container() {
    local container_name="$1"
    local stop_message="$2"

    if [ -z "$container_name" ]; then
        echo "$MSG_ERROR_CONTAINER_NAME"
        return 1
    fi

    docker stop "$container_name" > /dev/null 2>&1

    echo -e "${RED}${container_name} ${stop_message}${RESET}"
    docker ps -a
}

function download_latest_tool() {
    local REPO=$1
    local TOOL_NAME=$2
    local TOOL_BINARY=$3

    # Отримуємо останню версію з GitHub API
    local latest_version=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep -oP '"tag_name": "\K[^"]+')

    # Перевірка, чи файл потребує формування з версією
    local temp_tool_folder_name="/tmp/tool_folder/${TOOL_NAME}"
    create_folder "$temp_tool_folder_name" > /dev/null 2>&1
    local local_temp_tool="$temp_tool_folder_name/$latest_version"

    # Використовуємо case для перевірки TOOL_BINARY і визначення шляху до файлу
    case "$TOOL_BINARY" in
        "wp-cli.phar")
            local version_number=${latest_version#v}
            TOOL_BINARY="wp-cli-${version_number}.phar"
            ;;
    esac

    # Завантажуємо бінарний файл
    curl -sL "https://github.com/$REPO/releases/download/${latest_version}/${TOOL_BINARY}" -o "$local_temp_tool"
    chmod +x "$local_temp_tool"

    # Якщо local_temp_tool є директорією, перевіряємо ліміти запитів до GitHub і виходимо зі скрипта
    if [ -d "$local_temp_tool" ]; then
        # Перевіряємо ліміти запитів до GitHub
        local rate_limit_info=$(curl -sI "https://api.github.com/rate_limit")
        local remaining_requests=$(echo "$rate_limit_info" | grep -i "X-RateLimit-Remaining" | awk '{print $2}' | tr -d '\r')

        if [ "$remaining_requests" -le 0 ]; then
            echo "Ліміт запитів до GitHub API перевищено. Завершення роботи скрипта."
            echo "Запити до GitHub API: $remaining_requests залишилось."
            exit 1
        fi
        
        # Виходимо зі скрипта, якщо $local_temp_tool є директорією
        echo "$local_temp_tool є директорією. Завершення скрипта."
        exit 0
    fi

    echo "$local_temp_tool"  # Повертаємо тільки шлях до бінарного файлу
}

# Функція для оновлення налаштувань x-ui
function update_xui_settings() {
    local username="$1"
    local password="$2"
    local port="$3"
    local web_base_path="$4"
    local container_x_ui="$5"

    # Оновлення імені користувача та пароля
    if docker exec -it $container_x_ui /app/x-ui setting -username "$username" -password "$password"; then
        echo "$MSG_USERNAME_PASSWORD_UPDATED_PART1$MSG_USERNAME_PASSWORD_UPDATED_PART2"
    else
        echo "$MSG_USERNAME_PASSWORD_FAILED_PART1"
    fi

    # Оновлення порту
    if docker exec -it $container_x_ui /app/x-ui setting -port "$port"; then
        echo "$MSG_PORT_UPDATED_PART1$MSG_PORT_UPDATED_PART2"
    else
        echo "$MSG_PORT_FAILED_PART1"
    fi

    # Оновлення базового шляху
    if docker exec -it $container_x_ui /app/x-ui setting -webBasePath "$web_base_path"; then
        echo "$MSG_WEB_BASE_PATH_UPDATED_PART1$MSG_WEB_BASE_PATH_UPDATED_PART2"
    else
        echo "$MSG_WEB_BASE_PATH_FAILED_PART1"
    fi

    # Перезапуск Docker-контейнера
    if docker restart $container_x_ui; then
        echo "$MSG_DOCKER_RESTART_PART1$container_x_ui$MSG_DOCKER_RESTART_PART2"
    else
        echo "$MSG_DOCKER_RESTART_FAILED_PART1$container_x_ui"
    fi
}

function check_x_ui_panel_settings() {
    local container_name="$1"
    local settings_output

    # Перевірка наявності контейнера
    if ! docker ps --format '{{.Names}}' | grep -qw "$container_name"; then
        echo "$MSG_CONTAINER_NOT_FOUND_PART1 $container_name $MSG_CONTAINER_NOT_FOUND_PART2"
        return 1
    fi

    # Отримання налаштувань та очищення виводу від кольорових символів та стороннього тексту
    settings_output=$(docker exec -i "$container_name" /app/x-ui setting --show 2>/dev/null | sed 's/[^[:print:]\n]//g')

    # Перевірка на порожній вивід
    if [[ -z "$settings_output" ]]; then
        echo "$MSG_SETTINGS_RETRIEVE_FAILED_PART1 $container_name"
        return 1
    fi

    X_UI_USERNAME=$(echo "$settings_output" | grep -oP '(?<=username: ).*')
    X_UI_PASSWORD=$(echo "$settings_output" | grep -oP '(?<=password: ).*')
    X_UI_PORT=$(echo "$settings_output" | grep -oP '(?<=port: ).*')
    X_UI_WEB_BASE_PATH=$(echo "$settings_output" | grep -oP '(?<=webBasePath: ).*')

    if [[ -z "$X_UI_USERNAME" || -z "$X_UI_PASSWORD" || -z "$X_UI_PORT" || -z "$X_UI_WEB_BASE_PATH" ]]; then
        echo "$MSG_PARSE_ERROR_PART1"
        echo "$MSG_DEBUG_INFO_PART1"
        echo "$settings_output"
        return 1
    fi
}