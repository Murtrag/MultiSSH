#!/bin/bash

. "${SCRIPT_DIR}/../../_utils/_tmux_op.sh"

function activate(){
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5

    start_tmux_ssh_session "$@"

    resource_duplicates=$(grep -F "$resource" "$current_resource")
    if [[ -z "${resource_duplicates}" ]]
    then
        # GROUP BLOCK
        echo $resource >> $current_resource
    fi
}