#!/bin/bash

function ssh_password(){
    # Adds sshpass string to ssh command
    # input: none
    # output: <str:sshpass_cmd>
    # return: <int:0||1>

    if [[ -z ${DEFAULT_PASSWORD} ]]
    then
        echo ""
        return 0
    fi
    echo "sshpass -p '$DEFAULT_PASSWORD' "
    return 0
}

function generate_ssh_command(){
    # Generates the SSH command string
    # input: <str:user> <str:ip> <str:port>
    # output: <str:ssh_command>
    # return: <int:0||1>
    local user=$1
    local ip=$2
    local port=$3
    echo "$(ssh_password)ssh ${DEFAULT_IDENTITY} ${DEFAULT_EXTRA} ${user}@${ip} -p ${port}"
    return 0
}

function start_tmux_ssh_session(){
    # Starts session tmux session
    # input: <str:ip> <str:port> <str:group_name> <str:name> <str:user>
    # output: none
    # return: <int:0||1>
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    (tmux new-session -d -s "${group_name}-${name}" \
    "$(generate_ssh_command ${user} ${ip} ${port})") &>/dev/null

    # Check the output code
    sleep 0.1
    check_tmux_ssh_session $group_name $name &>/dev/null # Returns 0 or 1
    return $?
}

function kill_tmux_ssh_sessioin(){
    # Kills existing tmux session
    # input: <str:group_name> <str:name>
    # output: none
    # return: <int:0||1>
    local group_name=$1
    local name=$2
    (tmux kill-session -t "${group_name}-${name}") &>/dev/null
    return $?
}

function check_tmux_ssh_session(){
    # Verifys if tmux session is opened with specified host
    # input: <str:group_name> <str:name>
    # output: <str:"linked"||"unlinked">
    # return: <int:0||1>
    if tmux ls | grep -q "${group_name}-${name}"
    then
        echo "linked"
        return 0
    else
        echo "unlinked"
        return 1
    fi
}

function execute_tmux_ssh_command(){
    # Executes give command in existing tmux session
    # input: <str:group_name> <str:name> <str:command>
    # output: <str:tmux_command_output>
    # return: none 
    # @TODO exit should return <int:0||1>
    local group_name=$1
    local name=$2
    local command=$3
    local signal_done='678e5e019a79526d0fcca5e29f6e5f78'

    local before=$(tmux capture-pane -p -S '-' -J -t "${group_name}-${name}")
    tmux send-keys -t "${group_name}-${name}" "$command ;echo $? > /tmp/$signal_done" C-m

    # Wait for signal done
    while true; do
        sleep 0.5s
        ssh_cmd="$(generate_ssh_command ${user} ${ip} ${port})"
        if eval "$ssh_cmd [ -f /tmp/$signal_done ]"
        then
            # exit_code=$(eval "$ssh_cmd cat /tmp/$signal_done")
            eval "$ssh_cmd rm /tmp/$signal_done"
            local after=$(tmux capture-pane -p -S '-' -J -t "${group_name}-${name}")
            break
        else
            continue
        fi
    done

    # echo "$exit_code"
    diff <(echo "$before") <(echo "$after") | grep ">" | grep -v "$signal_done" | sed 's/> /\t/g'
}
