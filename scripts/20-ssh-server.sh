#!/bin/sh

source ./00-error-handling.sh

# Install openssh-server
apt-get install -y openssh-server

# Configure access
echo "Port 4242" >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# Reload
service ssh restart
