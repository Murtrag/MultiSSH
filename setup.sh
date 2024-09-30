#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
readonly TARGET_DIR="/home/$USER/MultiSSH"

readonly GLOBAL_CONFIG_DIR="/home/$USER/.config/multissh/"

# Copy the current directory (SCRIPT_DIR) to the target location
cp -r "$SCRIPT_DIR" "$TARGET_DIR"
cd "$TARGET_DIR"

# Create symlink to the main script (will fail if the symlink already exists)
sudo ln -s $(pwd)/multiSSH.sh /usr/local/bin/multissh

# Create global config
mkdir -p $GLOBAL_CONFIG_DIR
mv "$(pwd)/global.sh" "$GLOBAL_CONFIG_DIR/global.sh"

# Add execution permission to the main script
chmod +x $(pwd)/multiSSH.sh