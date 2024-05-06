# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 7_Installation_operating_systems() {
    case $operating_system in
    arch | sysrescue) ;;
    *)
        echo -e "${RED}Встановлення систем відбувається лише через ${YELLOW}SystemRescueCd -> ${GREEN}https://www.system-rescue.org/Download/${RESET}"
        return 1
        ;;
    esac

    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Встановлення ${BLUE}RouterOS від Mikrotik${RESET}"
        echo -e "2. Встановлення ${BLUE}Ubuntu${RESET}"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) 7_installRouterOSMikrotik ;;
        2) 7_installUbuntu ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

function 7_installRouterOSMikrotik() {
    echo -e "${RED}Бажаєте встановити систему RouterOS від MikroTik? Після цієї операції диск буде перезаписаний${RESET}"
    read -p "Ви згодні, що система перезапише дані та виконає перезапуск? (y/n): " answer
    if [[ "$answer" =~ ^[Yy](es)?$ ]]; then
        echo -e "${GREEN}Встановлення системи RouterOS... https://mikrotik.com/download${RESET}"
        read -p "Вкажіть версію для RouterOS (наприклад 7.5, 7.12. default: 7.14): " version_routeros
        version_routeros=${version_routeros:-7.14}
    elif [[ "$answer" =~ ^[Nn]o?$ ]]; then
        echo -e "Відмінено користувачем."
        return 1
    else
        echo -e "Невірний ввід. Будь ласка, введіть ${RED}'yes'${RESET} або ${GREEN}'no'${RESET}."
    fi
    echo -e "${RED}Вам потрібно обрати лише диск, вибір розділів пропустити.${RESET}"
    select_disk_and_partition
    generate_random_password_show
    read -p "Вкажіть пароль користувача admin для RouterOS: " passwd_routeros
    case $operating_system in
    sysrescue)
        if ! command -v qemu-img &>/dev/null || ! command -v pv &>/dev/null; then
            echo -e "${RED}qemu-utils або pv не знайдено. Встановлюємо...${RESET}"
            pacman -Sy qemu-utils pv
        fi

        if grep '/mnt' /proc/mounts; then
            umount /mnt && echo "Виконав команду розмонтування."
        fi
        create_folder "/mnt/disk_vm"
        if mount ${selected_partition} /mnt/disk_vm && cd /mnt/disk_vm; then
            echo "Диск ${selected_partition} змонтовано."
        else
            echo -e "${RED}Не вдалося монтувати диск ${selected_partition}.${RESET}"
            return 1
        fi
        ;;
    *)
        echo -e "${RED}Не вдалося встановити RouterOS Mikrotik. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac
    wget https://download.mikrotik.com/routeros/${version_routeros}/chr-${version_routeros}.img.zip -O chr.img.zip
    if [ $? -ne 0 ]; then
        echo -e "${RED}Помилка $?:${RESET} не вдалося завантажити файл chr.img.zip."
        return 1
    fi
    gunzip -c chr.img.zip >chr.img

    delay_command=3

    # Монтування образу
    qemu-img convert chr.img -O qcow2 chr.qcow2 && sleep "$delay_command"
    qemu-img resize chr.qcow2 1073741824 && sleep "$delay_command" # Розширюєм образ диска до 1G
    modprobe nbd && qemu-nbd -c /dev/nbd0 chr.qcow2 && sleep "$delay_command"
    sleep 2 && partprobe /dev/nbd0 && sleep 5
    create_folder "/mnt/image_vm"
    mount /dev/nbd0p2 /mnt/image_vm

    # Отримання налаштувань мережі ip, mask, gateway
    get_public_interface
    #date_start_install=$(date)

    # Налаштування мережі та інших параметрів
    cat <<EOF >/mnt/image_vm/rw/autorun.scr
/ip address add address=${hostname_ip}/${mask} network=${gateway} interface=ether1
/ip route add dst-address=0.0.0.0/0 gateway=${gateway}
/user set [find name=admin] password=${passwd_routeros}
/ip service disable telnet
EOF
    #/system package update install
    if [ -z "$passwd_routeros" ]; then
        passwd_routeros="не заданий"
    elif [ -z "$(echo "$passwd_routeros" | tr -d '[:space:]')" ]; then
        passwd_routeros="не заданий"
    fi

    # Розмонтування образу
    umount /mnt/image_vm && sleep "$delay_command"

    # Створення нового розділу
    echo -e 'd\n2\nn\np\n2\n65537\n\nw\n' | fdisk /dev/nbd0 && sleep "$delay_command"

    # Виконання перевірки файлової системи і зміна її розміру
    e2fsck -f -y /dev/nbd0p2 || true && resize2fs /dev/nbd0p2 && sleep "$delay_command"

    # Копіювання образу та збереження його на тимчасове сховище
    pv /dev/nbd0 | gzip >/mnt/image_vm/chr-extended.gz && sleep "$delay_command"

    # Завершення роботи qemu-nbd
    killall qemu-nbd && sleep "$delay_command"
    echo u >/proc/sysrq-trigger && sleep "$delay_command"

    # Розпакування образу та копіювання його на пристрій ${selected_partition}
    zcat /mnt/image_vm/chr-extended.gz | pv >${selected_partition} && sleep 10 || true

    #echo -e "${RED}Перевірте, будь ласка, роботу RouterOS. На даний момент ${YELLOW}\"${date_start_install}\"${RED} в системі запущене оновлення.${RESET}"
    echo -e "${YELLOW}Система RouterOS встановлена. Перейдіть за посиланням http://${hostname_ip}/webfig/ для доступу до WEB-інтерфейсу.\nЛогін: admin\nПароль: ${passwd_routeros}${RESET}"
    echo -e "\nВиконайте наступні команди, якщо мережа не налаштована:"
    echo -e "ip address add address=${hostname_ip}/${mask} network=${gateway} interface=ether1"
    echo -e "ip route add dst-address=0.0.0.0/0 gateway=${gateway}"
    echo -e "Перевірте мережу: \nping ${gateway} \nping 8.8.8.8"

    # Синхронізація даних на диску і перезавантаження системи
    echo "sync disk" && sleep "$delay_command" && echo s >/proc/sysrq-trigger && sleep "$delay_command" && echo b >/proc/sysrq-trigger

}

7_installUbuntu() {
    echo -e "\nВ розробці ...\n"
}
