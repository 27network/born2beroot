#!/bin/sh

source ./00-error-handling.sh
source ../config/wordpress-variables.conf

# Finalize Wordpress setup
curl -X POST "http://$WP_DOMAIN/wp-admin/install.php?step=2" \
  --data-urlencode "weblog_title=$WP_TITLE"\
  --data-urlencode "user_name=$WP_ADMIN_USER" \
  --data-urlencode "admin_email=$WP_ADMIN_EMAIL" \
  --data-urlencode "admin_password=$WP_ADMIN_PASSWORD" \
  --data-urlencode "admin_password2=$WP_ADMIN_PASSWORD" \
  --data-urlencode "pw_weak=1"  
