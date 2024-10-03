#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../../_utils/_db_op.sh"
. "${SCRIPT_DIR}/_utils.sh"
. "${SCRIPT_DIR}/_help.sh"
. "${SCRIPT_DIR}/../../_utils/_beautiful_table.sh"

readonly active_resources="$(cat /tmp/multissh/active_resources.tmp)"
readonly COMMAND=$1 

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
    parse_db "${SCRIPT_DIR}/../../_db/"
    
    table_value="group|name|ip|port\n"
    if [[ $args != "" ]] 
    then
        execute_on_group $args check_group
        print_table '|' "${table_value}"
        exit 0
    elif [[ "${active_resources}" != "" ]]
    then
        formated_active_resources=$(echo "${active_resources}" | tr '\n' ',')
        execute_on_group "$formated_active_resources" check_group
        print_table '|' "${table_value}"
        exit 0
    else
        echo "Please specify group name or activate a group/s"
        exit 0
    fi
    exit 0
fi
exit 1