FROM alpine:3.10
LABEL Maintainer="Fernando Yannice <yannice92@gmail.com>" \
      Description="Lightweight pimcore or lumen container with Nginx 1.16 & PHP-FPM 7.3 based on Alpine Linux."

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install packages
RUN apk --no-cache add tzdata php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
    php7-mbstring php7-gd php7-redis php7-opcache php7-iconv php7-zip php7-xmlwriter php7-pdo php7-soap php7-pdo_mysql php7-tokenizer php7-fileinfo php7-simplexml php7-exif nginx supervisor curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative \
    && rm -rf /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer
