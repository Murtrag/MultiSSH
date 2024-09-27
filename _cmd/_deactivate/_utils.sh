#!/bin/bash
. "${SCRIPT_DIR}/../../_utils/_tmux_op.sh"

function close_session(){
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    kill_tmux_ssh_sessioin "${group_name}" "${name}"
}