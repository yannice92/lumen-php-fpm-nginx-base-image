FROM alpine:3.10
LABEL Maintainer="Fernando Yannice <yannice92@gmail.com>" \
      Description="Lightweight pimcore or lumen container with Nginx 1.16 & PHP-FPM 7.3 based on Alpine Linux."

ENV TZ=Asia/Jakarta
ENV PHPIZE_DEPS="php7-dev autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo -e "http://nl.alpinelinux.org/alpine/v3.10/main\nhttp://nl.alpinelinux.org/alpine/v3.10/community" > /etc/apk/repositories

# Install packages busybox-extras vim for dev
RUN apk --no-cache add busybox-extras vim mysql-client lftp gettext\
    supervisor openssl tzdata php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl php7-ftp \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
    php7-mbstring php7-gd php7-redis php7-opcache php7-iconv php7-zip php7-xmlwriter php7-pdo \
    php7-soap php7-pdo_mysql php7-tokenizer php7-fileinfo php7-simplexml php7-exif nginx curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --1\
    && composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative \
    && rm -rf /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer
    
RUN apk add --no-cache --virtual $PHPIZE_DEPS && pecl install mongodb \
    && echo "extension=mongodb.so" > /etc/php7/conf.d/01_mongodb.ini \
    && rm -rf /tmp/* /usr/share/php7 \
    && apk del $PHPIZE_DEPS

#for crontab
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.9/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=5ddf8ea26b56d4a7ff6faecdd8966610d5cb9d85

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic
