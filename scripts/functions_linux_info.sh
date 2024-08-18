#!/bin/bash -n
# shellcheck disable=SC2148,SC2154

# Color message display function
print_color_message() {
    local red=$1
    local green=$2
    local blue=$3
    local message=$4
    echo -e "\033[38;2;${red};${green};${blue}m${message}\033[m"
}

# Function to allocate IP addresses
distribute_ips() { # ${server_IPv4[0]} ${server_IPv6[0]}
    # Отримуємо IP-адреси з hostname -I та hostname -i
    local ip_output_i=$(hostname -i 2>/dev/null)
    local ip_output_I=$(hostname -I 2>/dev/null)

    # Розділяємо IP-адреси за пробілами та зберігаємо їх в масивах
    IFS=' ' read -r -a ip_addresses_i <<<"$ip_output_i"
    IFS=' ' read -r -a ip_addresses_I <<<"$ip_output_I"

    # Перевіряємо наявність спільних IP-адрес у hostname -i та hostname -I
    for ip_i in "${ip_addresses_i[@]}"; do
        for ip_I in "${ip_addresses_I[@]}"; do
            if [[ "$ip_i" == "$ip_I" ]]; then
                # Якщо адреси співпадають, видаляємо її з hostname -i
                ip_addresses_i=("${ip_addresses_i[@]/$ip_i/}")
            fi
        done
    done

    # Об'єднуємо IP-адреси знову та записуємо у hostname -I
    local merged_ip_addresses="${ip_addresses_I[*]} ${ip_addresses_i[*]}"

    # Розділяємо IP-адреси за пробілами та зберігаємо їх в масиві
    IFS=' ' read -r -a ip_addresses <<<"$merged_ip_addresses"

    # масиви для IPv4 та IPv6
    server_IPv4=()
    server_IPv6=()

    for ip in "${ip_addresses[@]}"; do
        if [[ $ip == *:* ]]; then
            server_IPv6+=("$ip")
        else
            server_IPv4+=("$ip")
        fi
    done
}

version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

check_compatibility_script() {
    if [ "$(id -u)" -ne 0 ]; then
        print_color_message 200 0 0 "$MSG_ERROR_NOT_ROOT"
    fi

    if [ -e "/etc/os-release" ]; then
        source "/etc/os-release"
    else
        print_color_message 200 0 0 "$MSG_ERROR_OS_RELEASE_NOT_FOUND"
        print_color_message 200 0 0 "$MSG_ERROR_LSB_NOT_INSTALLED"

        case "$(uname -s)" in
        Linux)
            if [ -x "$(command -v apt-get)" ]; then
                print_color_message 200 0 0 "$MSG_DEBIAN_BASED_SYSTEM"
                print_color_message 200 0 0 "sudo apt-get update && sudo apt-get install lsb-release"
            elif [ -x "$(command -v yum)" ]; then
                print_color_message 200 0 0 "$MSG_REDHAT_BASED_SYSTEM"
                print_color_message 200 0 0 "sudo yum install redhat-lsb-core"
            elif [ -x "$(command -v dnf)" ]; then
                print_color_message 200 0 0 "$MSG_ALMALINUX"
                print_color_message 200 0 0 "sudo dnf install redhat-lsb-core"
            elif [ -x "$(command -v zypper)" ]; then
                print_color_message 200 0 0 "$MSG_SUSE"
                print_color_message 200 0 0 "sudo zypper install lsb-release"
            elif [ -x "$(command -v pacman)" ]; then
                print_color_message 200 0 0 "$MSG_ARCH_LINUX"
                print_color_message 200 0 0 "sudo pacman -Sy lsb-release"
            else
                print_color_message 200 0 0 "$MSG_ERROR_UNSUPPORTED_PACKAGE_MANAGER"
            fi
            ;;
        *)
            print_color_message 200 0 0 "$MSG_ERROR_UNSUPPORTED_OS"
            ;;
        esac

        exit 1
    fi
}

check_info_server() {
    print_color_message 0 200 0 "----------------------------------------------------------------------------------------------------------------------------------------"

    if [ -z "$data" ]; then
        # URL to get data about Linux distributions
        base_url="https://endoflife.date/api/${ID}.json"
        data=$(curl -s --max-time 2 "${base_url}")
        SUPPORT_OS_END=$(echo "$data" | grep -oP '"cycle":\s*"'${VERSION_ID}'".*?"eol":\s*".*?"' | grep -oP '"eol":\s*".*?"' | sed 's/"eol":\s*"\(.*\)"/\1/')
    fi

    case "${ID}" in
    "debian" | "ubuntu")
        echo -e "$(print_color_message 255 255 0 "$MSG_INFORMATION") $(print_color_message 255 0 0 "$ID") $(print_color_message 0 255 255 "$VERSION (based system)"). $([ -n "${SUPPORT_OS_END}" ] && print_color_message 255 0 0 "$MSG_END_LIFE: $SUPPORT_OS_END")"
        ;;
    "rhel" | "almalinux" | "eurolinux" | "rocky" | "centos")
        echo -e "$(print_color_message 255 255 0 "$MSG_INFORMATION") $(print_color_message 255 0 0 "$ID") $(print_color_message 0 255 255 "$VERSION (Red Hat-based system)"). $([ -n "${SUPPORT_OS_END}" ] && print_color_message 255 0 0 "$MSG_END_LIFE: $SUPPORT_OS_END")"
        ;;
    "arch" | "sysrescue" | "gentoo" | "slackware")
        echo -e "$(print_color_message 255 255 0 "$MSG_INFORMATION") $(print_color_message 255 0 0 "$ID") $(print_color_message 0 255 255 "$VERSION (Arch-based system)"). $([ -n "${SUPPORT_OS_END}" ] && print_color_message 255 0 0 "$MSG_END_LIFE: $SUPPORT_OS_END")"
        ;;
    *)
        echo -e "$(print_color_message 255 255 0 "$MSG_INFORMATION") $(print_color_message 255 0 0 "$ID") $(print_color_message 0 255 255 "$VERSION (Other Linux-based system)"). $([ -n "${SUPPORT_OS_END}" ] && print_color_message 255 0 0 "$MSG_END_LIFE: $SUPPORT_OS_END")"
        ;;
    esac

    # Function for outputting IP addresses
    print_ips() {
        local iface="$1"
        local ips=("${!2}")
        local ipv6_color="$3"

        echo -n "$MSG_INTERFACE $(print_color_message 0 255 255 "$iface") IP:"
        for ip in "${ips[@]}"; do
            if [[ $ip == *":"* ]]; then
                # IPv6 address
                echo -n " $(print_color_message 100 100 100 "$ip")"
            else
                # IPv4 address
                echo -n " $(print_color_message 0 255 0 "$ip")"
            fi
        done
        echo
    }

    # Network interfaces
    print_color_message 255 255 0 "$MSG_NETWORK_INTERFACES"

    # Hostname and IP
    server_hostname=$(hostname)
    echo -e "$MSG_HOSTNAME: $(print_color_message 0 255 0 "$server_hostname") IP: $(print_color_message 255 0 255 "${server_IPv4[0]}")"

    if [[ "$1" == "full" ]]; then
        network_type="$(curl -s --max-time 5 http://ip6.me/api/ | cut -d, -f1)"
        if [[ $? -ne 0 || -z "$network_type" ]]; then
            network_type="$MSG_UNKNOWN"
        fi
        ipv4_check=$( (ping -4 -c 1 -W 4 ipv4.google.com >/dev/null 2>&1 && echo true) || curl -s --max-time 5 -4 icanhazip.com)
        if [[ $? -ne 0 || -z "$ipv4_check" ]]; then
            ipv4_check=""
        fi
        ipv6_check=$( (ping -6 -c 1 -W 4 ipv6.google.com >/dev/null 2>&1 && echo true) || curl -s --max-time 5 -6 icanhazip.com)
        if [[ $? -ne 0 || -z "$ipv6_check" ]]; then
            ipv6_check=""
        fi

        [[ -n "$ipv6_check" ]] && ipv6_status=$(echo "IPv6: $(print_color_message 0 255 0 "Online")") || ipv6_status=$(echo "IPv6: $(print_color_message 200 0 0 "Offline")")
        [[ -n "$ipv4_check" ]] && ipv4_status=$(echo "IPv4: $(print_color_message 0 255 0 "Online")") || ipv4_status=$(echo "IPv4: $(print_color_message 200 0 0 "Offline")")
        [[ -n "$network_type" ]] && echo "$MSG_PRIMARY_NETWORK: $(print_color_message 0 255 0 "$network_type") | $(print_color_message 255 255 0 "$MSG_STATUS_NETWORK:") ${ipv6_status}, ${ipv4_status}"
    fi

    declare -A interfaces
    # Get all IP addresses (IPv4 and IPv6) for each interface
    ip_output=$(ip -o addr show)
    if [ $? -ne 0 ]; then
        echo "$MSG_ERROR_IP_COMMAND"
    else
        while read -r line; do
            if [ $(echo $line | awk '{print NF}') -lt 4 ]; then
                echo "$MSG_INSUFFICIENT_FIELDS$line"
                continue
            fi

            iface=$(echo $line | awk '{print $2}')
            addr=$(echo $line | awk '{print $4}')

            if [ -z "$iface" ] || [ -z "$addr" ]; then
                echo "$MSG_INVALID_FORMAT$line"
                continue
            fi

            interfaces[$iface]+="$addr "
        done <<<"$ip_output"

        # Create sorted array of interfaces by number of characters
        sorted_interfaces=($(for iface in "${!interfaces[@]}"; do echo "$iface"; done | awk '{ print length, $0 }' | sort -n | cut -d" " -f2-))

        # Output IP addresses for each interface sorted by number of characters
        for iface in "${sorted_interfaces[@]}"; do
            ip_array=(${interfaces[$iface]})
            print_ips "$iface" ip_array[@]
        done
    fi

    # File Systems
    largest_disk=$(df -h | grep '^/dev/' | sort -k 4 -hr | head -n 1)
    disk_usage=$(echo "$largest_disk" | awk '{print $5}') # Disk usage on the largest disk
    echo -e "\n$(print_color_message 255 255 0 "$MSG_FILE_SYSTEMS") $MSG_DISK_USAGE: $disk_usage"
    df -hT | grep '^/dev/'

    # Memory
    echo -e "\n$(print_color_message 255 255 0 "$MSG_MEMORY")"
    read -r mem_total mem_used mem_free mem_shared mem_buff_cache mem_available < <(free -m | awk '/^Mem:/ {print $2, $3, $4, $5, $6, $7}')
    echo -e "$MSG_TOTAL_MEMORY: $(print_color_message 0 255 0 "${mem_total}MB") $MSG_USED_MEMORY: $(print_color_message 255 0 0 "${mem_used}MB") $MSG_FREE_MEMORY: $(print_color_message 0 255 255 "${mem_free}MB") $MSG_SHARED_MEMORY: $(print_color_message 128 0 128 "${mem_shared}MB") $MSG_BUFF_CACHE_MEMORY: $(print_color_message 100 149 237 "${mem_buff_cache}MB") $MSG_AVAILABLE_MEMORY: $(print_color_message 255 165 0 "${mem_available}MB")"

    # Load Average
    load_average=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}')
    load_average=${load_average%,*}
    load_average=$(echo "${load_average/,/.}")

    if (($(awk 'BEGIN {print ($load_average < 2)}'))); then
        load_average=$(print_color_message 0 200 0 "$load_average")
    elif (($(awk 'BEGIN {print ($load_average < 5)}'))); then
        load_average=$(print_color_message 200 200 0 "$load_average")
    else
        load_average=$(print_color_message 200 0 0 "$load_average (!)")
    fi
    echo -e "\n$(print_color_message 255 255 0 "$MSG_CPU") $MSG_LOAD_AVERAGE $load_average"

    # CPU
    cpu_info=$(lscpu)
    cpu_model=$(echo "$cpu_info" | awk -F': ' '/Model name/ {gsub(/^[ \t]+/, "", $2); print $2}')
    cpu_cores=$(echo "$cpu_info" | awk -F': ' '/^CPU\(s\)/ {gsub(/^[ \t]+/, "", $2); print $2}')
    echo -e "$MSG_CPU_MODEL $(print_color_message 0 255 255 "$cpu_model") $MSG_CPU_CORES $(print_color_message 0 255 0 "$cpu_cores")\n"

}

all_control_panels=("/usr/local/hestia" "/usr/local/vesta" "/usr/local/mgr5" "/usr/local/cpanel" "/usr/local/fastpanel2" "/usr/local/brainycp" "/usr/local/CyberCP" "/usr/local/CyberPanel")

check_info_control_panel() { # Function to check control panels
    for panel_dir in "${all_control_panels[@]}"; do
        if [ -d "$panel_dir" ]; then
            case $panel_dir in
            "/usr/local/hestia")
                source "$panel_dir/conf/hestia.conf"
                hestia_info=$(/usr/local/hestia/bin/v-list-sys-info)
                hestia_version=$(echo "$hestia_info" | awk 'NR==3{print $5}')
                cp_hostname=$(echo "$hestia_info" | awk 'NR==3{print $1}')
                cp_operating_system_panel=$(echo "$hestia_info" | awk 'NR==3{print $2}')
                cp_os_version=$(echo "$hestia_info" | awk 'NR==3{print $3}')

                WEB_ADMIN_PORT=$(ss -utpln | grep "hestia-nginx" | awk '{print $5}')
                print_color_message 0 102 204 "${MSG_HESTIA_INSTALLED} $(print_color_message 51 153 102 "$hestia_version") backend: $(print_color_message 200 200 0 "$WEB_SYSTEM") | ${MSG_WEB_ADMIN_PORT} $(print_color_message 200 200 0 "$WEB_ADMIN_PORT")"
                source /etc/os-release
                ;;
            "/usr/local/vesta")
                source "$panel_dir/conf/vesta.conf"
                vesta_info=$(/usr/local/vesta/bin/v-list-sys-info)
                vesta_version=$(echo "$VERSION")
                cp_hostname=$(echo "$vesta_info" | awk 'NR==3{print $1}')
                cp_operating_system_panel=$(echo "$vesta_info" | awk 'NR==3{print $2}')
                cp_os_version=$(echo "$vesta_info" | awk 'NR==3{print $3}')

                print_color_message 0 200 200 "${MSG_VESTA_INSTALLED} $(print_color_message 200 0 200 "$vesta_version") backend: $(print_color_message 200 200 0 "$WEB_SYSTEM")"
                source /etc/os-release
                ;;
            "/usr/local/mgr5")
                print_color_message 0 200 0 "$MSG_ISPMANAGER_INSTALLED"
                "$panel_dir/sbin/licctl" info ispmgr
                ;;
            "/usr/local/cpanel")
                print_color_message 0 200 0 "$MSG_CPanel_INSTALLED"
                "$panel_dir/cpanel" -V
                cat /etc/*release
                ;;
            "/usr/local/fastpanel2")
                fastuser_passwd_dir="/usr/local/fastpanel2/app/config/.my.cnf"
                print_color_message 0 150 230 "$MSG_FASTPANEL_INSTALLED"
                if [ -f $fastuser_passwd_dir ]; then
                    cat "$fastuser_passwd_dir" | tr '\n' ' ' && echo
                else
                    print_color_message 200 0 0 "$MSG_FILE_NOT_FOUND $fastuser_passwd_dir"
                fi
                ;;
            "/usr/local/brainycp")
                print_color_message 0 123 193 "$MSG_BRAINYCP_INSTALLED"
                #  Memory detector brainycp
                arr=(mysqld exim dovecot httpd nginx named brainyphp-fpm pure-ftpd memcached redis fail2ban csf xinetd sshd clamd clamsmtp-clamd spamassassin proftpd network NetworkManager postgresql tuned)
                not_found=""
                for t in "${arr[@]}"; do
                    if mem=$(systemctl status "$t" 2>&1 | grep Memory:); then
                        echo "$mem - $t"
                    else
                        not_found="$not_found $t"
                    fi
                done
                if [ -n "$not_found" ]; then
                    echo "$MSG_UNIT_NOT_FOUND $not_found"
                fi
                ;;
            "/www/server/panel/BTPanel/")
                print_color_message 0 200 0 "$MSG_BTPANEL_INSTALLED"
                ;;
            "/usr/local/CyberCP/")
                print_color_message 0 200 0 "$MSG_CyberCP_INSTALLED"
                ;;
            "/usr/local/CyberPanel/")
                print_color_message 0 200 0 "$MSG_CyberPanel_INSTALLED"
                ;;
            esac

            source /etc/os-release
            return
        fi
    done
    print_color_message 200 0 0 "$MSG_CONTROL_PANEL_NOT_FOUND"
}

check_command_version() {
    local command=$1
    local display_name=$2
    local color_success=(0 200 0)
    local color_version=(0 117 143)
    local color_error=(200 0 0)

    if command -v $command >/dev/null 2>&1; then
        local version=$($command --version 2>&1 | head -n 1)
        print_color_message ${color_success[0]} ${color_success[1]} ${color_success[2]} "$display_name $(print_color_message ${color_version[0]} ${color_version[1]} ${color_version[2]} "$version")"
    else
        print_color_message ${color_error[0]} ${color_error[1]} ${color_error[2]} "$display_name $MSG_COMMAND_NOT_INSTALLED."

    fi
}

check_available_services() {
    echo
    # Check MySQL, MariaDB, PostgreSQL, SQLite
    if ! command -v mysql >/dev/null 2>&1 && ! command -v mariadb >/dev/null 2>&1 && ! command -v psql >/dev/null 2>&1 && ! command -v sqlite3 >/dev/null 2>&1; then
        print_color_message 200 0 0 "$MSG_MYSQL_MARIADB_POSTGRESQL_SQLITE_NOT_INSTALLED"
    else
        check_command_version mysql "MySQL"
        check_command_version mariadb "MariaDB"
        check_command_version psql "PostgreSQL"
        check_command_version sqlite3 "SQLite"
    fi

    # Check PHP, Python, Node.js
    if ! command -v php >/dev/null 2>&1 && ! command -v python3 >/dev/null 2>&1 && ! command -v node >/dev/null 2>&1; then
        print_color_message 200 0 0 "$MSG_PHP_PYTHON_NODE_NOT_INSTALLED"
    else
        check_command_version php "PHP"
        check_command_version python3 "Python"
        check_command_version node "Node.js"
    fi

    # Check Composer
    check_command_version composer "Composer"

    # Check Docker
    if command -v docker >/dev/null 2>&1; then
        print_color_message 0 102 204 "$(docker -v)"
        docker ps -a
    else
        print_color_message 200 0 0 "$MSG_DOCKER_NOT_INSTALLED"
    fi

    ports=$(ss -tuln | awk 'NR>1 {print $5}' | cut -d ':' -f 2 | sort -n | uniq)
    for port in $ports; do
        count=$(ss -an | grep ":$port " | wc -l)
        if [[ $count -ge 3 ]]; then
            echo -e "Port $port: $(print_color_message 200 165 0 "$count")"
        fi
    done
    ss -plns
    ss -utnpl | awk '{printf "%-6s %-6s %-7s %-7s %-42s %-42s %-s\n", $1, $2, $3, $4, $5, $6, $7}'
}
