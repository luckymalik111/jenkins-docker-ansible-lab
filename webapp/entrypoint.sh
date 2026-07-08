#!/bin/sh
set -e
php-fpm83 -D
exec nginx -g "daemon off;"
