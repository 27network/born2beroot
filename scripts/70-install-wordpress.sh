#!/bin/sh

source ./00-error-handling.sh

# Variables
WP_DOMAIN="127.0.0.1"
WP_TITLE="My Wordpress Blog"
WP_ADMIN_USER="admin"
WP_ADMIN_PASSWORD="admin"
WP_ADMIN_EMAIL="admin@localhost"

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
apt install -y php php-cli php-fpm php-mysql php-cgi

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

# Finalize Wordpress setup
curl "http://$WP_DOMAIN/wp-admin/install.php?step=2" \
  --data-urlencode "weblog_title=$WP_TITLE"\
  --data-urlencode "user_name=$WP_ADMIN_USER" \
  --data-urlencode "admin_email=$WP_ADMIN_EMAIL" \
  --data-urlencode "admin_password=$WP_ADMIN_PASSWORD" \
  --data-urlencode "admin_password2=$WP_ADMIN_PASSWORD" \
  --data-urlencode "pw_weak=1"  
