#!/bin/sh

source ./00-error-handling.sh

# Install php
apt install -y php php-cli php-fpm php-mysql php-cgi

# Yeet apache
apt purge -y apache2
apt autoremove -y
