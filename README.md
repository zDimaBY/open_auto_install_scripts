# control Panel Commands

wget https://raw.githubusercontent.com/zDimaBY/setting_up_control_panels/main/setting_up_control_panels.sh && bash ./setting_up_control_panels.sh && history -a && sed -i '/wget https:\/\/raw.githubusercontent.com\/zDimaBY/d' ~/.bash_history

history -d $(history | tail -n 2 | head -n 1 | awk '{print $1}') && rm -rf /root/controlPanelFiles /root/setting_up_control_panels.sh