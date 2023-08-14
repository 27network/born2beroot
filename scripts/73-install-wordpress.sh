#!/bin/sh

source ./00-error-handling.sh
source ../config/database-credentials.conf
source ../config/wordpress-variables.conf

# Download Wordpress
rm -f /var/www/html/*.html

apt install -y curl tar
curl -sSL https://wordpress.org/latest.tar.gz -o /var/www/html/wordpress.tar.gz
cd /var/www/html
tar -xpvf wordpress.tar.gz
mv ./wordpress/* ./
rm -rf ./wordpress
rm -f wordpress.tar.gz

# Configure Wordpress
## Database credentials
sed -i "s/database_name_here/$WP_DATABASE/g" /var/www/html/wp-config-sample.php
sed -i "s/username_here/$WP_USER/g" /var/www/html/wp-config-sample.php
sed -i "s/password_here/$WP_PASSWORD/g" /var/www/html/wp-config-sample.php
## Secret key/salts
sed -i 's/.*unique\ phrase.*//g' /var/www/html/wp-config-sample.php
curl -s https://api.wordpress.org/secret-key/1.1/salt/ > tmp.txt
sed -i '/#@-/r tmp.txt' /var/www/html/wp-config-sample.php
rm -f tmp.txt
mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html

# Setup Wordpress cron
echo "*/5 * * * * www-data /usr/bin/php /var/www/html/wp-cron.php" >> /etc/crontab
service cron restart
