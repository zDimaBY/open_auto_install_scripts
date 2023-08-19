
function 0_funExit() {
    echo -e "\nExit. Приберіть за собою! Використавши: \n\nhistory -d \$(history | tail -n 2 | head -n 1 | awk '{print $1}')\n\n"
    exit 0
}

function 0_invalid() {
    echo -e "{$RED}Невірний вибір. Введіть 1, 2, 3 or 0.${RESET}"
}