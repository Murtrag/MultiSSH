#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"


readonly COMMAND=$1 



function ussage(){
    echo "Deactivate help"
}

if [[ "$COMMAND" =~ ^(!deactivate|!da) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        ussage
        exit 0
    fi

    # Check if deactivate resources specified
    if [[ "${args}" != "" ]]
    then
        # if resources provided
        # echo "resource provided!"
        echo $args
        IFS=","
        for resource in $args
        do
            # grep -v "$resource" "${SCRIPT_DIR}/../_db/.current_resource" #> "${SCRIPT_DIR}/../_db/.current_resource"
            sed -i "/^${resource}.*$/d" "${SCRIPT_DIR}/../_db/.current_resource"
        done
        unset IFS
        exit 0
    else
        # if not specified, deactive all
        # echo "resources not provided, da all"
        rm "${SCRIPT_DIR}/../_db/.current_resource"
        touch "${SCRIPT_DIR}/../_db/.current_resource"
        echo "Deactivating resource $args"
        exit 0
    fi
    exit 0
fi
exit 1