#!/bin/bash
function ssh_password(){
    if [[ -z ${DEFAULT_PASSWORD} ]]
    then
        echo ""
        exit 0
    fi
    echo "sshpass -p '$DEFAULT_PASSWORD' "
    exit 0
}

function start_tmux_ssh_session(){
    # Stargs session tmux session
    # usage: start_tmux_ssh_session <ip> <port> <group_name> <name> <user>
    # input: <ip> <port> <group_name> <name> <user>
    # output: exit 0 or 1
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    (tmux new-session -d -s "${group_name}-${name}" \
    "$(ssh_password)ssh \
    ${DEFAULT_IDENTITY} \
    ${DEFAULT_EXTRA} \
     ${user}@${ip} \
    -p ${port}") &>/dev/null
}

function kill_tmux_ssh_sessioin(){
    # Kills existing tmux session
    # usage: kill_tmux_ssh_session <group_name> <name>
    # input: <group_name> <name>
    # output: exit 0 or 1
    local group_name=$1
    local name=$2
    (tmux kill-session -t "${group_name}-${name}") &>/dev/null
}

function check_tmux_ssh_session(){
    # Verifys if tmux session is opened with specified host
    # usage: check_tmux_ssh_session <group_name> <name>
    # input: <group_name> <name>
    # output: <"linked" || "unlinked">
    if tmux ls | grep -q "${group_name}-${name}"
    then
        echo "linked"
    else
        echo "unlinked"
    fi
}

function execute_tmux_ssh_command(){
    # Executes give command in existing tmux session
    # usage: kill_tmux_ssh_session <group_name> <name> <command>
    # input: <group_name> <name> <command>
    # output: <tmux command output>
    local group_name=$1
    local name=$2
    local command=$3
    local signal_done='678e5e019a79526d0fcca5e29f6e5f78'

    local before=$(tmux capture-pane -p -S '-' -J -t "${group_name}-${name}")
    tmux send-keys -t "${group_name}-${name}" "$command ;touch /tmp/$signal_done" C-m


    (tmux new-session -d -s "${group_name}-${name}" \
    "$(ssh_password)ssh \
    ${DEFAULT_IDENTITY} \
    ${DEFAULT_EXTRA} \
     ${user}@${ip} \
    -p ${port}") &>/dev/null
    
    # Wait for signal done
    while true; do
        sleep 0.5s
        if ssh -i /home/vagrant/.ssh/my_vagrant_key \
            -o StrictHostKeyChecking=no \
            ${user}@${ip} \
            -p ${port} \
            "[ -f /tmp/$signal_done ] && rm /tmp/$signal_done"; then
            # sleep 0.5s
            local after=$(tmux capture-pane -p -S '-' -J -t "${group_name}-${name}")
            break
        else
            continue
        fi
    done

    diff <(echo "$before") <(echo "$after") | grep ">" | grep -v "$signal_done" | sed 's/> /\t/g'
}