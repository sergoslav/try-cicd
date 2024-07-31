##
# This Dockerfile uses to build image for production from local.
# Be careful! it could be outstanding! Comapre with circleci-production.Dockerfile!
##
# FROM snowcommerceinc/snowship:control-fpm-base-8.2.4.0 as builder
FROM registry.digitalocean.com/listrun/app-php-base:8.3.9.0 as builder

WORKDIR /var/www

FROM builder as builder_vendor

# Add local ssh key. On Local Only!!
# ARG SSH_KEY
# RUN mkdir -p /root/.ssh && \
#     chmod 0700 /root/.ssh && \
#     ssh-keyscan bitbucket.org > /root/.ssh/known_hosts && \
#     echo "${SSH_KEY}" > /root/.ssh/id_rsa && \
#     chmod 600 /root/.ssh/id_rsa
# RUN #mkdir -p -m 0600 ~/.ssh && ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts

# Install dependencies
COPY composer.* ./
#COPY . .
#RUN composer install --prefer-source --no-interaction --no-dev
RUN composer install --no-interaction --prefer-dist --no-scripts --no-autoloader

# Remoe SSH keys
# RUN rm /root/.ssh/id_rsa


FROM builder as builder_final

COPY --from=builder_vendor /var/www/vendor /var/www/vendor
COPY . .
# Finish composer
RUN composer dump-autoload --optimize --no-interaction && composer run post-autoload-dump --no-interaction

RUN chown -R www-data:www-data /var/www

# COPY docker/kubernetes/php-fpm/production-php.ini /usr/local/etc/php/php.ini
COPY deploy/php-fpm/entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]
CMD ["/entrypoint.sh"]

