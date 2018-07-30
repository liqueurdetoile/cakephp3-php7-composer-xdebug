FROM php:7.1-apache

#update apt-get
RUN apt-get update
#install the required components
RUN apt-get install -qqy \
    git-core \
    composer \
    libapache2-mod-php \
	php-mcrypt \
	php-intl \
	php-mbstring \
	php-zip \
	php-xml \
	php-codesniffer \
	php-mysql && \
	# Delete all the apt list files since they're big and get stale quickly
	rm -rf /var/lib/apt/lists/*
    
#install the PHP extensions we need
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip

#delete the lists for apt-get as the take up space we do not need.
RUN rm -rf /var/lib/apt/lists/*

# install xdebug for code coverage
RUN curl -L -o /tmp/xdebug-2.4.1.tgz http://xdebug.org/files/xdebug-2.4.1.tgz \
    && tar xfz /tmp/xdebug-2.4.1.tgz \
        && rm -r /tmp/xdebug-2.4.1.tgz \
        && docker-php-source extract \
            && mv xdebug-2.4.1 /usr/src/php/ext/xdebug \
                && docker-php-ext-install xdebug \
                && docker-php-source delete

# enable apache rewrite
RUN a2enmod rewrite

# set www permissions
RUN usermod -u 1000 www-data
