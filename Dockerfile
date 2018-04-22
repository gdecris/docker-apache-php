FROM ubuntu:16.04

LABEL maintainer="Giovanni DeCristofaro"

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Install apache and depnendencies
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

# Copy the apache config
COPY apache-site.conf /etc/apache2/sites-enabled/000-default.conf

# Clenaup
RUN apt-get remove -y --purge software-properties-common && apt-get -y autoremove && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/sbin/apache2", "-DFOREGROUND"]
