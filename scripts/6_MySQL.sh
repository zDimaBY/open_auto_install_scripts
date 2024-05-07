# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 6_manage_docker_databases() {
    check_docker_availability
    while true; do
        echo -e "\nВиберіть дію:\n"
        echo -e "1. MySQL"
        echo -e "2. MariaDB"
        echo -e "3. MongoDB"
        echo -e "4. PostgreSQL"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"
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
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

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

    read -p "Вкажіть, скільки версій баз даних вивести (за замовчуванням 100): " list_docker_tags_databases
    list_docker_tags_databases=${list_docker_tags_databases:-100}
    # Отримання списку тегів для вибраної бази даних
    case $db_name in
    "mariadb")
        tags=($(curl -s "https://hub.docker.com/v2/repositories/library/mariadb/tags/?page_size=$list_docker_tags_databases" | jq -r '.results[].name' | sort -r))
        ;;
    "mysql")
        tags=($(curl -s "https://hub.docker.com/v2/repositories/library/mysql/tags/?page_size=$list_docker_tags_databases" | jq -r '.results[].name' | sort -r))
        ;;
    "mongodb")
        tags=($(curl -s "https://hub.docker.com/v2/repositories/library/mongo/tags/?page_size=$list_docker_tags_databases" | jq -r '.results[].name' | sort -r))
        ;;
    "postgresql")
        tags=($(curl -s "https://hub.docker.com/v2/repositories/library/postgres/tags/?page_size=$list_docker_tags_databases" | jq -r '.results[].name' | sort -r))
        ;;
    *)
        echo "${RED}Помилка: Невідома база даних: $db_name${RESET}"
        return 1
        ;;
    esac

    echo -e "\n${BLUE}latest${RESET}: Цей тег вказує на найновішу версію образу, доступну на Docker Hub."
    echo -e "${YELLOW}oraclelinux8${RESET}: Це означає, що образ побудований на базі Oracle Linux 8."
    echo -e "${GREEN}lts${RESET}: LTS означає Long-Term Support, це для версій з довгостроковою підтримкою."
    echo -e "${GREEN}----------------------------------------------------------------------------${RESET}"
    echo -e "${GREEN}8.0.37-debian${RESET}, ${GREEN}8.0.37-bookworm${RESET}, ${GREEN}8.0.37-oraclelinux8${RESET},\nтакож в інших базах jammy та focal - це назви версій операційних систем Ubuntu. Вони вказують на те, для якої версії операційної системи побудовані образи Mariadb. \nЦі теги вказують на версії MySQL, побудовані на конкретних операційних системах (наприклад, Debian, Oracle Linux, Ubuntu)."
    echo -e "${GREEN}----------------------------------------------------------------------------${RESET}"
    echo -e "${RED}innovation${RESET}: Це спеціальна версія з новими функціями або експериментальні версії.\n"
    echo -e "${RED}11.3-rc-jammy, 11.3-rc${RESET}: це для версій, що перебувають у стадії реліз-кандидатів (RC), тобто перед остаточним релізом."

    echo "Виберіть образ для встановлення:"
    select tag in "${tags[@]}"; do
        if [[ -n "$tag" ]]; then
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

    # Вибір типу прослуховування
    select_listen_address

    # Введення порту прослуховування та паролю
    enter_port_and_password

    # Запуск контейнера з введеними параметрами
    start_container "$db_name" "$tag" "$listen_address" "$port" "$password"
}

# Вибір типу прослуховування
function select_listen_address() {
    echo "Обрати тип прослуховування:"
    echo "1. Локальний - 127.0.0.1"
    echo "2. Для всіх інтерфейсів - 0.0.0.0"
    read -p "Виберіть опцію (1 або 2): " option

    if [[ "$option" == "1" ]]; then
        listen_address="127.0.0.1"
    elif [[ "$option" == "2" ]]; then
        listen_address="0.0.0.0"
    else
        echo -e "${RED}Неправильний вибір${RESET}"
        return 1
    fi
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
        echo -e "\n\nmariadb:$tag встановлено!\nДля перевірки використовуйте підключення:\nmysql -h ${server_IPv4[0]} -P $port -u root -p\nПароль: $password\n\n"
        ;;
    "mysql")
        docker pull mysql:"$tag"
        docker run --name mysql-container-"$tag" -e MYSQL_ROOT_PASSWORD="$password" -p "$listen_address:$port":3306 -d mysql:"$tag"
        echo -e "\n\nmysql:$tag встановлено!\nДля перевірки використовуйте підключення:\nmysql -h ${server_IPv4[0]} -P $port -u root -p\nПароль: $password\n\n"
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
    echo "Виберіть образ для видалення:"
    select image in $(docker images --format "{{.Repository}}:{{.Tag}}"); do
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
