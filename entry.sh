#!/bin/sh

# Check if run as root
if [ "$(id -u)" -ne 0 ]; then
	echo "Please run this script as sudo/root."
	exit 1
fi

# Update packages
apt update -y
apt upgrade -y

# Install base packages
apt install -y build-essential curl wget neovim git

# Check if we're already cloned
REPO_URL=https://github.com/27network/born2beroot
TARGET_DIR=$HOME/b2br

if [ -d .git ]; then
	if [ "$(git config --get remote.origin.url)" == "$REPO_URL" ]; then
		echo "Already in a cloned repo, skipping clone..."
		TARGET_DIR=$(pwd)
	fi
fi

# Clone repository
if [ ! -d $TARGET_DIR ]; then
  git clone $REPO_URL $TARGET_DIR
fi

# Check for updates?
cd $TARGET_DIR
git fetch
git pull

# Launch installer
cd scripts
bash ./00-installer.sh
