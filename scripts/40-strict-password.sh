#!/bin/sh

# Install library
apt install -y libpam-pwquality

# Replace password aging
chmod +w /etc/login.defs
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS	30/g' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS	2/g' /etc/login.defs
sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE	7/g' /etc/login.defs
chmod -w /etc/login.defs
