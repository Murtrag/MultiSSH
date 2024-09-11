#!/bin/bash
readonly COMMAND=$1 

function ussage(){
    echo
}

if [[ "$COMMAND" =~ ^(!help|!h) ]]
then
    # If extra parameter specified display ussage
    echo "Displays help message"
    exit 0
fi
exit 1

