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

#RUN apt-get update && apt-get install -y vim

##Copy configs
#COPY docker/kubernetes/php-fpm/production-php.ini /usr/local/etc/php/php.ini


#COPY docker/php-fpm/entrypoint.sh /entrypoint.sh
#RUN ["chmod", "+x", "/entrypoint.sh"]
#CMD ["/entrypoint.sh"]


# # # XHProf START # # #
## install the xhprof extension to profile requests
## doc: https://baptiste.bouchereau.pro/tutorial/profile-php-applications-with-xhgui-and-xhprof-on-docker/
#RUN curl "https://github.com/tideways/php-xhprof-extension/archive/v5.0.4.tar.gz" -fsL -o ./php-xhprof-extension.tar.gz && \
#    tar xf ./php-xhprof-extension.tar.gz && \
#    cd php-xhprof-extension-5.0.4 && \
#    phpize && \
#    ./configure && \
#    make && \
#    make install
#RUN rm -rf ./php-xhprof-extension.tar.gz ./php-xhprof-extension-5.0.4
#RUN docker-php-ext-enable tideways_xhprof
#
## install mongodb extension. The xhgui-collector will send xprof data to mongo
#RUN pecl install mongodb && docker-php-ext-enable mongodb
#
## install composer
##RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#
## install the package that will collect data
#WORKDIR /var/xhgui
#RUN composer require perftools/php-profiler perftools/xhgui-collector alcaeus/mongo-php-adapter
#
## copy the configuration file
#COPY docker/xhprof/xhgui_config.php /var/xhgui/config/config.php
# # # XHProf END # # #


WORKDIR /var/www

USER $user

RUN mkdir ~/.ssh && ln -s /run/secrets/host_ssh_key ~/.ssh/id_rsa
