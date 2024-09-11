#!/bin/bash
readonly COMMAND=$1 

function ussage(){
    echo
}

if [[ "$COMMAND" =~ ^(!activate|!a) ]]
then
    # Check if group name specified
    # If no group specified display ussage
    # If not existing group specified display ussage
    echo "activates specified group"
    exit 0
fi
exit 1