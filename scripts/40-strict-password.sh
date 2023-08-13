#!/bin/sh

source ./00-error-handling.sh

# Install library
apt install -y libpam-pwquality

# Replace password aging
chmod +w /etc/login.defs
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS	30/g' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS	2/g' /etc/login.defs
sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE	7/g' /etc/login.defs
chmod -w /etc/login.defs

# Reset password aging for current accounts
chage -M 30 $1
chage -m 2 $1
chage -W 7 $1
chage -M 30 root
chage -m 2 root
chage -W 7 root

# Password rules
chmod +w /etc/pam.d/common-password
LINE="password	requisite			pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 lcredit=-1 maxrepeat=3 usercheck=1 difok=7 enforce_for_root"
sed -i "s/.*retry=3.*/$LINE/g" /etc/pam.d/common-password
chmod -w /etc/pam.d/common-password

