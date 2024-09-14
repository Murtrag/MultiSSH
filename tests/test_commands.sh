#!/bin/bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
set -eu

# test_clear(){
#     bash "${SCRIPT_DIR}/../commands/_clear.sh" clear
#     echo "SCRIPT_DIR: ${SCRIPT_DIR}"

#     command_output=$?
#     expected_output="1"
#     assertEquals "Return of clear cmd should match" "${expected_output}" "${command_output}"

#     bash "${SCRIPT_DIR}/../commands/_clear.sh" xyz
#     echo "SCRIPT_DIR: ${SCRIPT_DIR}"

#     command_output=$?
#     expected_output="0"
#     assertEquals "Return of clear cmd should match" "${expected_output}" "${command_output}"
# }

test_help(){
    # !h 
    # !help
    # !h activate
    set +e
    command_output_1=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!help')
    command_exit_1=$?

    command_output_2=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!h')
    command_exit_2=$?

    command_output_3=$(bash "${SCRIPT_DIR}/../commands/_help.sh" 'xyzabc')
    command_exit_3=$?

    command_output_4=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!help clear')
    command_exit_4=$?

    command_output_5=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!help xyzabc')
    command_exit_5=$?

    # Check exit codes
    expected_match="0"
    expected_skip="1"
    assertEquals "Content of help should match" "${expected_match}" "${command_exit_1}"
    assertEquals "Content of help should match" "${expected_match}" "${command_exit_2}"
    assertEquals "Content of help should match" "${expected_skip}" "${command_exit_3}"
    assertEquals "Content of help should match" "${expected_match}" "${command_exit_4}"
    assertEquals "Content of help should match" "${expected_match}" "${command_exit_5}"

    # Check output for a solo command output
    expected_output="1"
    expected_mute="0"

    command_output_code_1=$([[ "$command_output_1" != "" ]] && echo "1" || echo "0")
    assertEquals "Content of help should match" "${expected_output}" "$command_output_code_1"

    command_output_code_2=$([[ "$command_output_2" != "" ]] && echo "1" || echo "0")
    assertEquals "Content of help should match" "${expected_output}" "$command_output_code_2"

    command_output_code_3=$([[ "$command_output_3" != "" ]] && echo "1" || echo "0")
    assertEquals "Content of help should match" "${expected_mute}" "$command_output_code_3"

    command_output_code_4=$([[ "$command_output_4" != "" ]] && echo "1" || echo "0")
    assertEquals "Content of help should match" "${expected_output}" "$command_output_code_4"

    command_output_code_5=$([[ "$command_output_5" != "" ]] && echo "1" || echo "0")
    assertEquals "Content of help should match" "${expected_output}" "$command_output_code_5"





    # Check if returns correctly for parameter
    help_output=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!help clear')
    command_output=$(bash "${SCRIPT_DIR}/../commands/_clear.sh" 'clear ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"
    
    help_output=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!help !activate')
    command_output=$(bash "${SCRIPT_DIR}/../commands/_activate.sh" '!a ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!help !deactivate')
    command_output=$(bash "${SCRIPT_DIR}/../commands/_deactivate.sh" '!da ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!help exit')
    command_output=$(bash "${SCRIPT_DIR}/../commands/_exit.sh" 'exit ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!help !group')
    command_output=$(bash "${SCRIPT_DIR}/../commands/_group.sh" '!group ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../commands/_help.sh" '!help !groups')
    command_output=$(bash "${SCRIPT_DIR}/../commands/_groups.sh" '!groups ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"


}

test_activate(){
    expected_output=""
    command_output=""
    # Test group activation
    # !a group1

    # Test blade activation
    # !a group1:blade1

    # Test list of  resources activation
    # !a group1,group2,group3:blade4

    # Test bad resource activation
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_deactivate(){
    expected_output=""
    command_output=""
    # Test all deactivation

    # Test group deactivation
    # !a group1

    # Test blade deactivation
    # !a group1:blade1

    # Test list of  resources deactivation
    # !a group1,group2,group3:blade4

    # Test bad resource deactivation
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}


test_exit(){
    # set +e
    sleep 1h &
    pid=$!
    expected_process_status="killed"
    echo "Y" | bash "${SCRIPT_DIR}/../commands/_exit.sh" "exit" ${pid}

    if kill -0 $pid 2>/dev/null; then
        process_status="alive"
    else
        process_status="killed"
    fi

    # Test exit
    assertEquals "Content of group2 should match" "${expected_process_status}" "${process_status}"
}

test_group(){
    expected_output=""
    command_output=""

    # Test output for existing group

    # Test output for nonexisting group
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_groups(){
    expected_output=""
    command_output=""
    # Test output

    # Test output with bad param
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}


test_status(){
    expected_output=""
    command_output=""
    # Test output

    # Test output with bad param
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_unknown(){
    # Test output
    expected_output='test command not recognized'
    command_output=$(bash "${SCRIPT_DIR}/../commands/_unknown.sh" 'test')

    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

. /usr/bin/shunit2