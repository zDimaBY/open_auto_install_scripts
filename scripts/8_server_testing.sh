# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 8_server_testing() {
    while true; do
        check_info_server
        check_info_control_panel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Тестування ${BROWN}швидкості інтерфейсу${RESET}"
        echo -e "2. Тестування ${BLUE}пошти${RESET}"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) 8_server_testing_speed ;;
        2) 8_server_testing_mail ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

install_speedtest() {
    system_arch=$(uname -m)
    # Якщо архітектура не визначена, використовуємо іншу команду для її отримання
    [ -z "$system_arch" ] && system_arch=$(arch)

    # Визначаємо системну архітектуру та задаємо відповідну змінну
    case "$system_arch" in
    x86_64) system_arch_bit="x86_64" ;;
    i386 | i686) system_arch_bit="i386" ;;
    armv8 | armv8l | aarch64 | arm64) system_arch_bit="aarch64" ;;
    armv7 | armv7l) system_arch_bit="armhf" ;;
    armv6) system_arch_bit="armel" ;;
    *)
        echo "Помилка: Непідтримувана архітектура системи ($system_arch)." >&2
        return 1
        ;;
    esac

    download_url1="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-${system_arch_bit}.tgz"
    download_url2="https://dl.lamp.sh/files/ookla-speedtest-1.2.0-linux-${system_arch_bit}.tgz"

    # Завантажуємо файл з першого URL, якщо не вдалося - пробуємо з другого URL
    wget --no-check-certificate -q -T10 -O /root/speedtest_cli.tgz $download_url1 ||
        wget --no-check-certificate -q -T10 -O /root/speedtest_cli.tgz $download_url2 || {
        # Якщо завантаження не вдалося з обох URL, виводимо помилку і завершуємо скрипт
        echo "Помилка: Не вдалося завантажити speedtest-cli." >&2
        return 1
    }

    create_folder "/root/speedtest-cli" && tar -zxf speedtest_cli.tgz -C /root/speedtest-cli/ && chmod +x /root/speedtest-cli/speedtest && rm -f /root/speedtest_cli.tgz
}

speed_test() {
    local log_file="/root/speedtest-cli/speedtest.log"
    /root/speedtest-cli/speedtest --progress=no --accept-license --accept-gdpr >"$log_file"
    cat $log_file
}

8_server_testing_speed() {
    if [ ! -e "/root/speedtest-cli/speedtest" ]; then
        install_speedtest
    fi
    speed_test
}

8_server_testing_mail() {

    read -p "Введіть домен: " DOMAIN
    read -p "Введіть IP сервера: " SERVER_IP

    # Перевірка PTR запису
    check_ptr() {
        echo -e "${RED}PTR${BLUE}-------------------------------------------------------------------------------------------------------------------------------------${RESET}"
        PTR_DETAILS=$(dig -x $SERVER_IP)
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Помилка при перевірці PTR запису для $SERVER_IP${RESET}"
        else
            answer_section=$(echo "$PTR_DETAILS" | awk '/^;; ANSWER SECTION:$/,/^$/')
            result_answer_section=$(echo "$answer_section" | grep -v ';; ANSWER SECTION:')
            echo -e "PTR запис: \n${GREEN}$result_answer_section${RESET}"
            echo -e "\n${YELLOW}Для перевірки ви можете скористатися командою:${RESET} \ndig -x $SERVER_IP | awk '/^;; ANSWER SECTION:$/,/^$/{if(!/^;; ANSWER SECTION:$/)print}'"
        fi
        echo -e "${RED}END PTR${BLUE}---------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    }

    # Перевірка rDNS запису
    check_rdns() {
        echo -e "${RED}rDNS${BLUE}------------------------------------------------------------------------------------------------------------------------------------${RESET}"
        rDNS=$(dig -x $SERVER_IP +short)
        if [[ "$rDNS" != "$DOMAIN." ]]; then
            echo -e "${RED}rDNS запис не відповідає: $rDNS != $DOMAIN.${RESET}"
        else
            echo -e "rDNS запис відповідає: ${GREEN}$rDNS${RESET}"
        fi
        echo -e "\n${YELLOW}Для перевірки ви можете скористатися командою:${RESET} \ndig -x $SERVER_IP +short"
        echo -e "${RED}END rDNS${BLUE}--------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    }

    # Перевірка MX записів
    check_mx() {
        echo -e "${RED}MX${BLUE}--------------------------------------------------------------------------------------------------------------------------------------${RESET}"
        MX=$(dig MX $DOMAIN +short)
        if [[ -z "$MX" ]]; then
            echo -e "${RED}MX записи не знайдено для $DOMAIN${RESET}"
        else
            echo -e "MX записи для $DOMAIN: \n${GREEN}$MX${RESET}"
        fi
        echo -e "\n${YELLOW}Для перевірки ви можете скористатися командою:${RESET} \ndig MX $DOMAIN +short"
        echo -e "${RED}END MX${BLUE}----------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    }

    # Перевірка DKIM записів
    check_dkim() {
        echo -e "${RED}DKIM${BLUE}------------------------------------------------------------------------------------------------------------------------------------${RESET}"
        DKIM=$(dig TXT mail._domainkey.$DOMAIN +short)
        if [[ -z "$DKIM" ]]; then
            echo -e "${RED}Стандартні DKIM записи не знайдено для $DOMAIN${RESET}"
            echo "Якщо налаштований інший селектор, то можите скористатися командою: dig TXT ваш_селектор._domainkey.$DOMAIN +short"
        else
            echo -e "DKIM запис для $DOMAIN: \n${GREEN}$DKIM${RESET}"
            echo -e "\n${YELLOW}Для перевірки ви можете скористатися командою:${RESET} \ndig TXT mail._domainkey.$DOMAIN +short"
        fi
        echo -e "${RED}END DKIM${BLUE}--------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    }

    # Перевірка DMARC записів
    check_dmarc() {
        echo -e "${RED}DMARC${BLUE}-----------------------------------------------------------------------------------------------------------------------------------${RESET}"
        DMARC=$(dig TXT _dmarc.$DOMAIN +short)
        if [[ -z "$DMARC" ]]; then
            echo -e "${RED}DMARC запис не знайдено для $DOMAIN${RESET}"
        else
            echo -e "DMARC запис для $DOMAIN: \n${GREEN}$DMARC${RESET}"
        fi
        echo -e "\n${YELLOW}Для перевірки ви можете скористатися командою:${RESET} \ndig TXT _dmarc.$DOMAIN +short"
        echo -e "${RED}END DMARC${BLUE}-------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    }

    # Перевірка SPF записів
    check_spf() {
        echo -e "${RED}SPF${BLUE}-------------------------------------------------------------------------------------------------------------------------------------${RESET}"
        SPF=$(dig TXT $DOMAIN +short | grep "v=spf1")
        if [[ -z "$SPF" ]]; then
            echo -e "${RED}SPF запис не знайдено для $DOMAIN${RESET}"
        else
            echo -e "SPF запис для $DOMAIN: ${GREEN}$SPF${RESET}"
        fi
        echo -e "\n${YELLOW}Для перевірки ви можете скористатися командою:${RESET} \ndig TXT $DOMAIN +short | grep \"v=spf1\""
        echo -e "${RED}END SPF${BLUE}---------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    }

    # Перевірка HELO/EHLO
    check_helo() {
        echo -e "${RED}HELO/EHLO${BLUE}-------------------------------------------------------------------------------------------------------------------------------${RESET}"
        HELO=$(nslookup -type=PTR $SERVER_IP | awk '/name =/ {print $4}')
        if [[ "$HELO" != "$DOMAIN." ]]; then
            echo -e "${RED}HELO/EHLO запис не відповідає: $HELO != $DOMAIN.${RESET}"
        else
            echo -e "HELO/EHLO запис відповідає: ${GREEN}$HELO${RESET}"
        fi
        echo -e "${RED}END HELO/EHLO${BLUE}---------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    }

    # Перевірка DNS записів
    check_dns() {
        echo -e "${RED}DNS${BLUE}-------------------------------------------------------------------------------------------------------------------------------------${RESET}"
        DNS=$(dig A $DOMAIN +short)
        if [[ -z "$DNS" ]]; then
            echo -e "${RED}DNS запис не знайдено для $DOMAIN${RESET}"
        else
            echo -e "DNS запис для $DOMAIN: ${GREEN}$DNS${RESET}"
        fi
        echo -e "\n${YELLOW}Для перевірки ви можете скористатися командою:${RESET} \ndig A $DOMAIN +short"
        echo -e "${RED}END DNS${BLUE}---------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    }

    # Перевірка відповідності Hostname домену
    check_hostname() {
        echo -e "${RED}hostname${BLUE}--------------------------------------------------------------------------------------------------------------------------------${RESET}"
        HOSTNAME=$(hostname)
        if [[ "$HOSTNAME" != "$DOMAIN" ]]; then
            echo -e "${RED}Hostname не відповідає домену: $HOSTNAME != $DOMAIN${RESET}"
        else
            echo -e "Hostname відповідає домену: ${GREEN}$HOSTNAME${RESET}"
        fi
        echo -e "\n${YELLOW}Для перевірки ви можете скористатися командою:${RESET} hostname"
        echo -e "${RED}END hostname${BLUE}----------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    }

    # Виконання перевірок
    check_ptr
    check_rdns
    check_mx
    check_dkim
    check_dmarc
    check_spf
    check_helo
    check_dns
    check_hostname
}
