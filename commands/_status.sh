#!/bin/bash
readonly COMMAND=$1 

# ssh -i .vagrant/machines/test_vm_1/virtualbox/private_key vagrant@192.168.56.21 pwd 

if [[ "$COMMAND" =~ ^(!status|!s) ]]
then
    echo "Status of the servers!"
    exit 0
fi
exit 1