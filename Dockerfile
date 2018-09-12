#start with our base image (the foundation) - version 7.1.5
FROM php:7.1.5-apache

#install all the system dependencies and enable PHP modules 
RUN apt-get update && apt-get install -y \
      libicu-dev \
      libpq-dev \
      libmcrypt-dev \
      mysql-client \
      git \
      zip \
      unzip \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      intl \
      mbstring \
      mcrypt \
      pcntl \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      zip \
      opcache \
      exif

#install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# install xdebug for code coverage
RUN curl -L -o /tmp/xdebug-2.6.0.tgz https://xdebug.org/files/xdebug-2.6.0.tgz \
    && tar xfz /tmp/xdebug-2.6.0.tgz \
        && rm -r /tmp/xdebug-2.6.0.tgz \
        && docker-php-source extract \
            && mv xdebug-2.6.0 /usr/src/php/ext/xdebug \
                && docker-php-ext-install xdebug \
                && docker-php-source delete

#change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# enable apache module rewrite
RUN a2enmod rewrite
