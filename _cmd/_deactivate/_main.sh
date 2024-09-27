#!/bin/bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
readonly current_resource="$(cat ${SCRIPT_DIR}/../../_db/.current_resource)"

. "${SCRIPT_DIR}/../../_utils/_db_op.sh"
. "${SCRIPT_DIR}/_help.sh"
. "${SCRIPT_DIR}/_utils.sh"


readonly COMMAND=$1 


if [[ "$COMMAND" =~ ^(!deactivate|!da) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        usage
        exit 0
    fi


    if [[ "${current_resource}" != "" && $args != "" ]] 
    then
        IFS=","
        for resource in $args
        do
            sed -i "/^${resource}.*$/d" "${SCRIPT_DIR}/../../_db/.current_resource"
            execute_on_group $resource close_session
        done
        unset IFS
        exit 0
    elif [[ "${current_resource}" != "" ]]
    then
        rm "${SCRIPT_DIR}/../../_db/.current_resource"
        touch "${SCRIPT_DIR}/../../_db/.current_resource"
        (tmux ls | awk -F: '{print $1}' | xargs -I {} tmux kill-session -t {}) &>/dev/null
        echo "Deactivating resource ${args:-All}"
        exit 0
    else
        echo "Nothing to desactivate"
        exit 0
    fi
fi
exit 1