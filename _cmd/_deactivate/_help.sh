#!/bin/bash

function usage() {
    echo "Usage: !deactivate [RESOURCE] or !da [RESOURCE]"
    echo "Deactivate the specified resources (group or server)."
    echo ""
    echo "Examples:"
    echo "  !deactivate"
    echo "  !da"
    echo "  !deactivate group1"
    echo "  !deactivate group1,group2"
    echo "  !deactivate group1:server1"
}

