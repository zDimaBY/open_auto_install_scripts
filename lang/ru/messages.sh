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

MSG_WINDOWS_APPS="Windows - nekoray, v2rayNG: "

MSG_LINUX_APPS="Linux: "

MSG_MACOS_APPS="MacOS (Intel + Apple): "

MSG_IOS_APPS="iOS: "
MSG_IOS_APPS_LINK="https://apps.apple.com/us/app/napsternetv/id1629465476\nhttps://apps.apple.com/us/app/v2box-v2ray-client/id6446814690"

# Инструкции для Android
MSG_ANDROID_INSTRUCTIONS="Инструкции по подключению с использованием $MSG_ANDROID_APP"
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
MSG_WINDOWS_STEP_2="2. Добавьте профиль для подключения к VPN:"
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

MSG_CLIPBOARD_STRING_HEADER="У вас должна быть так называемая clipboard string, выглядит примерно так:"
MSG_CLIPBOARD_STRING="vmess://XXXXXXXXXX"
MSG_QR_CODE="Или QR-код, который содержит ту же строку."
MSG_PROXY_DATA="В этой строке заданы данные для подключения к proxy-серверу."
MSG_IMPORT_INSTRUCTIONS="Вам нужно только импортировать её в приложение. Во всех приложениях это называется примерно 'Add config from clipboard'. Приложение само берет из буфера обмена строку, либо вам нужно вставить её в поле."
MSG_CONNECTION_IMPORT="После импорта у вас появится подключение. Обычно его нужно выбрать и нажать кнопку внизу. Либо в десктопных приложениях правой кнопкой на подключение и в контекстном меню выбрать 'Start'. Подключений может быть несколько, и между ними можно легко переключаться."

# function menu_x_ui
MSG_XUI="X-UI"
MSG_INSTALL_XUI="1. Установить $MSG_XUI"
MSG_STOP_XUI="2. Остановить $MSG_XUI"
MSG_REMOVE_XUI="3. Удалить $MSG_XUI"

# function list_x_ui_versions_install
MSG_XUI_AVAILABLE_VERSIONS="Список доступных версий образа alireza7/x-ui:"
MSG_XUI_SELECT_VERSION="Введите номер версии, которую вы хотите установить (1-9): "
MSG_XUI_INVALID_SELECTION="Неверный выбор. Пожалуйста, выберите число от 1 до 9."
MSG_XUI_INSTALLED="X-UI установлен на сервере. Для доступа к панели администратора используйте следующие данные:"
MSG_XUI_USERNAME="Имя пользователя: admin"
MSG_XUI_PASSWORD="Пароль: admin"

# function stop_x_ui remove_x_ui update_x_ui
MSG_XUI_STOPPED="остановлен."
MSG_XUI_REMOVED="удален."
MSG_XUI_UPDATE_NOT_IMPLEMENTED="Функция не реализована."

# function menu_3x_ui
MSG_3X_UI="3X-UI"
MSG_3X_UI_AVAILABLE_WINDOWS="\nТакже $MSG_3X_UI теперь доступен на Windows. Чтобы запустить $MSG_3X_UI, выполните следующие шаги:"
MSG_3X_UI_STEP_1="1: Перейдите по ссылке: https://github.com/MHSanaei/3x-ui/releases"
MSG_3X_UI_STEP_2="2: Выберите нужную версию и скачайте её из подменю 'Assets' -> x-ui-windows-amd64.zip"
MSG_3X_UI_STEP_3="3: Распакуйте архив, скачайте и установите язык 'go' по ссылке: https://go.dev/dl/go1.22.1.windows-amd64.msi, как указано в readme.txt."
MSG_3X_UI_STEP_4="4: Выполните следующую команду в PowerShell: New-NetFirewallRule -DisplayName \"Allow_TCP_2053\" -Direction Inbound -LocalPort 2053 -Protocol TCP -Action Allow"
MSG_3X_UI_STEP_5="5: Запустите 3x-ui.exe из папки $MSG_3X_UI и перейдите по ссылке: http://localhost:2053"
MSG_3X_UI_STEP_6="6: Для получения SSL-сертификата установите Win64OpenSSL_Light-3_2_1.exe из папки 'SSL'"
MSG_3X_UI_NOTE="Примечание: В этом случае вам нужно открыть порты для каждого нового клиента или отключить брандмауэр."

MSG_INSTALL_3X_UI="1. Установить $MSG_3X_UI"
MSG_STOP_3X_UI="2. Остановить $MSG_3X_UI"
MSG_REMOVE_3X_UI="3. Удалить $MSG_3X_UI"

# function list_3x_ui_versions_install
MSG_AVAILABLE_3X_UI_VERSIONS="\n${GREEN}Список доступных версий для ${YELLOW}ghcr.io/mhsanaei/3x-ui:${RESET}"
MSG_SELECT_VERSION="Введите номер версии, которую вы хотите установить (1-9): "
MSG_INVALID_CHOICE="Неверный выбор. Пожалуйста, выберите число от 1 до 9."
MSG_X_UI_INSTALLED="${YELLOW}\n\n3x-UI установлен на сервере. Для доступа к панели администратора используйте следующую информацию:${RESET}"
MSG_ADMIN_USERNAME="Имя пользователя: admin"
MSG_ADMIN_PASSWORD="Пароль: admin\n"
MSG_UPDATE_FUNCTION_NOT_IMPLEMENTED="Функция не реализована"

# function menu_wireguard_easy
MSG_WIREGUARD_EASY="WireGuard Easy"
MSG_INSTALL_WIREGUARD_EASY="1. Установить $MSG_WIREGUARD_EASY"
MSG_STOP_WIREGUARD_EASY="2. Остановить $MSG_WIREGUARD_EASY"
MSG_REMOVE_WIREGUARD_EASY="3. Удалить $MSG_WIREGUARD_EASY"
MSG_UPDATE_WIREGUARD_EASY="4. Обновить $MSG_WIREGUARD_EASY"

# function install_wg_easy
MSG_ENTER_ADMIN_PASSWORD="Введите пароль администратора:"
MSG_INSTALL_FAILURE1="Не удалось установить "
MSG_INSTALL_FAILURE2=". Пожалуйста, установите вручную."
MSG_INSTALL_WG_EASY_SUCCESS="$MSG_WIREGUARD_EASY успешно установлен. Вы можете получить доступ к веб-интерфейсу по адресу:"
MSG_INSTALL_WG_EASY_PASSWORD="Пароль для доступа к интерфейсу:"
MSG_INSTALL_WG_EASY_INSTRUCTIONS="Инструкции по настройке WireGuard:"
MSG_INSTALL_WG_EASY_STEP_1="1. Скачайте клиент WireGuard по ссылке:"
MSG_INSTALL_WG_EASY_STEP_2="2. После скачивания установите его на вашем устройстве."
MSG_INSTALL_WG_EASY_STEP_3="3. Перейдите по ссылке и скопируйте конфигурационный файл с сервера на ваше устройство:"
MSG_INSTALL_WG_EASY_STEP_4="4. Откройте клиент WireGuard и импортируйте конфигурационный файл."
MSG_INSTALL_WG_EASY_STEP_5="5. После импорта ваш VPN-профиль будет доступен для подключения."
MSG_INSTALL_WG_EASY_DOC="Документацию можно найти по адресу:"
MSG_INSTALL_WG_EASY_DIAG="Для диагностики используйте следующие команды:"
MSG_INSTALL_WG_EASY_LOGS="  Просмотреть логи контейнера:"
MSG_INSTALL_WG_EASY_COMMANDS="  Просмотреть список команд в контейнере:"
MSG_INSTALL_WG_EASY_ERROR="Произошла ошибка при установке $MSG_WIREGUARD_EASY. Пожалуйста, проверьте настройки и попробуйте снова."

# function stop_wg_easy remove_wg_easy update_wg_easy
MSG_STOP_WG_EASY="$MSG_WIREGUARD_EASY остановлен."
MSG_REMOVE_WG_EASY="$MSG_WIREGUARD_EASY удален."
MSG_UPDATE_WG_EASY="$MSG_WIREGUARD_EASY обновлен."

# function menu_wireguard_scriptLocal
MSG_WIREGUARD_INSTALLER_HEADER="Установщик WireGuard. Выберите действие:\n"
MSG_WIREGUARD_AUTO_INSTALL="1. Автоматическая установка WireGuard"
MSG_WIREGUARD_MANUAL_MENU="2. Меню управления WireGuard и ручная установка"

# function install_wireguard_scriptLocal
MSG_WIREGUARD_INSTALL_SUCCESS="__________________________________________________________________________WireGuard успешно установлен!"
MSG_WIREGUARD_SETUP_INSTRUCTIONS="Инструкции по настройке WireGuard"
MSG_WIREGUARD_CLIENT_DOWNLOAD="1. Скачайте клиент WireGuard с: ${BLUE}https://www.wireguard.com/install/${RESET}"
MSG_WIREGUARD_INSTALL_CLIENT="2. После скачивания клиента установите его на ваше устройство."
MSG_WIREGUARD_COPY_CONFIG="3. Перейдите в каталог /root/VPN/wireguard/ на вашем сервере."
MSG_WIREGUARD_COPY_FILE="4. Скопируйте конфигурационный файл с сервера на ваше устройство."
MSG_WIREGUARD_IMPORT_CONFIG="5. Откройте клиент WireGuard и импортируйте конфигурационный файл."
MSG_WIREGUARD_PROFILE_ACCESS="6. После импорта ваш VPN-профиль будет доступен для подключения."
MSG_WIREGUARD_DOCUMENTATION="Документацию можно найти по адресу: https://github.com/angristan/openvpn-install"
MSG_WIREGUARD_INSTALL_ERROR="Произошла ошибка при установке WireGuard. Пожалуйста, проверьте конфигурацию и попробуйте снова."

# function menu_openVPNLocal
MSG_OPENVPN_INSTALLER_HEADER="Установщик OpenVPN. Выберите действие:"
MSG_OPENVPN_AUTO_INSTALL="1. Автоматическая установка OpenVPN"
MSG_OPENVPN_MANUAL_MENU="2. Меню управления OpenVPN и ручная установка"

# function avtoInstall_openVPN
MSG_OPENVPN_OPENVPN_INSTALL_SUCCESS="OpenVPN успешно установлен!"
MSG_OPENVPN_OPENVPN_DOCUMENTATION="Документация по адресу: https://github.com/angristan/openvpn-install"
MSG_OPENVPN_WINDOWS_INSTRUCTIONS_HEADER="Инструкции для платформы Windows"
MSG_OPENVPN_WINDOWS_INSTRUCTIONS="1. Скачайте установщик OpenVPN для Windows с официального сайта OpenVPN.\n\
2. Установите программу, используя стандартный процесс установки.\n\
3. Запустите OpenVPN.\n\
4. После запуска программы перейдите в 'Файл' -> 'Импортировать конфигурационный файл'.\n\
5. Выберите конфигурационный файл, который вы получили от вашего VPN-сервера.\n\
6. После импорта появится новый профиль с именем вашего VPN. Нажмите на него, чтобы подключиться."
MSG_OPENVPN_ANDROID_INSTRUCTIONS_HEADER="Инструкции для платформы Android"
MSG_OPENVPN_ANDROID_INSTRUCTIONS="1. Скачайте и установите приложение OpenVPN для Android из Google Play Store.\n\
2. Перенесите конфигурационный файл (с расширением .ovpn) на ваше Android-устройство.\n\
3. В приложении OpenVPN нажмите иконку '+' для добавления нового профиля.\n\
4. Выберите 'Импортировать из файла' и выберите ваш конфигурационный файл.\n\
5. После импорта профиль будет доступен для подключения."
MSG_OPENVPN_MACOS_INSTRUCTIONS_HEADER="Инструкции для платформы macOS (OS X)"
MSG_OPENVPN_MACOS_INSTRUCTIONS="1. Установите Tunnelblick, бесплатный клиент OpenVPN для macOS, скачав его с официального сайта.\n\
2. Откройте установочный файл и следуйте инструкциям для завершения процесса установки.\n\
3. После установки переместите конфигурационный файл (с расширением .ovpn) в папку 'configurations' в вашем домашнем каталоге.\n\
4. Запустите Tunnelblick и выберите 'Подключиться' для вашего VPN-профиля."
MSG_OPENVPN_LINUX_INSTRUCTIONS_HEADER="Инструкции для платформы Linux"
MSG_OPENVPN_LINUX_INSTRUCTIONS="1. Установите пакет OpenVPN с помощью менеджера пакетов вашей дистрибуции (например, apt для Ubuntu или yum для CentOS).\n\
2. Перенесите конфигурационный файл (с расширением .ovpn) в каталог /etc/openvpn.\n\
3. В терминале введите 'sudo openvpn имя_файла_конфигурации.ovpn', чтобы подключиться к VPN."
MSG_OPENVPN_IOS_INSTRUCTIONS_HEADER="Инструкции для платформы iOS (iPhone и iPad)"
MSG_OPENVPN_IOS_INSTRUCTIONS="1. Установите приложение OpenVPN Connect из App Store на ваше устройство iOS.\n\
2. Перенесите конфигурационный файл (с расширением .ovpn) на ваше устройство с помощью iTunes или других доступных методов.\n\
3. В приложении OpenVPN Connect перейдите в 'Настройки' и выберите 'Импортировать OpenVPN файл'.\n\
4. Выберите ваш конфигурационный файл и следуйте инструкциям для импорта.\n\
5. После импорта ваш VPN-профиль будет доступен для подключения."
MSG_DOWNLOAD_INSTALL_SCRIPT_FAILED="Не удалось скачать и установить openvpn-install.sh"
MSG_INSTALLATION_ERROR="Произошла ошибка при установке OpenVPN. Пожалуйста, проверьте ваши настройки и попробуйте снова."

# function menu_IPsec_L2TP_IKEv2
MSG_IPSEC="ipsec-vpn-server"
MSG_CHOOSE_ACTION_IPSEC="Выберите действие для настройки контейнера IPsec/L2TP, Cisco IPsec и IKEv2:"
MSG_INSTALL_IPSEC="Установить $MSG_IPSEC"
MSG_CREATE_NEW_CONFIG="Создать новую конфигурацию для клиента $MSG_IPSEC"
MSG_STOP_IPSEC="Остановить $MSG_IPSEC"
MSG_REMOVE_IPSEC="Удалить $MSG_IPSEC"
MSG_UPDATE_IPSEC="Обновить $MSG_IPSEC"

# function install_ipsec_vpn_server
# function generate_vpn_env_file
MSG_VPN_ENV_FILE_CREATED="Файл /root/VPN/IPsec_L2TP/vpn.env был успешно создан и настроен."
MSG_EXISTING_VPN_ENV_FILE="Файл vpn.env для конфигурации уже существует. Вы хотите создать новый файл или использовать существующий?"
MSG_USE_EXISTING_FILE="Использование существующего файла vpn.env."
MSG_CREATE_NEW_FILE="Создание нового файла vpn.env."

MSG_FILES_COPIED_SUCCESS="Файлы для конфигурации клиента успешно скопированы в /root/VPN/IPsec_L2TP."
MSG_COPY_FILES_ERROR="Произошла ошибка при копировании файлов. Пожалуйста, попробуйте выполнить команды вручную:"
MSG_COPY_COMMAND_1="docker cp $MSG_IPSEC:/etc/ipsec.d/vpnclient.p12 /root/VPN/IPsec_L2TP"
MSG_COPY_COMMAND_2="docker cp $MSG_IPSEC:/etc/ipsec.d/vpnclient.sswan /root/VPN/IPsec_L2TP"
MSG_COPY_COMMAND_3="docker cp $MSG_IPSEC:/etc/ipsec.d/vpnclient.mobileconfig /root/VPN/IPsec_L2TP"
MSG_CONTAINER_SETUP_SUCCESS="Контейнер $MSG_IPSEC был успешно установлен и настроен. Документация доступна по адресу: https://github.com/hwdsl2/setup-ipsec-vpn"

MSG_IKEV2_WINDOWS="Подключение через IKEv2 на Windows 10/11/8\n\
1. Перенесите сгенерированный файл .p12 в желаемую папку на вашем компьютере.\n\
1.1. Скачайте файлы ikev2_config_import.cmd и IPSec_NAT_Config.bat. Убедитесь, что оба файла находятся в одной папке с файлом .p12.\n\
2. Конфигурация VPN:\n\
2.1. Щелкните правой кнопкой мыши на файле IPSec_NAT_Config.bat.\n\
2.2. Выберите 'Запуск от имени администратора' из контекстного меню.\n\
2.3. Подтвердите действие, если появится запрос UAC (Контроль учетных записей).\n\
3. Импорт конфигурации:\n\
3.1. Щелкните правой кнопкой мыши на файле ikev2_config_import.cmd.\n\
3.2. Выберите 'Запуск от имени администратора' из контекстного меню.\n\
3.3. Следуйте инструкциям на экране для завершения импорта конфигурации.\n\
4. Перезагрузите компьютер, чтобы все изменения вступили в силу.\n\
5. Теперь вы можете попытаться подключиться к вашему VPN-серверу, используя настройки IKEv2."

MSG_ANDROID_CONNECTION="Подключение через Android\n\
1. Перенесите сгенерированный файл .sswan на ваше Android-устройство.\n\
2. Скачайте и установите приложение strongSwan VPN Client из Google Play, F-Droid или непосредственно с сервера strongSwan.\n\
3. Запустите приложение strongSwan VPN Client на вашем устройстве.\n\
4. Импорт профиля:\n\
4.1. Нажмите иконку 'Дополнительные параметры' (обычно обозначенную тремя вертикальными точками) в верхнем правом углу.\n\
4.2. В выпадающем меню выберите 'Импортировать VPN-профиль'.\n\
4.3. Чтобы найти файл .sswan, нажмите иконку трёх горизонтальных линий или кнопку меню и перейдите в папку, где сохранён файл.\n\
4.4. Выберите файл .sswan, полученный с VPN-сервера.\n\
5. Импорт сертификата:\n\
5.1. На экране 'Импортировать VPN-профиль' выберите 'ИМПОРТ СЕРТИФИКАТА ИЗ VPN-ПРОФИЛЯ' и следуйте инструкциям на экране.\n\
5.2. На экране 'Выбор сертификата' выберите вновь импортированный клиентский сертификат и нажмите 'Выбрать'.\n\
5.3. Затем нажмите 'ИМПОРТИРОВАТЬ'.\n\
5.4. Для подключения к VPN: Нажмите новый VPN-профиль для начала подключения."

MSG_MAC_IOS_CONNECTION="Для настройки OS X (macOS) / iOS используйте файл .mobileconfig\n\
Сначала безопасно перенесите сгенерированный файл .mobileconfig на ваш Mac, затем дважды щелкните по нему и следуйте инструкциям для импорта в виде профиля macOS.\n\
Если на вашем Mac установлена macOS Big Sur или новее, откройте 'Системные настройки' и перейдите в раздел 'Профили', чтобы завершить импорт.\n\
Для macOS Ventura и новее откройте 'Системные настройки' и найдите 'Профили'.\n\
После завершения убедитесь, что 'IKEv2 VPN' отображается в 'Системные настройки' -> 'Профили'.\n\
Для подключения к VPN:\n\
1. Откройте 'Системные настройки' и перейдите в раздел 'Сеть'.\n\
2. Выберите VPN-соединение с IP-адресом вашего VPN-сервера (или DNS-именем).\n\
3. Установите флажок 'Показывать статус VPN в строке меню'. Для macOS Ventura и новее эту настройку можно настроить в 'Системные настройки' -> 'Центр управления' -> 'Только строка меню'.\n\
4. Нажмите 'Подключиться' или переключите VPN в ВКЛ.\n\
5. (По желанию) Включите VPN по требованию, чтобы автоматически запускать VPN-соединение при подключении вашего Mac к Wi-Fi.\n\
   Для этого установите флажок 'Подключать по требованию' для VPN-соединения и нажмите 'Применить'.\n\
   Чтобы найти эту настройку в macOS Ventura и новее, нажмите на иконку 'i' рядом с VPN-соединением."

MSG_CONTAINER_INSTALLED="Контейнер $MSG_IPSEC уже установлен."

# function add_client_ipsec_vpn_server
MSG_PROMPT_CONNECTION_NAME="Введите имя подключения:"
MSG_NO_CONNECTION_NAME="Ошибка: Имя подключения не указано"
MSG_CONNECTION_EXISTS1="Ошибка: Подключение "
MSG_CONNECTION_EXISTS2=" уже существует"
MSG_CONFIG_FILES_COPIED="Файлы конфигурации скопированы в /root/VPN/IPsec_L2TP/"

# function stop_ipsec_vpn_server remove_ipsec_vpn_server update_ipsec_vpn_server
MSG_IPSEC_STOPPED="$MSG_IPSEC остановлен."
MSG_IPSEC_REMOVED="$MSG_IPSEC удалён."
MSG_IPSEC_UPDATED="$MSG_IPSEC обновлён."

# function menu_PPTP
MSG_VPN_PPTP="VPN-PPTP"
MSG_INSTALL_VPN_PPTP="1. Установка $MSG_VPN_PPTP"
MSG_ADD_USER="2. Добавление нового пользователя"
MSG_STOP_VPN_PPTP="3. Остановка $MSG_VPN_PPTP"
MSG_REMOVE_VPN_PPTP="4. Удаление $MSG_VPN_PPTP"

# function install_PPTP
MSG_SECRETS_HEADER="# Записи для аутентификации с использованием PAP"
MSG_SECRETS_FORMAT="# client    server      secret      допустимые локальные IP-адреса"

MSG_VPN_SUCCESS="VPN-PPTP успешно установлен и запущен!"
MSG_USER_DATA="Сгенерированные данные пользователя:"
MSG_USERNAME="Имя пользователя: user1"
MSG_PASSWORD="Пароль: "
MSG_INSTRUCTIONS="Инструкции по подключению к VPN-PPTP:\n"

MSG_WINDOWS="На Windows:"
MSG_WINDOWS_STEP1="1. Откройте 'Панель управления' > 'Сеть и Интернет' > 'Центр управления сетями и общим доступом'."
MSG_WINDOWS_STEP2="2. Нажмите 'Настроить новое подключение или сеть' > 'Подключиться к рабочему месту' > 'Использовать моё подключение к Интернету (VPN)'."
MSG_WINDOWS_STEP3="3. Введите IP-адрес сервера: "
MSG_WINDOWS_STEP4="4. Введите ваше имя пользователя и пароль."
MSG_WINDOWS_STEP5="5. Нажмите 'Подключиться'.\n"

MSG_MACOS="На macOS:"
MSG_MACOS_STEP1="1. Откройте 'Системные настройки' > 'Сеть'."
MSG_MACOS_STEP2="2. Нажмите '+' и выберите 'VPN'."
MSG_MACOS_STEP3="3. Выберите 'Тип VPN' как 'PPTP'."
MSG_MACOS_STEP4="4. Введите IP-адрес сервера: "
MSG_MACOS_STEP5="5. Введите ваше имя пользователя и пароль."
MSG_MACOS_STEP6="6. Нажмите 'Подключиться'.\n"

MSG_ANDROID="На Android:"
MSG_ANDROID_STEP1="1. Откройте 'Настройки' > 'Беспроводные сети и сети' > 'VPN'."
MSG_ANDROID_STEP2="2. Нажмите 'Добавить VPN' и выберите 'PPTP'."
MSG_ANDROID_STEP3="3. Введите IP-адрес сервера: "
MSG_ANDROID_STEP4="4. Введите ваше имя пользователя и пароль."
MSG_ANDROID_STEP5="5. Нажмите 'Сохранить' и 'Подключиться'.\n"

MSG_IOS="На iOS:"
MSG_IOS_STEP1="1. Откройте 'Настройки' > 'Основные' > 'VPN'."
MSG_IOS_STEP2="2. Нажмите 'Добавить конфигурацию VPN' и выберите 'PPTP'."
MSG_IOS_STEP3="3. Введите IP-адрес сервера: "
MSG_IOS_STEP4="4. Введите ваше имя пользователя и пароль."
MSG_IOS_STEP5="5. Нажмите 'Готово' и 'Подключиться'."

# function add_user_to_pptp
MSG_CONTAINER_NOT_FOUND1="Контейнер "
MSG_CONTAINER_NOT_FOUND2=" не установлен."
MSG_ENTER_USERNAME="Введите имя нового пользователя: "
MSG_ENTER_PASSWORD="Введите пароль для нового пользователя: "
MSG_USER_ADDED1="Новый пользователь "
MSG_USER_ADDED2=" добавлен."
MSG_CONTAINER_STOPPED="остановлен."
MSG_CONTAINER_REMOVED="удален."
MSG_FIREWALL_RULE_REMOVED="Правило брандмауэра для порта 1723 удалено."

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

MSG_RELEASE_DATA_ERROR="Не удалось получить данные о релизе"
MSG_FILE_TYPES_ERROR="Не удалось найти файлы соответствующего типа"
MSG_IN_RELEASES_FROM="в релизах от"

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
