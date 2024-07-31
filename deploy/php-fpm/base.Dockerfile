FROM php:8.3.9-fpm

RUN apt-get update && apt-get install -y \
        git \
        curl \
        zlib1g-dev \
        libzip-dev \
        libpng-dev \
        libxml2-dev \
#        openssl \
#        libcurl4-openssl-dev \
        zip \
        unzip \
      #  && apt-get install -y libmagickwand-dev --no-install-recommends \
        # clean up \
        && apt-get autoclean -y \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /tmp/pear/

RUN \
    # pdo_mysql
     docker-php-ext-install pdo_mysql \
    && docker-php-ext-install sockets \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install zip \
    # && docker-php-ext-install mbstring \
    #redis
    && pecl install -o -f redis \
    && docker-php-ext-enable redis \
    #imagick
#    && pecl install imagick \
#    && docker-php-ext-enable imagick \
    #oauthh
#    && pecl install -o -f oauth \
#    && docker-php-ext-enable oauth \
    # clean up
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pear/

#Install composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
### BASE PART FOR ALL ENV ### < END

#Copy configs
#COPY docker/kubernetes/php-fpm/production-php.ini /usr/local/etc/php/php.ini
