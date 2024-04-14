# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 1_list_install_programs() {
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Встановлення ${BROWN}Composer${RESET}"
        echo -e "2. Встановлення ${BROWN}Docker${RESET}"
        echo -e "3. Встановлення ${BLUE}RouterOS від Mikrotik${RESET}"
        echo -e "4. Встановлення ${BLUE}Elasticsearch${RESET} ${RED}(test)${RESET}"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) 1_installComposer ;;
        2) check_docker ;;
        3) 1_installRouterOSMikrotik ;;
        4) 1_installElasticsearch ;;
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

function 1_installRouterOSMikrotik() {
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
            pacman -S qemu-utils pv
        fi
        ;;
    *)
        echo -e "${RED}Не вдалося встановити RouterOS Mikrotik. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac
    echo -e "Бажаєте встановити систему RouterOS від MikroTik? ${RED}Після цієї операції диск буде перезаписаний${RESET}"
    read -p "Ви згодні, що система перезапише дані та виконає перезапуск? (y/n): " answer

    if [[ "$answer" =~ ^[Yy](es)?$ ]]; then
        echo -e "${GREEN}Встановлення системи RouterOS... https://mikrotik.com/download${RESET}"
        read -p "Вкажіть версію для RouterOS (наприклад 7.5, 7.12. default: 7.14): " version_routeros
        version_routeros=${version_routeros:-7.14}

        if [[ ! $version_routeros =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            echo "Помилка: Введено неправильне значення версії. Будь ласка, введіть числове значення (наприклад 7.12, 7.14)."
            echo "Для посилання: https://download.mikrotik.com/routeros/${version_routeros}/chr-${version_routeros}.img.zip."
            return 1
        fi

        echo -e "\nСписок дисків:"
        disks=($(fdisk -l | grep -o '^Disk /[^:]*' | cut -d ' ' -f 2))
        for ((i = 0; i < ${#disks[@]}; i++)); do
            echo "$(($i + 1)). ${disks[$i]}"
        done
        read -p "Виберіть диск (1-${#disks[@]}): " disk_number
        generate_random_password_show
        read -p "Вкажіть пароль користувача admin для RouterOS: " passwd_routeros

        if [ "$disk_number" -ge 1 ] && [ "$disk_number" -le "${#disks[@]}" ]; then
            selected_disk=${disks[$(($disk_number - 1))]}
            echo -e "Обраний диск: ${RED}${selected_disk}${RESET}"
            wget https://download.mikrotik.com/routeros/${version_routeros}/chr-${version_routeros}.img.zip -O chr.img.zip
            if [ $? -ne 0 ]; then
                echo -e "${RED}Помилка $?:${RESET} не вдалося завантажити файл chr.img.zip. Вихід зі скрипта."
                return 1
            fi
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
            date_start_install=$(date)

            # Налаштування мережі та інших параметрів
            cat <<EOF >/mnt/rw/autorun.scr
/ip address add address=${hostname_ip}/${mask} network=${gateway} interface=ether1
/ip route add dst-address=0.0.0.0/0 gateway=${gateway}
/ip service disable telnet
/user set 0 name=admin password=${passwd_routeros}
EOF
            #/system package update install
            if [ $? -ne 0 ]; then
                passwd_routeros="не заданий"
            fi

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

            # Розпакування образу та копіювання його на пристрій ${selected_disk}
            zcat /mnt/chr-extended.gz | pv >${selected_disk} && sleep 10 || true

            echo -e "${RED}Перевірте, будь ласка, роботу RouterOS. На даний момент ${YELLOW}\"${date_start_install}\"${RED} в системі запущене оновлення.${RESET}"
            echo -e "${YELLOW}Система RouterOS встановлена. Перейдіть за посиланням http://${hostname_ip}/webfig/ для доступу до WEB-інтерфейсу.\nЛогін: admin\nПароль: ${passwd_routeros}${RESET}"
            echo -e "\nВиконайте наступні команди, якщо мережа не налаштована:"
            echo -e "ip address add address=${hostname_ip}/${mask} network=${gateway} interface=ether1"
            echo -e "ip route add dst-address=0.0.0.0/0 gateway=${gateway}"
            echo -e "Перевірте мережу: ping ${gateway}, ping 8.8.8.8"

            # Синхронізація даних на диску і перезавантаження системи
            echo "sync disk" && sleep "$delay_command" && echo s >/proc/sysrq-trigger && sleep "$delay_command" && echo b >/proc/sysrq-trigger

        elif [[ "$answer" =~ ^[Nn]o?$ ]]; then
            echo "Відмінено користувачем."
            return 1
        else
            echo "Невірний ввід. Будь ласка, введіть ${RED}'yes'${RESET} або ${GREEN}'no'${RESET}."
        fi

    else
        echo "Помилка: Неправильний номер диска."
    fi
}

1_installElasticsearch() {
    case $operating_system in
    debian | ubuntu)
        if dpkg -l | grep -q '^ii.*apt-transport-https' &>/dev/null; then
            echo -e "${RED}apt-transport-https не знайдено. Встановлюємо...${RESET}"
            apt-get install apt-transport-https
        fi
        echo "Ви обрали головну версію $main_version."

        echo -e "${GREEN}Завантаження ключа GPG Elasticsearch...${RESET}"
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

        echo -e "${GREEN}Додавання репозиторію Elasticsearch до списку джерел APT...${RESET}"
        echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list
        echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list

        echo -e "${GREEN}Оновлення списку пакунків APT...${RESET}"
        apt update
        echo -e "${GREEN}Список пакунків APT оновлено.${RESET}"

        # Отримати доступні головні версії Elasticsearch
        main_versions=$(apt policy elasticsearch | grep -E "^[[:space:]]+[0-9]+\..*\." | awk '{print $1}' | cut -d'.' -f1 | sort -ru)

        PS3="Оберіть головну версію Elasticsearch: "
        select main_version in $main_versions; do
            if [ -n "$main_version" ]; then
                echo "Ви обрали головну версію $main_version."
                break
            else
                echo "Невірний вибір. Будь ласка, спробуйте ще раз."
            fi
        done

        # Отримати версії, що відповідають обраній головній версії
        sub_versions=$(apt policy elasticsearch | grep -E "^[[:space:]]+[0-9]+\..*\." | grep "^ *$main_version\." | awk '{print $1}')

        PS3="Оберіть підверсію Elasticsearch для встановлення: "
        select sub_version in $sub_versions; do
            if [ -n "$sub_version" ]; then
                echo "Ви обрали версію $sub_version для встановлення."
                apt install elasticsearch=$sub_version
                if [ $? -eq 0 ]; then
                    echo "Elasticsearch версії $sub_version успішно встановлено."
                else
                    echo -e "${RED}Помилка при встановленні Elasticsearch версії $sub_version.${RESET}"
                fi
                break
            else
                echo "Невірний вибір. Будь ласка, спробуйте ще раз."
            fi
        done

        ;;
    fedora)
        if rpm -q apt-transport-https &>/dev/null; then
            echo -e "${RED}apt-transport-https не знайдено. Функція не реалізована...${RESET}"
            #dnf install -y apt-transport-https
        fi
        ;;
    centos | oracle)
        if rpm -q apt-transport-https &>/dev/null; then
            echo -e "${RED}apt-transport-https не знайдено. Функція не реалізована...${RESET}"
            #yum install -y apt-transport-https
        fi
        ;;
    arch)
        if ! pacman -Qq apt-transport-https &>/dev/null; then
            echo -e "${RED}apt-transport-https не знайдено. Функція не реалізована...${RESET}"
            #pacman -Sy --noconfirm apt-transport-https
        fi
        ;;
    *)
        echo -e "${RED}Не вдалося встановити Composer. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac

}
