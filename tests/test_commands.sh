#!/bin/bash
set -eu

test_activate(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_deactivate(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_clear(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_exit(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_group(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_groups(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_help(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_status(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_status(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

test_unknown(){
    expected_output=""
    command_output=""
    assertEquals "Content of group2 should match" "${expected_output}" "${command_output}"
}

. /usr/bin/shunit2