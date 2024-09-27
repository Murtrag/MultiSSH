#!/bin/bash

function usage(){
    echo "Usage: execute-async [OPTIONS] COMMAND"
    echo "Execute a command asynchronously."
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo "  -t, --timeout Set a timeout for the command execution"
}
