#!/bin/bash

readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
. "$SCRIPT_DIR/_utils/_db_op.sh"

# A list of servers, one per line.
SERVER_LIST="${SCRIPT_DIR}/test_db.txt"

# Options for the ssh command.
SSH_OPTIONS='-o ConnectTimeout=2'

usage() {
  # Display the usage and exit.
  echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
  echo 'Executes COMMAND as a single command on every server.' >&2
  echo "  -f FILE  Use FILE for the list of servers. Default: ${SERVER_LIST}." >&2
  echo '  -n       Dry run mode. Display the COMMAND that would have been executed and exit.' >&2
  echo '  -s       Execute the COMMAND using sudo on the remote server.' >&2
  echo '  -v       Verbose mode. Displays the server name before executing COMMAND.' >&2
  echo '  -i       Interactive mode' >&2
  exit 1
}

declare -A db
parse_db $SERVER_LIST


# Make sure the script is not being executed with superuser privileges.
if [[ "${UID}" -eq 0 ]]
then
  echo 'Do not execute this script as root. Use the -s option instead.' >&2
  usage
fi

# Parse the options.
while getopts f:nsvi OPTION
do
  case ${OPTION} in
    f) SERVER_LIST="${OPTARG}" ;;
    i) RUN_INTERACTIVE='true' ;;
    n) DRY_RUN='true' ;;
    s) SUDO='sudo' ;;
    v) VERBOSE='true' ;;
    ?) usage ;;
  esac
done

# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 && "${RUN_INTERACTIVE}" != 'true' ]]
then
  usage
fi

# Anything that remains on the command line is to be treated as a single command.
COMMAND="${*}"

# Update the server list if a file is provided
if [[ -n "${SERVER_LIST}" ]]
then
  update_db "${SERVER_LIST}" "${SERVER_LIST}"
fi

# Check if user requested interactive mode
if [[ "${RUN_INTERACTIVE}" = 'true' ]]
then
  rlwrap "${SCRIPT_DIR}/_interactive_shell.sh" -f "${SERVER_LIST}"
  exit 0
fi

# If no command is provided, show usage
if [[ -z "${COMMAND}" ]]
then
  usage
fi

# Expect the best, prepare for the worst.
EXIT_STATUS='0'

# Loop through the SERVER_LIST
for SERVER in $(cat "${SERVER_LIST}")
do
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${SERVER}"
  fi

  SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"
 
  # If it's a dry run, don't execute anything, just echo it.
  if [[ "${DRY_RUN}" = 'true' ]]
  then
    echo "DRY RUN: ${SSH_COMMAND}"
  else
    eval "${SSH_COMMAND}"
    SSH_EXIT_STATUS="${?}"

    # Capture any non-zero exit status from the SSH_COMMAND and report to the user.
    if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
    then
      EXIT_STATUS=${SSH_EXIT_STATUS}
      echo "Execution on ${SERVER} failed." >&2
    fi 
  fi
done

exit ${EXIT_STATUS}
