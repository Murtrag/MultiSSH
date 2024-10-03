#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../../_utils/_db_op.sh"
. "${SCRIPT_DIR}/_help.sh"
. "${SCRIPT_DIR}/_utils.sh"
readonly active_resources="$(cat /tmp/multissh/active_resources.tmp)"
readonly COMMAND=$1 

if [[ "$COMMAND" =~ ^(!execute|!e) ]]
then
    readonly args=`echo "$COMMAND" | awk '{$1=""; print $0}' | xargs`
    # Check if user asks for help
    if [[ "${args}" = "?" ]]
    then
        usage
        exit 0
    fi
    declare -A db
    parse_db "${SCRIPT_DIR}/../../_db/"

    formated_active_resources=$(echo "${active_resources}" | tr '\n' ',')

    execute_on_group $formated_active_resources execute_command
    exit 0
fi
exit 1
