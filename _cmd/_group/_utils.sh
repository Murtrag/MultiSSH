#!/bin/bash

function check_group(){
    local ip=$1
    local port=$2
    local group_name=$3
    local name=$4
    local user=$5
    table_value+="$group_name|$name|$ip|$port\n"
}