# shellcheck disable=SC2148
# shellcheck disable=SC2154
function 7_Installation_operating_systems() {
    case $operating_system in
    arch | sysrescue)
        ;;
    *)
        echo -e "${RED}Встановлення систем відбувається лише через ${YELLOW}SystemRescueCd -> ${GREEN}https://www.system-rescue.org/Download/${RESET}"
        return 1
        ;;
    esac

    while true; do
        checkControlPanel
        echo -e "\nВиберіть дію:\n"
        echo -e "1. Встановлення ${BLUE}RouterOS від Mikrotik${RESET}"
        echo -e "2. Встановлення ${BLUE}Ubuntu${RESET}"
        echo -e "\n0. Вийти з цього підменю!"
        echo -e "00. Закінчити роботу скрипта\n"

        read -p "Виберіть варіант:" choice

        case $choice in
        1) 1_installRouterOSMikrotik ;;
        2) 7_installUbuntu ;;
        0) break ;;
        00) 0_funExit ;;
        *) 0_invalid ;;
        esac
    done
}

7_installUbuntu() {
    echo -e "\nВ розробці ...\n"
}