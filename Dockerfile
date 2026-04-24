FROM php:8.1-apache

# ===== Dependencias del sistema =====
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

# ===== Configuración PHP optimizada para Moodle =====
RUN echo "max_input_vars = 5000" > /usr/local/etc/php/conf.d/moodle.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "zend.assertions = -1" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "assert.exception = 0" >> /usr/local/etc/php/conf.d/moodle.ini \
    && echo "opcache.enable_cli = 1" >> /usr/local/etc/php/conf.d/moodle.ini

# ===== Apache =====
RUN a2enmod rewrite

# Forzar HTTPS (Render proxy)
RUN echo "SetEnv HTTPS on" >> /etc/apache2/apache2.conf

# ===== Directorio de trabajo =====
WORKDIR /var/www/html

# ===== Descargar Moodle =====
RUN curl -fL https://download.moodle.org/download.php/direct/stable404/moodle-4.4.1.zip -o moodle.zip \
    && unzip moodle.zip \
    && mv moodle/* . \
    && rm -rf moodle moodle.zip

# ===== Permisos =====
RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www \
    && chmod -R 777 /var/www

# ===== Puerto =====
EXPOSE 80
