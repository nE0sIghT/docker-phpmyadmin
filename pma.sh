#!/bin/bash

export PMA_SECRET=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
export PMA_PORT=${PMA_PORT:-8080}
export MYSQL_HOST=${MYSQL_HOST:-localhost}
export MYSQL_PORT=${MYSQL_PORT:-3306}

envsubst '$PMA_SECRET $MYSQL_HOST $MYSQL_PORT' < /tmp/config.inc.php > /usr/share/phpmyadmin/config.inc.php
php -S 0.0.0.0:${PMA_PORT} -t /usr/share/phpmyadmin
