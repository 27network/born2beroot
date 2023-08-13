#!/bin/sh

MARIADB_ROOT_PASSWORD="#StrongPassword42069"
WP_DATABASE="wp_data"
WP_USER="wp_user"
WP_PASSWORD="wp_password"

# Setup lighttpd
apt install -y lighttpd
systemctl enable --now lighttpd

# Update ufw to allow http/https
ufw allow 80
ufw allow 443
systemctl restart ufw

# MariaDB setup
apt install -y mariadb-server 

# mariadb-secure-installation
mariadb-secure-installation <<EOF

n
y
$MARIADB_ROOT_PASSWORD
$MARIADB_ROOT_PASSWORD
y
y
y
y
EOF

# Setup mysql user/database for Wordpress
mysql -e "CREATE DATABASE $WP_DATABASE;"
mysql -e "CREATE USER '$WP_USER'@'localhost' IDENTIFIED BY '$WP_PASSWORD';"
mysql -e "GRANT ALL ON ${WP_DATABASE}.* TO '$WP_USER'@'localhost' IDENTIFIED BY '$WP_PASSWORD' WITH GRANT OPTION;"

# End setup
mysql -e "FLUSH PRIVILEGES"

# Install php
apt install -y php php-fpm php-mysql phsudo apt-get install wget tar -yp-cgi

# Yeet apache
apt purge -y apache2
apt autoremove -y

# lighttpd php support
lighty-enable-mod fastcgi
lighty-enable-mod fastcgi-php
service lighttpd force-reload

# Download Wordpress
rm -f /var/www/html/*.html

apt install -y curl tar
curl -sSL https://wordpress.org/latest.tar.gz -o /var/www/html/wordpress.tar.gz
cd /var/www/html
tar -xpvf wordpress.tar.gz
mv ./wordpress/* ./
rm -rf ./wordpress
rm -f wordpress.tar.gz

chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html
