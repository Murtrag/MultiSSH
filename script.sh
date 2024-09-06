#!/usr/bin/env fish

function my_interpreter
    echo "Interactive shell welcome"

    while true
        set -l user_command (read -P "cmd> ")

        if test "$user_command" = "exit"
            echo "Close interactive view"
            return
        end

        switch $user_command
            case "hello"
                echo "Hello world"
            case "*"
                echo "Unknown command: $user_command"
        end
    end
end

my_interpreter
