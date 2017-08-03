#!/bin/bash
sed -i -e "s/host = localhost/host = ${OJS_DB_HOST}/g" /var/www/ojs/config.inc.php
sed -i -e "s/username = ojs/username = ${OJS_DB_USER}/g" /var/www/ojs/config.inc.php
sed -i -e "s/password = ojs/password = ${OJS_DB_PASSWORD}/g" /var/www/ojs/config.inc.php
sed -i -e "s/name = ojs.*/name = ${OJS_DB_NAME}/g" /var/www/ojs/config.inc.php

sed -i -e "s#base_url = [\"]http://pkp.sfu.ca/ojs[\"]#base_url = \"${BASE_URL}\"#g" /var/www/ojs/config.inc.php
sed -i -e "s/installed = Off/installed = ${OJS_INSTALLED}/g" /var/www/ojs/config.inc.php
sed -i -e "s#salt = [\"]YouMustSetASecretKeyHere!![\"]#salt = ${OJS_SALT}#g" /var/www/ojs/config.inc.php

sed -i -e "s/\/var\/www\/html/\/var\/www\/ojs/g" /etc/apache2/sites-available/000-default.conf
sed -i -e "s/www.example.com/${SERVERNAME}/g" /etc/apache2/sites-available/000-default.conf
sed -i -e "s/\/var\/log\/apache2/${APACHE_LOG_DIR}/g" /etc/apache2/sites-available/000-default.conf
sed -i -e "s/error.log/%Y-%m-%d+${LOG_NAME}-error.log/g" /etc/apache2/sites-available/000-default.conf
sed -i -e "s/access.log/%Y-%m-%d+${LOG_NAME}-error.log/g" /etc/apache2/sites-available/000-default.conf

# Start the cron service in the background.
cron -f &
echo "[OJS Startup] Started cron"

# Run the apache process in the foreground as in the php image
echo "[OJS Startup] Starting apache..."
apache2-foreground
