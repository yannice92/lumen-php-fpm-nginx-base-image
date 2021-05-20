FROM alpine:3.13
LABEL maintainer="Fernando Yannice <yannice92@gmail.com>" \
      description="Lightweight Pimcore, Lumen, or Laravel image with Nginx 1.18, PHP-FPM 8, Composer 2, and Supercronic (Cron) based on Alpine Linux."

ENV TZ="Asia/Jakarta"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "https://nl.alpinelinux.org/alpine/v3.13/main" >> /etc/apk/repositories
RUN echo "https://nl.alpinelinux.org/alpine/v3.13/community" >> /etc/apk/repositories

RUN apk --no-cache add busybox-extras vim mysql-client lftp gettext supervisor openssl tzdata nginx curl

RUN apk --no-cache add php8 php8-cli php8-fpm php8-mysqli php8-json php8-openssl php8-curl php8-ftp \
    php8-zlib php8-xml php8-phar php8-intl php8-dom php8-xmlreader php8-ctype php8-session \
    php8-mbstring php8-gd php8-redis php8-opcache php8-iconv php8-zip php8-xmlwriter php8-pdo \
    php8-soap php8-pdo_mysql php8-tokenizer php8-fileinfo php8-simplexml php8-exif
RUN ln -s /usr/bin/php8 /usr/bin/php

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --2 \
    && rm -rf /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

ENV SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64" \
    SUPERCRONIC="supercronic-linux-amd64" \
    SUPERCRONIC_SHA1SUM="048b95b48b708983effb2e5c935a1ef8483d9e3e"
RUN curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic
