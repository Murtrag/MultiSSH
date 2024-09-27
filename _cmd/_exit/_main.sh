#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/_help.sh"

readonly COMMAND=$1 
readonly parent_pid=$2

if [[ "$COMMAND" =~ ^exit ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        usage
        exit 0
    fi
    echo 'exiting'
    read -p "Do you really want to exit MultiSSH interactive mode? y/N: " is_exiting
    echo 'exiting'
    is_exiting=$(echo "$is_exiting" | tr '[:upper:]' '[:lower:]')
    if [[ "$is_exiting" != "y" ]]
    then
        echo "Exit canceled."
    else
        kill "$parent_pid"
        echo "Exiting..."
    fi
    exit 0
fi
exit 1
