#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"


readonly COMMAND=$1 



function ussage(){
    echo
}

if [[ "$COMMAND" =~ ^(!activate|!a) ]]
then
    declare -A db
    parse_db "${SCRIPT_DIR}/../_db/"
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`

    # Check if group name specified
    if [[ "$(echo $args | wc -w)" -ne "1" ]]
    then
        echo "Please specify resource to activate"
        exit 0
    else
        # if not specified, deactive all
        echo "" > "${SCRIPT_DIR}/../_db/.current_resource"
        exit 0
    fi
    echo echo "Activating resource $args"

    exit 0
fi
exit 1