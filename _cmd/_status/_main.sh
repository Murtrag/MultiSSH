#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../../_utils/_db_op.sh"
. "${SCRIPT_DIR}/_help.sh"
. "${SCRIPT_DIR}/_utils.sh"
. "${SCRIPT_DIR}/../../_utils/_beautiful_table.sh"

readonly current_resource="$(cat ${SCRIPT_DIR}/../../_db/.current_resource)"
readonly COMMAND=$1 


if [[ "$COMMAND" =~ ^(!status|!s) ]]
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