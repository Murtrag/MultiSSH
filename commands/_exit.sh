#!/bin/bash
readonly COMMAND=$1 
readonly parent_pid=$2

function usage() {
    echo
}

if [[ "$COMMAND" = "exit" ]]
then
    read -p "Do you really want to exit? y/N: " is_exiting
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
