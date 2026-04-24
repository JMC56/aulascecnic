FROM php:8.1-apache

# Extensiones necesarias para Moodle
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev zip unzip git curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_pgsql pgsql gd zip opcache

# Habilitar rewrite
RUN a2enmod rewrite

# Descargar Moodle
WORKDIR /var/www/html
RUN curl -L https://download.moodle.org/latest.zip -o moodle.zip \
    && unzip moodle.zip \
    && mv moodle/* . \
    && rm -rf moodle moodle.zip

# Permisos
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
