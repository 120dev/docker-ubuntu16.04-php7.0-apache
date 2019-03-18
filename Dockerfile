FROM ubuntu:16.04

MAINTAINER 120@dev.nc

ENV DEBIAN_FRONTEND noninteractive

# FISH
RUN apt -yq update && apt -yq full-upgrade

RUN apt-get install -yq \
    apt-utils \
    curl \
    wget \
    curl \
    git \
    gnupg2 \
    apt-transport-https

RUN apt-get install -yq \
    apache2 \
    libapache2-mod-php7.0 \
    php-pear \
    php-dev \
    php7.0-cli \
    php7.0-json \
    php7.0-pgsql \
    php7.0-curl \
    php7.0-fpm \
    php7.0-gd \
    php7.0-ldap \
    php7.0-mbstring \
    php7.0-mysql \
    php7.0-soap \
    php7.0-sqlite3 \
    php7.0-xml \
    php7.0-zip \
    php7.0-intl \
    php7.0-mcrypt \
    php-memcache \
    php-imagick \
    php7.0-bcmath \
    memcached \
    mcrypt

RUN apt-get install -yq \
    graphicsmagick \
    imagemagick \
    iputils-ping \
    nodejs \
    npm

RUN apt-get install -yq nano mysql-client locales
RUN apt -yq update
RUN apt-get install -yq default-jre

RUN npm -g install gulp bower

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo
# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8

RUN a2enmod rewrite expires headers

# Configure PHP
RUN wget -S --header="accept-encoding: gzip" -O-  "https://browscap.org/stream?q=Full_PHP_BrowsCapINI" | gunzip > /browscap.ini
ADD local.php.ini /etc/php/7.0/apache2/conf.d/

RUN pear channel-discover pear.twig-project.org
RUN pear update-channels
RUN pear install --alldeps PAGER twig/Twig

WORKDIR /var/www/

CMD ["apache2ctl", "-D", "FOREGROUND"]
