#!/bin/sh

source ./00-error-handling.sh
source ../config/database-credentials.conf

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
