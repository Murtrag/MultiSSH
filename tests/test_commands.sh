#!/bin/bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
# set -eu
set +e

test_clear(){
    # echo "${SCRIPT_DIR}/../_cmd/_clear/_main.sh" 'clear'

    # @TODO need to change clear command behaviour for testing purposes

    bash "${SCRIPT_DIR}/../_cmd/_clear/_main.sh" 'clear'
    command_output=$?

    expected_output="0"
    # echo "Return of clear cmd should match" "${expected_output}" "${command_output}"
    assertEquals "Return of clear cmd should match" "${expected_output}" "${command_output}"

    bash "${SCRIPT_DIR}/../_cmd/_clear/_main.sh" 'xyz'
    command_output=$?
    expected_output="1"

    # echo "Return of clear cmd should match" "${expected_output}" "${command_output}"
    assertEquals "Return of clear cmd should match" "${expected_output}" "${command_output}"
}

test_help(){
    # !h 
    # !help
    # !h activate
    set +e
    command_output_1=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!help')
    command_exit_1=$?

    command_output_2=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!h')
    command_exit_2=$?

    command_output_3=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" 'xyzabc')
    command_exit_3=$?

    command_output_4=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!help clear')
    command_exit_4=$?

    command_output_5=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!help xyzabc')
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
    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!help clear')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_clear/_main.sh" 'clear ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"
    
    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!help !activate')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" '!a ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!help !deactivate')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" '!da ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!help exit')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_exit/_main.sh" 'exit ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!help !group')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_group/_main.sh" '!group ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"

    help_output=$(bash "${SCRIPT_DIR}/../_cmd/_help/_main.sh" '!help !groups')
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_groups/_main.sh" '!groups ?')
    assertEquals "Content of help should match" "${command_output}" "${help_output}"


}

test_activate(){
    # Test group activation
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da"

    # !a group1
    expected_output="group1"
    bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" "!a group1" 2>/dev/null
    command_output=$(grep "${expected_output}" /tmp/multissh/active_resources.tmp) 
    assertEquals "Test activate one group (!a group1):\n" "${expected_output}" "${command_output}"
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da"

    # Test blade activation
    # !a group1:blade1
    expected_output="group1:blade1"
    bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" "!a group1:blade1" 2>/dev/null
    command_output=$(grep "${expected_output}" /tmp/multissh/active_resources.tmp) 
    assertEquals "Test activate one node (!a group1:blade1):\n" "${expected_output}" "${command_output}"
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da"

    # Test list of  resources activation
    # !a group1,group2,group3:blade4
    expected_output="group1:blade1
group2
group1:blade2"
    bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" "!a group1:blade1,group2,group1:blade2"
    command_output=$(cat /tmp/multissh/active_resources.tmp) 
    # diff <(echo "$expected_output") <(echo "$command_output")

    assertEquals "Test activate group and blades(!a group1:blade1,group2,group1:blade2):\n" "${expected_output}" "${command_output}"
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da"

    # Test bad resource activation

    expected_output=""
    bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" "!a xyz1:a1,xyy1,xyx:b2"
    command_output=$(cat /tmp/multissh/active_resources.tmp) 
    assertEquals "Test activate unexisting resources(!a xyz1:a1,xyy1,xyx:b2):" "${expected_output}" "${command_output}"
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da"
}

test_deactivate(){
    # Test all deactivation
    # !da
    bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" "!a group1,group2" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da"
    expected_result=""
    actual_result=$(cat /tmp/multissh/active_resources.tmp) 
    assertEquals "Test deactivate all(!da):\n" "${expected_output}" "${command_output}"

    # Test group deactivation
    # !da group1
    bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" "!a group1,group2" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da group2"
    expected_result="group1"
    actual_result=$(cat /tmp/multissh/active_resources.tmp) 
    assertEquals "Test deactivate group(!da group2):\n" "${expected_output}" "${command_output}"

    # Test blade deactivation
    # !da group1:blade1
    bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" "!a group1,group2:blade1" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da group2:blade1"
    expected_result="group1"
    actual_result=$(cat /tmp/multissh/active_resources.tmp) 
    assertEquals "Test deactivate group(!da group2:blade1):\n" "${expected_output}" "${command_output}"

    # Test list of  resources deactivation
    # !da group1,group2
    bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" "!a group1,group2:blade1" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da group1,group2"
    expected_result=""
    actual_result=$(cat /tmp/multissh/active_resources.tmp) 
    assertEquals "Test deactivate group(!da group1,group2):\n" "${expected_output}" "${command_output}"

    # Test bad resource deactivation
    bash "${SCRIPT_DIR}/../_cmd/_activate/_main.sh" "!a group1,group2:blade1" &>/dev/null
    bash "${SCRIPT_DIR}/../_cmd/_deactivate/_main.sh" "!da xyz,zzz,bbb:a1"
    expected_result="group1
    group2:blade1"
    actual_result=$(cat /tmp/multissh/active_resources.tmp) 
    assertEquals "Test deactivate group(!da group1,group2):\n" "${expected_output}" "${command_output}"
}


test_exit(){
    # set +e
    sleep 1h &
    pid=$!
    expected_process_status="killed"
    echo "Y" | bash "${SCRIPT_DIR}/../_cmd/_exit/_main.sh" "exit" ${pid}

    if kill -0 $pid 2>/dev/null; then
        process_status="alive"
    else
        process_status="killed"
    fi

    # Test exit
    assertEquals "Content of group2 should match" "${expected_process_status}" "${process_status}"
}

# test_group(){
#     expected_output=""
#     command_output=""

#     # Test output for existing group

#     # Test output for nonexisting group
#     assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
# }

# test_groups(){
#     expected_output=""
#     command_output=""
#     # Test output

#     # Test output with bad param
#     assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
# }


# test_status(){
#     expected_output=""
#     command_output=""
#     # Test output

#     # Test output with bad param
#     assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
# }

test_unknown(){
    # Test output
    expected_output='test command not recognized'
    command_output=$(bash "${SCRIPT_DIR}/../_cmd/_unknown.sh" 'test')

    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

. /usr/bin/shunit2
