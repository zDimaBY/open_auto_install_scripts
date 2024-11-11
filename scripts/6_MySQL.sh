#!/bin/bash -n
# shellcheck disable=SC2148,SC2154
function 6_manage_docker_databases() {
    if ! check_docker_availability; then
        return 1
    fi
    statistics_scripts "6"
    while true; do
        print_color_message 255 255 0 "\n${MSG_CHOOSE_OPTION}\n"
        print_color_message 255 255 255 "1. $(print_color_message 255 215 0 'MySQL')"
        print_color_message 255 255 255 "2. $(print_color_message 255 215 0 'MariaDB')"
        print_color_message 255 255 255 "3. $(print_color_message 255 215 0 'MongoDB')"
        print_color_message 255 255 255 "4. $(print_color_message 255 215 0 'PostgreSQL')"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"
        read -p "Виберіть дію:" choice
        case $choice in
        1) install_database "mysql" ;;
        2) install_database "mariadb" ;;
        3) install_database "mongodb" ;;
        4) install_database "postgresql" ;;
        0) break ;;
        00) exit_script ;;
        *) invalid_choice ;;
        esac
    done
}

# Встановлення та робота з Docker образами баз даних
function install_database() {
    local db_name="$1"
    while true; do
        echo "Виберіть опцію:"
        echo "1. Встановити образ"
        echo "2. Видалити образ"
        echo "3. Налаштувати Docker"
        echo "4. Перелік запущених контейнерів"
        print_color_message 255 255 255 "\n0. ${MSG_EXIT_SUBMENU}"
        print_color_message 255 255 255 "00. ${MSG_EXIT_SCRIPT}\n"

        read -p "${MSG_CHOOSE_OPTION}" choice

        case $choice in
        1) select_tag_and_install "$db_name" ;;
        2) remove_images ;;
        3) echo "Налаштування Docker..." ;;
        4) docker ps -a ;;
        0) break ;;
        00) 0_funExit ;;

        *)
            echo "Недійсна опція. Будь ласка, виберіть ще раз."
            ;;
        esac
    done
}

# Вибір та встановлення образу з вибраним тегом
function select_tag_and_install() {
    local db_name="$1"
    local tags=()
    local list_docker_tags_databases

    read -p "Вкажіть, скільки версій баз даних вивести (за замовчуванням 50) (0 - щоб вийти у попереднє меню): " list_docker_tags_databases
    list_docker_tags_databases=${list_docker_tags_databases:-50}  # Використовуємо 100, якщо не введено число
    
    if [[ "$list_docker_tags_databases" -eq 0 ]]; then
        return  # Повертаємося у попереднє меню
    fi

    # Отримання списку тегів для вибраної бази даних
    local next_url=""
    case $db_name in
    "mariadb")
        next_url="https://hub.docker.com/v2/repositories/library/mariadb/tags/?page_size=$list_docker_tags_databases"
        ;;
    "mysql")
        next_url="https://hub.docker.com/v2/repositories/library/mysql/tags/?page_size=$list_docker_tags_databases"
        ;;
    "mongodb")
        next_url="https://hub.docker.com/v2/repositories/library/mongo/tags/?page_size=$list_docker_tags_databases"
        ;;
    "postgresql")
        next_url="https://hub.docker.com/v2/repositories/library/postgres/tags/?page_size=$list_docker_tags_databases"
        ;;
    *)
        echo "${RED}Помилка: Невідома база даних: $db_name${RESET}"
        return 1
        ;;
    esac

    while [ -n "$next_url" ]; do
        response="$("$local_temp_curl_path" -s "$next_url")"
        tags+=($(echo "$response" | "$local_temp_jq_path" -r '.results[].name'))

        next_url=$(echo "$response" | "$local_temp_jq_path" -r '.next')  # Отримуємо URL наступної сторінки
        if [ "$next_url" == "null" ]; then
            next_url=""  # Завершуємо, якщо немає наступної сторінки
        fi

        # Перевіряємо, чи досягли бажаної кількості тегів
        if [[ ${#tags[@]} -ge $list_docker_tags_databases ]]; then
            break
        fi
    done

    # Зрізаємо масив до максимальної кількості, якщо потрібно
    tags=("${tags[@]:0:list_docker_tags_databases}")

    # Сортуємо теги
    IFS=$'\n' tags=($(sort -r <<<"${tags[*]}"))
    unset IFS

    echo -e "\n${BLUE}latest${RESET}: Цей тег вказує на найновішу версію образу, доступну на Docker Hub."
    echo -e "${YELLOW}oraclelinux8${RESET}: Це означає, що образ побудований на базі Oracle Linux 8."
    echo -e "${GREEN}lts${RESET}: LTS означає Long-Term Support, це для версій з довгостроковою підтримкою."
    echo -e "${GREEN}----------------------------------------------------------------------------${RESET}"
    echo -e "${GREEN}8.0.37-debian${RESET}, ${GREEN}8.0.37-bookworm${RESET}, ${GREEN}8.0.37-oraclelinux8${RESET},також в інших базах jammy та focal - це\nназви версій операційних систем Ubuntu. Вони вказують на те, для якої версії операційної системи побудовані образи Mariadb. \nВзагалі ці теги вказують на версії MySQL, побудовані на конкретних операційних системах (наприклад, Debian, Oracle Linux, Ubuntu)."
    echo -e "${RED}11.3-rc-jammy, 11.3-rc${RESET}: це для версій, що перебувають у стадії реліз-кандидатів (RC), тобто перед остаточним релізом."
    echo -e "${GREEN}----------------------------------------------------------------------------${RESET}"
    echo -e "${RED}innovation${RESET}: Це спеціальна версія з новими функціями або експериментальні версії.\n"
    echo -e "${YELLOW}Ведіть ${RED}\"0\"${YELLOW} - щоб вийти у попереднє меню з опціями баз даних.${RESET}\n"
    
    echo "Виберіть образ для встановлення:"
    select tag in "${tags[@]}"; do
        if [[ "$tag" == "0" ]]; then
            echo "Вихід у попереднє меню."
            return  # Повертаємося у попереднє меню
        elif [[ -n "$tag" ]]; then
            run_container "$db_name" "$tag"
        fi
        break
    done
}

# Запуск контейнера з обраним образом
function run_container() {
    local db_name="$1"
    local tag="$2"
    local listen_address=""
    local port=""
    local password=""

    echo "Встановлення образу з тегом: $tag"

    # Вибір адаптера для прослуховування
    get_selected_interface

    # Введення порту прослуховування та паролю
    enter_port_and_password

    # Запуск контейнера з введеними параметрами
    start_container "$db_name" "$tag" "$selected_ip_address" "$port" "$password"
}

# Введення порту прослуховування та паролю
function enter_port_and_password() {
    echo -e "${GREEN}Унікальні використовані порти (TCP та UDP) у системі:${RESET}"
    ss -tuln | awk 'NR>1 {split($5,a,":"); print a[length(a)]}' | sort -n | uniq

    read -p "Введіть порт прослуховування для контейнера (за замовчуванням 3306): " port
    port=${port:-3306}

    generate_random_password_show
    read -p "Введіть пароль для root користувача бази даних: " password
}

# Запуск контейнера з введеними параметрами
function start_container() {
    local db_name="$1"
    local tag="$2"
    local listen_address="$3"
    local port="$4"
    local password="$5"

    echo "Запуск контейнера для образу з тегом: $tag"

    case $db_name in
    "mariadb")
        docker pull mariadb:"$tag"
        docker run --name mariadb-container-"$tag" -e MYSQL_ROOT_PASSWORD="$password" -p "$listen_address:$port":3306 -d mariadb:"$tag"
        echo -e "\n\nmariadb:$tag встановлено!\nДля перевірки використовуйте команду:\nmysql -h ${selected_ip_address} -P $port -u root -p\nПароль: $password\n\n"
        ;;
    "mysql")
        docker pull mysql:"$tag"
        docker run --name mysql-container-"$tag" -e MYSQL_ROOT_PASSWORD="$password" -p "$listen_address:$port":3306 -d mysql:"$tag"
        echo -e "\n\nmysql:$tag встановлено!\nДля перевірки використовуйте команду:\nmysql -h ${selected_ip_address} -P $port -u root -p\nПароль: $password\n\n"
        ;;
    "mongodb")
        docker pull mongo:"$tag"
        docker run --name mongo-container-"$tag" -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD="$password" -p "$listen_address:$port":27017 -d mongo:"$tag"
        ;;
    "postgresql")
        docker pull postgres:"$tag"
        docker run --name postgres-container-"$tag" -e POSTGRES_PASSWORD="$password" -p "$listen_address:$port":5432 -d postgres:"$tag"
        ;;
    *)
        echo -e "${RED}Помилка: Невідома база даних: $db_name${RESET}"
        return 1
        ;;
    esac
}

remove_images() {
    if ! docker images --format '{{.Repository}}' | grep -q "$db_name"; then
        echo -e "Не знайдено контейнера баз даних з іменем системи ${RED}$db_name${RESET}, про те можливо є інші:"
        docker images --format '{{.Repository}}' | grep -q ":"
        return 1
    fi

    echo "Виберіть образ для видалення:"
    select image in $(docker images --format "{{if eq .Repository \"$db_name\"}}{{.Repository}}:{{.Tag}}{{end}}"); do
        if [[ -n "$image" ]]; then
            echo "Видалення образу: $image"
            # Зупинити всі контейнери, які використовують образ
            docker ps -a | grep "$image" | awk '{print $1}' | xargs -r docker stop

            # Видалити всі контейнери, які використовують образ
            docker ps -a | grep "$image" | awk '{print $1}' | xargs -r docker rm

            docker rmi "$image"
        fi
        break
    done
}
