![GitHub stars](https://img.shields.io/github/stars/zDimaBY/open_auto_install_scripts?style=social)
![GitHub forks](https://img.shields.io/github/forks/zDimaBY/open_auto_install_scripts?style=social)
![GitHub issues](https://img.shields.io/github/issues/zDimaBY/open_auto_install_scripts)
![GitHub license](https://img.shields.io/github/license/zDimaBY/open_auto_install_scripts)
![GitHub last commit](https://img.shields.io/github/last-commit/zDimaBY/open_auto_install_scripts)

How to Use the Script ?

<strong><span style="color: gold;">Control Panel Commands:</span></strong><br>
Deploy the Script
<span style="color: green;">Use the following command to download and run the setup script:</span>
```bash
wget -N https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/open_auto_install_scripts.sh && bash ./open_auto_install_scripts.sh
```

<strong>Script for displaying information about the system</strong><br>
Autorun for MobaXterm:<br>
```bash
(command -v curl &> /dev/null && curl -sSL https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/linuxinfo.sh | bash) || (command -v wget &> /dev/null && wget -qO- https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/linuxinfo.sh | bash) || { echo "Error: Neither 'curl' nor 'wget' found. Please install one of them to continue."; exit 1; }
```
or<br>
```bash
[ ! -f ~/.vimrc ] && echo -e "set number\nsyntax on" > ~/.vimrc && trap 'rm ~/.vimrc' EXIT && echo "Settings applied for the current session." || echo "File .vimrc already exists, no changes made."; (command -v curl &> /dev/null && curl -sSL --max-time 2 -s https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/linuxinfo.sh | bash) || (command -v wget &> /dev/null && wget --timeout=2 -qO- https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/linuxinfo.sh | bash) || { echo "Error: Neither 'curl' nor 'wget' found. Please install one of them to continue."; exit 1; }
```

Run in terminal:<br>
<code>curl -sSL https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/linuxinfo.sh | bash</code><br>
or<br>
<code>wget -qO- https://raw.githubusercontent.com/zDimaBY/open_auto_install_scripts/main/linuxinfo.sh | bash</code><br>

### Supported panel operating systems
| Operating System | Version | Supported          |
| ---------------- | ------- | ------------------ |
| SystemRescueCD   | 9.06    | :yellow_circle:    |
|                  | 11.00   | :yellow_circle:    |
| Ubuntu           | 18.04   | :yellow_circle:    |
|                  | 20.04   | :green_circle:     |
|                  | 22.04   | :green_circle:     |
|                  | 24.04   | :green_circle:     |
| Debian           | 10      | :green_circle:     |
|                  | 11      | :green_circle:     |
|                  | 12      | :green_circle:     |
| CentOS Stream    | 8       | :yellow_circle:    |
|                  | 9       | :yellow_circle:    |
| Rocky-Linux      | 8       | :red_circle:       |
|                  | 9       | :red_circle:       |

## Menu Options Explained

- **Software Installation**: This option allows you to install essential software such as Composer, Docker, RouterOS 7.5, Elasticsearch, Nginx as a proxy, and OpenSSH.

- **Functions for Control Panels**: Although labeled as a test feature, this may include utilities or functions for managing control panels.

- **DDoS Analysis**: This tools or scripts to help analyze and mitigate DDoS attacks.

- **VPN Configuration**: This comprehensive option allows you to install and configure various VPN services:
  - 3X-UI: Installs 3X-UI, a web-based management interface for Xray, on Docker.
  - X-UI: Installs X-UI, another web-based management tool for Xray, also on Docker.
  - WireGuard Easy: Installs a simple web-based interface for managing WireGuard on Docker.
  - IPsec/L2TP, Cisco IPsec, IKEv2: Installs a Docker-based VPN server supporting multiple protocols.
  - WireGuard: Installs WireGuard locally on the server.
  - OpenVPN: Installs OpenVPN locally on the server.
  - VPN-PPTP: Sets up a PPTP VPN with encryption on Docker.

- **FTP Configuration**: A test feature that may be used for setting up FTP servers.

- **Database Configuration**: This test feature might assist with setting up and managing databases.

- **Operating Systems Installation**: This feature might help with setting up operating systems on servers.

- **Server Testing**: Includes tools for testing server performance, such as port speed tests.

The script also provides options to exit the submenu or the script entirely.
