FROM php:5.5-apache
RUN	apt-get update && docker-php-ext-install pdo_mysql
EXPOSE	80
#ADD ./html /var/www/html
CMD		apache2	-D FOREGROUND