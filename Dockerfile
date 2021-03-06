FROM php:7.4.10-apache
# Used to load environment php.ini
ARG PHP_ENV=production
ARG ML=512M
ARG TZ='America/Chicago'

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y unzip libssl-dev libpng-dev libxslt-dev vim \
    libicu-dev libbz2-dev libzip-dev libpq-dev libmariadbclient-dev git openssh-client \
    libpcre3-dev
# Install redis with igbinary serialization but without compression
RUN pecl install apcu-5.1.18 \
    && pecl install igbinary-3.1.2 \
    && printf "yes\nno\nno" | pecl install redis-5.3.1
RUN docker-php-ext-install -j$(nproc) gd xsl intl \
    bz2 zip opcache pcntl pdo pdo_mysql pdo_pgsql json xml xmlrpc

COPY pecl_extensions.ini $PHP_INI_DIR/conf.d/pecl_extensions.ini
RUN a2enmod rewrite proxy proxy_http
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN mkdir /app
WORKDIR /app

COPY symfony4.conf /etc/apache2/sites-available/symfony4.conf
RUN cp $PHP_INI_DIR/php.ini-$PHP_ENV $PHP_INI_DIR/php.ini \
    && sed -i -e 's/^post_max_size.*/post_max_size = 64M/g' $PHP_INI_DIR/php.ini \
    && sed -i -e 's/^upload_max_filesize.*/upload_max_filesize = 64M/g' $PHP_INI_DIR/php.ini \
    && sed -i -e 's/^memory_limit.*/memory_limit = '$ML'/g' $PHP_INI_DIR/php.ini \
    && sed -i -e 's#^;date.timezone.*#date.timezone = "'$TZ'"#g' $PHP_INI_DIR/php.ini \
    && sed -i -e 's#var/www#app#g' /etc/apache2/apache2.conf \
    && rm /etc/apache2/sites-enabled/000-default.conf
