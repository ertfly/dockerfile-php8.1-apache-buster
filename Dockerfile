FROM php:8.1-rc-apache-buster
RUN apt-get update && apt-get install -y libpq-dev curl libcurl4-openssl-dev libxml2-dev zlib1g-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev openssl zip unzip git libonig-dev libtidy-dev libzip-dev nano libjpeg-dev libfreetype6-dev pkg-config libssl-dev libmcrypt-dev
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install curl dom gd mbstring pdo pdo_pgsql pgsql simplexml soap tidy zip sockets intl
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod expires
RUN mkdir /app
RUN a2dissite 000-default.conf default-ssl.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN pecl install mcrypt && docker-php-ext-enable mcrypt
RUN pecl install xdebug-3.3.2 && docker-php-ext-enable xdebug
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY php.ini /usr/local/etc/php/php.ini
COPY openssl.cnf /etc/ssl/openssl.cnf
RUN a2ensite 000-default.conf
ADD http://www.cacert.org/certs/root.crt /usr/local/share/ca-certificates/cacert.crt
RUN update-ca-certificates
RUN composer self-update --snapshot
RUN composer config --global secure-http false
RUN ln -s /usr/local/bin/php /usr/bin/php
RUN chmod +x /usr/bin/php
WORKDIR /app
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh
RUN git config --global --add safe.directory /app
ENTRYPOINT ["/root/start.sh"]