FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev zip unzip git curl \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_pgsql pgsql gd zip opcache

RUN a2enmod rewrite

WORKDIR /var/www/html

# ⬇️ DESCARGA MÁS SEGURA
RUN curl -fL https://download.moodle.org/download.php/direct/stable404/moodle-4.4.1.zip -o moodle.zip \
    && unzip moodle.zip \
    && mv moodle/* . \
    && rm -rf moodle moodle.zip

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
