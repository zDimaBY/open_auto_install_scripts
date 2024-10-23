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

# User prompts
MSG_CHOOSE_OPTION="Choose an option:"
MSG_EXIT_SUBMENU="Exit this submenu"
MSG_EXIT_SCRIPT="Exit script"

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

MSG_WINDOWS_APPS="Windows - nekoray, v2rayNG: "

MSG_LINUX_APPS="Linux: "

MSG_MACOS_APPS="MacOS: "

MSG_IOS_APPS="iOS: "
MSG_IOS_APPS_LINK="https://apps.apple.com/us/app/napsternetv/id1629465476\nhttps://apps.apple.com/us/app/v2box-v2ray-client/id6446814690"

# Instructions for Android
MSG_ANDROID_INSTRUCTIONS="Instructions for connecting using $MSG_ANDROID_APP"
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
MSG_WINDOWS_STEP_2="2. Add a profile for VPN connection:"
MSG_WINDOWS_STEP_3="   - Copy the link '$MSG_VMESS_EXAMPLE' and paste it into the Nekoray app, go to 'Program' -> 'Add profile from clipboard'."
MSG_WINDOWS_STEP_4="   - Or use the QR code. Copy the QR code and paste it into the Nekoray app, go to 'Program' -> 'Scan QR code'."
MSG_WINDOWS_STEP_5="3. Enable 'Tune Mode' and 'System Proxy' settings in the main menu of the app."
MSG_WINDOWS_STEP_6="4. Start the connection: go to 'Program' -> 'Active server' and select your connection. The VPN should become active."
MSG_WINDOWS_STEP_7="If you encounter errors related to missing libraries like MSVCP140.dll, download and install Microsoft Visual C++ 2015-2022: https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170#visual-studio-2015-2017-2019-and-2022"

# Instructions for Linux
MSG_LINUX_INSTRUCTIONS="Connecting to VPN server using Linux - nekoray:"
MSG_LINUX_STEP_1="-"

# Instructions for MacOS
MSG_MACOS_INSTRUCTIONS="MacOS - nekoray:"
MSG_MACOS_STEP_1="-"

# Instructions for iOS
MSG_IOS_INSTRUCTIONS="iOS - napsternetv, v2box-v2ray-client:"
MSG_IOS_STEP_1="-"

MSG_CLIPBOARD_STRING_HEADER="\nOverall you should have a so-called clipboard string, which looks something like this: $MSG_VMESS_EXAMPLE"
MSG_QR_CODE="Or a QR code that contains the same string."
MSG_PROXY_DATA="This string contains the data needed to connect to the proxy server."
MSG_IMPORT_INSTRUCTIONS="You just need to import it into the app. In all apps, this is roughly called 'Add config from clipboard'. The app will automatically take the string from the clipboard, or you may need to paste it into a field."
MSG_CONNECTION_IMPORT="After importing, you will have a connection. Usually, you need to select it and click the button at the bottom. Or in desktop apps, right-click on the connection and choose 'Start' from the context menu. There may be multiple connections, and you can easily switch between them.\n"

# function menu_x_ui
MSG_XUI="X-UI"
MSG_INSTALL_XUI="1. Install $MSG_XUI"
MSG_STOP_XUI="2. Stop $MSG_XUI"
MSG_REMOVE_XUI="3. Remove $MSG_XUI"

# function list_x_ui_versions_install
MSG_XUI_ENTER_ADMIN_PASSWORD_1="Enter admin user password for"
MSG_XUI_ENTER_ADMIN_PASSWORD_2="(default is random): "
MSG_XUI_AVAILABLE_VERSIONS="List of available alireza7/x-ui image versions:"
MSG_XUI_SELECT_VERSION="Enter the version number you want to install (1-9): "
MSG_XUI_INVALID_SELECTION="Invalid choice. Please select a number between 1 and 9."
MSG_XUI_INSTALLED="Installed X-UI on the server. Use the following credentials to access the admin panel:"
MSG_XUI_USERNAME="Username: "
MSG_XUI_PASSWORD="Password: "

# function stop_x_ui remove_x_ui update_x_ui
MSG_XUI_STOPPED="stopped."
MSG_XUI_REMOVED="removed."
MSG_XUI_UPDATE_NOT_IMPLEMENTED="Function not implemented."

# function menu_3x_ui
MSG_3X_UI="3X-UI"
MSG_3X_UI_AVAILABLE_WINDOWS="\nAlso, $MSG_3X_UI is now available on Windows. To run $MSG_3X_UI, follow these steps:"
MSG_3X_UI_STEP_1="1: Go to the link: https://github.com/MHSanaei/3x-ui/releases"
MSG_3X_UI_STEP_2="2: Select the required version and download it from the 'Assets' submenu -> x-ui-windows-amd64.zip"
MSG_3X_UI_STEP_3="3: Unzip the archive, download and install the 'go' language from the link: https://go.dev/dl/go1.22.1.windows-amd64.msi as specified in the readme.txt file."
MSG_3X_UI_STEP_4="4: Run the following command in PowerShell: New-NetFirewallRule -DisplayName \"Allow_TCP_2053\" -Direction Inbound -LocalPort 2053 -Protocol TCP -Action Allow"
MSG_3X_UI_STEP_5="5: Launch 3x-ui.exe from the $MSG_3X_UI folder and go to the link: http://localhost:2053"
MSG_3X_UI_STEP_6="6: To obtain an SSL certificate, install Win64OpenSSL_Light-3_2_1.exe from the 'SSL' folder"
MSG_3X_UI_NOTE="Note: In this case, you need to open ports for each new client or disable the firewall."

MSG_INSTALL_3X_UI="1. Install $MSG_3X_UI"
MSG_STOP_3X_UI="2. Stop $MSG_3X_UI"
MSG_REMOVE_3X_UI="3. Remove $MSG_3X_UI"

# function list_3x_ui_versions_install
MSG_AVAILABLE_3X_UI_VERSIONS="\n${GREEN}List of available versions for ${YELLOW}ghcr.io/mhsanaei/3x-ui:${RESET}"
MSG_SELECT_VERSION="Enter the version number you want to install (1-9): "
MSG_INVALID_CHOICE="Invalid choice. Please select a number between 1 and 9."
MSG_X_UI_INSTALLED="${YELLOW}\n\n$MSG_3X_UI has been installed on the server. To access the admin panel, use the following information:${RESET}"
MSG_ADMIN_USERNAME="Username: "
MSG_ADMIN_PASSWORD="Password: "
MSG_UPDATE_FUNCTION_NOT_IMPLEMENTED="Function not implemented"

# function menu_wireguard_easy
MSG_WIREGUARD_EASY="WireGuard Easy"
MSG_INSTALL_WIREGUARD_EASY="1. Install $MSG_WIREGUARD_EASY"
MSG_STOP_WIREGUARD_EASY="2. Stop $MSG_WIREGUARD_EASY"
MSG_REMOVE_WIREGUARD_EASY="3. Remove $MSG_WIREGUARD_EASY"
MSG_UPDATE_WIREGUARD_EASY="4. Update $MSG_WIREGUARD_EASY"

# function install_wg_easy
MSG_ENTER_ADMIN_PASSWORD="Enter the admin password:"
MSG_INSTALL_FAILURE1="Failed to install "
MSG_INSTALL_FAILURE2=". Please install it manually."
MSG_INSTALL_WG_EASY_SUCCESS="$MSG_WIREGUARD_EASY was successfully installed. You can access the web interface at:"
MSG_INSTALL_WG_EASY_PASSWORD="Password for accessing the interface:"
MSG_INSTALL_WG_EASY_INSTRUCTIONS="WireGuard setup instructions:"
MSG_INSTALL_WG_EASY_STEP_1="1. Download the WireGuard client from the link:"
MSG_INSTALL_WG_EASY_STEP_2="2. After downloading, install it on your device."
MSG_INSTALL_WG_EASY_STEP_3="3. Go to the link and copy the configuration file from the server to your device:"
MSG_INSTALL_WG_EASY_STEP_4="4. Open the WireGuard client and import the configuration file."
MSG_INSTALL_WG_EASY_STEP_5="5. After importing, your VPN profile will be available for connection."
MSG_INSTALL_WG_EASY_DOC="Documentation can be found at:"
MSG_INSTALL_WG_EASY_DIAG="For diagnostics, use the following commands:"
MSG_INSTALL_WG_EASY_LOGS="  View container logs:"
MSG_INSTALL_WG_EASY_COMMANDS="  View the list of commands in the container:"
MSG_INSTALL_WG_EASY_ERROR="An error occurred during the installation of $MSG_WIREGUARD_EASY. Please check the settings and try again."

# function stop_wg_easy remove_wg_easy update_wg_easy
MSG_STOP_WG_EASY="$MSG_WIREGUARD_EASY stopped."
MSG_REMOVE_WG_EASY="$MSG_WIREGUARD_EASY removed."
MSG_UPDATE_WG_EASY="$MSG_WIREGUARD_EASY updated."

# function menu_wireguard_scriptLocal
MSG_WIREGUARD_INSTALLER_HEADER="WireGuard installer. Choose an action:\n"
MSG_WIREGUARD_AUTO_INSTALL="1. Automatic WireGuard installation"
MSG_WIREGUARD_MANUAL_MENU="2. WireGuard management menu and manual installation"

# function install_wireguard_scriptLocal
MSG_WIREGUARD_INSTALL_SUCCESS="__________________________________________________________________________WireGuard successfully installed!"
MSG_WIREGUARD_SETUP_INSTRUCTIONS="Instructions for setting up WireGuard"
MSG_WIREGUARD_CLIENT_DOWNLOAD="1. Download the WireGuard client from: ${BLUE}https://www.wireguard.com/install/${RESET}"
MSG_WIREGUARD_INSTALL_CLIENT="2. After downloading the client, install it on your device."
MSG_WIREGUARD_COPY_CONFIG="3. Navigate to the /root/VPN/wireguard/ directory on your server."
MSG_WIREGUARD_COPY_FILE="4. Copy the configuration file from the server to your device."
MSG_WIREGUARD_IMPORT_CONFIG="5. Open the WireGuard client and import the configuration file."
MSG_WIREGUARD_PROFILE_ACCESS="6. After importing, your VPN profile will be available for connection."
MSG_WIREGUARD_DOCUMENTATION="Documentation can be found at: https://github.com/angristan/openvpn-install"
MSG_WIREGUARD_INSTALL_ERROR="An error occurred while installing WireGuard. Please check the configuration and try again."

# function menu_openVPNLocal
MSG_NAME_OPENVPN="OpenVPN"
MSG_OPENVPN_INSTALLER_HEADER="$MSG_NAME_OPENVPN installer. Select an action:"
MSG_OPENVPN_AUTO_INSTALL="1. Automatic $MSG_NAME_OPENVPN installation"
MSG_OPENVPN_MANUAL_MENU="2. $MSG_NAME_OPENVPN management menu and manual installation"

# function avtoInstall_openVPN
MSG_OPENVPN_INSTALL_SUCCESS="$MSG_NAME_OPENVPN successfully installed!"
MSG_OPENVPN_DOCUMENTATION="Documentation at: https://github.com/angristan/openvpn-install"
MSG_OPENVPN_WINDOWS_INSTRUCTIONS_HEADER="Instructions for Windows platform"
MSG_OPENVPN_WINDOWS_INSTRUCTIONS="1. Download the $MSG_NAME_OPENVPN installer for Windows from the official $MSG_NAME_OPENVPN website.\n\
2. Install the program using the standard installation process.\n\
3. Launch $MSG_NAME_OPENVPN.\n\
4. After launching the program, go to 'File' -> 'Import configuration file'.\n\
5. Select the configuration file you received from your VPN server.\n\
6. After importing, a new profile with your VPN name will appear. Click on it to connect."
MSG_OPENVPN_ANDROID_INSTRUCTIONS_HEADER="Instructions for Android platform"
MSG_OPENVPN_ANDROID_INSTRUCTIONS="1. Download and install the $MSG_NAME_OPENVPN app for Android from the Google Play Store.\n\
2. Transfer the configuration file (with .ovpn extension) to your Android device.\n\
3. In the $MSG_NAME_OPENVPN app, tap the '+' icon to add a new profile.\n\
4. Choose 'Import from file' and select your configuration file.\n\
5. After importing, the profile will be available for connection."
MSG_OPENVPN_MACOS_INSTRUCTIONS_HEADER="Instructions for macOS (OS X) platform"
MSG_OPENVPN_MACOS_INSTRUCTIONS="1. Install Tunnelblick, a free $MSG_NAME_OPENVPN client for macOS, by downloading it from the official website.\n\
2. Open the installer and follow the instructions to complete the installation process.\n\
3. After installation, move the configuration file (with .ovpn extension) to the 'configurations' folder in your home directory.\n\
4. Launch Tunnelblick and select 'Connect' for your VPN profile."
MSG_OPENVPN_LINUX_INSTRUCTIONS_HEADER="Instructions for Linux platform"
MSG_OPENVPN_LINUX_INSTRUCTIONS="1. Install the $MSG_NAME_OPENVPN package using your distribution's package manager (e.g., apt for Ubuntu or yum for CentOS).\n\
2. Transfer the configuration file (with .ovpn extension) to the /etc/openvpn directory.\n\
3. In the terminal, enter 'sudo openvpn configuration_file_name.ovpn' to connect to the VPN."
MSG_OPENVPN_IOS_INSTRUCTIONS_HEADER="Instructions for iOS (iPhone and iPad) platform"
MSG_OPENVPN_IOS_INSTRUCTIONS="1. Install the $MSG_NAME_OPENVPN Connect app from the App Store on your iOS device.\n\
2. Transfer the configuration file (with .ovpn extension) to your device via iTunes or other available methods.\n\
3. In the $MSG_NAME_OPENVPN Connect app, go to 'Settings' and select 'Import $MSG_NAME_OPENVPN file'.\n\
4. Choose your configuration file and follow the instructions for import.\n\
5. After importing, your VPN profile will be available for connection."
MSG_DOWNLOAD_INSTALL_SCRIPT_FAILED="Failed to download and install openvpn-install.sh"
MSG_INSTALLATION_ERROR="An error occurred during $MSG_NAME_OPENVPN installation. Please check your settings and try again."

# function menu_IPsec_L2TP_IKEv2
MSG_IPSEC="ipsec-vpn-server"
MSG_CHOOSE_ACTION_IPSEC="Select an action to configure the IPsec/L2TP, Cisco IPsec, and IKEv2 container:"
MSG_INSTALL_IPSEC="Install $MSG_IPSEC"
MSG_CREATE_NEW_CONFIG="Create a new configuration for $MSG_IPSEC client"
MSG_STOP_IPSEC="Stop $MSG_IPSEC"
MSG_REMOVE_IPSEC="Remove $MSG_IPSEC"
MSG_UPDATE_IPSEC="Update $MSG_IPSEC"


# function install_ipsec_vpn_server
# function generate_vpn_env_file
MSG_VPN_ENV_FILE_CREATED="File /root/VPN/IPsec_L2TP/vpn.env has been created and configured successfully."
MSG_EXISTING_VPN_ENV_FILE="The vpn.env file for configuration already exists. Do you want to create a new one or use the existing one?"
MSG_USE_EXISTING_FILE="Using the existing vpn.env file."
MSG_CREATE_NEW_FILE="Creating a new vpn.env file."

MSG_FILES_COPIED_SUCCESS="Files for client configuration have been successfully copied to /root/VPN/IPsec_L2TP."
MSG_COPY_FILES_ERROR="Error occurred while copying files. Please try executing the commands manually:"
MSG_COPY_COMMAND_1="docker cp $MSG_IPSEC:/etc/ipsec.d/vpnclient.p12 /root/VPN/IPsec_L2TP"
MSG_COPY_COMMAND_2="docker cp $MSG_IPSEC:/etc/ipsec.d/vpnclient.sswan /root/VPN/IPsec_L2TP"
MSG_COPY_COMMAND_3="docker cp $MSG_IPSEC:/etc/ipsec.d/vpnclient.mobileconfig /root/VPN/IPsec_L2TP"
MSG_CONTAINER_SETUP_SUCCESS="The $MSG_IPSEC container has been installed and configured successfully. Documentation available at: https://github.com/hwdsl2/setup-ipsec-vpn"

MSG_IKEV2_WINDOWS="Connecting via IKEv2 on Windows 10/11/8\n\
1. Transfer the generated .p12 file to a desired folder on your computer.\n\
1.1. Download the ikev2_config_import.cmd and IPSec_NAT_Config.bat files. Ensure both files are in the same folder as the .p12 file.\n\
2. VPN Configuration:\n\
2.1. Right-click on the IPSec_NAT_Config.bat file.\n\
2.2. Select 'Run as administrator' from the context menu.\n\
2.3. Confirm the action if prompted by UAC (User Account Control).\n\
3. Import Configuration:\n\
3.1. Right-click on the ikev2_config_import.cmd file.\n\
3.2. Select 'Run as administrator' from the context menu.\n\
3.3. Follow the on-screen instructions to complete the configuration import.\n\
4. Restart your computer to ensure all changes take effect.\n\
5. You can now attempt to connect to your VPN server using IKEv2 settings."

MSG_ANDROID_CONNECTION="Connecting via Android\n\
1. Transfer the generated .sswan file to your Android device.\n\
2. Download and install the strongSwan VPN Client app from Google Play, F-Droid, or directly from the strongSwan server.\n\
3. Launch the strongSwan VPN Client on your device.\n\
4. Import Profile:\n\
4.1. Tap the 'More options' icon (usually represented by three vertical dots) in the upper right corner.\n\
4.2. From the dropdown menu, select 'Import VPN profile'.\n\
4.3. To locate the .sswan file, tap the three horizontal lines icon or menu button, and navigate to the folder where the file is saved.\n\
4.4. Select the .sswan file obtained from the VPN server.\n\
5. Import Certificate:\n\
5.1. On the 'Import VPN profile' screen, select 'IMPORT CERTIFICATE FROM VPN PROFILE' and follow the on-screen instructions.\n\
5.2. On the 'Select Certificate' screen, choose the newly imported client certificate and tap 'Select'.\n\
5.3. Then tap 'IMPORT'.\n\
5.4. To connect to the VPN: Tap the new VPN profile to start the connection."

MSG_MAC_IOS_CONNECTION="For OS X (macOS) / iOS setup, use the .mobileconfig file\n\
First, securely transfer the generated .mobileconfig file to your Mac, then double-click it and follow the instructions to import it as a macOS profile.\n\
If your Mac has macOS Big Sur or newer, open System Preferences and go to the Profiles section to complete the import.\n\
For macOS Ventura and newer, open System Preferences and locate Profiles.\n\
After completion, verify that 'IKEv2 VPN' appears in System Preferences -> Profiles.\n\
To connect to the VPN:\n\
1. Open System Preferences and go to the Network section.\n\
2. Select the VPN connection with your VPN server IP address (or DNS name).\n\
3. Check 'Show VPN status in the menu bar'. For macOS Ventura and newer, this setting can be configured in System Preferences -> Control Center -> Menu bar only.\n\
4. Click Connect or toggle the VPN to ON.\n\
5. (Optional) Enable VPN on demand to automatically start the VPN connection when your Mac is connected to Wi-Fi.\n\
   To enable, check 'Connect on demand' for the VPN connection and click Apply.\n\
   To find this setting on macOS Ventura and newer, click the 'i' icon next to the VPN connection."

MSG_CONTAINER_INSTALLED="Container $MSG_IPSEC is already installed."

# function add_client_ipsec_vpn_server
MSG_PROMPT_CONNECTION_NAME="Enter connection name:"
MSG_NO_CONNECTION_NAME="Error: Connection name not provided"
MSG_CONNECTION_EXISTS1="Error: Connection "
MSG_CONNECTION_EXISTS2=" already exists"
MSG_CONFIG_FILES_COPIED="Configuration files copied to /root/VPN/IPsec_L2TP/"

# function stop_ipsec_vpn_server remove_ipsec_vpn_server update_ipsec_vpn_server
MSG_IPSEC_STOPPED="$MSG_IPSEC stopped."
MSG_IPSEC_REMOVED="$MSG_IPSEC removed."
MSG_IPSEC_UPDATED="$MSG_IPSEC updated."

# function menu_PPTP
MSG_VPN_PPTP="VPN-PPTP"
MSG_INSTALL_VPN_PPTP="1. Installing $MSG_VPN_PPTP"
MSG_ADD_USER="2. Adding a new user"
MSG_STOP_VPN_PPTP="3. Stopping $MSG_VPN_PPTP"
MSG_REMOVE_VPN_PPTP="4. Removing $MSG_VPN_PPTP"

# function install_PPTP
MSG_SECRETS_HEADER="# Secrets for authentication using PAP"
MSG_SECRETS_FORMAT="# client    server      secret      acceptable local IP addresses"

MSG_VPN_SUCCESS="VPN-PPTP successfully installed and started!"
MSG_USER_DATA="Generated user data:"
MSG_USERNAME="Username: user1"
MSG_PASSWORD="Password: "
MSG_INSTRUCTIONS="Instructions for connecting to VPN-PPTP:\n"

MSG_WINDOWS="On Windows:"
MSG_WINDOWS_STEP1="1. Open 'Control Panel' > 'Network and Internet' > 'Network and Sharing Center'."
MSG_WINDOWS_STEP2="2. Click 'Set up a new connection or network' > 'Connect to a workplace' > 'Use my Internet connection (VPN)'."
MSG_WINDOWS_STEP3="3. Enter the server IP address: "
MSG_WINDOWS_STEP4="4. Enter your username and password."
MSG_WINDOWS_STEP5="5. Click 'Connect'.\n"

MSG_MACOS="On macOS:"
MSG_MACOS_STEP1="1. Open 'System Preferences' > 'Network'."
MSG_MACOS_STEP2="2. Click '+' and select 'VPN'."
MSG_MACOS_STEP3="3. Choose 'VPN Type' as 'PPTP'."
MSG_MACOS_STEP4="4. Enter the server IP address: "
MSG_MACOS_STEP5="5. Enter your username and password."
MSG_MACOS_STEP6="6. Click 'Connect'.\n"

MSG_ANDROID="On Android:"
MSG_ANDROID_STEP1="1. Open 'Settings' > 'Wireless & Networks' > 'VPN'."
MSG_ANDROID_STEP2="2. Tap 'Add VPN' and select 'PPTP'."
MSG_ANDROID_STEP3="3. Enter the server IP address: "
MSG_ANDROID_STEP4="4. Enter your username and password."
MSG_ANDROID_STEP5="5. Tap 'Save' and 'Connect'.\n"

MSG_IOS="On iOS:"
MSG_IOS_STEP1="1. Open 'Settings' > 'General' > 'VPN'."
MSG_IOS_STEP2="2. Tap 'Add VPN Configuration' and select 'PPTP'."
MSG_IOS_STEP3="3. Enter the server IP address: "
MSG_IOS_STEP4="4. Enter your username and password."
MSG_IOS_STEP5="5. Tap 'Done' and 'Connect'."

# function add_user_to_pptp
MSG_CONTAINER_NOT_FOUND1="Container "
MSG_CONTAINER_NOT_FOUND2=" is not installed."
MSG_ENTER_USERNAME="Enter the name of the new user: "
MSG_ENTER_PASSWORD="Enter the password for the new user: "
MSG_USER_ADDED1="New user "
MSG_USER_ADDED2=" added."
MSG_CONTAINER_STOPPED="stopped."
MSG_CONTAINER_REMOVED="removed."
MSG_FIREWALL_RULE_REMOVED="Firewall rule for port 1723 removed."

# 8_server_testing.sh
MSG_SERVER_TESTING_PORT_SPEED="port speed"
MSG_SERVER_TESTING_PORT_MAIL="post"

# functions_controller.sh ----------------------------------------------------------------------------
# function check_dependency
MSG_DEPENDENCY_NOT_INSTALLED=" not installed."
MSG_DEPENDENCY_INSTALLED=" installed."
MSG_ERROR_INFO_UNSUPPORTED_OS="Unsupported operating system: "
MSG_ERROR_OS_DETECTION_FAILED="Failed to detect the operating system."
MSG_MISSING_PACKAGES="Missing packages:"
MSG_INSTALL_PROMPT="Install missing packages? (y/n): "
MSG_INSTALLATION_CANCELLED="Installation of missing packages cancelled."
MSG_ALL_PACKAGES_INSTALLED="All required packages are already installed."
MSG_ALL_PACKAGES_SUCCESSFULLY_INSTALLED="All missing packages have been successfully installed."
MSG_UNSUPPORTED_INSTALL_METHOD="Unsupported installation method."

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
MSG_FOLDER_ALREADY_EXISTS="Folder already exists"
MSG_FOLDER_CREATED="Folder created"

# function copy_file_from_container
MSG_WAITING_FOR_FILE="Waiting for file to be created in container..."
MSG_FILE_COPIED="File was copied to target directory."

# function get_public_interface
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

MSG_RELEASE_DATA_ERROR="Failed to retrieve release data from"
MSG_FILE_TYPES_ERROR="Failed to find files of type"
MSG_IN_RELEASES_FROM="in releases from"

# function remove_docker_container stop_docker_container
MSG_ERROR_CONTAINER_NAME="Error: Container name cannot be empty."

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

