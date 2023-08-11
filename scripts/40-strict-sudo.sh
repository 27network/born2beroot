#!/bin/sh

# Install sudo
apt install sudo -y

# Configure sudo
chmod +w /etc/sudoers

sed -i 's/\:\/bin/\:\/bin\:\/snap\/bin/' /etc/sudoers
sed -i 's/use_pty/requiretty/' /etc/sudoers
sed -i "0,/Defaults/s//Defaults	passwd_tries=3\nDefaults/" /etc/sudoers 

chmod -w /etc/sudoers
