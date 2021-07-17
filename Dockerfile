FROM ubuntu:latest

LABEL Description="PBRaiders vanilla"
LABEL Vendor="Olivier Jullien"
LABEL License="MIT"
LABEL Version=vanilla

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive;apt-get install -y tzdata;dpkg-reconfigure --frontend noninteractive tzdata \
    && apt-get -y install apache2 php7.4 php7.4-bz2 php7.4-fpm php7.4-gd php7.4-intl php7.4-mbstring php7.4-mysql php7.4-xml php7.4-zip mariadb-server \
    && apt-get -y clean && apt-get -y autoremove && rm -rf /var/cache/apt/* \
    && sync

COPY php /etc/php/7.4/mods-available
COPY mariadb /etc/mysql/mariadb.conf.d
COPY apache2/conf-available /etc/apache2/conf-available
COPY apache2/sites-available /etc/apache2/sites-available
COPY public_html /var/www/html
COPY script /usr/local/bin

RUN sync && chmod +x /usr/local/bin/pbr-start \
    && phpenmod zzz-prod \
    && a2enmod expires headers include proxy proxy_fcgi rewrite\
    && a2disconf serve-cgi-bin other-vhosts-access-log \
    && a2enconf php7.4-fpm zzz-* \
    && a2dissite 000-default \
    && a2ensite loader \
    && chown -R www-data:www-data /var/www && sync

WORKDIR /var/www/html
EXPOSE 80 3306
CMD ["pbr-start"]