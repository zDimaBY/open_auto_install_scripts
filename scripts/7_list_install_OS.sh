# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 7_Installation_operating_systems() {
    case $operating_system in
    arch | sysrescue) ;;
    *)
        echo -e "${RED}Встановлення систем відбувається лише через ${YELLOW}SystemRescueCd -> ${GREEN}https://www.system-rescue.org/Download/${RESET}"
        # Отримання налаштувань мережі ip, mask, gateway
        get_public_interface
        echo -e "${RED}Завантажтесь у ${YELLOW}SystemRescueCd${RESET} Виконайте наступні команди, якщо мережа та SSH не налаштовані:"
        echo -e "passwd root"
        echo -e "ifconfig ${selected_adapter} ${server_IPv4[0]}/${mask}"
        echo -e "route add default gw ${gateway}"
        echo -e 'echo "nameserver 8.8.8.8" >/etc/resolv.conf'
        echo -e "iptables -I INPUT 1 -p tcp -m tcp --dport 22 -j ACCEPT"
        echo -e "iptables-legacy-save >/etc/iptables/iptables.rules"
        echo -e "sysctl -w net.ipv6.conf.all.disable_ipv6=1"
        echo -e "#Після чого перевірте, будь ласка, мережу: \nping ${gateway} \nping 8.8.8.8"
        return 1
        ;;
    esac

    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Встановлення ${BLUE}RouterOS від Mikrotik${RESET}"
        echo -e "2. Встановлення ${BLUE}Ubuntu${RESET} ${RED}(test)${RESET}"
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
    if [[ "$answer" =~ ^(yes|Yes|y|Y)$ ]]; then
        echo -e "${GREEN}Встановлення системи RouterOS... https://mikrotik.com/download${RESET}"
        read -p "Вкажіть версію для RouterOS (наприклад 7.5, 7.12. default: 7.14): " version_routeros
        version_routeros=${version_routeros:-7.14}
    else
        echo -e "\n${RED}Встановлення RouterOS від MikroTik скасовано.${RESET}"
        return 1
    fi
    generate_random_password_show
    read -p "Вкажіть пароль користувача admin для RouterOS: " passwd_routeros
    echo -e "${RED}На цьому етапі вам потрібно обрати розділ на диску, де найбільше памяті.${RESET}"
    echo -e "${RED}Оберіть, будь ласка, диск, а потім розділ:${RESET}"
    select_disk_and_partition
    case $operating_system in
    sysrescue)
        if ! command -v pv &>/dev/null; then
            echo -e "${RED} pv не знайдено. Встановлюємо...${RESET}"
            install_package "pv"
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
    echo -e "${RED}На цьому етапі вам потрібно обрати лише диск, вибір розділу пропустити.${RESET}"
    echo -e "${RED}Оберіть, будь ласка, диск в який потрібно встановити систему:${RESET}"
    select_disk_and_partition

    wget https://download.mikrotik.com/routeros/${version_routeros}/chr-${version_routeros}.img.zip -O /mnt/disk_vm/chr.img.zip
    if [ $? -ne 0 ]; then
        echo -e "${RED}Помилка $?:${RESET} не вдалося завантажити файл chr.img.zip."
        return 1
    fi
    gunzip -c /mnt/disk_vm/chr.img.zip >/mnt/disk_vm/chr.img && rm -f /mnt/disk_vm/chr.img.zip
    delay_command=3

    # Монтування образу
    qemu-img convert /mnt/disk_vm/chr.img -O qcow2 /mnt/disk_vm/chr.qcow2 && sleep "$delay_command" && rm -f /mnt/disk_vm/chr.img
    qemu-img resize chr.qcow2 1073741824 && sleep "$delay_command" # Розширюєм образ диска до 1G
    modprobe nbd && qemu-nbd -c /dev/nbd0 /mnt/disk_vm/chr.qcow2 && sleep "$delay_command"
    partprobe /dev/nbd0 && sleep "$delay_command"
    create_folder "/mnt/image_vm"
    mount /dev/nbd0p2 /mnt/image_vm

    # Отримання налаштувань мережі ip, mask, gateway
    get_public_interface
    #date_start_install=$(date)

    # Налаштування мережі та інших параметрів
    cat <<EOF >/mnt/image_vm/rw/autorun.scr
/user set [find name=admin] password=${passwd_routeros}
/ip service disable telnet
/ip address add address=${server_IPv4[0]}/${mask} network=${gateway} interface=ether1
/ip route add dst-address=0.0.0.0/0 gateway=${gateway}
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
    pv /dev/nbd0 | gzip >/mnt/disk_vm/chr-extended.gz && sleep "$delay_command"

    # Завершення роботи qemu-nbd
    killall qemu-nbd && sleep "$delay_command"
    echo u >/proc/sysrq-trigger && sleep "$delay_command"

    # Розпакування образу та копіювання його на пристрій ${selected_partition}
    zcat /mnt/disk_vm/chr-extended.gz | pv >${selected_partition} && sleep 10 || true

    #echo -e "${RED}Перевірте, будь ласка, роботу RouterOS. На даний момент ${YELLOW}\"${date_start_install}\"${RED} в системі запущене оновлення.${RESET}"
    echo -e "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    echo -e "${YELLOW}Система RouterOS встановлена.${RED} Відключіть .iso образ з системою ${GREEN}SystemRescueCD${RED} для корректного перезавантаження в ${GREEN}RouterOS від MikroTik${RESET}"
    echo -e "${YELLOW}Перейдіть за посиланням http://${server_IPv4[0]}/webfig/ для доступу до WEB-інтерфейсу.\nЛогін: admin\nПароль: ${passwd_routeros}${RESET}"
    echo -e "\nВиконайте наступні команди, якщо мережа не налаштована:"
    echo -e "ip address add address=${server_IPv4[0]}/${mask} network=${gateway} interface=ether1"
    echo -e "ip route add dst-address=0.0.0.0/0 gateway=${gateway}"
    echo -e "Перевірте мережу: \nping ${gateway} \nping 8.8.8.8"
    echo -e "${GREEN}----------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    # Синхронізація даних на диску і перезавантаження системи
    echo "sync disk" && sleep "$delay_command" && echo s >/proc/sysrq-trigger && sleep "$delay_command"
    echo b >/proc/sysrq-trigger
}

7_installUbuntu() {
    echo -e "${RED}На цьому етапі вам потрібно обрати розділ на диску, де найбільше пам'яті.${RESET}"
    echo -e "${RED}Оберіть, будь ласка, диск, а потім розділ:${RESET}"
    select_disk_and_partition

    if [ "$operating_system" == "sysrescue" ]; then
        install_package "pv"

        if grep '/mnt' /proc/mounts; then
            umount /mnt && echo "Виконав команду розмонтування."
        fi

        create_folder "/mnt/disk_vm"
        if mount "${selected_partition}" /mnt/disk_vm && cd /mnt/disk_vm; then
            echo "Диск ${selected_partition} змонтовано."
        else
            echo -e "${RED}Не вдалося монтувати диск ${selected_partition}.${RESET}"
            return 1
        fi
    else
        echo -e "${RED}Не вдалося встановити Ubuntu. Будь ласка, встановіть його вручну.${RESET}"
        return 1
    fi

    BASE_URL="https://releases.ubuntu.com"
    TMP_FILE=$(mktemp)
    wget -q -O "$TMP_FILE" "$BASE_URL/"

    VERSIONS=$(grep -oP '(?<=href=")[0-9]+\.[0-9]+(\.[0-9]+)?(?=/")' "$TMP_FILE" | sort -u)
    rm "$TMP_FILE"
    VERSIONS_ARRAY=($VERSIONS)

    if [ ${#VERSIONS_ARRAY[@]} -eq 0 ]; then
        echo "Не вдалося знайти жодної доступної версії."
        return 1
    fi

    echo "Доступні версії:"
    select VERSION in "${VERSIONS_ARRAY[@]}"; do
        if [[ -n "$VERSION" ]]; then
            echo "Ви вибрали версію: $VERSION"
            break
        else
            echo "Недійсний вибір. Будь ласка, спробуйте ще раз."
        fi
    done

    IMAGES=("desktop" "live-server")
    echo "Доступні образи:"
    select IMAGE in "${IMAGES[@]}"; do
        if [[ -n "$IMAGE" ]]; then
            echo "Ви вибрали образ: $IMAGE"
            break
        else
            echo "Недійсний вибір. Будь ласка, спробуйте ще раз."
        fi
    done

    if [ "$IMAGE" == "desktop" ]; then
        FILE="ubuntu-$VERSION-desktop-amd64.iso"
    else
        FILE="ubuntu-$VERSION-live-server-amd64.iso"
    fi

    DEST_DIR="/mnt/disk_vm/downloads/ubuntu-$VERSION"
    create_folder "$DEST_DIR"

    wget -P "$DEST_DIR" -O "$DEST_DIR/SHA256SUMS" "$BASE_URL/$VERSION/SHA256SUMS"

    if [ ! -e "$DEST_DIR/$FILE" ] || ! (cd "$DEST_DIR" && sha256sum -c "SHA256SUMS" --ignore-missing | grep "$FILE" | grep "OK"); then
        if wget -P "$DEST_DIR" -O "$DEST_DIR/$FILE" "$BASE_URL/$VERSION/$FILE"; then
            echo "Файл успішно завантажено до $DEST_DIR/$FILE"
        else
            echo "Завантажити файл образу не вдалося."
            return 1
        fi
    else
        echo "Файл уже існує та має правильну контрольну суму. Пропускаємо завантаження."
    fi

    echo "Завантаження завершено. Файли збережені в $DEST_DIR, образ системи за шляхом $DEST_DIR/$FILE"

    ISODIR="/mnt/iso"
    create_folder "$ISODIR"
    if grep '/mnt/iso' /proc/mounts; then
        umount "$ISODIR" && echo "Виконав команду розмонтування директорії $ISODIR."
    fi
    if mount "${DEST_DIR}/${FILE}" "$ISODIR" && cd "$ISODIR"; then
        echo "Образ ${DEST_DIR}/${FILE} змонтовано."
    else
        echo -e "${RED}Не вдалося монтувати образ $DEST_DIR/$FILE.${RESET}"
        return 1
    fi

    BUILDDIR="$DEST_DIR/build_iso"
    create_folder "$BUILDDIR"
    echo "----- Копіюємо файли -----"
    rsync -a --info=progress2 --stats "$ISODIR/" "$BUILDDIR"
    chmod -R u+w "$BUILDDIR"
    umount "$ISODIR"
    echo "----- Файли скопійовано -----"

    cat <<EOF >>"$BUILDDIR/boot/grub/grub.cfg"

menuentry "Install ubuntu CUSTOM" {
    set gfxpayload=keep
    linux   /casper/vmlinuz  file=/cdrom/preseed/lubuntu-1804.seed auto=true priority=critical debian-installer/locale=ru_RU keyboard-configuration/layoutcode=us ubiquity/reboot=true languagechooser/language-name=English countrychooser/shortlist=US localechooser/supported-locales=ru_RU.UTF-8 boot=casper automatic-ubiquity initrd=/casper/initrd quiet splash noprompt noshell ---
    initrd  /casper/initrd
}
EOF

    echo "Новий GRUB запис додано."
    echo "Готово! Ви можете перевірити результат у $BUILDDIR."
}
