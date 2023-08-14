#!/bin/sh

source ./00-error-handling.sh

# Setup lighttpd
apt install -y lighttpd
systemctl enable --now lighttpd

# lighttpd php support
lighty-enable-mod fastcgi
lighty-enable-mod fastcgi-php
service lighttpd force-reload

# Update ufw to allow http/https
ufw allow 80
ufw allow 443
systemctl restart ufw
