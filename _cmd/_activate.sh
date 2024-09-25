#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"


readonly COMMAND=$1 
readonly current_resource="${SCRIPT_DIR}/../_db/.current_resource"



function usage(){
    echo "Explenation how you use this coomand"
}

function open_session(){
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    (tmux new-session -d -s "${group_name}-${name}" \
    "ssh \
    -i /home/vagrant/.ssh/my_vagrant_key \
    -o StrictHostKeyChecking=no\
     ${user}@${ip} \
    -p ${port}") &>/dev/null
}

function activate(){
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5

    open_session "$ip" "$port" "$group_name" "$name" "$user"
    resource_duplicates=$(grep -F "$resource" "$current_resource")
    if [[ -z "${resource_duplicates}" ]]
    then
        # GROUP BLOCK
        echo $resource >> $current_resource
    fi
}

if [[ "$COMMAND" =~ ^(!activate|!a) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`

    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        usage
        exit 0
    fi
    declare -A db
    parse_db "${SCRIPT_DIR}/../_db/"

    
    # Check if group name specified

    if [[ $args = "" ]] 
    then
        echo "Please specify resource to activate"
        exit 0
    else # If param specified
        execute_on_group $args activate
    fi

    exit 0
fi
exit 1