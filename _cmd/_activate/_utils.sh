#!/bin/bash

. "${SCRIPT_DIR}/../../_utils/_tmux_op.sh"

function activate(){
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5

    start_tmux_ssh_session "$@"

    resource_duplicates=$(grep -F "$resource" "$active_resources_path")
    if [[ -z "${resource_duplicates}" ]]
    then
        # Add to activated
        echo $resource >> $active_resources_path
    fi
}