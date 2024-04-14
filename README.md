### Supported panel operating systems

| Operating System | Version | Supported          |
| ---------------- | ------- | ------------------ |
| Ubuntu           | 18.04   | :red_circle: \*    |
|                  | 20.04   | :white_check_mark: |
|                  | 22.04   | :white_check_mark: |
| Debian           | 10      | :red_circle: \*    |
|                  | 11      | :white_check_mark: |
|                  | 12      |                    |
| CentOS           | 6       | :red_circle:       |
|                  | 7       | :white_check_mark: |
|                  | 8       | :red_circle: \*bag |
| Rocky Linux      | 9       |                    |
| AlmaLinux        | 8       |                    |
|                  | 9       |                    |

**Control Panel Commands:**

Розгортання скрипта:
```bash
wget -N https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/setting_up_control_panels.sh && bash ./setting_up_control_panels.sh && history -c && history -a
```

Після завершення роботи використовуйте цю команду:
```bash
rm -rf /root/scripts_* /root/setting_up_control_panels.sh && history -c && history -a
```