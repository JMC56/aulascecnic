FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev zip unzip git curl \
    libpq-dev \
    libicu-dev \
    libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo pdo_pgsql pgsql \
        gd zip opcache \
        intl soap exif

# 🔥 CONFIG PHP (CLAVE PARA EL ERROR ANTERIOR)
RUN echo "max_input_vars = 5000" > /usr/local/etc/php/conf.d/moodle.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "zend.assertions = -1" >> /usr/local/etc/php/conf.d/moodle.ini

RUN a2enmod rewrite

RUN echo "SetEnv HTTPS on" >> /etc/apache2/apache2.conf

WORKDIR /var/www/html

RUN curl -fL https://download.moodle.org/download.php/direct/stable404/moodle-4.4.1.zip -o moodle.zip \
    && unzip moodle.zip \
    && mv moodle/* . \
    && rm -rf moodle moodle.zip

RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www \
    && chmod -R 777 /var/www

EXPOSE 80
