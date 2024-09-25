#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"
. "${SCRIPT_DIR}/../_utils/_beautiful_table.sh"

readonly current_resource="$(cat ${SCRIPT_DIR}/../_db/.current_resource)"
readonly COMMAND=$1 


function check_status(){
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    local linked

    (tmux ls | grep -q "${group_name}-${name}") && linked="linked" || linked="unlinked"
    nc -zv -w 5 "$ip" "$port" &> /dev/null 
    if [[ $? -eq 0 ]]; then
        status="open/${linked}"
    elif [[ $? -eq 1 ]]; then
        status="closed/${linked}"
    else
        status="timeout/${linked}"
    fi
    table_value+="$group_name|$name|$ip|$port|$status\n"
}

if [[ "$COMMAND" =~ ^(!status|!s) ]]
then
    declare -A db
    parse_db "${SCRIPT_DIR}/../_db/"
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`

    table_value="group|name|ip|port|status\n"
    if [[ $args != "" ]] 
    then
        execute_on_group $args check_status
        print_table '|' "${table_value}"
        exit 0
    elif [[ "${current_resource}" != "" ]]
    then
        current_resource2=$(echo "${current_resource}" | tr '\n' ',')
        execute_on_group "$current_resource2" check_status
        print_table '|' "${table_value}"
        exit 0

    else
        echo "Please specify group name or activate a group/s"
        exit 0
    fi
fi
exit 1