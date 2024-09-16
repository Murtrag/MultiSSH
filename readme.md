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
Commands:
  !groups, !gs              Show all available groups
                            Example: !gs

  !group <group_name>, !g <group_name>
                            Show all servers in the specified group
                            Example: !g home_cluster

  !activate <group_name>, !a gs <group_name>
                            Activate all servers in the specified group
                            Example: !a gs home_cluster

  !activate <group_name>:<server_number>, !a <server_number>
                            Activate a specific server in the group
                            Example: !a home_cluster:blade1

  !exit, !e                 Exit the interactive shell

  !?, ?, !help              Show this help message
```
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