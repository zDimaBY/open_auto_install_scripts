function 3_list_install_programs() {
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Встановлення ${BROWN}Composer${RESET}"
        echo -e "2. Встановлення ${BROWN}Docker${RESET}"
        echo -e "3. Встановлення ${BLUE}RouterOS від Mikrotik${RESET}"
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
        if ! command -v qemu-img &>/dev/null || ! command -v pv &>/dev/null; then
            echo -e "${RED}qemu-utils або pv не знайдено. Встановлюємо...${RESET}"
            apt install -y qemu-utils pv
        fi
        ;;
    fedora)
        if ! command -v qemu-img &>/dev/null || ! command -v pv &>/dev/null; then
            echo -e "${RED}qemu-utils або pv не знайдено. Встановлюємо...${RESET}"
            dnf install epel-release
            dnf install qemu-img pv nbd
        fi
        ;;
    centos | oracle)
        if ! command -v qemu-img &>/dev/null || ! command -v pv &>/dev/null; then
            echo -e "${RED}qemu-utils або pv не знайдено. Встановлюємо...${RESET}"
            yum install qemu-img pv nbd -y
        fi
        ;;
    arch)
        if ! command -v qemu-img &>/dev/null || ! command -v pv &>/dev/null; then
            echo -e "${RED}qemu-utils або pv не знайдено. Встановлюємо...${RESET}"
            pacman -S qemu-utils pv
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
    elif [[ "$answer" =~ ^[Nn]o?$ ]]; then
        echo "Відмінено користувачем."
        return 1
    else
        echo "Невірний ввід. Будь ласка, введіть ${RED}'yes'${RESET} або ${GREEN}'no'${RESET}."
    fi

    echo "Список дисків:"
    disks=($(fdisk -l | grep -o '^Disk /[^:]*' | cut -d ' ' -f 2))
    for ((i = 0; i < ${#disks[@]}; i++)); do
        echo "$(($i + 1)). ${disks[$i]}"
    done
    read -p "Виберіть диск (1-${#disks[@]}): " disk_number
    generate_random_password_show
    read -p "Вкажіть пароль користувача admin для RouterOS: " passwd_routeros

    if [ "$disk_number" -ge 1 ] && [ "$disk_number" -le "${#disks[@]}" ]; then
        selected_disk=${disks[$(($disk_number - 1))]}
        echo -e "Обраний диск: ${RED}$selected_disk${RESET}"
        wget https://download.mikrotik.com/routeros/7.5/chr-7.5.img.zip -O chr.img.zip
        gunzip -c chr.img.zip >chr.img

        delay_command=3

        # Монтування образу
        qemu-img convert chr.img -O qcow2 chr.qcow2 && sleep "$delay_command"
        qemu-img resize chr.qcow2 1073741824 && sleep "$delay_command" # Розширюєм образ диска до 1G
        modprobe nbd && qemu-nbd -c /dev/nbd0 chr.qcow2 && sleep "$delay_command"
        sleep 2 && partprobe /dev/nbd0 && sleep 5
        mount /dev/nbd0p2 /mnt

        # Отримання налаштувань мережі ip, mask, gateway
        get_public_interface
        date_start_isntall=$(date)

        # Налаштування мережі та інших параметрів
        cat <<EOF >/mnt/rw/autorun.scr
/ip address add address=${hostname_ip}/${mask} network=${gateway} interface=ether1
/ip route add dst-address=0.0.0.0/0 gateway=${gateway}
/ip service disable telnet
/user set 0 name=admin password=${passwd_routeros}
/system package update install
EOF

        # Розмонтування образу
        umount /mnt && sleep "$delay_command"

        # Створення нового розділу та перепідключення образу диска
        echo -e 'd\n2\nn\np\n2\n65537\n\nw\n' | fdisk /dev/nbd0 && sleep "$delay_command"

        # Виконання перевірки файлової системи і зміна її розміру
        e2fsck -f -y /dev/nbd0p2 || true && resize2fs /dev/nbd0p2 && sleep "$delay_command"

        # Копіювання образу та збереження його на тимчасове сховище
        pv /dev/nbd0 | gzip >/mnt/chr-extended.gz && sleep "$delay_command"

        # Завершення роботи qemu-nbd та відправлення сигналу перезавантаження
        killall qemu-nbd && sleep "$delay_command"
        echo u >/proc/sysrq-trigger && sleep "$delay_command"

        # Розпакування образу та копіювання його на пристрій /dev/vda
        zcat /mnt/chr-extended.gz | pv >/dev/vda && sleep 10 || true

        echo -e "${RED}Перевірте, будь ласка, роботу RouterOS. На даний момент ${YELLOW}\"${date_start_install}\"${RED} в системі запущене оновлення.${RESET}"
        echo -e "${YELLOW}Система RouterOS встановлена. Перейдіть за посиланням http://${hostname_ip}/webfig/ для доступу до WEB-інтерфейсу.\nЛогін: admin\nПароль: ${passwd_routeros}${RESET}"
        echo -e "\nВиконайте наступні команди, якщо мережа не налаштована:"
        echo -e "ip address add address=${hostname_ip}/${mask} network=${gateway} interface=ether1"
        echo -e "ip route add dst-address=0.0.0.0/0 gateway=${gateway}"
        echo -e "Перевірте мережу: ping ${gateway}, ping 8.8.8.8"

        # Синхронізація даних на диску і перезавантаження системи
        echo "sync disk" && sleep "$delay_command" && echo s >/proc/sysrq-trigger && sleep "$delay_command" && echo b >/proc/sysrq-trigger
    else
        echo "Помилка: Неправильний номер диска."
    fi
}
