FROM php:7.1-apache

# Install all required extensions
RUN requirements="libmcrypt-dev g++ libicu-dev libmcrypt4 libpng12-0 libpng12-dev libicu52 mysql-client" \
    && apt-get update && apt-get install -y $requirements \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install intl \
    && docker-php-ext-install gd \
    && requirementsToRemove="libmcrypt-dev g++ libicu-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove \
    && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && apt-get update \
    && apt-get install -y zlib1g-dev git \
    && docker-php-ext-install zip \
    && apt-get purge -y --auto-remove zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

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
