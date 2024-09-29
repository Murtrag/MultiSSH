#!/bin/bash

cd
git clone https://github.com/Murtrag/MultiSSH.git
cd MultiSSH

# Create symlink to main script
sudo ln -s $(pwd)/multiSSH.sh /usr/local/bin/multissh

# Add execution permission to the main script
chmod +x $(pwd)/multiSSH.sh
