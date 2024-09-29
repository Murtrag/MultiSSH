#!/bin/bash

function usage() {
    echo "Usage: !execute COMMAND or !e COMMAND"
    echo "Execute a Linux command on active SSH servers and display the output in the shell."
    echo ""
    echo "Examples:"
    echo "  !execute cd /var; ls -l"
    echo "  !e cd /var; ls -l"
    echo "  !execute echo 'Hello, World!'"
    echo "  !e echo 'Hello, World!'"
}