FROM php:7.1-apache

# Install all required extensions
# update apt-get 
RUN apt-get update

# install the required components 
RUN apt-get install -y libmcrypt-dev g++ libicu-dev libmcrypt4 libicu52 zlib1g-dev git

# install the PHP extensions we need 
RUN docker-php-ext-install intl
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install zip

# cleanup after the installations 
RUN apt-get purge --auto-remove -y libmcrypt-dev g++ libicu-dev zlib1g-dev
# delete the lists for apt-get as the take up space we do not need. 
RUN rm -rf /var/lib/apt/lists/*

# install composer globally so that you can call composer directly 
RUN curl -sSL https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Run xdebug installation.
RUN mkdir -p /usr/src/php/ext/ && \
    curl -L http://pecl.php.net/get/xdebug-2.3.3.tgz >> /usr/src/php/ext/xdebug.tgz && \
    tar -xf /usr/src/php/ext/xdebug.tgz -C /usr/src/php/ext/ && \
    rm /usr/src/php/ext/xdebug.tgz && \
    docker-php-ext-install xdebug-2.3.3 && \
    docker-php-ext-install pcntl && \
    php -m

# Globally install phpunit and phpcs
#RUN composer global require 'cakephp/cakephp-codesniffer:dev-master' \
#    && composer global require 'phpunit/phpunit' \
#    && export PATH=~/.composer/vendor/bin:$PATH

# Enable apache mods
RUN a2enmod rewrite

RUN usermod -u 1001 www-data
