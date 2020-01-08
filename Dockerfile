FROM php:7.4-fpm

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y lsb-release \
    && apt-get update && apt-get install -y --no-install-recommends \
      autoconf automake libtool nasm make pkg-config openssl libz-dev build-essential g++ ca-certificates \
      zlib1g-dev libicu-dev libbz2-dev libjpeg-dev libvpx-dev libxpm-dev libpng-dev libfreetype6-dev libc-client-dev \
      libkrb5-dev libxml2-dev libxslt1.1 libxslt1-dev libzip-dev locales locales-all \
      html2text pngcrush jpegoptim exiftool poppler-utils git wget nginx curl supervisor procps \
    \
    && docker-php-ext-install intl mysqli bcmath gd bz2 soap xmlrpc xsl pdo_mysql exif zip opcache \
    && pecl install redis && docker-php-ext-enable redis \
    && cd ~ \
    \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative \
    && apt-get autoremove -y \
      && apt-get remove -y autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ \
      && apt-get clean; rm -rf /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer \
    && apt-get autoremove -y

RUN apt-get install -y vim
