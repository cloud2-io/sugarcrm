#!/bin/sh

set -e

if [ -z "$DB_HOST_NAME" ]; then
	export DB_HOST_NAME=$DB_PORT_3306_TCP_ADDR
fi

if [ -z "$DB_TCP_PORT" ]; then
	export DB_TCP_PORT=$DB_PORT_3306_TCP_PORT
fi

if [ -z "$DB_USER_NAME" ]; then
	export DB_USER_NAME=$DB_ENV_MYSQL_USER
fi

if [ -z "$DB_PASSWORD" ]; then
	export DB_PASSWORD=$DB_ENV_MYSQL_PASSWORD
fi

if [ -z "$DATABASE_NAME" ]; then
	export DATABASE_NAME=$DB_ENV_MYSQL_DATABASE
fi

# Copy Installation only if not already set
if [ ! -f /var/www/html/index.php ] ; then
    echo "`date -u` installing sugarcrm"
    rm -rf /var/www/html/*
    cp -r /tmp/html/* /var/www/html
    chown -R www-data:www-data /var/www/html/*
    chown -R www-data:www-data /var/www/html
fi
echo "`date -u` starting apache"

/usr/local/bin/envtemplate.py -i /usr/local/src/config_override.php.pyt -o /var/www/html/config_override.php
/usr/sbin/cron
apachectl -DFOREGROUND
