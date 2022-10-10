[![License: AGPL v3][uri_license_image]][uri_license]
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2da2a49afafc46b19275d1f8eb849f8e)](https://www.codacy.com/gh/Monogramm/docker-dolibarr?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Monogramm/docker-dolibarr&amp;utm_campaign=Badge_Grade)
[![Build Status](https://travis-ci.org/Monogramm/docker-dolibarr.svg)](https://travis-ci.org/Monogramm/docker-dolibarr)
[![Docker Automated buid](https://img.shields.io/docker/cloud/build/monogramm/docker-dolibarr.svg)](https://hub.docker.com/r/monogramm/docker-dolibarr/)
[![Docker Pulls](https://img.shields.io/docker/pulls/monogramm/docker-dolibarr.svg)](https://hub.docker.com/r/monogramm/docker-dolibarr/)
[![Docker Version](https://images.microbadger.com/badges/version/monogramm/docker-dolibarr.svg)](https://microbadger.com/images/monogramm/docker-dolibarr)
[![Docker Size](https://images.microbadger.com/badges/image/monogramm/docker-dolibarr.svg)](https://microbadger.com/images/monogramm/docker-dolibarr)
[![GitHub stars](https://img.shields.io/github/stars/Monogramm/docker-dolibarr?style=social)](https://github.com/Monogramm/docker-dolibarr)

# Dolibarr on Docker

Docker image for Dolibarr.

Provides full database configuration, production mode, HTTPS enforcer (SSL must be provided by reverse proxy), handles upgrades, and so on...

## What is Dolibarr

Dolibarr ERP & CRM is a modern software package to manage your organization's activity (contacts, suppliers, invoices, orders, stocks, agenda, ...).

> [More informations](https://github.com/dolibarr/dolibarr)

## Supported tags and respective `Dockerfile` links

[Dockerhub monogramm/docker-dolibarr/](https://hub.docker.com/r/monogramm/docker-dolibarr/)

Tags:

<!-- >Docker Tags -->

-   16.0.1-apache 16.0-apache apache 16.0.1 16.0 latest  (`images/16.0/php7.3-apache-amd64/Dockerfile`)
-   16.0.1-apache 16.0-apache apache 16.0.1 16.0 latest  (`images/16.0/php7.3-apache-i386/Dockerfile`)
-   16.0.1-fpm 16.0-fpm fpm  (`images/16.0/php7.3-fpm-amd64/Dockerfile`)
-   16.0.1-fpm 16.0-fpm fpm  (`images/16.0/php7.3-fpm-i386/Dockerfile`)
-   16.0.1-fpm-alpine 16.0-fpm-alpine fpm-alpine  (`images/16.0/php7.3-fpm-alpine-amd64/Dockerfile`)
-   16.0.1-fpm-alpine 16.0-fpm-alpine fpm-alpine  (`images/16.0/php7.3-fpm-alpine-i386/Dockerfile`)
-   15.0.3-apache 15.0-apache 15.0.3 15.0  (`images/15.0/php7.3-apache-amd64/Dockerfile`)
-   15.0.3-apache 15.0-apache 15.0.3 15.0  (`images/15.0/php7.3-apache-i386/Dockerfile`)
-   15.0.3-fpm 15.0-fpm  (`images/15.0/php7.3-fpm-amd64/Dockerfile`)
-   15.0.3-fpm 15.0-fpm  (`images/15.0/php7.3-fpm-i386/Dockerfile`)
-   15.0.3-fpm-alpine 15.0-fpm-alpine  (`images/15.0/php7.3-fpm-alpine-amd64/Dockerfile`)
-   15.0.3-fpm-alpine 15.0-fpm-alpine  (`images/15.0/php7.3-fpm-alpine-i386/Dockerfile`)
-   14.0.5-apache 14.0-apache 14.0.5 14.0  (`images/14.0/php7.3-apache-amd64/Dockerfile`)
-   14.0.5-apache 14.0-apache 14.0.5 14.0  (`images/14.0/php7.3-apache-i386/Dockerfile`)
-   14.0.5-fpm 14.0-fpm  (`images/14.0/php7.3-fpm-amd64/Dockerfile`)
-   14.0.5-fpm 14.0-fpm  (`images/14.0/php7.3-fpm-i386/Dockerfile`)
-   14.0.5-fpm-alpine 14.0-fpm-alpine  (`images/14.0/php7.3-fpm-alpine-amd64/Dockerfile`)
-   14.0.5-fpm-alpine 14.0-fpm-alpine  (`images/14.0/php7.3-fpm-alpine-i386/Dockerfile`)
-   13.0.5-apache 13.0-apache 13.0.5 13.0  (`images/13.0/php7.3-apache-amd64/Dockerfile`)
-   13.0.5-apache 13.0-apache 13.0.5 13.0  (`images/13.0/php7.3-apache-i386/Dockerfile`)
-   13.0.5-fpm 13.0-fpm  (`images/13.0/php7.3-fpm-amd64/Dockerfile`)
-   13.0.5-fpm 13.0-fpm  (`images/13.0/php7.3-fpm-i386/Dockerfile`)
-   13.0.5-fpm-alpine 13.0-fpm-alpine  (`images/13.0/php7.3-fpm-alpine-amd64/Dockerfile`)
-   13.0.5-fpm-alpine 13.0-fpm-alpine  (`images/13.0/php7.3-fpm-alpine-i386/Dockerfile`)
-   12.0.5-apache 12.0-apache 12.0.5 12.0  (`images/12.0/php7.3-apache-amd64/Dockerfile`)
-   12.0.5-apache 12.0-apache 12.0.5 12.0  (`images/12.0/php7.3-apache-i386/Dockerfile`)
-   12.0.5-fpm 12.0-fpm  (`images/12.0/php7.3-fpm-amd64/Dockerfile`)
-   12.0.5-fpm 12.0-fpm  (`images/12.0/php7.3-fpm-i386/Dockerfile`)
-   12.0.5-fpm-alpine 12.0-fpm-alpine  (`images/12.0/php7.3-fpm-alpine-amd64/Dockerfile`)
-   12.0.5-fpm-alpine 12.0-fpm-alpine  (`images/12.0/php7.3-fpm-alpine-i386/Dockerfile`)
-   11.0.5-apache 11.0-apache 11.0.5 11.0  (`images/11.0/php7.3-apache-amd64/Dockerfile`)
-   11.0.5-apache 11.0-apache 11.0.5 11.0  (`images/11.0/php7.3-apache-i386/Dockerfile`)
-   11.0.5-fpm 11.0-fpm  (`images/11.0/php7.3-fpm-amd64/Dockerfile`)
-   11.0.5-fpm 11.0-fpm  (`images/11.0/php7.3-fpm-i386/Dockerfile`)
-   11.0.5-fpm-alpine 11.0-fpm-alpine  (`images/11.0/php7.3-fpm-alpine-amd64/Dockerfile`)
-   11.0.5-fpm-alpine 11.0-fpm-alpine  (`images/11.0/php7.3-fpm-alpine-i386/Dockerfile`)
-   develop-apache develop-apache develop develop  (`images/develop/php7.3-apache-amd64/Dockerfile`)
-   develop-apache develop-apache develop develop  (`images/develop/php7.3-apache-i386/Dockerfile`)
-   develop-fpm develop-fpm  (`images/develop/php7.3-fpm-amd64/Dockerfile`)
-   develop-fpm develop-fpm  (`images/develop/php7.3-fpm-i386/Dockerfile`)
-   develop-fpm-alpine develop-fpm-alpine  (`images/develop/php7.3-fpm-alpine-amd64/Dockerfile`)
-   develop-fpm-alpine develop-fpm-alpine  (`images/develop/php7.3-fpm-alpine-i386/Dockerfile`)

<!-- <Docker Tags -->

<!--
## Quick reference

-   **Supported architectures**: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
    -   [`amd64`](https://hub.docker.com/r/amd64/php/)
    -   [`arm32v5`](https://hub.docker.com/r/arm32v5/php/)
    -   [`arm32v6`](https://hub.docker.com/r/arm32v6/php/)
    -   [`arm32v7`](https://hub.docker.com/r/arm32v7/php/)
    -   [`arm64v8`](https://hub.docker.com/r/arm64v8/php/)
    -   [`i386`](https://hub.docker.com/r/i386/php/)
    -   [`ppc64le`](https://hub.docker.com/r/ppc64le/php/)
-->

## How to run this image

This image is based on the [officiel PHP repository](https://registry.hub.docker.com/_/php/).
It is inspired from [nextcloud](https://github.com/nextcloud/docker) and [tuxgasy/docker-dolibarr](https://github.com/tuxgasy/docker-dolibarr).

This image does not contain the database for Dolibarr. You need to use either an existing database or a database container.

This image is designed to be used in a micro-service environment. There are two versions of the image you can choose from.

The `apache` tag contains a full Dolibarr installation including an apache web server. It is designed to be easy to use and gets you running pretty fast. This is also the default for the `latest` tag and version tags that are not further specified.

The second option is a `fpm` container. It is based on the [php-fpm](https://hub.docker.com/_/php/) image and runs a fastCGI-Process that serves your Dolibarr page. To use this image it must be combined with any webserver that can proxy the http requests to the FastCGI-port of the container.

## Using the apache image

The apache image contains a webserver and exposes port 80. To start the container type:

```shell
$ docker run -d -e DOLI_AUTO_CONFIGURE='' -p 8080:80 monogramm/docker-dolibarr
```

Now you can access Dolibarr at <http://localhost:8080/> from your host system.

## Using the fpm image

To use the fpm image you need an additional web server that can proxy http-request to the fpm-port of the container. For fpm connection this container exposes port 9000. In most cases you might want use another container or your host as proxy.
If you use your host you can address your Dolibarr container directly on port 9000. If you use another container, make sure that you add them to the same docker network (via `docker run --network <NAME> ...` or a `docker-compose` file).
In both cases you don't want to map the fpm port to you host.

```shell
$ docker run -d -e DOLI_AUTO_CONFIGURE='' monogramm/docker-dolibarr:fpm
```

As the fastCGI-Process is not capable of serving static files (style sheets, images, ...) the webserver needs access to these files. This can be achieved with the `volumes-from` option. You can find more information in the docker-compose section.

## Using an external database

By default this container does not contain the database for Dolibarr. You need to use either an existing database or a database container.

The Dolibarr setup wizard (should appear on first run) allows connecting to an existing MySQL/MariaDB or PostgreSQL database. You can also link a database container, e. g. `--link my-mysql:mysql`, and then use `mysql` as the database host on setup. More info is in the docker-compose section.

## Persistent data

The Dolibarr installation and all data beyond what lives in the database (file uploads, etc) are stored in the [unnamed docker volume](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume) volume `/var/www/html` and  `/var/www/documents`. The docker daemon will store that data within the docker directory `/var/lib/docker/volumes/...`. That means your data is saved even if the container crashes, is stopped or deleted.

To make your data persistent to upgrading and get access for backups is using named docker volume or mount a host folder. To achieve this you need one volume for your database container and Dolibarr.

Dolibarr:

-   `/var/www/html/` folder where all Dolibarr data lives
-   `/var/www/documents/` folder where all Dolibarr documents lives

```shell
$ docker run -d \
    -v dolibarr_html:/var/www/html \
    -v dolibarr_docs:/var/www/documents \
    -e DOLI_AUTO_CONFIGURE='' \
    monogramm/docker-dolibarr
```

Database:

-   `/var/lib/mysql` MySQL / MariaDB Data
-   `/var/lib/postgresql/data` PostgreSQL Data

```shell
$ docker run -d \
    -v db:/var/lib/mysql \
    mariadb \
    --character_set_client=utf8 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --character-set-client-handshake=FALSE
```

If you want to get fine grained access to your individual files, you can mount additional volumes for config, your theme and custom modules.
The `conf` is stored in subfolder inside `/var/www/html/`. The modules are split into core `apps` (which are shipped with Dolibarr and you don't need to take care of) and a `custom` folder. If you use a custom theme it would go into the `theme` subfolder.

Overview of the folders that can be mounted as volumes:

-   `/var/www/html` Main folder, needed for updating
-   `/var/www/html/custom` installed / modified modules
-   `/var/www/html/conf` local configuration
-   `/var/www/html/theme/<YOUR_CUSTOM_THEME>` theming/branding

If you want to use named volumes for all of these it would look like this

```shell
$ docker run -d \
    -v dolibarr:/var/www/html \
    -v apps:/var/www/html/custom \
    -v config:/var/www/html/conf \
    -v theme:/var/www/html/theme/<YOUR_CUSTOM_THEME> \
    -e DOLI_AUTO_CONFIGURE='' \
    monogramm/docker-dolibarr
```

## Auto configuration via environment variables

The Dolibarr image supports auto configuration via environment variables. You can preconfigure nearly everything that is asked on the install page on first run. To enable auto configuration, set your database connection via the following environment variables. ONLY use one database type!

See [conf.php.example](https://github.com/Dolibarr/dolibarr/blob/develop/htdocs/conf/conf.php.example) and [install.forced.sample.php](https://github.com/Dolibarr/dolibarr/blob/develop/htdocs/install/install.forced.sample.php) for more details on install configuration.

### DOLI_AUTO_CONFIGURE

_Default value_: `1`

_Possible values_: `1`, `''`

This parameter triggers the Dolibarr default configuration generation based on environment variables.

Examples:
```properties
    DOLI_AUTO_CONFIGURE=1
    DOLI_AUTO_CONFIGURE=''
```

### DOLI_DB_TYPE

_Default value_: `mysqli`

_Possible values_: `mysqli`, `pgsql`

This parameter contains the name of the driver used to access your Dolibarr database.

Examples:
```properties
    DOLI_DB_TYPE=mysqli
    DOLI_DB_TYPE=pgsql
```

### DOLI_DB_HOST

_Default value_:

This parameter contains host name or ip address of Dolibarr database server.

Examples:
```properties
    DOLI_DB_HOST=localhost
    DOLI_DB_HOST=127.0.2.1
    DOLI_DB_HOST=192.168.0.10
    DOLI_DB_HOST=mysql.myserver.com
```

### DOLI_DB_PORT

_Default value_: `3306`

This parameter contains the port of the Dolibarr database.

Examples:
```properties
    DOLI_DB_PORT=3306
    DOLI_DB_PORT=5432
```

### DOLI_DB_NAME

_Default value_: `dolibarr`

This parameter contains name of Dolibarr database.

Examples:
```properties
    DOLI_DB_NAME=dolibarr
    DOLI_DB_NAME=mydatabase
```

### DOLI_DB_USER

_Default value_: `dolibarr`

This parameter contains user name used to read and write into Dolibarr database.

Examples:
```properties
    DOLI_DB_USER=admin
    DOLI_DB_USER=dolibarruser
```

### DOLI_DB_PASSWORD

_Default value_:

This parameter contains password used to read and write into Dolibarr database.

Examples:
```properties
    DOLI_DB_PASSWORD=myadminpass
    DOLI_DB_PASSWORD=myuserpassword
```

### DOLI_DB_PREFIX

_Default value_: `llx_`

This parameter contains prefix of Dolibarr database.

Examples:
```properties
    DOLI_DB_PREFIX=llx_
```

### DOLI_DB_CHARACTER_SET

_Default value_: `utf8`

Database character set used to store data (forced during database creation. value of database is then used).
Depends on database driver used. See `DOLI_DB_TYPE`.

Examples:
```properties
    DOLI_DB_CHARACTER_SET=utf8
```

### DOLI_DB_COLLATION

_Default value_: `utf8_unicode_ci`

Database collation used to sort data (forced during database creation. value of database is then used).
Depends on database driver used. See `DOLI_DB_TYPE`.

Examples:
```properties
    DOLI_DB_COLLATION=utf8_unicode_ci
```

### DOLI_DB_ROOT_LOGIN

_Default value_:

This parameter contains the database server root username used to create the Dolibarr database.

If this parameter is set, the container will automatically tell Dolibarr to create the database on first install with the root account.

Examples:
```properties
    DOLI_DB_ROOT_LOGIN=root
    DOLI_DB_ROOT_LOGIN=dolibarruser
```

### DOLI_DB_ROOT_PASSWORD

_Default value_:

This parameter contains the database server root password used to create the Dolibarr database.

Examples:
```properties
    DOLI_DB_ROOT_PASSWORD=myrootpass
```

### DOLI_ADMIN_LOGIN

_Default value_: `admin`

This parameter contains the admin's login used in the first install.

Examples:
```properties
    DOLI_ADMIN_LOGIN=admin
```

### DOLI_MODULES

_Default value_:

This parameter contains the list (comma separated) of modules to enable in the first install.

Examples:
```properties
    DOLI_MODULES=modSociete
    DOLI_MODULES=modSociete,modPropale,modFournisseur,modContrat,modLdap
```

### DOLI_URL_ROOT

_Default value_: `http://localhost`

This parameter defines the root URL of your Dolibarr index.php page without ending "/".
It must link to the directory htdocs.
In most cases, this is autodetected but it's still required

-   to show full url bookmarks for some services (ie: agenda rss export url, ...)
-   or when using Apache dir aliases (autodetect fails)
-   or when using nginx (autodetect fails)

Examples:
```properties
    DOLI_URL_ROOT=http://localhost
    DOLI_URL_ROOT=http://mydolibarrvirtualhost
    DOLI_URL_ROOT=http://myserver/dolibarr/htdocs
    DOLI_URL_ROOT=http://myserver/dolibarralias
```

### DOLI_AUTH

_Default value_: `dolibarr`

_Possible values_: Any values found in files in htdocs/core/login directory after the `function_` string and before the `.php` string, **except forceuser**. You can also separate several values using a `,`. In this case, Dolibarr will check login/pass for each value in order defined into value. However, note that this can't work with all values.

This parameter contains the way authentication is done.
**Will not be used if you use first install wizard.** See _First use_ for more details.

If value `ldap` is used, you must also set parameters `DOLI_LDAP_*` and `DOLI_MODULES` must contain `modLdap`.

Examples:
```properties
    DOLI_AUTH=http
    DOLI_AUTH=dolibarr
    DOLI_AUTH=ldap
    DOLI_AUTH=openid,dolibarr
```

### DOLI_LDAP_HOST

_Default value_:

You can define several servers here separated with a comma.

Examples:
```properties
    DOLI_LDAP_HOST=localhost
    DOLI_LDAP_HOST=ldap.company.com
    DOLI_LDAP_HOST=ldaps://ldap.company.com:636,ldap://ldap.company.com:389
```

### DOLI_LDAP_PORT

_Default value_: `389`

### DOLI_LDAP_VERSION

_Default value_: `3`

### DOLI_LDAP_SERVERTYPE

_Default value_: `openldap`
_Possible values_: `openldap`, `activedirectory` or `egroupware`

### DOLI_LDAP_DN

_Default value_:

Examples:
```properties
    DOLI_LDAP_DN=ou=People,dc=company,dc=com
```

### DOLI_LDAP_LOGIN_ATTRIBUTE

_Default value_: `uid`

Ex: uid or samaccountname for active directory

### DOLI_LDAP_FILTER

_Default value_:

If defined, the two previous parameters are not used to find a user into LDAP.

Examples:
```properties
    DOLI_LDAP_FILTER=(uid=%1%)
    DOLI_LDAP_FILTER=(&(uid=%1%)(isMemberOf=cn=Sales,ou=Groups,dc=company,dc=com))
```

### DOLI_LDAP_ADMIN_LOGIN

_Default value_:

Required only if anonymous bind disabled.

Examples:
```properties
    DOLI_LDAP_ADMIN_LOGIN=cn=admin,dc=company,dc=com
```

### DOLI_LDAP_ADMIN_PASS

_Default value_:

Required only if anonymous bind disabled. Ex:

Examples:
```properties
    DOLI_LDAP_ADMIN_PASS=secret
```

### DOLI_LDAP_DEBUG

_Default value_: `false`

### DOLI_PROD

_Default value_: `0`

_Possible values_: `0` or `1`

When this parameter is defined, all errors messages are not reported.
This feature exists for production usage to avoid to give any information to hackers.

Examples:
```properties
    DOLI_PROD=0
    DOLI_PROD=1
```

### DOLI_HTTPS

_Default value_: `0`

_Possible values_: `0`, `1`, `2` or `https://my.domain.com`

This parameter allows to force the HTTPS mode.

-   `0` = No forced redirect
-   `1` = Force redirect to https, until `SCRIPT_URI` start with https into response
-   `2` = Force redirect to https, until `SERVER["HTTPS"]` is 'on' into response
-   `https://my.domain.com` = Force redirect to https using this domain name.

_Warning_: If you enable this parameter, your web server must be configured to
respond URL with https protocol.
According to your web server setup, some values may work and other not. Try
different values (`1`, `2` or `https://my.domain.com`) if you experience problems.

Examples:
```properties
    DOLI_HTTPS=0
    DOLI_HTTPS=1
    DOLI_HTTPS=2
    DOLI_HTTPS=https://my.domain.com
```

### DOLI_NO_CSRF_CHECK

_Default value_: `0`

_Possible values_: `0`, `1`

This parameter can be used to disable CSRF protection.

This might be required if you access Dolibarr behind a proxy that make URL rewriting, to avoid false alarms.

Examples:
```properties
    DOLI_NO_CSRF_CHECK=0
    DOLI_NO_CSRF_CHECK=1
```

### PHP_INI_DATE_TIMEZONE

_Default value_: `UTC`

Default timezone on PHP.

### PHP_MEMORY_LIMIT

_Default value_: `256M`

Default memory limit on PHP.

### PHP_MAX_UPLOAD

_Default value_: `20M`

Default max upload size on PHP.

### PHP_MAX_EXECUTION_TIME

_Default value_: `300`

Default max execution time (in seconds) on PHP.

### WWW_USER_ID

_Default value_: `33`

ID of user www-data. ID will not change if left empty. During development, it is very practical to put the same ID as the host user.

### WWW_GROUP_ID

_Default value_: `33`

ID of group www-data. ID will not change if left empty.

## Running this image with docker-compose

### Base version - apache with MariaDB/MySQL

This version will use the apache image and add a [MariaDB](https://hub.docker.com/_/mariadb/) container (you can also use [MySQL](https://hub.docker.com/_/mysql/) if you prefer). The volumes are set to keep your data persistent. This setup provides **no ssl encryption** and is intended to run behind a proxy.

Make sure to set the variables `MYSQL_ROOT_PASSWORD`, `MYSQL_PASSWORD`, `DOLI_DB_PASSWORD` before you run this setup.

Create `docker-compose.yml` file using [docker-compose_apache.yml](/template/docker-compose.apache.test.yml) as template.

Then run all services `docker-compose up -d`. Now, go to <http://localhost:80/install> to access the new Dolibarr installation wizard.
In this example, the Dolibarr scripts, documents, HTML and database will all be stored locally in the following folders:

-   `/srv/dolibarr/html`
-   `/srv/dolibarr/scripts`
-   `/srv/dolibarr/documents`
-   `/srv/dolibarr/db`

## Base version - FPM with PostgreSQL

When using the FPM image you need another container that acts as web server on port 80 and proxies the requests to the Dolibarr container. In this example a simple nginx container is combined with the monogramm/docker-dolibarr-fpm image and a [PostgreSQL](https://hub.docker.com/_/postgres/) database container. The data is stored in docker volumes. The nginx container also need access to static files from your Dolibarr installation. It gets access to all the volumes mounted to Dolibarr via the `volumes_from` option. The configuration for nginx is stored in the configuration file `nginx.conf`, that is mounted into the container.

As this setup does **not include encryption** it should to be run behind a proxy.

Make sure to set the variables `POSTGRES_PASSWORD` and `DOLI_DB_PASSWORD` before you run this setup.

Create `docker-compose.yml` file using [docker-compose_fpm.yml](/template/docker-compose.fpm.test.yml) as template.

Here is a sample `nginx.conf` file expected to be in the same folder:
```nginx
    server {
        listen 80;
        server_name ${NGINX_HOST};

        root /var/www/html;
        index index.php;

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        location / {
            try_files $uri $uri/ index.php;
        }

        location ~ [^/]\.php(/|$) {
            # try_files $uri =404;
            fastcgi_split_path_info ^(.+?\.php)(/.*)$;
            fastcgi_pass dolibarr:9000;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $fastcgi_path_info;
        }

        location /api {
            if ( !-e $request_filename) {
                rewrite ^.* /api/index.php last;
            }
        }

    }
```

Then run all services `docker-compose up -d`. Now, go to <http://localhost:80/install> to access the new Dolibarr installation wizard.
In this example, the Dolibarr scripts, documents, HTML and database will all be stored in Docker's default location.
Feel free to edit this as you see fit.

## Make your Dolibarr available from the internet

Until here your Dolibarr is just available from you docker host. If you want you Dolibarr available from the internet adding SSL encryption is mandatory.

### HTTPS - SSL encryption

There are many different possibilities to introduce encryption depending on your setup.

We recommend using a reverse proxy in front of our Dolibarr installation. Your Dolibarr will only be reachable through the proxy, which encrypts all traffic to the clients. You can mount your manually generated certificates to the proxy or use a fully automated solution, which generates and renews the certificates for you.

## First use

When you first access your Dolibarr, you need to access the install wizard at `http://localhost/install/`.
The setup wizard will appear and ask you to choose an administrator account, password and the database connection. For the database use the name of your database container as host and `dolibarr` as table and user name. Also enter the database password you chose in your `docker-compose.yml` file.

Most of the fields of the wizard can be initialized with the environment variables.

You should note though that some environment variables will be ignored during install wizard (`DOLI_AUTH` and `DOLI_LDAP_*` for instance). An initial `conf.php` was generated by the container on the first start with the Dolibarr environment variables you set through Docker. To use the container generated configuration, you can skip the first step of install and go directly to <http://localhost:8080/install/step2.php>.

## Update to a newer version

Updating the Dolibarr container is done by pulling the new image, throwing away the old container and starting the new one. Since all data is stored in volumes, nothing gets lost. The startup script will check for the version in your volume and the installed docker version. If it finds a mismatch, it automatically starts the upgrade process. Don't forget to add all the volumes to your new container, so it works as expected. Also, we advised you do not skip major versions during your upgrade. For instance, upgrade from 5.0 to 6.0, then 6.0 to 7.0, not directly from 5.0 to 7.0.

```shell
$ docker pull monogramm/docker-dolibarr
$ docker stop <your_dolibarr_container>
$ docker rm <your_dolibarr_container>
$ docker run <OPTIONS> -d monogramm/docker-dolibarr
```

Beware that you have to run the same command with the options that you used to initially start your Dolibarr. That includes volumes, port mapping.

When using docker-compose your compose file takes care of your configuration, so you just have to run:

```shell
$ docker-compose pull
$ docker-compose up -d
```

## Adding Features

If the image does not include the packages you need, you can easily build your own image on top of it.
Start your derived image with the `FROM` statement and add whatever you like.

```Dockerfile
FROM monogramm/docker-dolibarr:apache

RUN ...

```

You can also clone this repository and use the [update.sh](update.sh) shell script to generate a new Dockerfile based on your own needs.

For instance, you could build a container based on Dolibarr develop branch by setting the `update.sh` versions like this:

```bash
versions=( "develop" )
```

Then simply call [update.sh](update.sh) script.

```shell
bash update.sh
```

Your Dockerfile(s) will be generated in the `images/develop` folder.

If you use your own Dockerfile you need to configure your docker-compose file accordingly. Switch out the `image` option with `build`. You have to specify the path to your Dockerfile. (in the example it's in the same directory next to the docker-compose file)

```yaml
  app:
    build: .
    links:
      - db
    volumes:
      - data:/var/www/html/data
      - config:/var/www/html/config
      - apps:/var/www/html/apps
    restart: always
```

**Updating** your own derived image is also very simple. When a new version of the Dolibarr image is available run:

```shell
docker build -t your-name --pull .
docker run -d your-name
```

or for docker-compose:

```shell
docker-compose build --pull
docker-compose up -d
```

The `--pull` option tells docker to look for new versions of the base image. Then the build instructions inside your `Dockerfile` are run on top of the new image.

## Questions / Issues

If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-dolibarr) and write an issue.  

[uri_license]: http://www.gnu.org/licenses/agpl.html

[uri_license_image]: https://img.shields.io/badge/License-AGPL%20v3-blue.svg
