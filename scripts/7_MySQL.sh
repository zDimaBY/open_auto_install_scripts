function 7_DB() {
    check_docker
    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. MySQL"
        echo -e "2. MariaDB"
        echo -e "3. MongoDB"
        echo -e "4. PostgreSQL"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) 7_docker_DB "mysql" ;;
        2) 7_docker_DB "mariadb" ;;
        3) 7_docker_DB "mongodb" ;;
        4) 7_docker_DB "postgresql" ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

7_docker_DB() {
    # tags=( "8.1.0" "8.1" "8" "innovation" "latest" "8.1.0-oracle" "8.1-oracle" "8-oracle" "innovation-oracle" "oracle" "8.0.34" "8.0"
    #    "8.0.34-oracle" "8.0-oracle" "8.0.34-debian" "8.0-debian" "5.7.43" "5.7" "5" "5.7.43-oracle" "5.7-oracle" "5-oracle")
    db_name="$1"
    if [[ "$db_name" == "mariadb" ]]; then
        tags=($(curl -s "https://hub.docker.com/v2/repositories/library/mariadb/tags/" | jq -r '.results[].name'))
    elif [[ "$db_name" == "mysql" ]]; then
        tags=($(curl -s "https://hub.docker.com/v2/repositories/library/mysql/tags/" | jq -r '.results[].name'))
    elif [[ "$db_name" == "mongodb" ]]; then
        tags=($(curl -s "https://hub.docker.com/v2/repositories/library/mongo/tags/" | jq -r '.results[].name'))
    elif [[ "$db_name" == "postgresql" ]]; then
        tags=($(curl -s "https://hub.docker.com/v2/repositories/library/postgres/tags/" | jq -r '.results[].name'))
    else
        echo -e "${RED}База даних не підтримується: $db_name${RESET}"
        exit 1
    fi

    install_images() {
        echo "Виберіть образ для встановлення:"
        select tag in "${tags[@]}"; do
            if [[ -n "$tag" ]]; then
                run_container "$tag"
            fi
            break
        done
    }

    run_container() {
        local tag="$1"
        echo "Встановлення образу з тегом: $tag"
        echo "Введіть пароль для кореневого користувача MySQL"
        generate_random_password_show
        read -p "root password: " mysql_password
        echo -e "${GREEN}Унікальні використовані порти (TCP та UDP) у системі:${RESET}"
        netstat -tuln | awk '/^Proto|^tcp|^udp/ {print $4}' | sed 's/.*://' | sort -n | uniq
        echo "Введіть порт прослуховування для контейнера"
        read -p "(за замовчуванням 3306): " port
        port=${port:-3306}

        echo "Запуск контейнера для образу з тегом: $tag"
        if [[ "$db_name" == "mariadb" ]]; then
            docker pull mariadb:"$tag"
            docker run --name mariadb-container-$tag -e MYSQL_ROOT_PASSWORD="$mysql_password" -p "$port":3306 -d mariadb:$tag
        elif [[ "$db_name" == "mysql" ]]; then
            docker pull mysql:"$tag"
            docker run --name mysql-container-$tag -e MYSQL_ROOT_PASSWORD="$mysql_password" -p "$port":3306 -d mysql:$tag
        elif [[ "$db_name" == "mongodb" ]]; then
            docker pull mongo:"$tag"
            docker run --name mongo-container-$tag -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD="$mongo_password" -p "$port":27017 -d mongo:$tag
        elif [[ "$db_name" == "postgresql" ]]; then
            docker pull postgres:"$tag"
            docker run --name postgres-container-$tag -e POSTGRES_PASSWORD="$postgres_password" -p "$port":5432 -d postgres:$tag
        else
            echo -e "${RED}База даних не підтримується: $db_name${RESET}"
            exit 1
        fi
    }

    list_installed_images() {
        echo "Встановлені образ:"
        docker images --format "{{.Repository}}:{{.Tag}}"
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

    while true; do
        echo "Виберіть опцію:"
        echo "1. Встановити Docker образ"
        echo "2. Видалити Docker образ"
        echo "3. Налаштувати Docker"
        echo "4. Перелік запущених контейнерів"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) install_images ;;
        2) remove_images ;;
        3) echo "Налаштування Docker..." ;;
        4) docker ps ;;
        0) break ;;
        00) 0_funExit ;;

        *)
            echo "Недійсна опція. Будь ласка, виберіть ще раз."
            ;;
        esac
    done
}
