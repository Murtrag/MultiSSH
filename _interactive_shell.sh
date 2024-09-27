#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Import libs
source "${SCRIPT_DIR}/_utils/_db_op.sh"
# source "${SCRIPT_DIR}/_cmd/_fasade.sh"

declare -A db
parse_db "_db"

SERVER_LIST=$2

function prompt(){
    local resources=$(cat "${SCRIPT_DIR}/_db/.current_resource" | xargs)
    # Check if any activated && build prompt
    if [[ "${resources}" != "" ]]
    then
        resources="(${resources}) "

    fi
    # Display user prompt
    echo -ne "\033[0;34m${resources}\033[0m\033[1;33mcmd>\033[0m "
    read USER_COMMAND
    tput cuu1
    # echo -ne "\033[K"
    tput el
    echo -e "\033[0;34m${resources}\033[0m\033[1;33mcmd>\033[0m ${USER_COMMAND}"
}

function usage(){
    echo "Commands:"
    echo "  !groups, !gs              Show all available groups"
    echo "                            Example: !gs"
    echo ""
    echo "  !group <group_name>, !g <group_name>"
    echo "                            Show all servers in the specified group"
    echo "                            Example: !g home_cluster"
    echo ""
    echo "  !activate gs <group_name>, !a gs <group_name>"
    echo "                            Activate all servers in the specified group"
    echo "                            Example: !a gs home_cluster"
    echo ""
    echo "  !activate gs <group_name>:<server_number>, !a <server_number>"
    echo "                            Activate a specific server in the group"
    echo "                            Example: !a home_cluster:1"
    echo "                                     !a 1"
    echo ""
    echo "  !exit, !e                 Exit the interactive shell"
    echo ""
    echo "  !?, ?, !help              Show this help message"
}

function my_interpreter(){
    echo "Interactive shell welcome"

    trap ctrl_c_handler SIGINT

    while true;
    do
        prompt
        bash "${SCRIPT_DIR}/_cmd/_fasade.sh" "${USER_COMMAND}"
    done
}

function ctrl_c_handler(){
    if [[ -n "$current_pid" ]]; then
        echo "Ctrl+C detected. Killing process $current_pid..."
        kill -SIGINT "$current_pid"  # Zabij zawieszony proces
        wait "$current_pid"  # Upewnij się, że proces się zakończył
        current_pid=""
    else
        echo "No process to kill. Continuing..."
        exit 0
        bash "$SCRIPT_DIR/_cmd/_exit/_main.sh" "exit" "$PPID"
    fi
}
# Uruchom skrypt przez rlwrap
my_interpreter
