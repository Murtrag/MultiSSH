# MultiSSH
**MultiSSH** is a lightweight shell script tool designed to execute commands across multiple SSH servers simultaneously, making it ideal for managing server configurations or performing bulk operations with minimal dependencies

## Description
MultiSSH is a simple yet powerful shell script created to streamline operations across entire lists of SSH servers. Its primary function is to allow users to execute a single command on multiple servers at once, making it an efficient tool for tasks like system administration, bulk server configuration, or automating maintenance routines. With minimal dependencies due to its shell script nature, MultiSSH is highly accessible and easy to integrate into existing workflows. This makes it particularly useful for DevOps teams, network administrators, or even automating tasks in environments with large server infrastructures.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Contributing](#contributing)
- [License](#license)
- [Authors](#authors)

## Installation
Comming soon

## Usage
**MultiSSH** can be used in two modes: **standard command-line mode** and **interactive mode**.
### Command-Line Mode:

You can run the program as a regular command by providing a list of servers and the command to be executed. Below is the syntax for usage:
```
Usage: ./multissh [-nsv] [-f FILE] COMMAND
Executes COMMAND as a single command on every server.
  -f FILE  Use FILE for the list of servers. Default: ${SERVER_LIST}.
  -n       Dry run mode. Display the COMMAND that would have been executed and exit.
  -s       Execute the COMMAND using sudo on the remote server.
  -v       Verbose mode. Displays the server name before executing COMMAND.
  -i       Interactive mode
```
- -f FILE: Specifies the file that contains the list of servers to use. By default, it reads from a predefined list ${SERVER_LIST}.
- -n: Runs the script in dry-run mode, where the commands are shown but not executed.
- -s: Executes the command with sudo on the remote server.
- -v: Enables verbose mode, showing the server name before executing the command.
- -i: Starts the program in interactive mode.
### Interactive Mode:

In interactive mode, you can run commands dynamically to manage groups of servers. The available commands are:
```
!gs or !groups          - Display available groups.
!g or !group [GROUP]    - Display available servers in the specified group or in the active group if none is provided.
!a or !activate [RESOURCE]   - Activate the specified resources (group or server).
!da or !deactivate [RESOURCE] - Deactivate the specified resources (group or server).
!s or !status           - Display the status of the active group of servers, including SSH status and connection status.
exit                    - Exit the session and disconnect from active SSH servers.

!e or !execute          - Execute a Linux command on active SSH servers and display the output in the shell.
!ea or !execute-async   - Execute a Linux command asynchronously on active SSH servers and display the output in the shell.
!h or !help [COMMAND]   - Get general help or specific help for a command.
clear                   - Clear the terminal screen.
```
How to Use the Shell:

    Check Available Groups
    To start, you may want to list all available server groups. Use the following command to see which groups are available:

    diff

!gs

Display Servers in a Group
If you want to see which servers belong to a specific group, use the command:

diff

!g group_name

If you don’t specify a group, it will show servers in the currently active group:

diff

!g

Activate Servers
To activate all servers in a particular group, use the !a command followed by the group name:

css

!a group_name

You can also activate multiple groups at once:

css

!a group1,group2

Additionally, if you want to activate only a specific server (blade) within a group, use the format:

css

!a group_name:server_number

Deactivate Servers
Similarly, to deactivate servers in a group, use the !da command followed by the group name:

diff

!da group_name

To deactivate multiple groups:

diff

!da group1,group2

You can also deactivate a specific server within a group:

diff

!da group_name:server_number

Check Status of Servers
To check the status of active servers (whether SSH is running and if they are connected), use:

diff

!s

Execute Commands on Active Servers
To run a Linux command synchronously on all active servers and view the output in the shell:

bash

!e command

For example:

bash

!e ls /var

Run Commands Asynchronously
If you need to run a long-running command asynchronously (in the background) on active servers, use:

bash

!ea command

Exit the Shell
When you're done, exit the interactive mode and disconnect from all active SSH sessions with:

bash

exit

Get Help
If you need general help or help with a specific command, use:

diff

    !h
    !h command_name

    Clear the Terminal Screen
    To clear the terminal window:

arduino

clear

Example Workflow:

    Start by displaying available groups with !gs.
    Activate multiple groups with !a group1,group2.
    Check the status of all active servers with !s.
    Run a Linux command across the active servers with !e ls /var.
    Deactivate specific servers with !da group2.
    Exit the interactive mode with exit.

This shell allows you to easily manage server groups, run commands, and monitor server statuses in an intuitive way.

## Configuration

## Running Tests
For testing, the project uses **shunit2** as the testing framework.

In the root directory, there is a script named **`./test.sh`**, which can be run to execute the entire test suite:

```bash
./test.sh
```
You can also specify a particular group of tests to run by providing the group name as an argument:
```
./test.sh <group>
```
This flexibility allows for running specific test cases or groups of tests when needed.
## Contributing

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more details.

## Authors
- Lukasz Czernik - [lukasz.czernik@gmail.com](mailto:lukasz.czernik@gmail.com)

## Acknowledgements