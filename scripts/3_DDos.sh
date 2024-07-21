#!/bin/bash -n
# shellcheck disable=SC2148,SC2154
function 3_DDos() {
    clear
    statistics_scripts "3"
    while true; do
        check_info_server
        check_info_control_panel
        get_selected_interface
        read -p "Введіть тривалість таймауту tcpdump (у секундах, стандартне значення: 5): " duration
        duration=${duration:-5}
        print_color_message 255 255 0 "\nВиберіть дію:\n"
        print_color_message 255 255 255 "1. Аналіз кількості IP-запитів на мережевому інтерфейсі протягом $(print_color_message 255 99 71 '$duration') секунд"
        print_color_message 255 255 255 "2. Аналіз кількості унікальних IP-адрес на мережевому інтерфейсі протягом $(print_color_message 255 99 71 '$duration') секунд"
        print_color_message 255 255 255 "3. Перехопити пакети з мережевого інтерфейсу $(print_color_message 255 99 71 '$selected_adapter') окрім ssh/22"
        print_color_message 255 255 255 "4. Створити файл blocked_IPs.log на основі аналізу tcpdump протягом $(print_color_message 255 99 71 '$duration') секунд"
        print_color_message 255 255 255 "5. Створити резервні копії iptables та заблокувати IP з файлу $(print_color_message 255 99 71 'blocked_IPs.log')"
        print_color_message 255 255 255 "\n0. Вийти з цього підменю!"
        read -p "Виберіть опцію (1/0): " choice

        case $choice in
        1) 3_AnalysisRequestsOfNetworkInterface ;;
        2) 3_repeatsOfNetworkInterface ;;
        3) 3_viewInterfacePacks ;;
        4) 3_blockIPs ;;
        5) 3_blockIPsUsingIptables ;;
        0) return ;;
        *) 0_invalid ;;
        esac
    done
}
function 3_viewInterfacePacks() {
    tcpdump -i $selected_adapter 'not port 22'
}
function 3_AnalysisRequestsOfNetworkInterface() {
    clear
    while true; do
        check_info_server
        check_info_control_panel
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

function 3_repeatsOfNetworkInterface() {
    clear
    while true; do
        check_info_server
        check_info_control_panel
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

function 3_blockIPs() {
    read -p "Введіть кількість запитів, що спричиняють блокування (за замовчуванням 100): " threshold
    threshold=${threshold:-100}

    log_file="blocked_IPs.log" # Шлях до лог-файлу для зберігання заблокованих IP-адрес

    # Масив системних та зарезервованих IP-адрес
    system_IPs=("${server_IPv4[0]}" "$server_hostname" "127.0.0.1" "localhost" "0.0.0.0" "255.255.255.255")

    clear
    while true; do
        check_info_server
        check_info_control_panel
        echo -e "\e[93mВи у пункті: "2. Блокування IP-адрес з підозрілими запитами"${RESET}"
        echo -e "\e[93mЩоб повернутися до попереднього меню натисніть${RED} 0 та Enter${RESET}\n"
        output=$(timeout "$duration" tcpdump -nn -i "$selected_adapter")
        ip_requests=$(echo "$output" | awk '/IP /{print $3}' | awk -F '.' '{print $1"."$2"."$3"."$4}' | sort | uniq -c)

        while read -r line; do
            count=$(echo "$line" | awk '{print $1}')
            ip=$(echo "$line" | awk '{print $2}')

            # Перевірка, чи IP-адреса не належить системним або зарезервованим IP-адресам та не знаходиться в лог-файлі заблокованих IP-адрес
            if [[ ! " ${system_IPs[*]} " =~ " $selected_ip_address " ]] && [[ $count -gt $threshold ]] && ! grep -q "$selected_ip_address" "$log_file"; then
                echo "Заблоковано IP: $selected_ip_address"
                echo "$selected_ip_address" >>"$log_file"
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

3_createIptablesBackup() {
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

3_blockIPsUsingIptables() {
    3_createIptablesBackup
    blocked_ips_file="blocked_IPs.log"
    iptables-save
    if [ -f "$blocked_ips_file" ]; then
        # Зчитування IP-адрес з файлу та блокування їх за допомогою iptables
        while read -r ip; do
            # Блокування IP-адреси за допомогою iptables
            iptables -t filter -I INPUT 1 -s "$selected_ip_address" -j REJECT

            #iptables -t filter -I OUTPUT 1 -d "$selected_ip_address" -j REJECT
            #iptables -A INPUT -s "$selected_ip_address" -j DROP
            echo "Заблоковано IP: $selected_ip_address"
        done <"$blocked_ips_file"
        iptables-save
        echo "IP-адреси з файлу $blocked_ips_file були заблоковані за допомогою iptables."
    else
        echo "Файл $blocked_ips_file не існує."
    fi
}
