checkControlPanel() {
    load_average=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}')
    load_average=${load_average%,*}
    load_average=$(echo "${load_average/,/.}")

    if (($(echo "$load_average < 2" | bc -l))); then
        load_average="${GREEN}$load_average${RESET}"
    elif (($(echo "$load_average < 5" | bc -l))); then
        load_average="${YELLOW}$load_average${RESET}"
    else
        load_average="${RED}$load_average (!)${RESET}"
    fi

    largest_disk=$(df -h | grep '^/dev/' | sort -k 4 -hr | head -n 1)
    disk_usage=$(echo "$largest_disk" | awk '{print $5}') # Використання місця на найбільшому диску

    echo -e "\n\033[1mInformation:${RESET}"

    server_IP=$(hostname -I | awk '{print $1}')

    case $operating_system in
    "Debian" | "ubuntu" | "fedora" | "centos" | "oracle" | "arch")
        if [ -d "/usr/local/hestia" ]; then
            hestia_info=$(/usr/local/hestia/bin/v-list-sys-info)

            hostname=$(echo "$hestia_info" | awk 'NR==3{print $1}')
            operating_system=$(echo "$hestia_info" | awk 'NR==3{print $2}')
            os_version=$(echo "$hestia_info" | awk 'NR==3{print $3}')
            hestia_version=$(echo "$hestia_info" | awk 'NR==3{print $5}')

            echo -e "Hostname:${GREEN}$hostname${RESET} IP: $server_IP OS:${YELLOW}$operating_system${RESET} Ver:${BLUE}$operating_system_version${RESET} HestiaCP:\033[35m$hestia_version${RESET}"
            echo -e "Load Average: $load_average Disk Usage: $disk_usage"
        elif [ -d "/usr/local/vesta" ]; then
            vesta_info=$(/usr/local/vesta/bin/v-list-sys-info)

            hostname=$(echo "$vesta_info" | awk 'NR==3{print $1}')
            operating_system=$(echo "$vesta_info" | awk 'NR==3{print $2}')
            os_version=$(echo "$vesta_info" | awk 'NR==3{print $3}')
            vesta_version=$(echo "$vesta_info" | awk 'NR==3{print $5}')

            echo -e "Hostname:${GREEN}$hostname${RESET} IP: $server_IP OS:${YELLOW}$operating_system${RESET} Ver:${BLUE}$operating_system_version${RESET} VestiaCP:\033[35m$vesta_version${RESET}"
            echo -e "Load Average: $load_average Disk Usage: $disk_usage"
        elif [ -d "/usr/local/mgr5" ]; then
            echo -e "${GREEN}ISPmanager is installed.${RESET}"
            /usr/local/mgr5/sbin/licctl info ispmgr
        elif [ -f "/usr/local/cpanel/cpanel" ]; then
            echo -e "${GREEN}cPanel is installed.${RESET}"
            /usr/local/cpanel/cpanel -V
            cat /etc/*release
        else
            echo "No supported control panel found."
        fi
        ;;
    *)
        echo "No supported control panel found for the detected operating system."
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

function check_dependency() {
    local dependency_name=$1
    local package_name=$2
    
    operating_system=""
if [[ -e /etc/debian_version ]]; then
    source /etc/os-release
    operating_system="${ID}"
elif [[ -e /etc/fedora-release ]]; then
    source /etc/os-release
    operating_system="${ID}"
elif [[ -e /etc/centos-release ]]; then
    source /etc/os-release
    operating_system="${ID}"
elif [[ -e /etc/oracle-release ]]; then
    source /etc/os-release
    operating_system=oracle
elif [[ -e /etc/arch-release ]]; then
    operating_system=arch
elif [[ -e /etc/lsb-release ]]; then
    source /etc/lsb-release
    if [[ "$DISTRIB_ID" == "Ubuntu" ]]; then
        operating_system="ubuntu"
    else
        echo "$operating_system Схоже, ви не використовуєте цей інсталятор у системах Debian, Ubuntu, Fedora, CentOS, Oracle або Arch Linux. Ваша система: $operating_system"
        exit 1
    fi
else
    echo "Схоже, ви не використовуєте цей інсталятор у системах Debian, Ubuntu, Fedora, CentOS, Oracle або Arch Linux. Ваша система: $operating_system"
    exit 1
fi


    # Перевірка наявності залежності
    if ! command -v "$dependency_name" &>/dev/null; then
        echo -e "${RED}$dependency_name не встановлено. Встановлюємо...${RESET}"

        # Перевірка чи вже було виконано оновлення системи
        if ! "$UPDATE_DONE"; then
            # Встановлення залежності залежно від операційної системи
            case $operating_system in
            Debian | ubuntu)
                sudo apt-get update
                sudo apt-get install -y "$package_name"
                ;;
            fedora)
                sudo dnf update
                sudo dnf install -y "$package_name"
                ;;
            centos | oracle)
                sudo yum update
                sudo yum install -y "$package_name"
                ;;
            arch)
                sudo pacman -Sy
                sudo pacman -S --noconfirm "$package_name"
                ;;
            *)
                echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
                return 1
                ;;
            esac

            # Встановлено оновлення системи
            UPDATE_DONE=true
        else
            # Встановлення залежності без оновлення системи
            case $operating_system in
            Debian | ubuntu)
                sudo apt-get install -y "$package_name"
                ;;
            fedora)
                sudo dnf install -y "$package_name"
                ;;
            centos | oracle)
                sudo yum install -y "$package_name"
                ;;
            arch)
                sudo pacman -S --noconfirm "$package_name"
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
    docker_status=$(sudo systemctl status docker)

    if ! command -v docker &>/dev/null; then
        echo -e "\n${RED}Докер не встановлено на цій системі.${RESET}"
        echo -e "${YELLOW}Бажаєте встановити докер? ${RESET}"
        read -p "(y/n): " install_docker
        if [[ "$install_docker" =~ ^(y|Y|yes)$ ]]; then
            echo -e "${YELLOW}Встановлення докера...${RESET}"
            curl -sSL https://get.docker.com | sh
            sudo usermod -aG docker $(whoami)
            echo -e "\n${GREEN}Докер успішно встановлено.${RESET}"
        else
            echo -e "\n${RED}Встановлення докера скасовано. Скрипт завершується.${RESET}"
            exit 1
        fi
    fi

    # Перевірка, чи демон Docker запущений
    if ! sudo systemctl status docker | grep -q "running"; then
        echo -e "\n${RED}Демон Docker не запущений.${RESET}"
        echo -e "\n${YELLOW}Бажаєте запустити демон Docker? ${RESET}"
        read -p "(y/n): " start_docker
        if [[ "$start_docker" =~ ^(y|Y|yes)$ ]]; then
            echo -e "${YELLOW}Запуск демона Docker...${RESET}"
            sudo systemctl start docker
            echo -e "\n${GREEN}Демон Docker успішно запущений.${RESET}"
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