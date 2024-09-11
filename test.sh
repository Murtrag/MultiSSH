#!/bin/bash
# Run automatic tests

test_dir="/vagrant/tests" 

for file in "${test_dir}"/test_*.sh; do
    bash "$file"
done