#!/bin/bash
readonly COMMAND=$1 

function ussage(){
    echo
}

if [[ "$COMMAND" = "clear" ]]
then
    clear
    exit 0
fi
exit 1
