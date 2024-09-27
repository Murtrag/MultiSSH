#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

readonly COMMAND=$1 


# CoR
if ! bash "${SCRIPT_DIR}/_status/_main.sh" "${COMMAND}"
then
    if ! bash "${SCRIPT_DIR}/_groups/_main.sh" "${COMMAND}"
    then
        if ! bash "${SCRIPT_DIR}/_group/_main.sh" "${COMMAND}"
        then
            if ! bash "${SCRIPT_DIR}/_activate/_main.sh" "${COMMAND}"
            then
                if ! bash "${SCRIPT_DIR}/_deactivate/_main.sh" "${COMMAND}"
                then
                    if ! bash "${SCRIPT_DIR}/_help/_main.sh" "${COMMAND}"
                    then
                        if ! bash "${SCRIPT_DIR}/_clear/_main.sh" "${COMMAND}"
                        then
                            if ! bash "${SCRIPT_DIR}/_exit/_main.sh" "${COMMAND}" $PPID
                            then
                                if ! bash "${SCRIPT_DIR}/_execute-async/_main.sh" "${COMMAND}"
                                then
                                    last_pid=$BASHPID
                                    echo $last_pid
                                    if ! bash "${SCRIPT_DIR}/_execute/_main.sh" "${COMMAND}"
                                    then
                                        bash "${SCRIPT_DIR}/_unknown.sh" "${COMMAND}"
                                    fi # execute
                                fi # execute-async
                            fi # exit
                        fi # clear
                    fi # help
                fi # deactivate
            fi # activate
        fi # group
    fi # groups
fi # status
