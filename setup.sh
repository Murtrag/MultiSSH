#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
readonly TARGET_DIR="/home/$USER/MultiSSH"

# Copy the current directory (SCRIPT_DIR) to the target location
cp -r "$SCRIPT_DIR" "$TARGET_DIR"
cd "$TARGET_DIR"

# Create symlink to the main script (will fail if the symlink already exists)
sudo ln -s $(pwd)/multiSSH.sh /usr/local/bin/multissh

# Add execution permission to the main script
chmod +x $(pwd)/multiSSH.sh