#!/bin/bash
source /vagrant/_utils/_tmux_op.sh

set -eu

test_ssh_password() {
    export DEFAULT_PASSWORD="testpassword"
    local result=$(ssh_password)
    local expected="sshpass -p 'testpassword' "
    assertEquals "ssh_password should return the correct sshpass command" "$expected" "$result"
}

test_generate_ssh_command() {
    export DEFAULT_IDENTITY="-i /path/to/identity"
    export DEFAULT_EXTRA="-o StrictHostKeyChecking=no"
    local result=$(generate_ssh_command "user" "192.168.1.1" "22")
    local expected="sshpass -p 'testpassword' ssh -i /path/to/identity -o StrictHostKeyChecking=no user@192.168.1.1 -p 22"
    assertEquals "generate_ssh_command should return the correct SSH command" "$expected" "$result"
}

test_start_tmux_ssh_session() {
    start_tmux_ssh_session "192.168.1.1" "22" "testgroup" "testname" "user"
    tmux has-session -t "testgroup-testname" 2>/dev/null
    assertEquals "tmux session should be started" 0 $?
    kill_tmux_ssh_session "testgroup" "testname"
}

test_kill_tmux_ssh_session() {
    start_tmux_ssh_session "192.168.1.1" "22" "testgroup" "testname" "user"
    kill_tmux_ssh_session "testgroup" "testname"
    tmux has-session -t "testgroup-testname" 2>/dev/null
    assertNotEquals "tmux session should be killed" 0 $?
}

test_check_tmux_ssh_session() {
    start_tmux_ssh_session "192.168.1.1" "22" "testgroup" "testname" "user"
    local result=$(check_tmux_ssh_session "testgroup" "testname")
    assertEquals "check_tmux_ssh_session should return 'linked'" "linked" "$result"
    kill_tmux_ssh_session "testgroup" "testname"
}

. /usr/bin/shunit2
