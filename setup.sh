#!/bin/bash
readonly SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
readonly TARGET_DIR="/home/$USER/MultiSSH"
readonly GLOBAL_CONFIG_DIR="/home/$USER/.config/multissh/"

# Install dependencies
# Ubuntu / Debian
sudo apt update
sudo apt install rlwrap tmux sshpass

# Arch
# sudo pacman -Syu
# sudo pacman -S rlwrap tmux sshpass


# Fedora
# sudo dnf update
# sudo dnf install rlwrap tmux sshpass

# CentOS / RHEL
# sudo yum install epel-release
# sudo yum update
# sudo yum install rlwrap tmux sshpass

# openSUSE
# sudo zypper refresh
# sudo zypper install rlwrap tmux sshpass

# Alpine
# sudo apk update
# sudo apk add rlwrap tmux sshpass

# Gentoo
# sudo emerge --sync
# sudo emerge rlwrap tmux sshpass

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

# Create directory for temporary files
mkdir -p "/tmp/multissh"
touch "/tmp/multissh/active_resources.tmp"