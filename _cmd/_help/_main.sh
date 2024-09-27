#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
. "${SCRIPT_DIR}/_help.sh"

readonly COMMAND=$1 


if [[ "$COMMAND" =~ ^(!help|!h) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    if [[ $args =~ ^(\?|)$ ]]
    then
        usage
        exit 0
    fi
    
    cmd_name=$(echo "_${args}" | sed 's/^_!/_/')
    if [[ "$args" != "" && -e "${SCRIPT_DIR}/../${cmd_name}/_main.sh" ]]
    then
        bash "${SCRIPT_DIR}/../${cmd_name}/_main.sh" "$args ?"
        exit 0
    else
        echo "Requested command ${cmd_name} does not exist"
        exit 0
    fi
    echo "Displays help message"
    exit 0
fi
exit 1

