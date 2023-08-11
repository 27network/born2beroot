#!/bin/sh

# Update packages
apt update -y
apt upgrade -y

# Install base packages
apt install -y build-essential curl wget neovim git

# Clone repository
git clone https://github.com/27network/born2beroot $HOME/b2br
cd $HOME/b2br

# Launch installer
cd scripts
bash ./01-installer.sh
