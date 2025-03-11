FROM php:apache-bookworm

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli 