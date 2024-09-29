#!/bin/bash

function usage() {
    echo "Usage: !g [GROUP_NAME] or !group [GROUP_NAME]"
    echo "Display available servers in the specified group."
    echo ""
    echo "If no group name is provided, it will display servers for the active group."
    echo ""
    echo "Examples:"
    echo "  !g"
    echo "  !g group_name"
    echo "  !group group_name"
}
