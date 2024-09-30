#!/bin/bash
# DB operations
# SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
if [[ -z "${SCRIPT_DIR:-}" ]]; then
    SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
    readonly SCRIPT_DIR
fi

. "/home/$USER/.config/multissh/global.sh"

declare -A db

function parse_db(){
    # Parse DB from specified directory
    # Usage: declare -A db; parse_db '/path/to/db'
    # input: <dir>
    # output: <array> or exit 1
    db_dir="${1}"

    if [ ! -d "$db_dir" ]; then
        echo "Directory $db_dir does not exist." >&2
        exit 1
    fi


    for file in "${db_dir}"/*.list; do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .list)
            content=$(<"$file")
            db["$filename"]="$content"
        else
            echo "No files found in $db_dir" >&2
            exit 1
        fi
    done

    # for key in "${!db[@]}"; do
    #     echo "$key=${db[$key]}"
    # done
}

function get_record() {
    # Get record from db
    # ussage: # get_record "group1" 1
    # input: <str> <int>
    # output: <str> or exit 1
    local group_name=$1
    local index=$2

    local content="${db[$group_name]}"

    if [ -z "$content" ]; then
        echo "No data for group: $group_name" >&2
        exit 1
    fi

    IFS=$'\n' read -r -d '' -a ip_array <<< "$content"

    if [[ $index -lt ${#ip_array[@]} ]]; then
        echo "${ip_array[$index]}"
        exit 0
    else
        echo "Index out of range" >&2
        exit 1
    fi
}

function get_record_by_name() {
    # Get record by name from db
    # usage: get_record_by_name "group1" "name1"
    # input: <str> <str>
    # output: <str> or exit 1
    local group_name=$1
    local search_name=$2

    local content="${db[$group_name]}"

    if [ -z "$content" ]; then
        echo "No data for group: $group_name" >&2
        exit 1
    fi

    IFS=$'\n' read -r -d '' -a ip_array <<< "$content"

    # Search for the IP based on the given name
    for line in "${ip_array[@]}";
    do
        name=$(echo "$line" | awk -F '[()]' '{print $2}')  # Extract the name part (inside parentheses)

        if [[ "${name}" == "${search_name}" ]]; then
            echo "${line}"
            exit 0
        fi
    done

    echo "No IP found for name: $search_name" >&2
    exit 1
}

function update_db(){
    # Takes raw file with data and overwrites database with new groups
    # usage: update_db _db/ raw_data.txt
    # input: <string> <string>
    # output: exit 0 or 1
    db_dir="${1}"
    raw_file="${2}"

    rm -f "${db_dir}"/*.list
    awk -v RS= '{print > ("'"${db_dir}"'/group" NR ".list")}' "${raw_file}"

    for file in "${db_dir}"/*.list;
    do
        new_filename="$(head -1 "${file}" | cut -c2-).list"
        new_content=$(tail -n +2 "${file}")
        rm "${file}"
        echo "${new_content}" > "${db_dir}/${new_filename}"
    done
}

function execute_on_group(){
    # HoF to perform func on the selected group
    # usage: execute_on_group func_name
    # input: <group_name> <function <ip> <port> <group_name> <name>>
    # output: exit 0 or 1
    local group_name=$1 # Coma separated values
    local func=$2
    local db_path=${3:-"${SCRIPT_DIR}/../../_db"}
    parse_db "$db_path"

    function pass_to_func(){
            local group=$1
            local node=$2

            host_and_port=$(echo "$node" | awk -F '[()]' '{print $1}' | xargs)
            login_host=$(echo "${host_and_port}" | awk -F ':' '{print $1}')
            if [[ "$login_host" == *@* ]]; then
                user=$(echo "${login_host}" | awk -F '@' '{print $1}')
                ip=$(echo "${login_host}" | awk -F '@' '{print $2}')
            else
                user=$DEFAULT_USER
                ip="$login_host"
            fi
            port=$(echo "${host_and_port}" | awk -F ':' '{print $2}')
            port=${port:-$DEFAULT_PORT}
            name=$(echo "$node" | awk -F '[()]' '{print $2}')
            $func "$ip" "$port" "$group" "$name" "$user"
    }


    IFS=',' read -r -a group_names <<< "$group_name" 

    for resource in "${group_names[@]}"
    do
        # Check if resource follows <group>:<name>
        if [[ "${resource}" =~ .+:.+ ]]; then
            local node_group="$(echo ${resource} | awk -F ':' '{print $1}')"
            local node_name="$(echo ${resource} | awk -F ':' '{print $2}')"
            local node
            node=$(get_record_by_name "${node_group}" "${node_name}")
            if [[ "$?" -ne 1 ]]
            then
                pass_to_func "${node_group}" "${node}"
            fi
        else
            IFS=$'\n'
            for node in ${db[$resource]}
            do
                pass_to_func "${resource}" "${node}" 
            done
        fi
    done

    unset IFS

}
