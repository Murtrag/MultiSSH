#!/bin/bash
readonly COMMAND=$1 

function ussage(){
    echo "Explenation how you use this coomand"
}

if [[ "$COMMAND" =~ ^clear ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        ussage
        exit 0
    fi
    # clear
    exit 0
fi
exit 1
