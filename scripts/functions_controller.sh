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
    echo -e "Hostname:${GREEN}$server_hostname${RESET} IP: $server_IP"

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
    echo -e "\n\nЗгенерований випадковий пароль: ${RED}$rand_password${RESET}"
}
generate_random_password() {
    rand_password=$(openssl rand -base64 12)
}

get_server_ip() {
    echo "Визначення IP-адреси сервера"
    echo "Список доступних мережевих інтерфейсів та їх IP-адрес:"
    interfaces=($(ifconfig -a | grep -E '^[A-Za-z0-9]+:' | awk '{print $1}' | sed 's/://g'))

    for ((i = 0; i < ${#interfaces[@]}; i++)); do
        interface_name=${interfaces[$i]}
        ip_address=$(ifconfig "$interface_name" | awk '/inet / {print $2}')
        echo -e "$((i + 1)). Інтерфейс: ${RED}$interface_name${RESET}, IP-адреса: $ip_address"
    done

    read -p "Введіть номер інтерфейсу для використання: " choice
    index=$((choice - 1))

    if [[ $index -lt 0 || $index -ge ${#interfaces[@]} ]]; then
        echo "Невірний вибір. Спробуйте ще раз."
        exit 1
    fi

    interface=${interfaces[$index]}
    ip_address=$(ifconfig "$interface" | awk '/inet / {print $2}')

    if [ -z "$ip_address" ]; then
        echo "Не вдалося отримати IP-адресу для інтерфейсу $interface."
        exit 1
    fi

    echo "Обраний мережевий інтерфейс: $interface"
    echo "IP-адреса: $ip_address"
    server_ip="$ip_address"
}

check_docker() {
    docker_status=$(systemctl status docker)

    if ! command -v docker &>/dev/null; then
        echo -e "\n${RED}Докер не встановлено на цій системі.${RESET}"
        read -p "Бажаєте встановити докер? (y/n): " install_docker
        if [[ "$install_docker" =~ ^(y|Y|yes)$ ]]; then
            echo -e "${YELLOW}Встановлення докера...${RESET}"
            curl -sSL https://get.docker.com | sh
            usermod -aG docker $(whoami)
            echo -e "\n${GREEN}Докер успішно встановлено.${RESET}"
        else
            echo -e "\n${RED}Встановлення докера скасовано. Скрипт завершується.${RESET}"
            exit 1
        fi
    fi

    # Перевірка, чи Docker запущений
    if ! systemctl status docker | grep -q "running"; then
        echo -e "\n${RED}Docker не запущений.${RESET}"
        read -p "Бажаєте запустити Docker? (y/n): " start_docker
        if [[ "$start_docker" =~ ^(y|Y|yes)$ ]]; then
            echo -e "${YELLOW}Запуск демона Docker...${RESET}"
            systemctl start docker
            if [[ $? -eq 0 ]]; then
                echo -e "\n${GREEN}Docker успішно запущений.${RESET}"

                active_status=$(echo "$docker_status" | grep "Active:")
                if echo "$docker_status" | grep -q "running"; then
                    echo -e "\n${YELLOW}Статус демона Docker:${RESET}\n${GREEN}$active_status${RESET}"
                else
                    echo -e "\n${YELLOW}Статус демона Docker:${RESET}\n${RED}$active_status${RESET}"
                fi
            else
                echo -e "\n${RED}Не вдалося запустити демона Docker.${RESET}"
                exit 1
            fi
        else
            echo -e "\n${RED}Запуск демона Docker скасовано. Скрипт завершується.${RESET}"
            exit 1
        fi
    else
        active_status=$(echo "$docker_status" | grep "Active:")

        if echo "$docker_status" | grep -q "running"; then
            echo -e "\n${YELLOW}Статус демона Docker:${RESET}\n${GREEN}$active_status${RESET}"
        else
            echo -e "\n${YELLOW}Статус демона Docker:${RESET}\n${RED}$active_status${RESET}"
        fi
    fi
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
