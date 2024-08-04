#!/bin/bash -n
# shellcheck disable=SC2148,SC2154
function 8_server_testing() {
    statistics_scripts "8"
    while true; do
        check_info_server
        check_info_control_panel
        print_color_message 255 255 0 "\nВиберіть дію:\n"
        echo -e "1. Тестування ${BROWN}швидкості інтерфейсу${RESET}"
        echo -e "2. Тестування ${BLUE}пошти${RESET}"
        print_color_message 255 255 255 "\n0. Вийти з цього підменю!"
        print_color_message 255 255 255 "00. Закінчити роботу скрипта\n"

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
        print_color_message 200 0 0 "Помилка: Не вдалося завантажити speedtest-cli." >&2
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
        print_color_message 200 0 0 "speedtest-cli не знайдено."
        install_speedtest
    fi
    if [ -e "/root/speedtest-cli/speedtest" ]; then
        speed_test
    fi
}

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
        echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} dig -x $SERVER_IP | awk '/^;; ANSWER SECTION:$/,/^$/{if(!/^;; ANSWER SECTION:$/)print}'"
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
    echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} dig -x $SERVER_IP +short"
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
    echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} dig MX $DOMAIN +short"
    echo -e "${RED}END MX${BLUE}----------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

# Перевірка DKIM записів
check_dkim() {
    echo -e "${RED}DKIM${BLUE}------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    SELECTORS=(
        "mail" "default" "dkim" "selector1" "selector2" "s1" "s2"
        "google" "fastmail" "yahoo" "zoho" "hotmail" 
        "mandrill" "mailchimp" "sendgrid" "postmark" "amazon"
        "sparkpost" "mailgun" "ms" "smtp" "exchange" 
        "protection" "office365" "sendinblue" "mailjet"
    )
    
    DKIM_FOUND=false
    
    for SELECTOR in "${SELECTORS[@]}"; do
        DKIM=$(dig TXT ${SELECTOR}._domainkey.$DOMAIN +short)
        if [[ -n "$DKIM" ]]; then
            echo -e "DKIM запис для селектора ${SELECTOR}: \n${GREEN}$DKIM${RESET}"
            echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} dig TXT ${SELECTOR}._domainkey.$DOMAIN +short"
            DKIM_FOUND=true
        fi
    done
    
    if [[ "$DKIM_FOUND" == false ]]; then
        echo -e "${RED}DKIM записів не знайдено для домену $DOMAIN за всіма перевіреними селекторами.${RESET}"
        echo "Якщо налаштований інший селектор, ви можете скористатися командою: dig TXT ваш_селектор._domainkey.$DOMAIN +short"
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
    echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} dig TXT _dmarc.$DOMAIN +short"
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
    echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} dig TXT $DOMAIN +short | grep \"v=spf1\""
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
    
    echo -e "${YELLOW}Перевірка HELO/EHLO через telnet на порт 25...${RESET}"
    
    TELNET_RESPONSE=$( (echo open $DOMAIN 25; sleep 2; echo EHLO $DOMAIN; sleep 2; echo quit) | telnet )
    if [[ "$TELNET_RESPONSE" == *"220"* && "$TELNET_RESPONSE" == *"250"* ]]; then
        echo -e "Telnet з'єднання встановлено успішно. Відповідь сервера: \n${GREEN}$TELNET_RESPONSE${RESET}"
    else
        echo -e "${RED}Не вдалося встановити telnet з'єднання на порт 25 або отримати правильну відповідь.${RESET}"
        echo -e "Отримана відповідь: \n${RED}$TELNET_RESPONSE${RESET}"
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
    echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} dig A $DOMAIN +short"
    echo -e "${RED}END DNS${BLUE}---------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

# Перевірка доступності SMTP-порту
check_smtp_port() {
    echo -e "${RED}SMTP PORT${BLUE}-------------------------------------------------------------------------------------------------------------------------------${RESET}"
    nc -zv $DOMAIN 25
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}SMTP порт 25 не доступний на $DOMAIN${RESET}"
    else
        echo -e "SMTP порт 25 доступний на ${GREEN}$DOMAIN${RESET}"
    fi
    echo -e "${RED}END SMTP PORT${BLUE}---------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

# Перевірка TLS/SSL сертифіката
check_ssl() {
    echo -e "${RED}SSL${BLUE}-------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    SSL=$(echo | openssl s_client -connect $DOMAIN:25 -starttls smtp 2>/dev/null | openssl x509 -noout -dates)
    if [[ -z "$SSL" ]]; then
        echo -e "${RED}SSL сертифікат не знайдено або не налаштовано для $DOMAIN${RESET}"
    else
        echo -e "SSL сертифікат для $DOMAIN: \n${GREEN}$SSL${RESET}"
    fi
    echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} echo | openssl s_client -connect $DOMAIN:25 -starttls smtp 2>/dev/null | openssl x509 -noout -dates"
    echo -e "${RED}END SSL${BLUE}---------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

# Перевірка можливості надсилання пошти
check_send_mail() {
    echo -e "${RED}SEND MAIL${BLUE}-------------------------------------------------------------------------------------------------------------------------------${RESET}"
    echo "Тестове повідомлення" | mail -s "Тест" test@$DOMAIN
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Помилка при спробі надсилання пошти до test@$DOMAIN${RESET}"
    else
        echo -e "Пошта успішно надіслана до ${GREEN}test@$DOMAIN${RESET}"
    fi
    echo -e "${RED}END SEND MAIL${BLUE}--------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

# Перевірка чорних списків
check_blacklists() {
    echo -e "${RED}BLACKLISTS${BLUE}------------------------------------------------------------------------------------------------------------------------------${RESET}"
    BLACKLISTS=("zen.spamhaus.org" "bl.spamcop.net" "b.barracudacentral.org")
    for BL in "${BLACKLISTS[@]}"; do
        BL_CHECK=$(dig +short $SERVER_IP.$BL)
        if [[ -z "$BL_CHECK" ]]; then
            echo -e "IP $SERVER_IP не знайдено в чорному списку ${GREEN}$BL${RESET}"
        else
            echo -e "${RED}IP $SERVER_IP знайдено в чорному списку $BL, запит повернув:${RESET}$BL_CHECK"
            echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} dig +short $SERVER_IP.$BL"
        fi
    done
    echo -e "${RED}END BLACKLISTS${BLUE}--------------------------------------------------------------------------------------------------------------------------${RESET}\n"
    # Перевірка у списку Combined Spam Sources (CSS) dig +short ${SERVER_IP}.cbl.abuseat.org
    # Перевірка у списку Domain Blocklist (DBL) dig +short ${SERVER_IP}.dbl.spamhaus.org
    # Перевірка у списку Exploits Blocklist (XBL) dig +short ${SERVER_IP}.xbl.spamhaus.org
    # Перевірка у списку Policy Blocklist (PBL) dig +short ${SERVER_IP}.pbl.spamhaus.org
    # Перевірка у списку Spamhaus Blocklist (SBL) dig +short ${SERVER_IP}.sbl.spamhaus.org
    # Перевірка у списку Zen Blocklist dig +short ${SERVER_IP}.zen.spamhaus.org
    # Перевірка згідно DNSBL Fair Use Policy dig +short ${SERVER_IP}.fabel.dk
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
    echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} hostname"
    echo -e "${RED}END hostname${BLUE}----------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_hosts() {
    echo -e "${RED}HOSTS${BLUE}-------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    if grep -q "$SERVER_IP" /etc/hosts; then
        echo -e "${GREEN}IP-адреса $SERVER_IP присутня в /etc/hosts.${RESET}"
    else
        echo -e "${RED}IP-адреса $SERVER_IP не знайдена в /etc/hosts.${RESET}"
    fi
    echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} cat /etc/hosts"
    echo -e "${RED}END HOSTS${BLUE}-----------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_mailname() {
    echo -e "${RED}MAILNAME${BLUE}-------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    if [[ -f /etc/mailname ]]; then
        MAILNAME=$(cat /etc/mailname)
        if [[ "$MAILNAME" == "$DOMAIN" ]]; then
            echo -e "${GREEN}Домен у /etc/mailname відповідає $DOMAIN.${RESET}"
        else
            echo -e "${RED}Домен у /etc/mailname не відповідає: $MAILNAME != $DOMAIN.${RESET}"
        fi
        echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} cat /etc/mailname"
    else
        echo -e "${RED}Файл /etc/mailname не знайдено.${RESET}"
    fi
    echo -e "${RED}END ETC/MAILNAME${BLUE}-----------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_exim4() {
    echo -e "${RED}EXIM4${BLUE}-------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    if [[ -d /etc/exim4 ]]; then
        if grep -q "$DOMAIN" /etc/exim4/*; then
            echo -e "${GREEN}Домен $DOMAIN присутній у конфігураціях Exim4.${RESET}"
        else
            echo -e "${RED}Домен $DOMAIN не знайдено у конфігураціях Exim4.${RESET}"
        fi
        echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} grep -rn "$DOMAIN" /etc/exim4"
    else
        echo -e "${RED}Директорія /etc/exim4 не знайдена.${RESET}"
    fi
    echo -e "${RED}END EXIM4${BLUE}-----------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_dovecot() {
    echo -e "${RED}DOVECOT${BLUE}-------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    if [[ -d /etc/dovecot ]]; then
        if grep -q "$DOMAIN" /etc/dovecot/*; then
            echo -e "${GREEN}Домен $DOMAIN присутній у конфігураціях Dovecot.${RESET}"
        else
            echo -e "${RED}Домен $DOMAIN не знайдено у конфігураціях Dovecot.${RESET}"
        fi
        echo -e "${YELLOW}Для перевірки ви можете скористатися командою:${RESET} grep -rn "$DOMAIN" /etc/dovecot"
    else
        echo -e "${RED}Директорія /etc/dovecot не знайдена.${RESET}"
    fi
    echo -e "${RED}END DOVECOT${BLUE}-----------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_mail_logs_exim() {
    echo -e "${RED}MAIL LOGS (EXIM)${BLUE}---------------------------------------------------------------------------------------------------------------------------${RESET}"
    if [[ -f /var/log/exim4/mainlog ]]; then
        tail -n 5 /var/log/exim4/mainlog
    else
        echo -e "${RED}Журнал пошти Exim не знайдено.${RESET}"
    fi
    echo -e "${RED}END MAIL LOGS (EXIM)${BLUE}-----------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_mail_logs_postfix() {
    echo -e "${RED}MAIL LOGS (POSTFIX)${BLUE}-------------------------------------------------------------------------------------------------------------------------${RESET}"
    if [[ -f /var/log/mail.log ]]; then
        tail -n 5 /var/log/mail.log
    else
        echo -e "${RED}Журнал пошти Postfix не знайдено.${RESET}"
    fi
    echo -e "${RED}END MAIL LOGS (POSTFIX)${BLUE}-----------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_mail_queue_exim() {
    echo -e "${RED}MAIL QUEUE (EXIM)${BLUE}--------------------------------------------------------------------------------------------------------------------------${RESET}"
    exim -bp
    echo -e "${RED}END MAIL QUEUE (EXIM)${BLUE}------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_mail_queue_postfix() {
    echo -e "${RED}MAIL QUEUE (POSTFIX)${BLUE}------------------------------------------------------------------------------------------------------------------------${RESET}"
    postqueue -p
    echo -e "${RED}END MAIL QUEUE (POSTFIX)${BLUE}----------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_postfix_config() {
    echo -e "${RED}POSTFIX CONFIG${BLUE}---------------------------------------------------------------------------------------------------------------------------${RESET}"
    if [[ -f /etc/postfix/main.cf ]]; then
        grep "inet_interfaces = all" /etc/postfix/main.cf
        grep "mydestination = " /etc/postfix/main.cf
    else
        echo -e "${RED}Конфігураційний файл Postfix не знайдено.${RESET}"
    fi
    echo -e "${RED}END POSTFIX CONFIG${BLUE}-----------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

check_amavis() {
    echo -e "${RED}AMAVIS${BLUE}-------------------------------------------------------------------------------------------------------------------------------------${RESET}"
    if [[ -f /etc/amavis/conf.d/50-user ]]; then
        grep "use strict;" /etc/amavis/conf.d/50-user
    else
        echo -e "${RED}Конфігураційний файл Amavis не знайдено.${RESET}"
    fi
    echo -e "${RED}END AMAVIS${BLUE}---------------------------------------------------------------------------------------------------------------------------------${RESET}\n"
}

8_server_testing_mail() {
    case $operating_system in
    debian | ubuntu)
        if ! command -v dig &>/dev/null || ! command -v nslookup &>/dev/null; then
            echo -e "${RED}dig або nslookup не знайдено. Встановлюємо...${RESET}"
            install_package "dnsutils" "dig"
        fi
        ;;
    fedora)
        if ! command -v dig &>/dev/null || ! command -v nslookup &>/dev/null; then
            echo -e "${RED}dig або nslookup не знайдено. Встановлюємо...${RESET}"
            install_package "bind-utils" "dig"
        fi
        ;;
    centos | oracle)
        if ! command -v dig &>/dev/null || ! command -v nslookup &>/dev/null; then
            echo -e "${RED}dig або nslookup не знайдено. Встановлюємо...${RESET}"
            install_package "bind-utils" "dig"
        fi
        ;;
    arch | sysrescue)
        if ! command -v dig &>/dev/null || ! command -v nslookup &>/dev/null; then
            echo -e "${RED}dig або nslookup не знайдено. Встановлюємо...${RESET}"
            install_package "dnsutils" "dig"
        fi
        ;;
    *)
        echo -e "${RED}Не вдалося встановити dig або nslookup. Будь ласка, встановіть їх вручну.${RESET}"
        return 1
        ;;
    esac

    read -p "Введіть домен: " DOMAIN
    read -p "Введіть IP сервера: " SERVER_IP

    # Виконання перевірок
    check_ptr
    check_rdns
    check_mx
    check_dkim
    check_dmarc
    check_spf
    check_helo
    check_dns
    check_smtp_port
    check_ssl
    #check_send_mail
    check_blacklists
    check_hostname
    check_hosts
    check_mailname
    check_exim4
    check_dovecot
    check_mail_logs_exim
    check_mail_logs_postfix
    #check_mail_queue_exim
    #check_mail_queue_postfix
    #check_postfix_config
    check_amavis
}
