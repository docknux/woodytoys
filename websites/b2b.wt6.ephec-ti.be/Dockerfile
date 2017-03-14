FROM httpd:alpine
MAINTAINER Denis Pettens <denis.pettens@gmail.com>

# Install php
RUN set -x \
    && apk update \
    && apk add --upgrade curl php7 php7-apache2 php7-pdo php7-pdo_mysql \
    && rm -rf /var/cache/apk/*

# Symlink php7
RUN ln -s /usr/bin/php7 /usr/bin/php

# ServerRoot of apache
WORKDIR /usr/local/apache2

# Change AllowOverride None to All in DocumentRoot Directory to allow htaccess file
RUN set -x \
    && sed -i -e '#^<Directory "/usr/local/apache2/htdocs">$#b' -e '0,/AllowOverride/ s/AllowOverride None/AllowOverride All/' conf/httpd.conf

EXPOSE 80
CMD ["httpd-foreground"]
