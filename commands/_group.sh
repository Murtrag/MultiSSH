#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"
. "${SCRIPT_DIR}/../_utils/_beautiful_table.sh"


readonly COMMAND=$1 



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
    db_key=''

    # Check if group name specified
    if [[ "$(echo $args | wc -w)" -ne "1" ]]
    then
        echo "Please specify name of group"
        exit 1
    fi

    # If no group name, check if any activated
    db_key=$args # args || active > depends on the situation

    printTable ' ' "$(echo "name ip"; echo "${db[$db_key]}" | awk -F '[()]' '{print $2, $1}')"
    exit 0
fi
exit 1