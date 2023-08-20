function 3_installComposer() {
    case $operating_system in
    Debian | ubuntu)
        if ! command -v php &> /dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            sudo apt-get install php-cli
        fi
        ;;
    fedora)
        if ! command -v php &> /dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            sudo dnf install php-cli
        fi
        ;;
    centos | oracle)
        if ! command -v php &> /dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            sudo yum install epel-release
            sudo yum install php-cli
        fi
        ;;
    arch)
        if ! command -v php &> /dev/null; then
            echo -e "${RED}PHP не знайдено. Встановлюємо...${RESET}"
            sudo pacman -S php
        fi
        ;;
    *)
        echo -e "${RED}Не вдалося встановити $dependency_name. Будь ласка, встановіть його вручну.${RESET}"
        return 1
        ;;
    esac

    if ! command -v composer &> /dev/null; then
        echo -e "${RED}Composer не знайдено. Встановлюємо...${RESET}"
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
        if [ $? -eq 0 ]; then
            echo -e "\n${GREEN}Composer встановлено успішно.${RESET}\n"
            yes | composer -V
        else
            echo -e "\n${RED}Помилка під час встановлення Composer.${RESET}\n"
        fi
    else
        echo -e "\n${YELLOW}Composer вже встановлено. Продовжуємо...${RESET}\n"
    fi
}
