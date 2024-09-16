#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

readonly COMMAND=$1 


# CoR
if ! bash "${SCRIPT_DIR}/_status.sh" "${COMMAND}"
then
    if ! bash "${SCRIPT_DIR}/_groups.sh" "${COMMAND}"
    then
        if ! bash "${SCRIPT_DIR}/_group.sh" "${COMMAND}"
        then
            if ! bash "${SCRIPT_DIR}/_activate.sh" "${COMMAND}"
            then
                if ! bash "${SCRIPT_DIR}/_deactivate.sh" "${COMMAND}"
                then
                    if ! bash "${SCRIPT_DIR}/_help.sh" "${COMMAND}"
                    then
                        if ! bash "${SCRIPT_DIR}/_clear.sh" "${COMMAND}"
                        then
                            if ! bash "${SCRIPT_DIR}/_exit.sh" "${COMMAND}" $PPID
                            then
                                bash "${SCRIPT_DIR}/_unknown.sh" "${COMMAND}"
                            fi # exit
                        fi # clear
                    fi # help
                fi # deactivate
            fi # activate
        fi # group
    fi # groups
fi # status
