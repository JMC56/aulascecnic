FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev zip unzip git curl \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_pgsql pgsql gd zip opcache

RUN a2enmod rewrite

# 🔥 Forzar HTTPS (por Render)
RUN echo "SetEnv HTTPS on" >> /etc/apache2/apache2.conf

WORKDIR /var/www/html

# 📥 Descargar Moodle (versión estable)
RUN curl -fL https://download.moodle.org/download.php/direct/stable404/moodle-4.4.1.zip -o moodle.zip \
    && unzip moodle.zip \
    && mv moodle/* . \
    && rm -rf moodle moodle.zip

# 🔐 Permisos correctos
RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www \
    && chmod -R 777 /var/www

EXPOSE 80
