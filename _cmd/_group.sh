#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"
. "${SCRIPT_DIR}/../_utils/_beautiful_table.sh"

readonly current_resource="$(cat ${SCRIPT_DIR}/../_db/.current_resource)"


readonly COMMAND=$1 

function check_group(){
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    table_value+="$group_name|$name|$ip|$port\n"
}


function usage(){
    echo "group help"
}

if [[ "$COMMAND" =~ ^(!group|!g) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        usage
        exit 0
    fi
    declare -A db
    parse_db "${SCRIPT_DIR}/../_db/"
    
    table_value="group|name|ip|port\n"
    if [[ $args != "" ]] 
    then
        execute_on_group $args check_group
        print_table '|' "${table_value}"
        exit 0
    elif [[ "${current_resource}" != "" ]]
    then
        current_resource2=$(echo "${current_resource}" | tr '\n' ',')
        execute_on_group "$current_resource2" check_group
        print_table '|' "${table_value}"
        exit 0
    else
        echo "Please specify group name or activate a group/s"
        exit 0
    fi
    exit 0
fi
exit 1