FROM php:7.2-fpm

RUN apt-get update
RUN apt-get install libxml2-dev unzip libmcrypt-dev zlib1g-dev -y
#Using docker-php-ext-install to install php modules
RUN docker-php-ext-install pdo_mysql mysqli mbstring xml opcache zip

EXPOSE 9000
CMD ["php-fpm", "-F"]
