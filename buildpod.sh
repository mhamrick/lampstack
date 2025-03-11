#!/bin/bash
#!/bin/bash
echo -e "Building Apache PHP image"
podman build -t php-apache-build .


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
  --volume /home/mmhamric/lampstack/lampstack/mysql:/var/lib/mysql \
  docker.io/library/mariadb:latest

# Create Apache/PHP container
podman run -d \
  --pod lampstack \
  --name apache \
  -v /home/mmhamric/lampstack/lampstack/html:/var/www/html \
  -v /home/mmhamric/lampstack/lampstack/logs:/var/log/apache2 \
  -v /home/mmhamric/lampstack/lampstack/ports.conf:/etc/apache2/ports.conf \
  -v /home/mmhamric/lampstack/lampstack/uploads.ini:/usr/local/etc/php/conf.d/uploads.ini \
  php-apache-build


# Create phpMyAdmin container
podman run -d \
  --pod lampstack \
  --name phpmyadmin \
  -e PMA_HOST="127.0.0.1" \
  -e MYSQL_ROOT_PASSWORD="rootpassword" \
  -e APACHE_PORT=8080 \
  docker.io/library/phpmyadmin:latest
