function 3_list_install_programs() {
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Встановлення ${BROWN}Composer${RESET}"
        echo -e "2. Встановлення ${BROWN}Docker${RESET}"
        echo -e "3. Встановлення ${BROWN}RouterOS від Mikrotik${RESET}"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) 3_installComposer ;;
        2) check_docker ;;
        3) 3_installRouterOSMikrotik ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

function 3_installComposer() {
    case $operating_system in
    debian | ubuntu)
        if ! command -v php &>/dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            apt-get install php-cli
        fi
        ;;
    fedora)
        if ! command -v php &>/dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            dnf install php-cli
        fi
        ;;
    centos | oracle)
        if ! command -v php &>/dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            yum install epel-release
            yum install php-cli
        fi
        ;;
    arch)
        if ! command -v php &>/dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            pacman -S php
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

function 3_installRouterOSMikrotik() {
    case $operating_system in
    debian | ubuntu)
        if ! command -v unzip &>/dev/null; then
            echo -e "${RED}unzip не знайдено. Встановлюємо...${RESET}"
            apt-get install unzip -y
        fi
        ;;
    fedora)
        if ! command -v unzip &>/dev/null; then
            echo -e "${RED}unzip не знайдено. Встановлюємо...${RESET}"
            dnf install unzip
        fi
        ;;
    centos | oracle)
        if ! command -v unzip &>/dev/null; then
            echo -e "${RED}unzip не знайдено. Встановлюємо...${RESET}"
            yum install unzip -y
        fi
        ;;
    arch)
        if ! command -v unzip &>/dev/null; then
            echo -e "${RED}unzip не знайдено. Встановлюємо...${RESET}"
            pacman -S unzip
        fi
        ;;
    *)
        echo -e "${RED}Не вдалося встановити RouterOS Mikrotik. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac
    echo -e "Бажаєте встановити систему RouterOS від MikroTik? ${RED}Після цієї операції диск буде перезаписаний${RESET}"
    read -p "Ви згодні, що система перезапише дані та виконає перезапуск? (yes/no): " answer

    if [[ "$answer" =~ ^[Yy](es)?$ ]]; then
        echo "Встановлення системи RouterOS..."
        wget https://download.mikrotik.com/routeros/7.5/chr-7.5.img.zip
        unzip chr-7.5.img.zip
    elif [[ "$answer" =~ ^[Nn]o?$ ]]; then
        echo "Відмінено користувачем."
    else
        echo "Невірний ввід. Будь ласка, введіть ${RED}'yes'${RESET} або ${GREEN}'no'${RESET}."
    fi

    echo "Список дисків:"
    disks=($(fdisk -l | grep -o '^Disk /[^:]*' | cut -d ' ' -f 2))
    for ((i = 0; i < ${#disks[@]}; i++)); do
        echo "$(($i + 1)). ${disks[$i]}"
    done

    read -p "Виберіть номер диска (1-${#disks[@]}): " disk_number

    if [ "$disk_number" -ge 1 ] && [ "$disk_number" -le "${#disks[@]}" ]; then
        selected_disk=${disks[$(($disk_number - 1))]}
        echo -e "Обраний диск: ${RED}$selected_disk${RESET}"
        echo -e "${RED}Система через декілька секунд система буде перезавантажена. Будь ласка, проведіть налаштування RouterOS у VNC.${GREEN} \nКористувач: admin \nПароль: <не налаштований в RouterOS>${RESET}"
        echo -e "\nВиконайти наступні команди, вкажіть IP-адресу: ip address add address=xxx.xxx.xxx.xxx/24 interface=ether1"
        echo -e "Вкажіть шлюз: ip route add gateway=yyy.yyy.yyy.yyy"
        
        echo -e "${YELLOW}\nСистема встановлена. Перейдіть за посиланням http://хх.хх.хх.хх/webfig/ для доступу до WEB-інтерфейсу. \nЛогін: admin \nПароль: <XXXXXXX>${RESET}"
        
        dd if=chr-7.5.img of=${selected_disk} bs=4M oflag=sync
        echo 1 >/proc/sys/kernel/sysrq
        echo b >/proc/sysrq-trigger
    else
        echo "Помилка: Неправильний номер диска."
    fi
}
