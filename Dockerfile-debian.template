FROM php:%%PHP_VERSION%%-%%VARIANT%%

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>"

# Build time env var
ENV DOLI_VERSION=%%VERSION%%

# Get Dolibarr
ADD https://github.com/Dolibarr/dolibarr/archive/${DOLI_VERSION}.zip /tmp/dolibarr.zip

# Install the packages we need
# Install the PHP extensions we need
# see https://wiki.dolibarr.org/index.php/Dependencies_and_external_libraries
# Prepare folders
# Install Dolibarr from tag archive
RUN set -ex; \
	apt-get update -q; \
	apt-get install -y --no-install-recommends \
		mysql-client \
		rsync \
		sendmail \
	; \
	apt-get install -y --no-install-recommends \
		libcurl4-openssl-dev \
		libfreetype6-dev \
		libjpeg-dev \
		libldap2-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmcrypt-dev \
		libpng-dev \
		libpq-dev \
		libxml2-dev \
		unzip \
	; \
	rm -rf /var/lib/apt/lists/*; \
	debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
	docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch"; \
	docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install \
		calendar \
		gd \
		ldap \
		mbstring \
		mysqli \
		pdo \
		pdo_mysql \
		pdo_pgsql \
		pgsql \
		soap \
		zip \
	; \
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    mkdir -p /var/www/documents; \
    chown -R www-data:root /var/www; \
    chmod -R g=u /var/www; \
    mkdir -p /tmp/dolibarr; \
	unzip -q /tmp/dolibarr.zip -d /tmp/dolibarr; \
	rm /tmp/dolibarr.zip; \
	mkdir -p /usr/src/dolibarr; \
	cp -r /tmp/dolibarr/dolibarr-${DOLI_VERSION}/* /usr/src/dolibarr; \
	rm -rf /tmp/dolibarr; \
	chmod +x /usr/src/dolibarr/scripts/*

# Runtime env var
ENV DOLI_AUTO_CONFIGURE=1 \
	DOLI_DB_TYPE=mysqli \
	DOLI_DB_HOST= \
	DOLI_DB_PORT=3306 \
	DOLI_DB_USER=dolibarr \
	DOLI_DB_PASSWORD='' \
	DOLI_DB_NAME=dolibarr \
	DOLI_DB_PREFIX=llx_ \
	DOLI_DB_CHARACTER_SET=utf8 \
	DOLI_DB_COLLATION=utf8_unicode_ci \
	DOLI_DB_ROOT_LOGIN='' \
	DOLI_DB_ROOT_PASSWORD='' \
	DOLI_ADMIN_LOGIN=admin \
	DOLI_MODULES='' \
	DOLI_URL_ROOT='http://localhost' \
	DOLI_AUTH=dolibarr \
	DOLI_LDAP_HOST= \
	DOLI_LDAP_PORT=389 \
	DOLI_LDAP_VERSION=3 \
	DOLI_LDAP_SERVERTYPE=openldap \
	DOLI_LDAP_LOGIN_ATTRIBUTE=uid \
	DOLI_LDAP_DN='' \
	DOLI_LDAP_FILTER='' \
	DOLI_LDAP_ADMIN_LOGIN='' \
	DOLI_LDAP_ADMIN_PASS='' \
	DOLI_LDAP_DEBUG=false \
	DOLI_HTTPS=0 \
	DOLI_PROD=0 \
	DOLI_NO_CSRF_CHECK=0 \
	WWW_USER_ID=33 \
	WWW_GROUP_ID=33 \
	PHP_INI_DATE_TIMEZONE='UTC' \
	PHP_MEMORY_LIMIT=256M \
	PHP_MAX_UPLOAD=20M \
	PHP_MAX_EXECUTION_TIME=300

VOLUME /var/www/html /var/www/documents /var/www/scripts

COPY entrypoint.sh /
RUN set -ex; \
	chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["%%CMD%%"]
