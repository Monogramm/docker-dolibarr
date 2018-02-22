[![Build Status](https://travis-ci.org/madmath03/docker-dolibarr.svg)](https://travis-ci.org/madmath03/docker-dolibarr)

# Dolibarr on Docker

Docker image for Dolibarr.

Provides full database configuration, LDAP support.

## Supported tags

* `7.0.0` `7.0` `7` `latest`
* `7.0.0-php7` `7.0-php7` `7-php7` `php7`
* `6.0.5` `6.0` `6`
* `6.0.5-php7` `6.0-php7` `6-php7`
* `5.0.7` `5.0` `5`
* `5.0.7-php7` `5.0-php7` `5-php7`

## What is Dolibarr ?

Dolibarr ERP & CRM is a modern software package to manage your organization's activity (contacts, suppliers, invoices, orders, stocks, agenda, ...).

> [More informations](https://github.com/dolibarr/dolibarr)

## How to run this image ?

This image is based on the [officiel PHP repository](https://registry.hub.docker.com/_/php/).

**Important**: This image does not contain the database. So you need to use either an existing database or a database container.

#### MariaDB

Let's use [Docker Compose](https://docs.docker.com/compose/) to integrate it with [MariaDB](https://hub.docker.com/_/mariadb/) (you can also use [MySQL](https://hub.docker.com/_/mysql/) if you prefer).

Create `docker-compose.yml` file as following:

```
dolibarrdb:
    image: mariadb:latest
    restart: always
    environment:
        - MYSQL_ROOT_PASSWORD: root
        - MYSQL_DATABASE: dolibarr
        - MYSQL_USER=dolibarr
        - MYSQL_PASSWORD=password
    volumes:
        - /srv/dolibarrdb:/var/lib/mysql

dolibarr:
    image: madmath03/dolibarr
    depends_on:
        - dolibarrdb
    ports:
        - "80:80"
    environment:
        - DOLI_DB_HOST: dolibarrdb
        - DOLI_DB_NAME: dolibarr
        - DOLI_DB_USER: dolibarr
        - DOLI_DB_PASSWORD: password
        - DOLI_URL_ROOT: 'http://0.0.0.0'
        - PHP_INI_DATE_TIMEZONE: 'Europe/Paris'
```

Then run all services `docker-compose up -d`. Now, go to http://0.0.0.0 to access the new Dolibarr installation.

#### PostgreSQL

Let's now use [Docker Compose](https://docs.docker.com/compose/) to integrate it with [PostgreSQL](https://hub.docker.com/_/postgres/).

Create `docker-compose.yml` file as following:

```
dolibarrdb:
    image: postgres:latest
    restart: always
    environment:
        - "POSTGRES_DB=dolibarr"
        - "POSTGRES_USER=dolibarr"
        - "POSTGRES_PASSWORD=password"
    volumes:
        - /srv/dolibarrdb/data:/var/lib/postgresql/data

dolibarr:
    image: madmath03/dolibarr
    depends_on:
        - dolibarrdb
    ports:
        - "80:80"
    environment:
        - DOLI_DB_TYPE: pgsql
        - DOLI_DB_HOST: dolibarrdb
        - DOLI_DB_PORT: 5432
        - DOLI_DB_NAME: dolibarr
        - DOLI_DB_USER: dolibarr
        - DOLI_DB_PASSWORD: password
        - DOLI_URL_ROOT: 'http://0.0.0.0'
        - PHP_INI_DATE_TIMEZONE: 'Europe/Paris'
    volumes:
        - /srv/dolibarr/html:/var/www/html
        - /srv/dolibarr/documents:/var/www/documents
```

Then run all services `docker-compose up -d`. Now, go to http://0.0.0.0 to access the new Dolibarr installation.

## Environment variables summary

| Variable                      | Default value                 | Description |
| ----------------------------- | ------------------            | ----------- |
| **DOLI_DB_TYPE**              | *mysqli*                      | Database type. Possible values: mysqli, pgsql
| **DOLI_DB_HOST**              | *mysql*                       | Host name of the database server
| **DOLI_DB_PORT**              | *3306*                        | Port number of the database server
| **DOLI_DB_NAME**              | *dolidb*                      | Database name
| **DOLI_DB_USER**              | *doli*                        | Database user
| **DOLI_DB_PASSWORD**          | *doli_pass*                   | Database user's password
| **DOLI_DB_PREFIX**            | *llx_*                        | Database tables prefix
| **DOLI_ADMIN_LOGIN**          | *admin*                       | Admin's login create on the first boot
| **DOLI_ADMIN_PASSWORD**       | *admin*                       | Admin'password
| **DOLI_URL_ROOT**             | *http://localhost*            | Url root of the Dolibarr installation
| **DOLI_AUTH**                 | *dolibarr*                    | Login mode. Possible values: Any values found in files in htdocs/core/login directory after the "function_" string and before the ".php" string. You can also separate several values using a ",". In this case, Dolibarr will check login/pass for each value in order defined into value. However, note that this can't work with all values.
| **DOLI_LDAP_HOST**            | *127.0.0.1*                   | Host of the LDAP server
| **DOLI_LDAP_PORT**            | *389*                         | Port number of the LDAP server
| **DOLI_LDAP_VERSION**         | *3*                           | LDAP version
| **DOLI_LDAP_SERVERTYPE**      | *openldap*                    | LDAP server type. Possible values: openldap, activedirectory or egroupware
| **DOLI_LDAP_DN**              | *ou=People,dc=company,dc=com* | Base DN
| **DOLI_LDAP_LOGIN_ATTRIBUTE** | *uid*                         | LDAP login field. Possible values: uid or samaccountname for active directory
| **DOLI_LDAP_FILTER**          | **                            | If defined, two previous parameters are not used to find a user into LDAP. Ex: (uid=%1%) or &(uid=%1%)(isMemberOf=cn=Sales,ou=Groups,dc=company,dc=com).
| **DOLI_LDAP_ADMIN_LOGIN**     | **                            | Required only if anonymous bind disabled. Ex: cn=admin,dc=company,dc=com
| **DOLI_LDAP_ADMIN_PASS**      | **                            | Required only if anonymous bind disabled. Ex: secret
| **DOLI_LDAP_DEBUG**           | *false*                       | LDAP Debug
| **DOLI_HTTPS**                | *0*                           | Force the HTTPS mode. Can be used if Dolibarr is served through a secured reversed proxy. Possible values: 0 or 1
| **DOLI_PROD**                 | *0*                           | Production usage. When this parameter is defined, all errors messages are not reported. Possible values: 0 or 1
| **PHP_INI_DATE_TIMEZONE**     | *UTC*                         | Default timezone on PHP
| **WWW_USER_ID**               | *33*                          | ID of user www-data. ID will not changed if leave empty. During a development, it is very practical to put the same ID as the host user.
| **WWW_GROUP_ID**              | *33*                          | ID of group www-data. ID will not changed if leave empty.
