#!/bin/bash
# English localization

# Error messages
MSG_FAILED_DOWNLOAD="Failed to download"

# Information messages
MSG_LAST_COMMIT_MESSAGE="Last commit message"
MSG_LAST_COMMIT_DATE_LABEL="Last commit date"
MSG_ACTION_SELECTION="Select an action:"
MSG_INSTALL_SOFTWARE="Software installation"
MSG_CONTROL_PANEL_FUNCTIONS="Functions for control panels"
MSG_DDOS_ANALYSIS="DDos analysis"
MSG_VPN_CONFIGURATION="VPN configuration"
MSG_FTP_CONFIGURATION="FTP configuration"
MSG_DATABASE_CONFIGURATION="Database configuration"
MSG_OPERATING_SYSTEMS_INSTALLATION="Operating systems installation"
MSG_SERVER_TESTING="Server testing"
MSG_EXIT_SCRIPT="Exit script"

# User prompts
MSG_CHOOSE_OPTION="Choose an option:"
MSG_EXIT_SUBMENU="Exit this submenu"
MSG_EXIT_SCRIPT="End the script"

# 0_exit.sh ----------------------------------------------------------------------------
MSG_EXIT_STARTUP_MESSAGE="Starting: wget -N https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/open_auto_install_scripts.sh && bash ./open_auto_install_scripts.sh"
MSG_EXIT_INVALID_SELECTION="Invalid choice. Enter 1, 2, 3 .. or 0."

# 4_VPN.sh ----------------------------------------------------------------------------
MSG_VMESS_CONNECTION="Also configured vmess connection:"
MSG_VMESS_LINK="Link: "
MSG_VMESS_EXAMPLE="vmess://XXXXXXXXXX"

# Application instructions
MSG_ANDROID_APPS="For connection, you can use these apps:"
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

# Instructions for Android
MSG_ANDROID_INSTRUCTIONS="Instructions for connecting using $MSG_ANDROID_APP:"
MSG_ANDROID_STEP_1="1. Download and install the v2rayNG app from the link: "
MSG_ANDROID_STEP_2="   - Copy the link '$MSG_VMESS_EXAMPLE' and paste it into the appropriate field of the v2rayNG app."
MSG_ANDROID_STEP_3="2. Open the v2rayNG app."
MSG_ANDROID_STEP_4="3. In the main menu of the app, click on the plus '+' button."
MSG_ANDROID_STEP_5="4. Choose 'Import config from Clipboard'."
MSG_ANDROID_STEP_6="5. The app will automatically import the configuration. You just need to select the added connection and click 'Connect'."
MSG_ANDROID_STEP_7="6. If you see the VPN icon in the status bar, it means the connection is active.\n"

# Instructions for Windows
MSG_WINDOWS_INSTRUCTIONS="Connecting to VPN server using Windows - Nekoray:"
MSG_WINDOWS_STEP_1="1. Download and unzip the Nekoray program from the link: "
MSG_WINDOWS_STEP_2="   - Add a profile for VPN connection:"
MSG_WINDOWS_STEP_3="   - Copy the link '$MSG_VMESS_EXAMPLE' and paste it into the Nekoray app, go to 'Program' -> 'Add profile from clipboard'."
MSG_WINDOWS_STEP_4="   - Or use the QR code. Copy the QR code and paste it into the Nekoray app, go to 'Program' -> 'Scan QR code'."
MSG_WINDOWS_STEP_5="3. Enable 'Tune Mode' and 'System Proxy' settings in the main menu of the app."
MSG_WINDOWS_STEP_6="4. Start the connection: go to 'Program' -> 'Active server' and select your connection. The VPN should become active."
MSG_WINDOWS_STEP_7="If you encounter errors related to missing libraries like MSVCP140.dll, download and install Microsoft Visual C++ 2015-2022: https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170#visual-studio-2015-2017-2019-and-2022"

# Instructions for Linux
MSG_LINUX_INSTRUCTIONS="Connecting to VPN server using Linux - nekoray:"
MSG_LINUX_STEP_1="-"

# Instructions for MacOS
MSG_MACOS_INSTRUCTIONS="MacOS (Intel + Apple) - nekoray:"
MSG_MACOS_STEP_1="-"

# Instructions for iOS
MSG_IOS_INSTRUCTIONS="iOS - napsternetv, v2box-v2ray-client:"
MSG_IOS_STEP_1="-"

# 8_server_testing.sh
MSG_SERVER_TESTING_PORT_SPEED="port speed"
MSG_SERVER_TESTING_PORT_MAIL="post"

# functions_controller.sh ----------------------------------------------------------------------------
# function check_dependency
MSG_ERROR_INFO_UNSUPPORTED_OS="It looks like you are not using this installer on Debian, Ubuntu, Fedora, CentOS, Oracle, AlmaLinux, or Arch Linux systems. Your system: "
MSG_ERROR_OS_DETECTION_FAILED="Failed to determine the operating system."
MSG_ERROR_INSTALL_FAILED="Failed to install "
MSG_ERROR_MANUAL_INSTALL_REQUIRED="Please install it manually."
MSG_DEPENDENCY_NOT_INSTALLED=" is not installed. Installing..."
MSG_DEPENDENCY_INSTALLED=" is already installed."
MSG_DEPENDENCY_SUCCESSFULLY_INSTALLED=" successfully installed."

# function install_package
MSG_PACKAGE_INSTALL_FAILED="Failed to install "
MSG_PACKAGE_ALREADY_INSTALLED=" is already installed."
MSG_PACKAGE_INSTALL_TRY_MANUAL="Failed to install "
MSG_PACKAGE_INSTALL_MANUAL_PROMPT="Please try installing it manually."

# function generate_random_password_show
MSG_GENERATED_RANDOM_PASSWORD="Generated random password:"

# function generate_random_password_show
MSG_DOCKER_NOT_INSTALLED_THIS="Docker is not installed on this system."
MSG_PROMPT_INSTALL_DOCKER="Do you want to install Docker? (y/n): "
MSG_INSTALLING_DOCKER="Installing Docker..."
MSG_DOCKER_INSTALLATION_CANCELED="Docker installation canceled."
MSG_DOCKER_NOT_STARTED="Docker is not running. Starting Docker..."
MSG_DOCKER_START_SUCCESS="Command 'sudo systemctl start docker' executed successfully."
MSG_DOCKER_START_FAILED="Error: Unable to execute 'sudo systemctl start docker'."
MSG_DOCKER_ALREADY_AUTOSTART="Docker is already enabled in autostart."
MSG_DOCKER_ADDED_AUTOSTART="Docker has been successfully added to autostart."
MSG_DOCKER_FAILED_AUTOSTART="Error: Docker was not added to autostart."
MSG_DOCKER_STATUS="Docker status:"

# function create_folder
MSG_FOLDER_ALREADY_EXISTS="Folder already exists."
MSG_FOLDER_CREATED="Folder created."

# function copy_file_from_container
MSG_WAITING_FOR_FILE="Waiting for file to be created in container..."
MSG_FILE_COPIED="File was copied to target directory."

# function mask_to_cidr get_public_interface
MSG_INVALID_SUBNET_MASK="Invalid subnet mask"
MSG_NO_ADAPTER_FOUND="Could not find adapter with IP address matching hostname -i result:"

# function get_selected_interface
MSG_SELECT_NETWORK_ADAPTER="Select an available network adapter:"
MSG_ENTER_ADAPTER_NUMBER="Enter the adapter number (from 1 to"
MSG_ERROR_NOT_A_NUMBER="Error: Input must be a number."
MSG_ERROR_INVALID_ADAPTER_NUMBER="Error: Invalid adapter number."
MSG_ADAPTER_INFO="Information about network adapter"
MSG_IP_ADDRESS="IP address:"
MSG_SUBNET_MASK="Subnet mask:"
MSG_GATEWAY="Gateway:"

# function add_firewall_rule
MSG_PORT="Port "
MSG_FIREWALLD_NOT_RUNNING_PART1="firewalld is not running or installed. If another firewall is installed, opening ports in it."
MSG_IPTABLES_NOT_INSTALLED_PART1="iptables is not installed."
MSG_UFW_NOT_INSTALLED_PART1="ufw is not installed."
MSG_FIREWALL_NOT_INSTALLED_PART1="Error: Firewall not installed or unknown. Check port "

# function remove_firewall_rule
MSG_FIREWALLD_NOT_RUNNING_PART2="firewalld is not running or installed. If another firewall is installed, removing rules from it."
MSG_RULE_FOR_PORT="Rule for port "
MSG_IPTABLES_NOT_INSTALLED_PART2="iptables is not installed."
MSG_UFW_NOT_INSTALLED_PART2="ufw is not installed."
MSG_FIREWALL_NOT_INSTALLED_PART2="Error: Firewall not installed or unknown."

# function check_domain
MSG_DOMAIN_POINTED="Domain "
MSG_DOMAIN_TARGET_SERVER=" is pointing to this server ("
MSG_DOMAIN_NOT_TARGET_SERVER=" is not pointing to this server"

# function select_disk_and_partition
MSG_SELECT_DISK="Select a disk:"
MSG_INVALID_INPUT_DISK="Invalid input. Please enter the disk number."
MSG_INVALID_CHOICE_DISK="Invalid choice. Please select a valid number from the list."
MSG_SELECTED_DISK="Selected disk: "
MSG_NO_PARTITIONS="There are no partitions on this disk."
MSG_SELECT_PARTITION="Select a partition (or press Enter to skip):"
MSG_INVALID_INPUT_PARTITION="Invalid input. Please enter the partition number."
MSG_INVALID_CHOICE_PARTITION="Invalid choice. Please select a valid number from the list."
MSG_SELECTED_PARTITION="Selected partition: "

# linuxinfo.sh
MSG_ERROR_NO_DOWNLOAD_TOOL="Error: 'wget' or 'curl' not found. Please install one of them to continue."

# functions_linux_info.sh
MSG_ERROR_NOT_ROOT="Error: This script is not run as root."
MSG_ERROR_OS_RELEASE_NOT_FOUND="Error: /etc/os-release not found"
MSG_ERROR_LSB_NOT_INSTALLED="lsb_release is currently not installed, please install it:"
MSG_ERROR_UNSUPPORTED_PACKAGE_MANAGER="Unsupported package manager. Please install lsb-release manually."
MSG_ERROR_UNSUPPORTED_OS="Unsupported operating system. Please install lsb-release manually."
MSG_INFORMATION="Information:"
MSG_DEBIAN_BASED_SYSTEM="Debian or Ubuntu:"
MSG_REDHAT_BASED_SYSTEM="Red Hat-based systems:"
MSG_ALMALINUX="AlmaLinux:"
MSG_SUSE="SUSE:"
MSG_ARCH_LINUX="Arch Linux:"

# End of Life message
MSG_END_LIFE="End Life"

MSG_ERROR_IP_COMMAND="Error executing ip command"
MSG_INSUFFICIENT_FIELDS="Insufficient fields in line: "
MSG_INVALID_FORMAT="Invalid format in line: "
MSG_HOSTNAME="Hostname:"
MSG_PRIMARY_NETWORK="Primary Network"
MSG_STATUS_NETWORK="Status Network"
MSG_FILE_SYSTEMS="File Systems:"
MSG_DISK_USAGE="Disk Usage:"

# Memory messages
MSG_MEMORY="Memory:"
MSG_TOTAL_MEMORY="Total Memory"
MSG_USED_MEMORY="Used Memory"
MSG_FREE_MEMORY="Free Memory"
MSG_SHARED_MEMORY="Shared Memory"
MSG_BUFF_CACHE_MEMORY="Buff/Cache Memory"
MSG_AVAILABLE_MEMORY="Available Memory"

# Load Average messages
MSG_CPU="CPU:"
MSG_LOAD_AVERAGE="Load Average:"

# CPU info messages
MSG_CPU_MODEL="Model:"
MSG_CPU_CORES="Cores:"

MSG_CONTROL_PANEL_NOT_FOUND="Control panel not found."
MSG_MYSQL_MARIADB_POSTGRESQL_SQLITE_NOT_INSTALLED="MySQL or MariaDB, PostgreSQL or SQLite is not installed."
MSG_PHP_PYTHON_NODE_NOT_INSTALLED="PHP, Python or Node.js is not installed."
MSG_DOCKER_NOT_INSTALLED="Docker is not installed."

# Control Panel Specific Messages
# Hestia Panel messages
MSG_HESTIA_INSTALLED="Hestia Control Panel is installed."
MSG_WEB_ADMIN_PORT="WEB Admin Port:"

# Vesta Panel messages
MSG_VESTA_INSTALLED="Vesta Control Panel is installed."

MSG_ISPMANAGER_INSTALLED="ISPmanager is installed."
MSG_CPanel_INSTALLED="cPanel is installed."
MSG_FASTPANEL_INSTALLED="FastPanel is installed."
MSG_BRAINYCP_INSTALLED="BrainyCP is installed."
MSG_BTPANEL_INSTALLED="aaPanal(BT-Panel) is installed."
MSG_CyberCP_INSTALLED="CyberCP is installed."
MSG_CyberPanel_INSTALLED="CyberPanel is installed."

# File-related Messages
MSG_FILE_NOT_FOUND="File not found:"
MSG_UNIT_NOT_FOUND="Unit(s) not found:"

# Function messages
MSG_INFO="Information"
MSG_UNKNOWN="Unknown"
MSG_COMMAND_NOT_INSTALLED="is not installed"

# Function get_latest_v2rayng_apk_url
MSG_LATEST_VERSION="Latest version available for download: "