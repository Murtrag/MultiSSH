#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

. "${SCRIPT_DIR}/../../_utils/_db_op.sh"
. "${SCRIPT_DIR}/_help.sh"
. "${SCRIPT_DIR}/_utils.sh"
readonly current_resource="$(cat ${SCRIPT_DIR}/../../_db/.current_resource)"

readonly COMMAND=$1 

if [[ "$COMMAND" =~ ^(!execute-async|!ea) ]]
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


    # Iterate all active resources
    current_resource2=$(echo "${current_resource}" | tr '\n' ',')

    execute_on_group $current_resource2 execute_command_async
    exit 0
fi
exit 1
