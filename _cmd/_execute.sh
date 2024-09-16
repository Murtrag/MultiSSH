#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"
. "${SCRIPT_DIR}/../_db/.current_resource.sh"

readonly COMMAND=$1 

function ussage(){
    echo "Explenation how you use this coomand"
}

if [[ "$COMMAND" =~ ^(!execute|!e) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        ussage
        exit 0
    fi
    echo "execute command: ${args}"
    IFS=

    exit 0
fi
exit 1
