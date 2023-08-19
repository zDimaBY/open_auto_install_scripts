function 3_installComposer() {
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    if [ $? -eq 0 ]; then
        echo -e "\n\033[92mComposer встановлено успішно.${RESET}\n"
        yes | composer -V
    else
        echo -e "\n\033[91mПомилка під час встановлення Composer.${RESET}\n"
    fi
}