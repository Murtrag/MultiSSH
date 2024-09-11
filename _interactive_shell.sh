#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Import libs
source "${SCRIPT_DIR}/_utils/_db_op.sh"
# source "${SCRIPT_DIR}/commands/_fasade.sh"

declare -A db
parse_db "_db"

SERVER_LIST=$2

function prompt(){
    read -p "cmd> " USER_COMMAND # &>/dev/null
    tput cuu1
    echo -ne "\033[K"
    echo "cmd> ${USER_COMMAND}"
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

    while true;
    do
        prompt
        bash "${SCRIPT_DIR}/commands/_fasade.sh" "${USER_COMMAND}"
    done
}

# Uruchom skrypt przez rlwrap
my_interpreter
