#!/bin/bash

PODNAME=lampstack
MYSQL_ROOT_PASSWORD=arootpassword
MYSQL_DATABASE=lampdb 
MYSQL_USER=lamper
MYSQL_PASSWORD=somepassword 



echo -e "Building Apache PHP image"
podman build -t php-apache-build .


# Create a pod for the LAMP stack
podman pod create --name  ${PODNAME}  --userns=keep-id -p 8000:8000 -p 8080:8080

# Create MariaDB container
podman run -d \
  --pod lampstack \
  --name mariadb \
  -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
  -e MYSQL_USER=${MYSQL_USER} \
  -e MYSQL_PASSWORD=${MYSQL_PASSWORD}  \
  -e MYSQL_DATABASE=${MYSQL_DATABASE} \
  --volume ~/lampstack/lampstack/mysql:/var/lib/mysql \
  docker.io/library/mariadb:latest

# Create Apache/PHP container
podman run -d \
  --pod lampstack \
  --name apache \
  -v ~/lampstack/lampstack/html:/var/www/html \
  -v ~/lampstack/lampstack/logs:/var/log/apache2 \
  -v ~/lampstack/lampstack/ports.conf:/etc/apache2/ports.conf \
  -v ~/lampstack/lampstack/uploads.ini:/usr/local/etc/php/conf.d/uploads.ini \
  php-apache-build


# Create phpMyAdmin container
podman run -d \
  --pod lampstack \
  --name phpmyadmin \
  -e PMA_HOST="127.0.0.1" \
  -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
  -e APACHE_PORT=8080 \
  docker.io/library/phpmyadmin:latest
