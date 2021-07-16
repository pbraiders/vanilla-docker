FROM php:7.4-apache

LABEL Description="PBRaiders vanilla"
LABEL Vendor="Olivier Jullien"
LABEL License="MIT"
LABEL Version=vanilla

COPY php/conf.d /usr/local/etc/php/conf.d
COPY apache2/conf-available /etc/apache2/conf-available
COPY apache2/sites-available /etc/apache2/sites-available
COPY apache2/sites-available /etc/apache2/sites-available
COPY apache2/change_ports /usr/local/bin
COPY public_html /var/www/html

# Configure extensions
ARG user_extension="gd opcache pdo_mysql"
RUN curl --location --silent https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions --output /usr/local/bin/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && chmod +x /usr/local/bin/change_ports \
    && sync \
    && install-php-extensions opcache ${user_extension} \
    && rm -rf /var/cache/apk/* \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && a2enmod expires headers include rewrite \
    && a2enconf zzz-apache2 zzz-deflate zzz-dir zzz-expires zzz-headers zzz-log zzz-mime zzz-security zzz-ssl \
    && a2dissite 000-default \
    && a2ensite loader \
    && chown -R www-data:www-data /var/www