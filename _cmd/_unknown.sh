#!/bin/bash
readonly COMMAND=$1 

    if [[ "$COMMAND" != "" ]]
    then
        echo "$1 command not recognized"
        exit 0
    else
        exit 0
    fi