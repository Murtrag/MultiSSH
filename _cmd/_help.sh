#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

readonly COMMAND=$1 

function ussage(){
    echo
}

if [[ "$COMMAND" =~ ^(!help|!h) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # If extra parameter specified display ussage
    
    file_name=$(echo "_${args}" | sed 's/^_!/_/')
    if [[ "$args" != "" && -e "${SCRIPT_DIR}/${file_name}.sh" ]]
    then
        bash "${SCRIPT_DIR}/${file_name}.sh" "$args ?"
        exit 0
    else
        echo "Requested command ${file_name} does not exist"
        exit 0
    fi
    echo "Displays help message"
    exit 0
fi
exit 1

