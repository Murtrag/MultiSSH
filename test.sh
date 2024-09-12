#!/bin/bash
# Run automatic tests

test_dir="/vagrant/tests" 

if [[ "$1" != "" ]]
then
    bash ""${test_dir}"/test_${1}.sh"
    exit 0
fi

for file in "${test_dir}"/test_*.sh; do
    bash "$file"
done
exit 0