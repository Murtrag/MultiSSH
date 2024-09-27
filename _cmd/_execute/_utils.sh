#!/bin/bash
. "${SCRIPT_DIR}/../../_utils/_tmux_op.sh"

function execute_command() {
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    local command=$args

    local command_output=$(execute_tmux_ssh_command  $group_name $name $command)
    echo -e "\033[0;32m${group_name}@${name} \033[0m(\033[0;31m${ip}\033[0m):"
    echo -e "$command_output"
    echo
}