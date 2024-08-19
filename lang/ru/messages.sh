#!/bin/bash
# Русская локализация

# Сообщения об ошибках
MSG_FAILED_DOWNLOAD="Не удалось скачать"

# Информационные сообщения
MSG_LAST_COMMIT_MESSAGE="Последнее сообщение коммита"
MSG_LAST_COMMIT_DATE_LABEL="Дата последнего коммита"
MSG_ACTION_SELECTION="Выберите действие:"
MSG_INSTALL_SOFTWARE="Установка ПО"
MSG_CONTROL_PANEL_FUNCTIONS="Функции для панелей управления"
MSG_DDOS_ANALYSIS="Анализ DDos"
MSG_VPN_CONFIGURATION="Настройка VPN серверов"
MSG_FTP_CONFIGURATION="Настройка FTP доступа"
MSG_DATABASE_CONFIGURATION="Настройка баз данных"
MSG_OPERATING_SYSTEMS_INSTALLATION="Установка операционных систем"
MSG_SERVER_TESTING="Тестирование сервера"

# Пользовательские подсказки
MSG_CHOOSE_OPTION="Выберите вариант:"
MSG_EXIT_SUBMENU="Выйти из этого подменю"
MSG_EXIT_SCRIPT="Завершить работу скрипта"

# 0_exit.sh
MSG_EXIT_STARTUP_MESSAGE="Запуск: wget -N https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/open_auto_install_scripts.sh && bash ./open_auto_install_scripts.sh"
MSG_EXIT_INVALID_SELECTION="Неверный выбор. Введите 1, 2, 3 .. или 0."

# 4_VPN.sh ----------------------------------------------------------------------------
MSG_VMESS_CONNECTION="Также настроено подключение vmess:"
MSG_VMESS_LINK="Ссылка: "
MSG_VMESS_EXAMPLE="vmess://XXXXXXXXXX"

# Инструкции по приложениям
MSG_ANDROID_APPS="Для подключения вы можете использовать эти приложения:"
MSG_ANDROID_APP="Android - v2rayNG: "
MSG_ANDROID_APP_LINK="https://github.com/2dust/v2rayNG/releases/download/1.8.6/v2rayNG_1.8.6.apk"

MSG_WINDOWS_APPS="Windows - nekoray, v2rayNG: "
MSG_WINDOWS_APPS_LINK="https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-windows64.zip , https://github.com/2dust/v2rayN/releases/download/6.42/v2rayN.zip"

MSG_LINUX_APPS="Linux: "
MSG_LINUX_APPS_LINK="https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-debian-x64.deb , https://github.com/MatsuriDayo/nekoray/releases/download/3.20/nekoray-3.20-2023-09-07-linux64.zip"

MSG_MACOS_APPS="MacOS (Intel + Apple): "
MSG_MACOS_APPS_LINK="https://github.com/abbasnaqdi/nekoray-macos/releases/download/3.18/nekoray_amd64.zip"

MSG_IOS_APPS="iOS: "
MSG_IOS_APPS_LINK="https://apps.apple.com/us/app/napsternetv/id1629465476 , https://apps.apple.com/us/app/v2box-v2ray-client/id6446814690"

# Инструкции для Android
MSG_ANDROID_INSTRUCTIONS="Инструкции по подключению с использованием $MSG_ANDROID_APP:"
MSG_ANDROID_STEP_1="1. Скачайте и установите приложение v2rayNG по ссылке: "
MSG_ANDROID_STEP_2="   - Скопируйте ссылку '$MSG_VMESS_EXAMPLE' и вставьте её в соответствующее поле приложения v2rayNG."
MSG_ANDROID_STEP_3="2. Откройте приложение v2rayNG."
MSG_ANDROID_STEP_4="3. В главном меню приложения нажмите на кнопку плюс '+'."
MSG_ANDROID_STEP_5="4. Выберите 'Импорт конфигурации из буфера обмена'."
MSG_ANDROID_STEP_6="5. Приложение автоматически импортирует конфигурацию. Вам нужно только выбрать добавленное подключение и нажать 'Подключиться'."
MSG_ANDROID_STEP_7="6. Если вы видите значок VPN в строке состояния, это означает, что подключение активно.\n"

# Инструкции для Windows
MSG_WINDOWS_INSTRUCTIONS="Подключение к VPN серверу с помощью Windows - Nekoray:"
MSG_WINDOWS_STEP_1="1. Скачайте и распакуйте программу Nekoray по ссылке: "
MSG_WINDOWS_STEP_2="   - Добавьте профиль для подключения к VPN:"
MSG_WINDOWS_STEP_3="   - Скопируйте ссылку '$MSG_VMESS_EXAMPLE' и вставьте её в приложение Nekoray, перейдите в меню 'Program' -> 'Add profile from clipboard'."
MSG_WINDOWS_STEP_4="   - Или используйте QR-код. Скопируйте QR-код и вставьте его в приложение Nekoray, перейдите в меню 'Program' -> 'Scan QR code'."
MSG_WINDOWS_STEP_5="3. Включите настройки 'Tune Mode' и 'System Proxy' в главном меню приложения."
MSG_WINDOWS_STEP_6="4. Запустите подключение: перейдите в меню 'Program' -> 'Active server' и выберите ваше подключение. VPN должен стать активным."
MSG_WINDOWS_STEP_7="Если вы столкнулись с ошибками, связанными с отсутствием библиотек, таких как MSVCP140.dll, скачайте и установите Microsoft Visual C++ 2015-2022: https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170#visual-studio-2015-2017-2019-and-2022"

# Инструкции для Linux
MSG_LINUX_INSTRUCTIONS="Подключение к VPN серверу с помощью Linux - nekoray:"
MSG_LINUX_STEP_1="-"

# Инструкции для MacOS
MSG_MACOS_INSTRUCTIONS="MacOS (Intel + Apple) - nekoray:"
MSG_MACOS_STEP_1="-"

# Инструкции для iOS
MSG_IOS_INSTRUCTIONS="iOS - napsternetv, v2box-v2ray-client:"
MSG_IOS_STEP_1="-"

# 8_server_testing.sh
MSG_SERVER_TESTING_PORT_SPEED="скорость порта"
MSG_SERVER_TESTING_PORT_MAIL="почта"

# functions_controller.sh
# function check_dependency
MSG_ERROR_INFO_UNSUPPORTED_OS="Похоже, вы используете этот установщик не на системах Debian, Ubuntu, Fedora, CentOS, Oracle, AlmaLinux или Arch Linux. Ваша система: "
MSG_ERROR_OS_DETECTION_FAILED="Не удалось определить операционную систему."
MSG_ERROR_INSTALL_FAILED="Не удалось установить "
MSG_ERROR_MANUAL_INSTALL_REQUIRED="Пожалуйста, установите его вручную."
MSG_DEPENDENCY_NOT_INSTALLED=" не установлен. Устанавливаю..."
MSG_DEPENDENCY_INSTALLED=" уже установлен."
MSG_DEPENDENCY_SUCCESSFULLY_INSTALLED=" успешно установлен."

# function install_package
MSG_PACKAGE_INSTALL_FAILED="Не удалось установить "
MSG_PACKAGE_ALREADY_INSTALLED=" уже установлен."
MSG_PACKAGE_INSTALL_TRY_MANUAL="Не удалось установить "
MSG_PACKAGE_INSTALL_MANUAL_PROMPT="Пожалуйста, попробуйте установить его вручную."

# function generate_random_password_show
MSG_GENERATED_RANDOM_PASSWORD="Сгенерированный случайный пароль:"

# function check_docker_availability
MSG_DOCKER_NOT_INSTALLED_THIS="Docker не установлен в этой системе."
MSG_PROMPT_INSTALL_DOCKER="Хотите установить Docker? (y/n): "
MSG_INSTALLING_DOCKER="Установка Docker..."
MSG_DOCKER_INSTALLATION_CANCELED="Установка Docker отменена."
MSG_DOCKER_NOT_STARTED="Docker не запущен. Запуск Docker..."
MSG_DOCKER_START_SUCCESS="Команда 'sudo systemctl start docker' выполнена успешно."
MSG_DOCKER_START_FAILED="Ошибка: Не удалось выполнить 'sudo systemctl start docker'."
MSG_DOCKER_ALREADY_AUTOSTART="Docker уже включен в автозапуск."
MSG_DOCKER_ADDED_AUTOSTART="Docker успешно добавлен в автозапуск."
MSG_DOCKER_FAILED_AUTOSTART="Ошибка: Docker не был добавлен в автозапуск."
MSG_DOCKER_STATUS="Статус Docker:"

# function create_folder
MSG_FOLDER_ALREADY_EXISTS="Папка уже существует."
MSG_FOLDER_CREATED="Папка создана."

# function copy_file_from_container
MSG_WAITING_FOR_FILE="Ожидание создания файла в контейнере..."
MSG_FILE_COPIED="Файл был скопирован в целевую директорию."

# function mask_to_cidr get_public_interface
MSG_INVALID_SUBNET_MASK="Недействительная маска подсети"
MSG_NO_ADAPTER_FOUND="Не удалось найти адаптер с IP-адресом, совпадающим с результатом команды hostname -i:"

# function get_selected_interface
MSG_SELECT_NETWORK_ADAPTER="Выберите доступный сетевой адаптер:"
MSG_ENTER_ADAPTER_NUMBER="Введите номер адаптера (от 1 до"
MSG_ERROR_NOT_A_NUMBER="Ошибка: Ввод должен быть числом."
MSG_ERROR_INVALID_ADAPTER_NUMBER="Ошибка: Неверный номер адаптера."
MSG_ADAPTER_INFO="Информация о сетевом адаптере"
MSG_IP_ADDRESS="IP-адрес:"
MSG_SUBNET_MASK="Маска подсети:"
MSG_GATEWAY="Шлюз:"

# function add_firewall_rule
MSG_PORT="Порт "
MSG_FIREWALLD_NOT_RUNNING_PART1="firewalld не запущен или не установлен. Если установлен другой файрвол, открою порты в нем."
MSG_IPTABLES_NOT_INSTALLED_PART1="iptables не установлен."
MSG_UFW_NOT_INSTALLED_PART1="ufw не установлен."
MSG_FIREWALL_NOT_INSTALLED_PART1="Ошибка: файервол не установлен или неизвестен. Проверьте порт "

# function remove_firewall_rule
MSG_FIREWALLD_NOT_RUNNING_PART2="firewalld не запущен или не установлен. Если установлен другой файрвол, удалю правила из него."
MSG_RULE_FOR_PORT="Правило для порта "
MSG_IPTABLES_NOT_INSTALLED_PART2="iptables не установлен."
MSG_UFW_NOT_INSTALLED_PART2="ufw не установлен."
MSG_FIREWALL_NOT_INSTALLED_PART2="Ошибка: файервол не установлен или неизвестен."

# function check_domain
MSG_DOMAIN_POINTED="Домен "
MSG_DOMAIN_TARGET_SERVER=" указывает на этот сервер ("
MSG_DOMAIN_NOT_TARGET_SERVER=" не указывает на этот сервер"

# function select_disk_and_partition
MSG_SELECT_DISK="Выберите диск:"
MSG_INVALID_INPUT_DISK="Неверный ввод. Пожалуйста, введите номер диска."
MSG_INVALID_CHOICE_DISK="Неверный выбор. Пожалуйста, выберите правильный номер из списка."
MSG_SELECTED_DISK="Выбранный диск: "
MSG_NO_PARTITIONS="На этом диске нет разделов."
MSG_SELECT_PARTITION="Выберите раздел (или нажмите Enter, чтобы пропустить):"
MSG_INVALID_INPUT_PARTITION="Неверный ввод. Пожалуйста, введите номер раздела."
MSG_INVALID_CHOICE_PARTITION="Неверный выбор. Пожалуйста, выберите правильный номер из списка."
MSG_SELECTED_PARTITION="Выбранный раздел: "

# linuxinfo.sh
MSG_ERROR_NO_DOWNLOAD_TOOL="Ошибка: 'wget' или 'curl' не найден. Пожалуйста, установите один из них для продолжения."

# functions_linux_info.sh
MSG_ERROR_NOT_ROOT="Ошибка: Скрипт не запущен от имени root."
MSG_ERROR_OS_RELEASE_NOT_FOUND="Ошибка: /etc/os-release не найден"
MSG_ERROR_LSB_NOT_INSTALLED="lsb_release в данный момент не установлен, пожалуйста, установите его:"
MSG_ERROR_UNSUPPORTED_PACKAGE_MANAGER="Неподдерживаемый менеджер пакетов. Пожалуйста, установите lsb-release вручную."
MSG_ERROR_UNSUPPORTED_OS="Неподдерживаемая операционная система. Пожалуйста, установите lsb-release вручную."
MSG_INFORMATION="Информация:"
MSG_DEBIAN_BASED_SYSTEM="Debian или Ubuntu:"
MSG_REDHAT_BASED_SYSTEM="Системы на базе Red Hat:"
MSG_ALMALINUX="AlmaLinux:"
MSG_SUSE="SUSE:"
MSG_ARCH_LINUX="Arch Linux:"

# Сообщение о завершении поддержки
MSG_END_LIFE="Конец поддержки"

MSG_ERROR_IP_COMMAND="Ошибка выполнения команды ip"
MSG_INSUFFICIENT_FIELDS="Недостаточно полей в строке: "
MSG_INVALID_FORMAT="Неверный формат строки: "
MSG_HOSTNAME="Имя хоста:"
MSG_PRIMARY_NETWORK="Основная сеть"
MSG_STATUS_NETWORK="Статус сети"
MSG_FILE_SYSTEMS="Файловые системы:"
MSG_DISK_USAGE="Использование диска:"

# Сообщения о памяти
MSG_MEMORY="Память:"
MSG_TOTAL_MEMORY="Всего памяти"
MSG_USED_MEMORY="Используемая память"
MSG_FREE_MEMORY="Свободная память"
MSG_SHARED_MEMORY="Разделяемая память"
MSG_BUFF_CACHE_MEMORY="Буфер/Кэш память"
MSG_AVAILABLE_MEMORY="Доступная память"

# Сообщения о загрузке
MSG_CPU="ЦП:"
MSG_LOAD_AVERAGE="Средняя загрузка:"

# Сообщения о ЦП
MSG_CPU_MODEL="Модель:"
MSG_CPU_CORES="Ядра:"

MSG_CONTROL_PANEL_NOT_FOUND="Панель управления не найдена."
MSG_MYSQL_MARIADB_POSTGRESQL_SQLITE_NOT_INSTALLED="MySQL или MariaDB, PostgreSQL или SQLite не установлены."
MSG_PHP_PYTHON_NODE_NOT_INSTALLED="PHP, Python или Node.js не установлены."
MSG_DOCKER_NOT_INSTALLED="Docker не установлен."

# Сообщения для панели управления
# Сообщения для Hestia Panel
MSG_HESTIA_INSTALLED="Hestia Control Panel установлена."
MSG_WEB_ADMIN_PORT="WEB Админ Порт:"

# Сообщения для Vesta Panel
MSG_VESTA_INSTALLED="Vesta Control Panel установлена."

MSG_ISPMANAGER_INSTALLED="ISPmanager установлен."
MSG_CPanel_INSTALLED="cPanel установлен."
MSG_FASTPANEL_INSTALLED="FastPanel установлен."
MSG_BRAINYCP_INSTALLED="BrainyCP установлен."
MSG_BTPANEL_INSTALLED="aaPanal(BT-Panel) установлен."
MSG_CyberCP_INSTALLED="CyberCP установлен."
MSG_CyberPanel_INSTALLED="CyberPanel установлен."

# Сообщения, связанные с файлами
MSG_FILE_NOT_FOUND="Файл не найден:"
MSG_UNIT_NOT_FOUND="Единица(ы) не найдены:"

# Сообщения функции
MSG_INFO="Информация"
MSG_UNKNOWN="Неизвестно"
MSG_COMMAND_NOT_INSTALLED="не установлен"

# Function get_latest_v2rayng_apk_url
MSG_LATEST_VERSION="Последняя версия доступна для скачивания: "