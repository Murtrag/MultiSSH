#!/bin/bash

function usage() {
    echo "Usage: !activate [RESOURCE] or !a [RESOURCE]"
    echo "Activate the specified resources (group or a single serwer)."
    echo ""
    echo "Examples:"
    echo "  !a group1"
    echo "  !activate group2"
    echo "  !a group1,group2,group3"
    echo "  !a group1:blade1"
}