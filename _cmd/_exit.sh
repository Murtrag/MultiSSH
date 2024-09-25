#!/bin/bash
readonly COMMAND=$1 
readonly parent_pid=$2

function usage() {
    echo "Exit help"
}

if [[ "$COMMAND" =~ ^exit ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        usage
        exit 0
    fi
    kill "$parent_pid"
    read -p "Do you really want to exit? y/N: " is_exiting
    is_exiting=$(echo "$is_exiting" | tr '[:upper:]' '[:lower:]')
    if [[ "$is_exiting" != "y" ]]
    then
        echo "Exit canceled."
    else
        echo "$parent_pid"
        kill "$parent_pid"
        echo "Exiting..."
    fi
    exit 0
fi
exit 1
