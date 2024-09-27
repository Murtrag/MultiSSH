#!/bin/bash
# readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../../_utils/_tmux_op.sh"

function check_status(){
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    local linked

    local linked=$(check_tmux_ssh_session $group_name $name)
    nc -zv -w 5 "$ip" "$port" &> /dev/null 
    if [[ $? -eq 0 ]]; then
        status="open/${linked}"
    elif [[ $? -eq 1 ]]; then
        status="closed/${linked}"
    else
        status="timeout/${linked}"
    fi
    table_value+="$group_name|$name|$ip|$port|$status\n"
}