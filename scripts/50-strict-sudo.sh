#!/bin/sh

# Install sudo
apt install sudo -y

# Configure sudo
chmod +w /etc/sudoers

function add_default() {
	sed -i "0,/Defaults/s//Defaults	$1\nDefaults/" /etc/sudoers 
}

sed -i 's/\:\/bin/\:\/bin\:\/snap\/bin/' /etc/sudoers
sed -i 's/use_pty/requiretty/' /etc/sudoers
add_default "passwd_tries=3"
add_default "badpass_message=\"can\'t even write a password lmao\""
add_default "logfile=\"/var/log/sudo/sudo.log\""
add_default "log_input, log_output"
add_default "mail_badpass"

chmod -w /etc/sudoers
