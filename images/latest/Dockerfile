FROM php:5.6-apache

LABEL maintainer="mb.mathieu.brunot@gmail.com"

ENV DOLI_VERSION develop

ENV DOLI_DB_TYPE mysqli
ENV DOLI_DB_HOST mysql
ENV DOLI_DB_PORT 3306
ENV DOLI_DB_USER doli
ENV DOLI_DB_PASSWORD doli_pass
ENV DOLI_DB_NAME dolidb
ENV DOLI_DB_PREFIX llx_


ENV DOLI_ADMIN_LOGIN admin
ENV DOLI_ADMIN_PASSWORD admin
ENV DOLI_URL_ROOT 'http://localhost'

ENV DOLI_AUTH dolibarr
ENV DOLI_LDAP_HOST 127.0.0.1
ENV DOLI_LDAP_PORT 389
ENV DOLI_LDAP_VERSION 3
ENV DOLI_LDAP_SERVERTYPE openldap
ENV DOLI_LDAP_LOGIN_ATTRIBUTE uid
ENV DOLI_LDAP_DN ou=People,dc=company,dc=com
ENV DOLI_LDAP_FILTER ''
ENV DOLI_LDAP_ADMIN_LOGIN ''
ENV DOLI_LDAP_ADMIN_PASS ''
ENV DOLI_LDAP_DEBUG false

ENV DOLI_HTTPS 0
ENV DOLI_PROD 0

ENV WWW_USER_ID 33
ENV WWW_GROUP_ID 33

ENV PHP_INI_DATE_TIMEZONE 'UTC'

RUN apt-get update -q && apt-get upgrade -yq \
	&& apt-get install -yq \
		libpng-dev \
		libjpeg-dev \
    	libxml2-dev \
		postgresql-dev \
		unzip \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli pgsql ldap soap zip

# Get Dolibarr
ADD https://github.com/Dolibarr/dolibarr/archive/${DOLI_VERSION}.zip /tmp/dolibarr.zip
RUN unzip -q /tmp/dolibarr.zip -d /tmp/dolibarr
RUN cp -r /tmp/dolibarr/dolibarr-${DOLI_VERSION}/htdocs/* /var/www/html/ && ln -s /var/www/html /var/www/htdocs
RUN cp -r /tmp/dolibarr/dolibarr-${DOLI_VERSION}/scripts /var/www/
RUN rm -rf /tmp/dolibarr

EXPOSE 80

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
