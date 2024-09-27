#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../../_utils/_db_op.sh"
. "${SCRIPT_DIR}/_help.sh"
. "${SCRIPT_DIR}/_utils.sh"


readonly COMMAND=$1 
readonly current_resource="${SCRIPT_DIR}/../../_db/.current_resource"



if [[ "$COMMAND" =~ ^(!activate|!a) ]]
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

    
    # Check if group name specified

    if [[ $args = "" ]] 
    then
        echo "Please specify resource to activate"
        exit 0
    else # If param specified
        execute_on_group $args activate
    fi

    exit 0
fi
exit 1