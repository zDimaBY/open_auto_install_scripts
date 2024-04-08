# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 2_DDos() {
    clear
    while true; do
        checkControlPanel
        get_selected_interface
        read -p "Введіть тривалість таймауту tcpdump (у секундах, стандартне значення: 5): " duration
        duration=${duration:-5}
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Аналіз кількості IP-запитів на мережевому інтерфейсі протягом ${RED}$duration${RESET} секунд"
        echo -e "2. Аналіз кількості унікальних IP-адрес на мережевому інтерфейсі протягом ${RED}$duration${RESET} секунд"
        echo -e "3. Перехопити пакети з мережевого інтерфейсу ${RED}$selected_adapter${RESET} окрім ssh/22"
        echo -e "4. Створити файл blocked_IPs.log на основі аналізу tcpdump протягом ${RED}$duration${RESET} секунд"
        echo -e "5. Створити резервні копії iptables та заблокувати IP з файлу ${RED}blocked_IPs.log${RESET}"
        echo -e "0. Повернутися до головного меню\n"
        read -p "Виберіть опцію (1/0): " choice

        case $choice in
        1) 4_AnalysisRequestsOfNetworkInterface ;;
        2) 4_repeatsOfNetworkInterface ;;
        3) 4_viewInterfacePacks ;;
        4) 4_blockIPs ;;
        5) 4_blockIPsUsingIptables ;;
        0) return ;;
        *) 0_invalid ;;
        esac
    done
}
function 4_viewInterfacePacks() {
    tcpdump -i $selected_adapter 'not port 22'
}
function 4_AnalysisRequestsOfNetworkInterface() {
    clear
    while true; do
        checkControlPanel
        echo -e "\e[93mВи у пункті: "1. Аналіз IP-запитів мережевого інтерфейса за "$duration"/сек"${RESET}"
        echo -e "\e[93mЩоб повернутися до попереднього меню натисніть${RED} 0 та Enter${RESET}\n"
        output=$(timeout "$duration" tcpdump -nn -i "$selected_adapter")
        total_requests=$(echo "$output" | grep -c "IP ")
        echo -e "\nЗагальна кількість запитів: $total_requests"

        ip_requests=$(echo "$output" | awk '/IP /{print $3, $5}' | awk -F "[ .:]" '{printf "%s %-20s %s:%s\n", $1, $2"."$3"."$4"."$5, $6"."$7"."$8"."$9, $10}' | sort | uniq -c | sort -nr | head -n 20)
        echo -e "Топ-20 IP-запитів за 10/сек:"
        echo -e "Запити\tДжерело\t\t\tПризначення"
        echo "$ip_requests"

        echo -e "\nЗагальна кількість з одного IP (без урахування портів):"
        echo "$output" | awk '/IP /{gsub(/\.[0-9]+$/, "", $3); print $3}' | sort | uniq -c

        if read -t 0; then
            read -p "Виберіть варіант (0):" choice
            if [[ $choice -eq 0 ]]; then
                break
            fi
        fi
    done
}

function 4_repeatsOfNetworkInterface() {
    clear
    while true; do
        checkControlPanel
        echo -e "\e[93mВи у пункті: "2. Аналіз IP усіх повторень мережевого інтерфейса за "$duration"/сек"${RESET}"
        echo -e "\e[93mЩоб повернутися до попереднього меню натисніть${RED} 0 та Enter${RESET}\n"
        output=$(timeout "$duration" tcpdump -nn -i "$selected_adapter")
        total_requests=$(echo "$output" | grep -c "IP ")
        echo "Загальна кількість запитів: $total_requests"

        echo "$output" | grep -o "IP .*:" | cut -d':' -f1 | sort | uniq -c
        if read -t 0; then
            read -p "Виберіть варіант (0):" choice
            if [[ $choice -eq 0 ]]; then
                break
            fi
        fi
    done
}

function 4_blockIPs() {
    read -p "Введіть кількість запитів, що спричиняють блокування (за замовчуванням 100): " threshold
    threshold=${threshold:-100}

    log_file="blocked_IPs.log" # Шлях до лог-файлу для зберігання заблокованих IP-адрес

    # Масив системних та зарезервованих IP-адрес
    system_IPs=("$server_IP" "$hostname" "127.0.0.1" "localhost" "0.0.0.0" "255.255.255.255")

    clear
    while true; do
        checkControlPanel
        echo -e "\e[93mВи у пункті: "2. Блокування IP-адрес з підозрілими запитами"${RESET}"
        echo -e "\e[93mЩоб повернутися до попереднього меню натисніть${RED} 0 та Enter${RESET}\n"
        output=$(timeout "$duration" tcpdump -nn -i "$selected_adapter")
        ip_requests=$(echo "$output" | awk '/IP /{print $3}' | awk -F '.' '{print $1"."$2"."$3"."$4}' | sort | uniq -c)

        while read -r line; do
            count=$(echo "$line" | awk '{print $1}')
            ip=$(echo "$line" | awk '{print $2}')

            # Перевірка, чи IP-адреса не належить системним або зарезервованим IP-адресам та не знаходиться в лог-файлі заблокованих IP-адрес
            if [[ ! " ${system_IPs[*]} " =~ " $ip " ]] && [[ $count -gt $threshold ]] && ! grep -q "$ip" "$log_file"; then
                echo "Заблоковано IP: $ip"
                echo "$ip" >>"$log_file"
            fi
        done <<<"$ip_requests"

        if read -t 0; then
            read -p "Виберіть варіант (0):" choice
            if [[ $choice -eq 0 ]]; then
                break
            fi
        fi
    done
}

4_createIptablesBackup() {
    backup_date=$(date +"%Y-%m-%d_%H-%M")
    backup_dir="/root/backup"
    backup_file="$backup_dir/iptables_backup_$backup_date"

    mkdir -p "$backup_dir" # Створення папки бекапу, якщо вона ще не існує
    iptables-save >"$backup_file"
    echo "Створено перший бекап iptables: $backup_file"

    second_backup_file="iptables_backup_$backup_date"

    iptables-save >"$second_backup_file"
    echo "Створено другий бекап iptables: $second_backup_file"
}

4_blockIPsUsingIptables() {
    4_createIptablesBackup
    blocked_ips_file="blocked_IPs.log"
    iptables-save
    if [ -f "$blocked_ips_file" ]; then
        # Зчитування IP-адрес з файлу та блокування їх за допомогою iptables
        while read -r ip; do
            # Блокування IP-адреси за допомогою iptables
            iptables -t filter -I INPUT 1 -s "$ip" -j REJECT

            #iptables -t filter -I OUTPUT 1 -d "$ip" -j REJECT
            #iptables -A INPUT -s "$ip" -j DROP
            echo "Заблоковано IP: $ip"
        done <"$blocked_ips_file"
        iptables-save
        echo "IP-адреси з файлу $blocked_ips_file були заблоковані за допомогою iptables."
    else
        echo "Файл $blocked_ips_file не існує."
    fi
}
