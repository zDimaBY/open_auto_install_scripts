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

MSG_MACOS_APPS="MacOS: "

MSG_IOS_APPS="iOS: "
MSG_IOS_APPS_LINK="https://apps.apple.com/us/app/napsternetv/id1629465476\nhttps://apps.apple.com/us/app/v2box-v2ray-client/id6446814690"

# Інструкції для Android
MSG_ANDROID_INSTRUCTIONS="Інструкції для підключення за допомогою $MSG_ANDROID_APP"
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
MSG_WINDOWS_STEP_2="2. Додайте профіль для підключення до VPN:"
MSG_WINDOWS_STEP_3="   - Скопіюйте посилання '$MSG_VMESS_EXAMPLE' і вставте його в додаток Nekoray, перейдіть у меню 'Program' -> 'Add profile from clipboard'."
MSG_WINDOWS_STEP_4="   - Або скористайтеся QR-кодом. Скопіюйте QR-код і вставте його в додаток Nekoray, перейдіть у меню 'Program' -> 'Scan QR code'."
MSG_WINDOWS_STEP_5="3. Увімкніть налаштування 'Tune Mode' і 'System Proxy' в головному меню програми."
MSG_WINDOWS_STEP_6="4. Запустіть підключення: перейдіть у меню 'Program' -> 'Active server' і виберіть ваше підключення. VPN має стати активним."
MSG_WINDOWS_STEP_7="Якщо виникають помилки, пов'язані з відсутністю бібліотек, таких як MSVCP140.dll, завантажте та встановіть Microsoft Visual C++ 2015-2022: https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170#visual-studio-2015-2017-2019-and-2022"

# Інструкції для Linux
MSG_LINUX_INSTRUCTIONS="Підключення до VPN сервера за допомогою Linux - nekoray:"
MSG_LINUX_STEP_1="-"

# Інструкції для MacOS
MSG_MACOS_INSTRUCTIONS="MacOS - nekoray:"
MSG_MACOS_STEP_1="-"

# Інструкції для iOS
MSG_IOS_INSTRUCTIONS="iOS - napsternetv, v2box-v2ray-client:"
MSG_IOS_STEP_1="-"

MSG_CLIPBOARD_STRING_HEADER="\nЗагалом у вас повинна бути так звана clipboard string, виглядає приблизно так: $MSG_VMESS_EXAMPLE"
MSG_QR_CODE="Або QR-код, який містить той самий рядок."
MSG_PROXY_DATA="В у цьому рядку задані дані для підключення до proxy-сервера."
MSG_IMPORT_INSTRUCTIONS="Вам потрібно лише імпортувати її в додаток. У всіх додатках це називається приблизно 'Add config from clipboard'. Додаток сам бере з буфера обміну рядок, або вам потрібно вставити її в поле."
MSG_CONNECTION_IMPORT="Після імпорту у вас з’явиться підключення. Зазвичай його потрібно вибрати і натиснути кнопку внизу. Або в десктопних додатках правою кнопкою на підключення і в контекстному меню вибрати 'Start'. Підключень може бути кілька, і між ними можна легко перемикатися.\n"

# function menu_x_ui
MSG_XUI="X-UI"
MSG_INSTALL_XUI="1. Встановити $MSG_XUI"
MSG_STOP_XUI="2. Зупинити $MSG_XUI"
MSG_REMOVE_XUI="3. Видалити $MSG_XUI"

# function list_x_ui_versions_install
MSG_XUI_ENTER_ADMIN_PASSWORD_1="Вкажіть пароль користувача admin для"
MSG_XUI_ENTER_ADMIN_PASSWORD_2="(за замовчуванням випадковий): "
MSG_XUI_AVAILABLE_VERSIONS="Список доступних версій образів alireza7/x-ui:"
MSG_XUI_SELECT_VERSION="Введіть номер версії, яку ви хочете встановити (1-9): "
MSG_XUI_INVALID_SELECTION="Недійсний вибір. Будь ласка, виберіть номер від 1 до 9."
MSG_XUI_INSTALLED="X-UI встановлено на сервері. Для доступу до панелі адміністратора використовуйте наступні облікові дані:"
MSG_XUI_USERNAME="Ім'я користувача: "
MSG_XUI_PASSWORD="Пароль: "
MSG_CONTAINER_EXISTS_PART1="Не взається створити контейнер, перевірте контейнери: docker ps -a"

# function stop_x_ui remove_x_ui update_x_ui
MSG_XUI_STOPPED="зупинено."
MSG_XUI_REMOVED="видалено."
MSG_XUI_UPDATE_NOT_IMPLEMENTED="Функція не реалізована."

# function menu_3x_ui
MSG_3X_UI="3X-UI"
MSG_3X_UI_AVAILABLE_WINDOWS="\nТакож $MSG_3X_UI тепер доступний на Windows. Щоб запустити $MSG_3X_UI, виконайте ці кроки:"
MSG_3X_UI_STEP_1="1: Перейдіть за посиланням: https://github.com/MHSanaei/3x-ui/releases"
MSG_3X_UI_STEP_2="2: Виберіть потрібну версію та завантажте її з підменю 'Assets' -> x-ui-windows-amd64.zip"
MSG_3X_UI_STEP_3="3: Розпакуйте архів, завантажте та встановіть мову 'go' з посилання: https://go.dev/dl/go1.22.1.windows-amd64.msi, як зазначено у файлі readme.txt."
MSG_3X_UI_STEP_4="4: Запустіть наступну команду в PowerShell: New-NetFirewallRule -DisplayName \"Allow_TCP_2053\" -Direction Inbound -LocalPort 2053 -Protocol TCP -Action Allow"
MSG_3X_UI_STEP_5="5: Запустіть 3x-ui.exe з папки $MSG_3X_UI та перейдіть за посиланням: http://localhost:2053"
MSG_3X_UI_STEP_6="6: Щоб отримати сертифікат SSL, встановіть Win64OpenSSL_Light-3_2_1.exe з папки 'SSL'"
MSG_3X_UI_NOTE="Примітка: У цьому випадку потрібно відкрити порти для кожного нового клієнта або вимкнути брандмауер."

MSG_INSTALL_3X_UI="1. Встановити $MSG_3X_UI"
MSG_STOP_3X_UI="2. Зупинити $MSG_3X_UI"
MSG_REMOVE_3X_UI="3. Видалити $MSG_3X_UI"

# function list_3x_ui_versions_install
MSG_AVAILABLE_3X_UI_VERSIONS="\n${GREEN}Список доступних версій для ${YELLOW}ghcr.io/mhsanaei/3x-ui:${RESET}"
MSG_SELECT_VERSION="Введіть номер версії, яку ви хочете встановити (1-9): "
MSG_INVALID_CHOICE="Недійсний вибір. Будь ласка, виберіть номер від 1 до 9."
MSG_X_UI_INSTALLED="${YELLOW}\n\n$MSG_3X_UI було встановлено на сервері. Для доступу до панелі адміністратора використовуйте наступну інформацію:${RESET}"
MSG_ADMIN_USERNAME="Ім'я користувача: "
MSG_ADMIN_PASSWORD="Пароль: "
MSG_UPDATE_FUNCTION_NOT_IMPLEMENTED="Функція не реалізована"

# function menu_wireguard_easy
MSG_WIREGUARD_EASY="WireGuard Easy"
MSG_INSTALL_WIREGUARD_EASY="1. Встановити $MSG_WIREGUARD_EASY"
MSG_STOP_WIREGUARD_EASY="2. Зупинити $MSG_WIREGUARD_EASY"
MSG_REMOVE_WIREGUARD_EASY="3. Видалити $MSG_WIREGUARD_EASY"
MSG_UPDATE_WIREGUARD_EASY="4. Оновити $MSG_WIREGUARD_EASY"

# function install_wg_easy
MSG_ENTER_ADMIN_PASSWORD="Введіть пароль адміністратора:"
MSG_INSTALL_FAILURE1="Не вдалося встановити "
MSG_INSTALL_FAILURE2=". Будь ласка, встановіть його вручну."
MSG_INSTALL_WG_EASY_SUCCESS="$MSG_WIREGUARD_EASY успішно встановлено. Ви можете отримати доступ до веб-інтерфейсу за адресою:"
MSG_INSTALL_WG_EASY_PASSWORD="Пароль для доступу до інтерфейсу:"
MSG_INSTALL_WG_EASY_INSTRUCTIONS="Інструкції з налаштування WireGuard:"
MSG_INSTALL_WG_EASY_STEP_1="1. Завантажте клієнт WireGuard за посиланням:"
MSG_INSTALL_WG_EASY_STEP_2="2. Після завантаження встановіть його на вашому пристрої."
MSG_INSTALL_WG_EASY_STEP_3="3. Перейдіть за посиланням і скопіюйте конфігураційний файл з сервера на ваш пристрій:"
MSG_INSTALL_WG_EASY_STEP_4="4. Відкрийте клієнт WireGuard та імпортуйте конфігураційний файл."
MSG_INSTALL_WG_EASY_STEP_5="5. Після імпорту ваш профіль VPN буде доступний для підключення."
MSG_INSTALL_WG_EASY_DOC="Документацію можна знайти за адресою:"
MSG_INSTALL_WG_EASY_DIAG="Для діагностики використовуйте наступні команди:"
MSG_INSTALL_WG_EASY_LOGS="  Переглянути журнали контейнера:"
MSG_INSTALL_WG_EASY_COMMANDS="  Переглянути список команд у контейнері:"
MSG_INSTALL_WG_EASY_ERROR="Сталася помилка під час встановлення $MSG_WIREGUARD_EASY. Будь ласка, перевірте налаштування та спробуйте ще раз."

# function stop_wg_easy remove_wg_easy update_wg_easy
MSG_STOP_WG_EASY="$MSG_WIREGUARD_EASY зупинено."
MSG_REMOVE_WG_EASY="$MSG_WIREGUARD_EASY видалено."
MSG_UPDATE_WG_EASY="$MSG_WIREGUARD_EASY оновлено."

# function menu_wireguard_scriptLocal
MSG_WIREGUARD_INSTALLER_HEADER="Інсталятор WireGuard. Виберіть дію:\n"
MSG_WIREGUARD_AUTO_INSTALL="1. Автоматичне встановлення WireGuard"
MSG_WIREGUARD_MANUAL_MENU="2. Меню управління WireGuard та ручне встановлення"

# function install_wireguard_scriptLocal
MSG_WIREGUARD_INSTALL_SUCCESS="__________________________________________________________________________WireGuard успішно встановлено!"
MSG_WIREGUARD_SETUP_INSTRUCTIONS="Інструкції для налаштування WireGuard"
MSG_WIREGUARD_CLIENT_DOWNLOAD="1. Завантажте клієнт WireGuard з: ${BLUE}https://www.wireguard.com/install/${RESET}"
MSG_WIREGUARD_INSTALL_CLIENT="2. Після завантаження клієнта, встановіть його на вашому пристрої."
MSG_WIREGUARD_COPY_CONFIG="3. Перейдіть до директорії /root/VPN/wireguard/ на вашому сервері."
MSG_WIREGUARD_COPY_FILE="4. Скопіюйте конфігураційний файл з сервера на ваш пристрій."
MSG_WIREGUARD_IMPORT_CONFIG="5. Відкрийте клієнт WireGuard та імпортуйте конфігураційний файл."
MSG_WIREGUARD_PROFILE_ACCESS="6. Після імпорту ваш профіль VPN буде доступний для підключення."
MSG_WIREGUARD_DOCUMENTATION="Документацію можна знайти за адресою: https://github.com/angristan/openvpn-install"
MSG_WIREGUARD_INSTALL_ERROR="Сталася помилка під час встановлення WireGuard. Будь ласка, перевірте конфігурацію та спробуйте ще раз."

# function menu_openVPNLocal
MSG_NAME_OPENVPN="OpenVPN"
MSG_OPENVPN_INSTALLER_HEADER="Інсталятор $MSG_NAME_OPENVPN. Виберіть дію:"
MSG_OPENVPN_AUTO_INSTALL="1. Автоматичне встановлення $MSG_NAME_OPENVPN"
MSG_OPENVPN_MANUAL_MENU="2. Меню управління $MSG_NAME_OPENVPN та ручне встановлення"

# function avtoInstall_openVPN
MSG_OPENVPN_INSTALL_SUCCESS="$MSG_NAME_OPENVPN успішно встановлено!"
MSG_OPENVPN_DOCUMENTATION="Документація: https://github.com/angristan/openvpn-install"
MSG_OPENVPN_WINDOWS_INSTRUCTIONS_HEADER="Інструкції для платформи Windows"
MSG_OPENVPN_WINDOWS_INSTRUCTIONS="1. Завантажте інсталятор $MSG_NAME_OPENVPN для Windows з офіційного сайту $MSG_NAME_OPENVPN.\n\
2. Встановіть програму, використовуючи стандартний процес установки.\n\
3. Запустіть $MSG_NAME_OPENVPN.\n\
4. Після запуску програми перейдіть до 'Файл' -> 'Імпортувати конфігураційний файл'.\n\
5. Виберіть конфігураційний файл, який ви отримали від вашого VPN-сервера.\n\
6. Після імпорту новий профіль з вашим VPN-іменем з’явиться. Натисніть на нього для підключення."
MSG_OPENVPN_ANDROID_INSTRUCTIONS_HEADER="Інструкції для платформи Android"
MSG_OPENVPN_ANDROID_INSTRUCTIONS="1. Завантажте та встановіть додаток $MSG_NAME_OPENVPN для Android з Google Play Store.\n\
2. Перенесіть конфігураційний файл (з розширенням .ovpn) на ваш Android-пристрій.\n\
3. У додатку $MSG_NAME_OPENVPN натисніть іконку '+' для додавання нового профілю.\n\
4. Виберіть 'Імпортувати з файлу' і виберіть ваш конфігураційний файл.\n\
5. Після імпорту профіль буде доступний для підключення."
MSG_OPENVPN_MACOS_INSTRUCTIONS_HEADER="Інструкції для платформи macOS (OS X)"
MSG_OPENVPN_MACOS_INSTRUCTIONS="1. Встановіть Tunnelblick, безкоштовний клієнт $MSG_NAME_OPENVPN для macOS, завантаживши його з офіційного сайту.\n\
2. Відкрийте інсталятор і дотримуйтесь інструкцій для завершення процесу установки.\n\
3. Після установки перемістіть конфігураційний файл (з розширенням .ovpn) до папки 'configurations' у вашій домашній директорії.\n\
4. Запустіть Tunnelblick і виберіть 'Підключити' для вашого VPN-профілю."
MSG_OPENVPN_LINUX_INSTRUCTIONS_HEADER="Інструкції для платформи Linux"
MSG_OPENVPN_LINUX_INSTRUCTIONS="1. Встановіть пакет $MSG_NAME_OPENVPN, використовуючи менеджер пакетів вашого дистрибутива (наприклад, apt для Ubuntu або yum для CentOS).\n\
2. Перенесіть конфігураційний файл (з розширенням .ovpn) до директорії /etc/openvpn.\n\
3. У терміналі введіть 'sudo openvpn configuration_file_name.ovpn', щоб підключитися до VPN."
MSG_OPENVPN_IOS_INSTRUCTIONS_HEADER="Інструкції для платформи iOS (iPhone і iPad)"
MSG_OPENVPN_IOS_INSTRUCTIONS="1. Встановіть додаток $MSG_NAME_OPENVPN Connect з App Store на вашому iOS-пристрої.\n\
2. Перенесіть конфігураційний файл (з розширенням .ovpn) на ваш пристрій через iTunes або іншими доступними методами.\n\
3. У додатку $MSG_NAME_OPENVPN Connect перейдіть до 'Налаштування' та виберіть 'Імпортувати файл $MSG_NAME_OPENVPN'.\n\
4. Виберіть ваш конфігураційний файл та дотримуйтесь інструкцій для імпорту.\n\
5. Після імпорту ваш VPN-профіль буде доступний для підключення."
MSG_DOWNLOAD_INSTALL_SCRIPT_FAILED="Не вдалося завантажити та встановити openvpn-install.sh"
MSG_INSTALLATION_ERROR="Сталася помилка під час установки $MSG_NAME_OPENVPN. Будь ласка, перевірте ваші налаштування та спробуйте ще раз."

# function menu_IPsec_L2TP_IKEv2
MSG_IPSEC="ipsec-vpn-server"
MSG_CHOOSE_ACTION_IPSEC="Оберіть дію для налаштування контейнера IPsec/L2TP, Cisco IPsec та IKEv2:"
MSG_INSTALL_IPSEC="Встановити $MSG_IPSEC"
MSG_CREATE_NEW_CONFIG="Створити нову конфігурацію для клієнта $MSG_IPSEC"
MSG_STOP_IPSEC="Зупинити $MSG_IPSEC"
MSG_REMOVE_IPSEC="Видалити $MSG_IPSEC"
MSG_UPDATE_IPSEC="Оновити $MSG_IPSEC"

# function install_ipsec_vpn_server
# function generate_vpn_env_file
MSG_VPN_ENV_FILE_CREATED="Файл /root/VPN/IPsec_L2TP/vpn.env був створений та успішно налаштований."
MSG_EXISTING_VPN_ENV_FILE="Файл vpn.env для конфігурації вже існує. Ви хочете створити новий файл або використовувати існуючий?"
MSG_USE_EXISTING_FILE="Використання існуючого файлу vpn.env."
MSG_CREATE_NEW_FILE="Створення нового файлу vpn.env."

MSG_FILES_COPIED_SUCCESS="Файли для конфігурації клієнта були успішно скопійовані до /root/VPN/IPsec_L2TP."
MSG_COPY_FILES_ERROR="Сталася помилка під час копіювання файлів. Будь ласка, спробуйте виконати команди вручну:"
MSG_COPY_COMMAND_1="docker cp $MSG_IPSEC:/etc/ipsec.d/vpnclient.p12 /root/VPN/IPsec_L2TP"
MSG_COPY_COMMAND_2="docker cp $MSG_IPSEC:/etc/ipsec.d/vpnclient.sswan /root/VPN/IPsec_L2TP"
MSG_COPY_COMMAND_3="docker cp $MSG_IPSEC:/etc/ipsec.d/vpnclient.mobileconfig /root/VPN/IPsec_L2TP"
MSG_CONTAINER_SETUP_SUCCESS="Контейнер $MSG_IPSEC був встановлений та успішно налаштований. Документація доступна за адресою: https://github.com/hwdsl2/setup-ipsec-vpn"

MSG_IKEV2_WINDOWS="Підключення через IKEv2 на Windows 10/11/8\n\
1. Перенесіть згенерований файл .p12 до бажаної папки на вашому комп'ютері.\n\
1.1. Завантажте файли ikev2_config_import.cmd та IPSec_NAT_Config.bat. Переконайтеся, що обидва файли знаходяться в одній папці з файлом .p12.\n\
2. Конфігурація VPN:\n\
2.1. Клацніть правою кнопкою миші на файлі IPSec_NAT_Config.bat.\n\
2.2. Виберіть 'Запустити від імені адміністратора' з контекстного меню.\n\
2.3. Підтвердіть дію, якщо з'явиться запит від UAC (Контроль облікових записів користувачів).\n\
3. Імпорт конфігурації:\n\
3.1. Клацніть правою кнопкою миші на файлі ikev2_config_import.cmd.\n\
3.2. Виберіть 'Запустити від імені адміністратора' з контекстного меню.\n\
3.3. Дотримуйтесь інструкцій на екрані, щоб завершити імпорт конфігурації.\n\
4. Перезавантажте комп'ютер, щоб переконатися, що всі зміни набули чинності.\n\
5. Тепер ви можете спробувати підключитися до вашого VPN-сервера, використовуючи налаштування IKEv2."

MSG_ANDROID_CONNECTION="Підключення через Android\n\
1. Перенесіть згенерований файл .sswan на ваш Android-пристрій.\n\
2. Завантажте та встановіть додаток strongSwan VPN Client з Google Play, F-Droid або безпосередньо з сервера strongSwan.\n\
3. Запустіть додаток strongSwan VPN Client на вашому пристрої.\n\
4. Імпорт профілю:\n\
4.1. Торкніться іконки 'Більше опцій' (зазвичай позначена трьома вертикальними крапками) у верхньому правому куті.\n\
4.2. Виберіть 'Імпортувати профіль VPN' з випадаючого меню.\n\
4.3. Щоб знайти файл .sswan, натисніть на іконку трьох горизонтальних ліній або меню, і перейдіть до папки, де збережено файл.\n\
4.4. Виберіть файл .sswan, отриманий від VPN-сервера.\n\
5. Імпорт сертифіката:\n\
5.1. На екрані 'Імпортувати профіль VPN' виберіть 'ІМПОРТ СЕРТИФІКАТА З VPN ПРОФІЛЮ' і дотримуйтесь інструкцій на екрані.\n\
5.2. На екрані 'Вибір сертифіката' виберіть новий імпортований сертифікат клієнта та натисніть 'Вибрати'.\n\
5.3. Потім натисніть 'ІМПОРТ'.\n\
5.4. Щоб підключитися до VPN: Торкніться нового VPN-профілю, щоб розпочати з'єднання."

MSG_MAC_IOS_CONNECTION="Для налаштування OS X (macOS) / iOS використовуйте файл .mobileconfig\n\
Спочатку безпечно перенесіть згенерований файл .mobileconfig на ваш Mac, а потім двічі клацніть на ньому та дотримуйтесь інструкцій для імпорту як профілю macOS.\n\
Якщо ваш Mac має macOS Big Sur або новішу версію, відкрийте Системні налаштування та перейдіть до розділу Профілі для завершення імпорту.\n\
Для macOS Ventura та новіших версій відкрийте Системні налаштування та знайдіть Профілі.\n\
Після завершення перевірте, що 'IKEv2 VPN' з'являється в Системних налаштуваннях -> Профілі.\n\
Щоб підключитися до VPN:\n\
1. Відкрийте Системні налаштування та перейдіть до розділу Мережа.\n\
2. Виберіть VPN-з'єднання з IP-адресою вашого VPN-сервера (або DNS-ім'ям).\n\
3. Перевірте 'Показувати статус VPN у панелі меню'. Для macOS Ventura та новіших версій це налаштування можна налаштувати в Системних налаштуваннях -> Центр управління -> Тільки панель меню.\n\
4. Клацніть Підключити або перемкніть VPN на ВКЛ.\n\
5. (Необов'язково) Увімкніть VPN за запитом, щоб автоматично запускати з'єднання VPN, коли ваш Mac підключено до Wi-Fi.\n\
   Щоб увімкнути, перевірте 'Підключити за запитом' для VPN-з'єднання та натисніть Застосувати.\n\
   Щоб знайти це налаштування в macOS Ventura та новіших версіях, натисніть іконку 'i' поруч з VPN-з'єднанням."

MSG_CONTAINER_INSTALLED="Контейнер $MSG_IPSEC вже встановлений."

# function add_client_ipsec_vpn_server
MSG_PROMPT_CONNECTION_NAME="Введіть ім'я з'єднання:"
MSG_NO_CONNECTION_NAME="Помилка: Ім'я з'єднання не надано"
MSG_CONNECTION_EXISTS1="Помилка: З'єднання "
MSG_CONNECTION_EXISTS2=" вже існує"
MSG_CONFIG_FILES_COPIED="Конфігураційні файли скопійовані до /root/VPN/IPsec_L2TP/"

# function stop_ipsec_vpn_server remove_ipsec_vpn_server update_ipsec_vpn_server
MSG_IPSEC_STOPPED="$MSG_IPSEC зупинено."
MSG_IPSEC_REMOVED="$MSG_IPSEC видалено."
MSG_IPSEC_UPDATED="$MSG_IPSEC оновлено."

# function menu_PPTP
MSG_VPN_PPTP="VPN-PPTP"
MSG_INSTALL_VPN_PPTP="1. Встановлення $MSG_VPN_PPTP"
MSG_ADD_USER="2. Додавання нового користувача"
MSG_STOP_VPN_PPTP="3. Зупинка $MSG_VPN_PPTP"
MSG_REMOVE_VPN_PPTP="4. Видалення $MSG_VPN_PPTP"

# function install_PPTP
MSG_SECRETS_HEADER="# Записи для автентифікації за допомогою PAP"
MSG_SECRETS_FORMAT="# client    server      secret      допустимі локальні IP-адреси"

MSG_VPN_SUCCESS="VPN-PPTP успішно встановлено та запущено!"
MSG_USER_DATA="Згенеровані дані користувача:"
MSG_USERNAME="Ім'я користувача: user1"
MSG_PASSWORD="Пароль: "
MSG_INSTRUCTIONS="Інструкції для підключення до VPN-PPTP:\n"

MSG_WINDOWS="На Windows:"
MSG_WINDOWS_STEP1="1. Відкрийте 'Панель управління' > 'Мережа та Інтернет' > 'Центр управління мережами та загальним доступом'."
MSG_WINDOWS_STEP2="2. Клацніть 'Налаштувати нове з'єднання або мережу' > 'Підключитися до робочого місця' > 'Використовувати моє підключення до Інтернету (VPN)'."
MSG_WINDOWS_STEP3="3. Введіть IP-адресу сервера: "
MSG_WINDOWS_STEP4="4. Введіть ваше ім'я користувача та пароль."
MSG_WINDOWS_STEP5="5. Клацніть 'Підключитися'.\n"

MSG_MACOS="На macOS:"
MSG_MACOS_STEP1="1. Відкрийте 'Системні налаштування' > 'Мережа'."
MSG_MACOS_STEP2="2. Клацніть '+' і виберіть 'VPN'."
MSG_MACOS_STEP3="3. Виберіть 'Тип VPN' як 'PPTP'."
MSG_MACOS_STEP4="4. Введіть IP-адресу сервера: "
MSG_MACOS_STEP5="5. Введіть ваше ім'я користувача та пароль."
MSG_MACOS_STEP6="6. Клацніть 'Підключитися'.\n"

MSG_ANDROID="На Android:"
MSG_ANDROID_STEP1="1. Відкрийте 'Налаштування' > 'Бездротові мережі та мережі' > 'VPN'."
MSG_ANDROID_STEP2="2. Торкніться 'Додати VPN' і виберіть 'PPTP'."
MSG_ANDROID_STEP3="3. Введіть IP-адресу сервера: "
MSG_ANDROID_STEP4="4. Введіть ваше ім'я користувача та пароль."
MSG_ANDROID_STEP5="5. Торкніться 'Зберегти' та 'Підключитися'.\n"

MSG_IOS="На iOS:"
MSG_IOS_STEP1="1. Відкрийте 'Налаштування' > 'Основні' > 'VPN'."
MSG_IOS_STEP2="2. Торкніться 'Додати конфігурацію VPN' і виберіть 'PPTP'."
MSG_IOS_STEP3="3. Введіть IP-адресу сервера: "
MSG_IOS_STEP4="4. Введіть ваше ім'я користувача та пароль."
MSG_IOS_STEP5="5. Торкніться 'Готово' та 'Підключитися'."

# function add_user_to_pptp
MSG_CONTAINER_NOT_FOUND1="Контейнер "
MSG_CONTAINER_NOT_FOUND2=" не встановлений."
MSG_ENTER_USERNAME="Введіть ім'я нового користувача: "
MSG_ENTER_PASSWORD="Введіть пароль для нового користувача: "
MSG_USER_ADDED1="Новий користувач "
MSG_USER_ADDED2=" додано."
MSG_CONTAINER_STOPPED="зупинено."
MSG_CONTAINER_REMOVED="видалено."
MSG_FIREWALL_RULE_REMOVED="Правило брандмауера для порту 1723 видалено."

# 8_server_testing.sh
MSG_SERVER_TESTING_PORT_SPEED="Швидкість порта"
MSG_SERVER_TESTING_PORT_MAIL="Пошта"

# functions_controller.sh
# function check_dependency
MSG_DEPENDENCY_NOT_INSTALLED=" не встановлений."
MSG_DEPENDENCY_INSTALLED=" встановлений."
MSG_ERROR_INFO_UNSUPPORTED_OS="Непідтримувана операційна система: "
MSG_ERROR_OS_DETECTION_FAILED="Не вдалося визначити операційну систему."
MSG_MISSING_PACKAGES="Відсутні пакети:"
MSG_INSTALL_PROMPT="Встановити відсутні пакети? (y/n): "
MSG_INSTALLATION_CANCELLED="Встановлення відсутніх пакетів скасовано."
MSG_ALL_PACKAGES_INSTALLED="Всі необхідні пакети вже встановлені."
MSG_ALL_PACKAGES_SUCCESSFULLY_INSTALLED="Всі відсутні пакети успішно встановлені."
MSG_UNSUPPORTED_INSTALL_METHOD="Непідтримуваний метод встановлення."

# function install_package
MSG_PACKAGE_INSTALL_FAILED="Не вдалося встановити "
MSG_PACKAGE_ALREADY_INSTALLED=" вже встановлений."
MSG_PACKAGE_INSTALL_TRY_MANUAL="Не вдалося встановити "
MSG_PACKAGE_INSTALL_MANUAL_PROMPT="Будь ласка, спробуйте встановити його вручну."

# function generate_random_password_show
MSG_GENERATED_RANDOM_PASSWORD="Сгенерований випадковий пароль:"

# function check_docker_availability
MSG_DOCKER_NOT_INSTALLED_THIS="Docker не встановлено на цій системі."
MSG_PROMPT_INSTALL_DOCKER="Ви хочете встановити Docker? (y/n): "
MSG_INSTALLING_DOCKER="Встановлення Docker... Будь ласка, зачекайте."
MSG_DOCKER_INSTALLATION_FAILED="Помилка: Встановлення Docker не вдалося. Спробуйте встановити його вручнуму режимі та повторити виконня скрипта..."
MSG_DOCKER_INSTALLATION_SUCCESS="Docker успішно встановлено."
MSG_DOCKER_ADD_GROUP_FAILED="Помилка: Не вдалося додати поточного користувача до групи Docker."
MSG_DOCKER_INSTALLATION_CANCELED="Встановлення Docker скасовано."
MSG_DOCKER_NOT_STARTED="Docker не запущено. Запуск Docker..."
MSG_DOCKER_START_SUCCESS="Docker успішно запущено."
MSG_DOCKER_START_FAILED="Помилка: Не вдалося запустити Docker."
MSG_DOCKER_ALREADY_AUTOSTART="Docker вже додано до автозавантаження."
MSG_DOCKER_ADDED_AUTOSTART="Docker успішно додано до автозавантаження."
MSG_DOCKER_FAILED_AUTOSTART="Помилка: Docker не було додано до автозавантаження."
MSG_DOCKER_STATUS="Статус Docker:"


# function create_folder
MSG_FOLDER_ALREADY_EXISTS="Папка вже існує"
MSG_FOLDER_CREATED="Папка створена"

# function copy_file_from_container
MSG_WAITING_FOR_FILE="Очікування створення файлу в контейнері..."
MSG_FILE_COPIED="Файл був скопійований до цільової директорії."

# function get_public_interface
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
MSG_PORT_OPEN="відкритий в iptables."
MSG_FIREWALLD_NOT_RUNNING_PART1="firewalld не запущений або не встановлений. Якщо встановлений інший файрвол, відкрию порти в ньому."
MSG_IPTABLES_NOT_INSTALLED_PART1="iptables не встановлений."
MSG_UFW_NOT_INSTALLED_PART1="ufw не встановлений."
MSG_FIREWALL_NOT_INSTALLED_PART1="Помилка: файервол не встановлений або невідомий. Перевірте порт "

# function delete_firewall_rule_by_port
MSG_RULE_DELETED_PART1="Правило з портом"
MSG_RULE_DELETED_PART2="та ID"
MSG_RULE_DELETED_PART3="успішно видалено."
MSG_RULE_DELETE_FAILED_PART1="Не вдалося видалити правило з ID "
MSG_RULE_DELETE_FAILED_PART2="."
MSG_RULE_NOT_FOUND_PART1="Правило з портом "
MSG_RULE_NOT_FOUND_PART2="не знайдено."


# function remove_firewall_rule
MSG_FIREWALLD_NOT_RUNNING_PART2="firewalld не запущений або не встановлений. Якщо встановлений інший файрвол, видалю правила з нього."
MSG_RULE_FOR_PORT="Правило для порту "
MSG_IPTABLES_NOT_INSTALLED_PART2="iptables не встановлений."
MSG_UFW_NOT_INSTALLED_PART2="ufw не встановлений."
MSG_FIREWALL_NOT_INSTALLED_PART2="Помилка: файервол не встановлений або невідомий."

# function check_domain

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

# function remove_docker_container stop_docker_container
MSG_ERROR_CONTAINER_NAME="Помилка: назва контейнера не може бути порожньою."

# function update_xui_settings
MSG_USERNAME_PASSWORD_UPDATED_PART1="Ім'я користувача та пароль"
MSG_USERNAME_PASSWORD_UPDATED_PART2=" успішно оновлено."
MSG_USERNAME_PASSWORD_FAILED_PART1="Не вдалося оновити ім'я користувача та пароль."
MSG_PORT_UPDATED_PART1="Порт"
MSG_PORT_UPDATED_PART2=" успішно оновлено."
MSG_PORT_FAILED_PART1="Не вдалося оновити порт."
MSG_WEB_BASE_PATH_UPDATED_PART1="Базовий шлях"
MSG_WEB_BASE_PATH_UPDATED_PART2=" успішно оновлено."
MSG_WEB_BASE_PATH_FAILED_PART1="Не вдалося оновити базовий шлях."
MSG_DOCKER_RESTART_PART1="Docker контейнер "
MSG_DOCKER_RESTART_PART2=" успішно перезапущено."
MSG_DOCKER_RESTART_FAILED_PART1="Не вдалося перезапустити Docker контейнер "

# function check_x_ui_panel_settings
MSG_CONTAINER_NOT_FOUND_PART1="Контейнер"
MSG_CONTAINER_NOT_FOUND_PART2="не знайдено."

MSG_SETTINGS_RETRIEVE_FAILED_PART1="Не вдалося отримати налаштування x-ui для контейнера"

MSG_PARSE_ERROR_PART1="Помилка: Не вдалося витягти всі необхідні дані."
MSG_DEBUG_INFO_PART1="Відлагоджувальна інформація:"

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
MSG_WEB_ADMIN_PORT="WEB панель адміністратора:"

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
