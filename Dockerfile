FROM ubuntu:16.04

MAINTAINER Giovanni DeCristofaro

RUN apt-get update && apt-get install -y apache2 curl \
    && apt-get install -y libxml2 libxml2-dev libcurl4-openssl-dev libjpeg-dev libpng12-dev fontconfig wget \
    && apt-get install -y libfreetype6-dev libmcrypt-dev autoconf libmagickwand-dev imagemagick pkg-config

# Install php
RUN apt-get install -y php7.0 php7.0-common php7.0-cli php7.0-mcrypt php7.0-gd php7.0-json php7.0-mysql php7.0-imap \
    && apt-get install -y php7.0-mbstring php7.0-mcrypt php7.0-dev php7.0-xml \
    && apt-get install -y php7.0-curl php7.0-zip php7.0-readline php7.0-opcache php-imagick

# Install libapache php and composer
RUN apt-get install -y libapache2-mod-php7.0 \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# Enable apache modules
RUN a2enmod php7.0 && a2enmod rewrite

COPY apache-site.conf /etc/apache2/sites-enabled/000-default.conf

RUN apt-get remove -y --purge software-properties-common && apt-get -y autoremove && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD apachectl -f /etc/apache2/apache2.conf -DFOREGROUND
