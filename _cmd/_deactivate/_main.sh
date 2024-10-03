#!/bin/bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
readonly active_resources_path="/tmp/multissh/active_resources.tmp"
active_resources="$(cat "$active_resources_path")"

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


    if [[ "${active_resources}" != "" && $args != "" ]] 
    then
        IFS=","
        for resource in $args
        do
            sed -i "/^${resource}.*$/d" "${active_resources_path}"
            execute_on_group $resource close_session
        done
        unset IFS
        exit 0
    elif [[ "${active_resources}" != "" ]]
    then
        rm "${active_resources_path}"
        touch "${active_resources_path}"
        (tmux ls | awk -F: '{print $1}' | xargs -I {} tmux kill-session -t {}) &>/dev/null
        echo "Deactivating resource ${args:-All}"
        exit 0
    else
        echo "Nothing to desactivate"
        exit 0
    fi
fi
exit 1