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
        table_value="name|ip|port|status\n"
        for node in ${db[$args]}
        do
            ip=$(echo "$node" | awk -F '[()]' '{print $1}' | xargs)
            name=$(echo "$node" | awk -F '[()]' '{print $2}')
            
            nc -zv -w 5 "$ip" 22 &> /dev/null 
            if [[ $? -eq 0 ]]; then
                status="open"
            elif [[ $? -eq 1 ]]; then
                status="closed"
            else
                status="timeout"
            fi
            table_value+="$name|$ip|22|$status\n"
    done
    unset IFS
    printTable '|' "${table_value}"
    exit 0
fi
exit 1