#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"
. "${SCRIPT_DIR}/../_utils/_beautiful_table.sh"

readonly COMMAND=$1 


if [[ "$COMMAND" =~ ^(!status|!s) ]]
then
    declare -A db
    parse_db "${SCRIPT_DIR}/../_db/"
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    db_key=''

    # Check if group name specified
    if [[ "$(echo $args | wc -w)" -ne "1" ]]
    then
        echo "Please specify name of group"
        exit 1
    fi

    IFS=$'\n' 
    for node in ${db[$args]}; do
        ip=$(echo "$node" | awk -F '[()]' '{print $1}')
        name=$(echo "$node" | awk -F '[()]' '{print $2}')
        
        nc -zv "$ip" 22 2>&1 | awk -v name="$name" '{$1=name; print}'
    done
    unset IFS  # Przywracamy domyślne IFS

    # If no group name, check if any activated
    # db_key=$args # args || active > depends on the situation

    # printTable ' ' "$(echo "name ip"; echo "${db[$db_key]}" | awk -F '[()]' '{print $2, $1}')"
    exit 0
fi
exit 1