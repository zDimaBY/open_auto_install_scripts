#!/bin/bash
# Українська локалізація

# Повідомлення про помилки
MSG_FAILED_DOWNLOAD="Не вдалося завантажити"

# Інформаційні повідомлення
MSG_LAST_COMMIT_MESSAGE="Останнє повідомлення з комітів"
MSG_LAST_COMMIT_DATE_LABEL="Дата останньої фіксації"
MSG_ACTION_SELECTION="Виберіть дію:"
MSG_INSTALL_SOFTWARE="Встановлення ПЗ"
MSG_CONTROL_PANEL_FUNCTIONS="Функції для панелей керування сайтами"
MSG_DDOS_ANALYSIS="Аналіз DDos"
MSG_VPN_CONFIGURATION="Налаштування VPN серверів"
MSG_FTP_CONFIGURATION="Налаштування FTP доступу"
MSG_DATABASE_CONFIGURATION="Налаштування баз даних"
MSG_OPERATING_SYSTEMS_INSTALLATION="Встановлення операційних систем"
MSG_SERVER_TESTING="Тестування сервера"

# Запити до користувача
MSG_CHOOSE_OPTION="Виберіть варіант:"
MSG_EXIT_SUBMENU="Вийти з цього підменю"
MSG_EXIT_SCRIPT="Закінчити роботу скрипта"

# 0_exit.sh
MSG_EXIT_STARTUP_MESSAGE="Старт: wget -N https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/open_auto_install_scripts.sh && bash ./open_auto_install_scripts.sh"
MSG_EXIT_INVALID_SELECTION="Неправильний вибір. Введіть 1, 2, 3 ... або 0."

# 4_VPN.sh ----------------------------------------------------------------------------
MSG_VMESS_CONNECTION="Також налаштовано підключення vmess:"
MSG_VMESS_LINK="Посилання: "
MSG_VMESS_EXAMPLE="vmess://XXXXXXXXXX"

# Інструкції для програм
MSG_ANDROID_APPS="Для підключення ви можете використовувати ці додатки:"
MSG_ANDROID_APP="Android - v2rayNG: "

MSG_WINDOWS_APPS="Windows - nekoray, v2rayNG: "

MSG_LINUX_APPS="Linux: "

MSG_MACOS_APPS="MacOS (Intel + Apple): "

MSG_IOS_APPS="iOS: "
MSG_IOS_APPS_LINK="https://apps.apple.com/us/app/napsternetv/id1629465476 , https://apps.apple.com/us/app/v2box-v2ray-client/id6446814690"

# Інструкції для Android
MSG_ANDROID_INSTRUCTIONS="Інструкції для підключення за допомогою $MSG_ANDROID_APP:"
MSG_ANDROID_STEP_1="1. Завантажте та встановіть додаток v2rayNG за посиланням: "
MSG_ANDROID_STEP_2="   - Скопіюйте посилання '$MSG_VMESS_EXAMPLE' і вставте його у відповідне поле додатку v2rayNG."
MSG_ANDROID_STEP_3="2. Відкрийте додаток v2rayNG."
MSG_ANDROID_STEP_4="3. У головному меню додатку натисніть на кнопку плюс '+'."
MSG_ANDROID_STEP_5="4. Виберіть 'Імпорт конфігурації з буфера обміну'."
MSG_ANDROID_STEP_6="5. Додаток автоматично імплементує конфігурацію. Вам потрібно лише вибрати додане підключення і натиснути 'Підключитися'."
MSG_ANDROID_STEP_7="6. Якщо ви бачите значок VPN у статусній панелі, це означає, що підключення активне.\n"

# Інструкції для Windows
MSG_WINDOWS_INSTRUCTIONS="Підключення до VPN сервера за допомогою Windows - Nekoray:"
MSG_WINDOWS_STEP_1="1. Завантажте та розпакуйте програму Nekoray за посиланням: "
MSG_WINDOWS_STEP_2="   - Додайте профіль для підключення до VPN:"
MSG_WINDOWS_STEP_3="   - Скопіюйте посилання '$MSG_VMESS_EXAMPLE' і вставте його в додаток Nekoray, перейдіть у меню 'Program' -> 'Add profile from clipboard'."
MSG_WINDOWS_STEP_4="   - Або скористайтеся QR-кодом. Скопіюйте QR-код і вставте його в додаток Nekoray, перейдіть у меню 'Program' -> 'Scan QR code'."
MSG_WINDOWS_STEP_5="3. Увімкніть налаштування 'Tune Mode' і 'System Proxy' в головному меню програми."
MSG_WINDOWS_STEP_6="4. Запустіть підключення: перейдіть у меню 'Program' -> 'Active server' і виберіть ваше підключення. VPN має стати активним."
MSG_WINDOWS_STEP_7="Якщо виникають помилки, пов'язані з відсутністю бібліотек, таких як MSVCP140.dll, завантажте та встановіть Microsoft Visual C++ 2015-2022: https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170#visual-studio-2015-2017-2019-and-2022"

# Інструкції для Linux
MSG_LINUX_INSTRUCTIONS="Підключення до VPN сервера за допомогою Linux - nekoray:"
MSG_LINUX_STEP_1="-"

# Інструкції для MacOS
MSG_MACOS_INSTRUCTIONS="MacOS (Intel + Apple) - nekoray:"
MSG_MACOS_STEP_1="-"

# Інструкції для iOS
MSG_IOS_INSTRUCTIONS="iOS - napsternetv, v2box-v2ray-client:"
MSG_IOS_STEP_1="-"

MSG_CLIPBOARD_STRING_HEADER="У вас повинна бути так звана clipboard string, виглядає приблизно так:"
MSG_CLIPBOARD_STRING="vmess://XXXXXXXXXX"
MSG_QR_CODE="Або QR-код, який містить ту ж саму рядок."
MSG_PROXY_DATA="В цій рядку задані дані для підключення до proxy-сервера."
MSG_IMPORT_INSTRUCTIONS="Вам потрібно лише імпортувати її в додаток. У всіх додатках це називається приблизно 'Add config from clipboard'. Додаток сам бере з буфера обміну рядок, або вам потрібно вставити її в поле."
MSG_CONNECTION_IMPORT="Після імпорту у вас з’явиться підключення. Зазвичай його потрібно вибрати і натиснути кнопку внизу. Або в десктопних додатках правою кнопкою на підключення і в контекстному меню вибрати 'Start'. Підключень може бути кілька, і між ними можна легко перемикатися."

# 8_server_testing.sh
MSG_SERVER_TESTING_PORT_SPEED="Швидкість порта"
MSG_SERVER_TESTING_PORT_MAIL="Пошта"

# functions_controller.sh
# function check_dependency
MSG_ERROR_INFO_UNSUPPORTED_OS="Схоже, що ви використовуєте цей установник не на системах Debian, Ubuntu, Fedora, CentOS, Oracle, AlmaLinux або Arch Linux. Ваша система: "
MSG_ERROR_OS_DETECTION_FAILED="Не вдалося визначити операційну систему."
MSG_ERROR_INSTALL_FAILED="Не вдалося встановити "
MSG_ERROR_MANUAL_INSTALL_REQUIRED="Будь ласка, встановіть його вручну."
MSG_DEPENDENCY_NOT_INSTALLED=" не встановлений. Встановлюю..."
MSG_DEPENDENCY_INSTALLED=" вже встановлений."
MSG_DEPENDENCY_SUCCESSFULLY_INSTALLED=" успішно встановлений."

# function install_package
MSG_PACKAGE_INSTALL_FAILED="Не вдалося встановити "
MSG_PACKAGE_ALREADY_INSTALLED=" вже встановлений."
MSG_PACKAGE_INSTALL_TRY_MANUAL="Не вдалося встановити "
MSG_PACKAGE_INSTALL_MANUAL_PROMPT="Будь ласка, спробуйте встановити його вручну."

# function generate_random_password_show
MSG_GENERATED_RANDOM_PASSWORD="Сгенерований випадковий пароль:"

# function check_docker_availability
MSG_DOCKER_NOT_INSTALLED_THIS="Docker не встановлений в цій системі."
MSG_PROMPT_INSTALL_DOCKER="Бажаєте встановити Docker? (y/n): "
MSG_INSTALLING_DOCKER="Встановлюю Docker..."
MSG_DOCKER_INSTALLATION_CANCELED="Встановлення Docker скасовано."
MSG_DOCKER_NOT_STARTED="Docker не запущено. Запуск Docker..."
MSG_DOCKER_START_SUCCESS="Команда 'sudo systemctl start docker' виконана успішно."
MSG_DOCKER_START_FAILED="Помилка: Не вдалося виконати 'sudo systemctl start docker'."
MSG_DOCKER_ALREADY_AUTOSTART="Docker вже включений в автозапуск."
MSG_DOCKER_ADDED_AUTOSTART="Docker успішно додано в автозапуск."
MSG_DOCKER_FAILED_AUTOSTART="Помилка: Docker не було додано в автозапуск."
MSG_DOCKER_STATUS="Статус Docker:"

# function create_folder
MSG_FOLDER_ALREADY_EXISTS="Папка вже існує."
MSG_FOLDER_CREATED="Папка створена."

# function copy_file_from_container
MSG_WAITING_FOR_FILE="Очікування створення файлу в контейнері..."
MSG_FILE_COPIED="Файл був скопійований до цільової директорії."

# function mask_to_cidr get_public_interface
MSG_INVALID_SUBNET_MASK="Недійсна маска підмережі"
MSG_NO_ADAPTER_FOUND="Не вдалося знайти адаптер з IP-адресою, що відповідає результату команди hostname -i:"

# function get_selected_interface
MSG_SELECT_NETWORK_ADAPTER="Виберіть доступний мережевий адаптер:"
MSG_ENTER_ADAPTER_NUMBER="Введіть номер адаптера (від 1 до"
MSG_ERROR_NOT_A_NUMBER="Помилка: Введення має бути числом."
MSG_ERROR_INVALID_ADAPTER_NUMBER="Помилка: Невірний номер адаптера."
MSG_ADAPTER_INFO="Інформація про мережевий адаптер"
MSG_IP_ADDRESS="IP адреса:"
MSG_SUBNET_MASK="Маска підмережі:"
MSG_GATEWAY="Шлюз:"

# function add_firewall_rule
MSG_PORT="Порт "
MSG_FIREWALLD_NOT_RUNNING_PART1="firewalld не запущений або не встановлений. Якщо встановлений інший файрвол, відкрию порти в ньому."
MSG_IPTABLES_NOT_INSTALLED_PART1="iptables не встановлений."
MSG_UFW_NOT_INSTALLED_PART1="ufw не встановлений."
MSG_FIREWALL_NOT_INSTALLED_PART1="Помилка: файервол не встановлений або невідомий. Перевірте порт "

# function remove_firewall_rule
MSG_FIREWALLD_NOT_RUNNING_PART2="firewalld не запущений або не встановлений. Якщо встановлений інший файрвол, видалю правила з нього."
MSG_RULE_FOR_PORT="Правило для порту "
MSG_IPTABLES_NOT_INSTALLED_PART2="iptables не встановлений."
MSG_UFW_NOT_INSTALLED_PART2="ufw не встановлений."
MSG_FIREWALL_NOT_INSTALLED_PART2="Помилка: файервол не встановлений або невідомий."

# function check_domain
MSG_DOMAIN_POINTED="Домен "
MSG_DOMAIN_TARGET_SERVER=" вказує на цей сервер ("
MSG_DOMAIN_NOT_TARGET_SERVER=" не вказує на цей сервер"

# function select_disk_and_partition
MSG_SELECT_DISK="Виберіть диск:"
MSG_INVALID_INPUT_DISK="Невірний ввід. Будь ласка, введіть номер диска."
MSG_INVALID_CHOICE_DISK="Невірний вибір. Будь ласка, виберіть правильний номер зі списку."
MSG_SELECTED_DISK="Вибраний диск: "
MSG_NO_PARTITIONS="На цьому диску немає розділів."
MSG_SELECT_PARTITION="Виберіть розділ (або натисніть Enter, щоб пропустити):"
MSG_INVALID_INPUT_PARTITION="Невірний ввід. Будь ласка, введіть номер розділу."
MSG_INVALID_CHOICE_PARTITION="Невірний вибір. Будь ласка, виберіть правильний номер зі списку."
MSG_SELECTED_PARTITION="Вибраний розділ: "

MSG_RELEASE_DATA_ERROR="Не вдалося отримати дані випуску з"
MSG_FILE_TYPES_ERROR="Не вдалося знайти файли типу"
MSG_IN_RELEASES_FROM="у випусках від"

# linuxinfo.sh
MSG_ERROR_NO_DOWNLOAD_TOOL="Помилка: 'wget' або 'curl' не знайдено. Будь ласка, встановіть один з них для продовження."

# functions_linux_info.sh
MSG_ERROR_NOT_ROOT="Помилка: Скрипт не запущено від імені root."
MSG_ERROR_OS_RELEASE_NOT_FOUND="Помилка: /etc/os-release не знайдено"
MSG_ERROR_LSB_NOT_INSTALLED="lsb_release наразі не встановлено, будь ласка, встановіть його:"
MSG_ERROR_UNSUPPORTED_PACKAGE_MANAGER="Непідтримуваний менеджер пакетів. Будь ласка, встановіть lsb-release вручну."
MSG_ERROR_UNSUPPORTED_OS="Непідтримувана операційна система. Будь ласка, встановіть lsb-release вручну."
MSG_INFORMATION="Інформація:"
MSG_DEBIAN_BASED_SYSTEM="Debian або Ubuntu:"
MSG_REDHAT_BASED_SYSTEM="Системи на базі Red Hat:"
MSG_ALMALINUX="AlmaLinux:"
MSG_SUSE="SUSE:"
MSG_ARCH_LINUX="Arch Linux:"

# Повідомлення про закінчення підтримки
MSG_END_LIFE="Кінець підтримки"

MSG_ERROR_IP_COMMAND="Помилка виконання команди ip"
MSG_INSUFFICIENT_FIELDS="Недостатньо полів у рядку: "
MSG_INVALID_FORMAT="Неправильний формат рядка: "
MSG_HOSTNAME="Ім'я хоста:"
MSG_PRIMARY_NETWORK="Основна мережа"
MSG_STATUS_NETWORK="Статус мережі"
MSG_FILE_SYSTEMS="Файлові системи:"
MSG_DISK_USAGE="Використання диска:"

# Повідомлення про пам'ять
MSG_MEMORY="Пам'ять:"
MSG_TOTAL_MEMORY="Загальна пам'ять"
MSG_USED_MEMORY="Використана пам'ять"
MSG_FREE_MEMORY="Вільна пам'ять"
MSG_SHARED_MEMORY="Спільна пам'ять"
MSG_BUFF_CACHE_MEMORY="Буферна/Кеш-пам'ять"
MSG_AVAILABLE_MEMORY="Доступна пам'ять"

# Повідомлення про середнє навантаження
MSG_CPU="ЦП:"
MSG_LOAD_AVERAGE="Середнє навантаження:"

# Повідомлення про інформацію про ЦП
MSG_CPU_MODEL="Модель:"
MSG_CPU_CORES="Ядра:"

MSG_CONTROL_PANEL_NOT_FOUND="Панель керування не знайдена."
MSG_MYSQL_MARIADB_POSTGRESQL_SQLITE_NOT_INSTALLED="MySQL або MariaDB, PostgreSQL або SQLite не встановлені."
MSG_PHP_PYTHON_NODE_NOT_INSTALLED="PHP, Python або Node.js не встановлені."
MSG_DOCKER_NOT_INSTALLED="Docker не встановлений."

# Специфічні повідомлення для панелей керування
# Повідомлення для Hestia Panel
MSG_HESTIA_INSTALLED="Панель керування Hestia встановлена."
MSG_WEB_ADMIN_PORT="Порт WEB адміністратора:"

# Повідомлення для Vesta Panel
MSG_VESTA_INSTALLED="Панель керування Vesta встановлена."

MSG_ISPMANAGER_INSTALLED="ISPmanager встановлений."
MSG_CPanel_INSTALLED="cPanel встановлений."
MSG_FASTPANEL_INSTALLED="FastPanel встановлений."
MSG_BRAINYCP_INSTALLED="BrainyCP встановлений."
MSG_BTPANEL_INSTALLED="aaPanal(BT-Panel) встановлений."
MSG_CyberCP_INSTALLED="CyberCP встановлений."
MSG_CyberPanel_INSTALLED="CyberPanel встановлений."

# Повідомлення, що стосуються файлів
MSG_FILE_NOT_FOUND="Файл не знайдено:"
MSG_UNIT_NOT_FOUND="Одиниця/Одиниці не знайдені:"

# Повідомлення про функції
MSG_INFO="Інформація"
MSG_UNKNOWN="Невідомо"
MSG_COMMAND_NOT_INSTALLED="не встановлений"
