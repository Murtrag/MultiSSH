#!/bin/bash
source /vagrant/_utils/_db_op.sh

set -eu


test_update_db(){
  test_raw_data="test_db/new_data.txt"
  update_db '/vagrant/tests/test_db' '/vagrant/tests/test_db/new_data.txt'
  declare -A db
  parse_db "$(dirname $0)/test_db"

    local expected_group1="127.0.5.1 (blade1)
127.0.5.2 (blade2)
127.0.5.3 (blade3)"
    local expected_group2="127.0.6.1 (blade1)
127.0.6.2 (blade2)
127.0.6.3 (blade3)"

  # Test group1
  assertEquals "Content of group1 should match" "$expected_group1" "${db["test1"]}"
  # Test group2
  assertEquals "Content of group2 should match" "$expected_group2" "${db["test2"]}"

  # Clean DB
  update_db '/vagrant/tests/test_db' '/vagrant/tests/test_db/recovery.txt'
}

test_parse_db() {
    declare -A db
    parse_db "$(dirname $0)/test_db"

    local expected_group1="127.0.0.1 (blade1)
127.0.0.2 (blade2)
127.0.0.3 (blade3)"
    local expected_group2="127.0.1.1 (blade1)
127.0.1.2 (blade2)
127.0.1.3 (blade3)"
    # Test group1
    assertEquals "Content of group1 should match" "$expected_group1" "${db["group1"]}"
    # Test group2
    assertEquals "Content of group2 should match" "$expected_group2" "${db["group2"]}"
}

test_get_record() {
    declare -A db
    parse_db "$(dirname $0)/test_db"

    ip1=$(get_record "group1" 0)
    expected_ip1='127.0.0.1 (blade1)'
    assertEquals "Conente of ip1 should match" "${expected_ip1}" "${ip1}"

    ip2=$(get_record "group2" 1)
    expected_ip2='127.0.1.2 (blade2)'
    assertEquals "Conente of ip2 should match" "${expected_ip2}" "${ip2}"
}

test_get_record_by_name() {
    declare -A db
    parse_db "$(dirname $0)/test_db"

    ip1=$(get_record_by_name "group1" "blade1")
    expected_ip1='127.0.0.1 (blade1)'
    assertEquals "Conente of ip1 should match" "${expected_ip1}" "${ip1}"

    ip2=$(get_record_by_name "group2" "blade2")
    expected_ip2='127.0.1.2 (blade2)'
    assertEquals "Conente of ip2 should match" "${expected_ip2}" "${ip2}"
}


. /usr/bin/shunit2