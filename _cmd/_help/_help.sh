#!/bin/bash

function usage() {
    echo "Usage: !help or !h [COMMAND]"
    echo "Get general help or specific help for a command."
    echo ""
    echo "Examples:"
    echo "  !help"
    echo "  !help command"
    echo "  !h"
    echo "  !h command"
}

function shell_usage() {
    echo "Available commands:"
    echo ""
    echo "!gs or !groups          - Display available groups."
    echo "!g or !group [GROUP]    - Display available servers in the specified group or in the active group if none is provided."
    echo "!a or !activate [RESOURCE]   - Activate the specified resources (group or server)."
    echo "!da or !deactivate [RESOURCE] - Deactivate the specified resources (group or server)."
    echo "!s or !status           - Display the status of the active group of servers, including SSH status and connection status."
    echo "exit                    - Exit the session and disconnect from active SSH servers."
    echo ""
    echo "!e or !execute          - Execute a Linux command on active SSH servers and display the output in the shell."
    echo "!ea or !execute-async   - Execute a Linux command asynchronously on active SSH servers and display the output in the shell."
    echo "!h or !help [COMMAND]   - Get general help or specific help for a command."
    echo "clear                   - Clear the terminal screen."
}
