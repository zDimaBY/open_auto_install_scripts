#!/bin/bash
# Коди кольорів
BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
BROWN='\033[0;33m'
RESET="\e[0m"

# Каталог для скриптів
rand_head=$(head /dev/urandom | tr -dc 'a-z' | head -c 6)
folder_script_path="/root/scripts"
mkdir -p "$folder_script_path"

# Підключення усіх файлів з папки
for file in "$folder_script_path"/*; do
    if [[ -f "$file" && -r "$file" ]]; then
        shc -f "$file" -o "${file%.sh}" && rm -f "$file"
    fi
done

shc -f ./open_auto_install_scripts.sh -o open_auto_install_scripts && rm -rf ./open_auto_install_scripts.sh
shc -f ./linuxinfo.sh -o linuxinfo && rm -rf ./linuxinfo.sh
