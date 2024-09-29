#!/bin/bash

function usage() {
    echo "Usage: !execute-async COMMAND or !ea COMMAND"
    echo "Execute a Linux command asynchronously on active SSH servers and display the output in the shell."
    echo ""
    echo "Examples:"
    echo "  !execute-async cd /var; ls -l"
    echo "  !ea cd /var; ls -l"
    echo "  !execute-async echo 'Hello, World!'"
}