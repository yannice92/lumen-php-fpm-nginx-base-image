# lumen-php-fpm-nginx-base-image

php-fpm pool location : /etc/php8/php-fpm.d/www.conf
php8 conf.d location : /etc/php8/conf.d/

running php-fpm : php-fpm8 -F

permission nginx:
chgrp -R 0 /var/lib/nginx /var/lib/nginx/logs /var/log/nginx && chmod -R g=u /var/lib/nginx /var/lib/nginx/logs /var/log/nginx
