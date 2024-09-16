#!/bin/bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
set -eu

# test_clear(){
#     bash "${SCRIPT_DIR}/../_cmd/_clear.sh" clear
#     echo "SCRIPT_DIR: ${SCRIPT_DIR}"

#     command_output=$?
#     expected_output="1"
#     assertEquals "Return of clear cmd should match" "${expected_output}" "${command_output}"

#     bash "${SCRIPT_DIR}/../_cmd/_clear.sh" xyz
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
    command_output_1=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!help')
    command_exit_1=$?

    command_output_2=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!h')
    command_exit_2=$?

    command_output_3=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" 'xyzabc')
    command_exit_3=$?

    command_output_4=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!help clear')
    command_exit_4=$?

    command_output_5=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!help xyzabc')
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
    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!help clear')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_clear.sh" 'clear ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"
    
    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!help !activate')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_activate.sh" '!a ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!help !deactivate')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" '!da ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!help exit')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_exit.sh" 'exit ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!help !group')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_group.sh" '!group ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help.sh" '!help !groups')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_groups.sh" '!groups ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"


}

test_activate(){
    # Test group activation
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da"

    # !a group1
    expected_output="group1"
    bash "${SCRIPT_DIR}/../_cmd/_activate.sh" "!a group1" 2>/dev/null
    command_output=$(grep "${expected_output}" ${SCRIPT_DIR}/../_db/.current_resource) 
    assertEquals "Test activate one group (!a group1):\n" "${expected_output}" "${command_output}"
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da"

    # Test blade activation
    # !a group1:blade1
    expected_output="group1:blade1"
    bash "${SCRIPT_DIR}/../_cmd/_activate.sh" "!a group1:blade1" 2>/dev/null
    command_output=$(grep "${expected_output}" ${SCRIPT_DIR}/../_db/.current_resource) 
    assertEquals "Test activate one node (!a group1:blade1):\n" "${expected_output}" "${command_output}"
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da"

    # Test list of  resources activation
    # !a group1,group2,group3:blade4
    expected_output="group1:blade1
group2
group1:blade2"
    bash "${SCRIPT_DIR}/../_cmd/_activate.sh" "!a group1:blade1,group2,group1:blade2"
    command_output=$(cat ${SCRIPT_DIR}/../_db/.current_resource) 
    # diff <(echo "$expected_output") <(echo "$command_output")

    assertEquals "Test activate group and blades(!a group1:blade1,group2,group1:blade2):\n" "${expected_output}" "${command_output}"
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da"

    # Test bad resource activation

    expected_output=""
    bash "${SCRIPT_DIR}/../_cmd/_activate.sh" "!a xyz1:a1,xyy1,xyx:b2"
    command_output=$(cat ${SCRIPT_DIR}/../_db/.current_resource) 
    assertEquals "Test activate unexisting resources(!a xyz1:a1,xyy1,xyx:b2):" "${expected_output}" "${command_output}"
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da"
}

test_deactivate(){
    # Test all deactivation
    # !da
    bash "${SCRIPT_DIR}/../_cmd/_activate.sh" "!a group1,group2" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da"
    expected_result=""
    actual_result=$(cat ${SCRIPT_DIR}/../_db/.current_resource) 
    assertEquals "Test deactivate all(!da):\n" "${expected_output}" "${command_output}"

    # Test group deactivation
    # !da group1
    bash "${SCRIPT_DIR}/../_cmd/_activate.sh" "!a group1,group2" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da group2"
    expected_result="group1"
    actual_result=$(cat  ${SCRIPT_DIR}/../_db/.current_resource) 
    assertEquals "Test deactivate group(!da group2):\n" "${expected_output}" "${command_output}"

    # Test blade deactivation
    # !da group1:blade1
    bash "${SCRIPT_DIR}/../_cmd/_activate.sh" "!a group1,group2:blade1" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da group2:blade1"
    expected_result="group1"
    actual_result=$(cat  ${SCRIPT_DIR}/../_db/.current_resource) 
    assertEquals "Test deactivate group(!da group2:blade1):\n" "${expected_output}" "${command_output}"

    # Test list of  resources deactivation
    # !da group1,group2
    bash "${SCRIPT_DIR}/../_cmd/_activate.sh" "!a group1,group2:blade1" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da group1,group2"
    expected_result=""
    actual_result=$(cat  ${SCRIPT_DIR}/../_db/.current_resource) 
    assertEquals "Test deactivate group(!da group1,group2):\n" "${expected_output}" "${command_output}"

    # Test bad resource deactivation
    bash "${SCRIPT_DIR}/../_cmd/_activate.sh" "!a group1,group2:blade1" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate.sh" "!da xyz,zzz,bbb:a1"
    expected_result="group1
    group2:blade1"
    actual_result=$(cat  ${SCRIPT_DIR}/../_db/.current_resource) 
    assertEquals "Test deactivate group(!da group1,group2):\n" "${expected_output}" "${command_output}"
}


test_exit(){
    # set +e
    sleep 1h &
    pid=$!
    expected_process_status="killed"
    echo "Y" | bash "${SCRIPT_DIR}/../_cmd/_exit.sh" "exit" ${pid}

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
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_unknown.sh" 'test')

    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

. /usr/bin/shunit2
