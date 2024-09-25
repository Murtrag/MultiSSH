#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../_utils/_db_op.sh"
readonly current_resource="$(cat ${SCRIPT_DIR}/../_db/.current_resource)"

readonly COMMAND=$1 

    function ussage(){
        echo "Explenation how you use this async coomand"
    }

function execute_command_async() {
    echo
    execute_command "$@" &
}

function execute_command() {
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    local command=$args
    local signal_done='678e5e019a79526d0fcca5e29f6e5f78'

    # Dump terminal before
    local before=$(tmux capture-pane -p -S '-' -J -t "${group_name}-${name}")
    # Execute command
    tmux send-keys -t "${group_name}-${name}" "$command ;touch /tmp/$signal_done" C-m

    # Wait for signal done
    while true; do
        sleep 0.5s
        if ssh -i /home/vagrant/.ssh/my_vagrant_key \
            -o StrictHostKeyChecking=no \
            ${user}@${ip} \
            -p ${port} \
            "[ -f /tmp/$signal_done ] && rm /tmp/$signal_done"; then
            local after=$(tmux capture-pane -p -S '-' -J -t "${group_name}-${name}")
            break
        else
            continue
        fi
    done

    # Display the difference with the command output
    # echo "${name}($ip):"
    echo
    echo -e "\033[0;32m${name}\033[0m(\033[0;31m${ip}\033[0m):"
    diff <(echo "$before") <(echo "$after") | grep ">" | grep -v "$signal_done" | sed 's/> //g'
    echo
}


    if [[ "$COMMAND" =~ ^(!execute-async|!ea) ]]
    then
        readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
        # Check if user asks for help
        if [[ "${args}" = "?" ]]
        then
            ussage
            exit 0
        fi
        declare -A db
        parse_db "${SCRIPT_DIR}/../_db/"


        # Iterate all active resources
        current_resource2=$(echo "${current_resource}" | tr '\n' ',')

        execute_on_group $current_resource2 execute_command_async
        exit 0
    fi
    exit 1
