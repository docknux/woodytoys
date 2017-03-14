FROM php:apache
MAINTAINER Denis Pettens <denis.pettens@gmail.com>

# Install pdo mysql driver 
RUN docker-php-ext-install pdo pdo_mysql

COPY ./public-html/ /var/www/html/

EXPOSE 80
