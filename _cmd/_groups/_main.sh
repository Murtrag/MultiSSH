#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../../_utils/_db_op.sh"
. "${SCRIPT_DIR}/_help.sh"
. "${SCRIPT_DIR}/../../_utils/_beautiful_table.sh"

readonly COMMAND=$1 

if [[ "$COMMAND" =~ ^(!groups|!gs) ]]
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
    # If extra parameters falsly specified, display ussage 

    if [[ "$(echo $args | wc -w)" -gt "0" ]]
    then
        echo "groups doesn't take any arguments"
        echo "Did you mean !g ${args}"
        exit 0
    fi

    table_value="name|node_count\n"
    for key in "${!db[@]}"
    do
        line_count=$(echo "${db[$key]}" | wc -l)
        table_value+="$key|$line_count\n"
    done
    print_table '|' "${table_value}"
    exit 0
fi
exit 1