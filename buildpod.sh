#!/bin/bash
#!/bin/bash
echo -e "Building Apache PHP image"
id=$(buildah from --pull php:apache-bookworm)
buildah run $id docker-php-ext-install pdo pdo_mysql mysqli
buildah commit $id php-apache-build


# Create a pod for the LAMP stack
podman pod create --name lampstack --userns=keep-id -p 8000:8000 -p 8080:8080

# Create MariaDB container
podman run -d \
  --pod lampstack \
  --name mariadb \
  -e MYSQL_ROOT_PASSWORD="rootpassword" \
  -e MYSQL_USER="lampuser" \
  -e MYSQL_PASSWORD="userpassword" \
  -e MYSQL_DATABASE="lampdb" \
  --volume /home/mmhamric/webspace/lampstack/mysql:/var/lib/mysql \
  docker.io/library/mariadb:latest

# Create Apache/PHP container
podman run -d \
  --pod lampstack \
  --name apache \
  -v /home/mmhamric/webspace/lampstack/html:/var/www/html \
  -v /home/mmhamric/webspace/lampstack/logs:/var/log/apache2 \
  -v /home/mmhamric/webspace/lampstack/ports.conf:/etc/apache2/ports.conf \
  php-apache-build


# Create phpMyAdmin container
podman run -d \
  --pod lampstack \
  --name phpmyadmin \
  -e PMA_HOST="127.0.0.1" \
  -e MYSQL_ROOT_PASSWORD="rootpassword" \
  docker.io/library/phpmyadmin:latest