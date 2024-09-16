#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"


readonly COMMAND=$1 
readonly current_resource="${SCRIPT_DIR}/../_db/.current_resource"



function usage(){
    echo "Explenation how you use this coomand"
}

if [[ "$COMMAND" =~ ^(!activate|!a) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`

    # Check if user asks for help
    echo 'Check if user asks for help'
    if [[ "${args}" = "?" ]]
    then
        usage
        exit 0
    fi
    declare -A db
    parse_db "${SCRIPT_DIR}/../_db/"

    # Check if group name specified
    echo 'Check if group name specified'
    if [[ "$(echo $args | wc -w)" -ne "1" ]]
    then
        echo "Please specify resource to activate"
        exit 1
    else # If param specified
        IFS=","
        for resource in $args
        do
            resource_duplicates=$(grep -F "$resource" "$current_resource")
            # echo "$resource"
            if [[ "$resource" =~ .*:.* ]]
            then 
                key=$(echo "$resource" | awk -F ":" '{print $1}')
                value=$(echo "$resource" | awk -F ":" '{print $2}')
                name_exist=$(grep -F "$resource" "$current_resource")
                # echo "name exist?: "$name_exist
                if [[ -v db["$key"] && -z "${name_exist}" ]]
                then
                    echo "Activating resource $resource"
                    echo $resource >> $current_resource
                fi
            elif [[ -v db["$resource"] && -z "${resource_duplicates}" ]]
            then
                echo "Activating resource $resource"
                echo $resource >> $current_resource

            elif [[ -n "${resource_duplicates}" ]]
            then
                echo "Resource ${resource} already activated. skipping."

            else
                echo "Resource ${resource} could no be found. skipping."
            fi
        done
        unset IFS
    fi

    exit 0
fi
exit 1