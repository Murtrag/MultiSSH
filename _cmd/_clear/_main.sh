#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
. "${SCRIPT_DIR}/_help.sh"

readonly COMMAND=$1 

if [[ "$COMMAND" =~ ^clear ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        usage
        exit 0
    fi
    clear
    exit 0
fi
exit 1
