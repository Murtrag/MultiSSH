#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"


readonly COMMAND=$1 



function ussage(){
    echo "Explenation how you use this coomand"
}

if [[ "$COMMAND" =~ ^(!activate|!a) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`

    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        ussage
        exit 0
    fi
    declare -A db
    parse_db "${SCRIPT_DIR}/../_db/"
    db_key=''

    # Check if group name specified
    if [[ "$(echo $args | wc -w)" -ne "1" ]]
    then
        echo "Please specify resource to activate"
        exit 1
    fi

    # Check if resources are available

    # Update
    echo echo "Activating resource $args"
    echo $args > "${SCRIPT_DIR}/../_db/.current_resource"


    
    exit 0
fi
exit 1