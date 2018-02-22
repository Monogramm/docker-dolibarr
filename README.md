[![Build Status](https://travis-ci.org/madmath03/docker-dolibarr.svg)](https://travis-ci.org/madmath03/docker-dolibarr)

# Dolibarr on Docker

Docker image for Dolibarr.

Provides full database configuration, LDAP support, debug configuration and HTTPS enforcer (SSL must be provided by reverse proxy).

## Supported tags

* `7.0.0-apache` `7.0.0` `7.0-apache` `7.0` `7-apache` `7` `apache` `latest`
* `7.0.0-fpm` `7.0-fpm` `7-fpm` `fpm`
* `6.0.5-apache` `6.0.5` `6.0-apache` `6.0` `6-apache` `6`
* `6.0.5-fpm` `6.0-fpm` `6-fpm`
* `5.0.7-apache` `5.0.7` `5.0-apache` `5.0` `5-apache` `5`
* `5.0.7-fpm` `5.0-fpm` `5-fpm`

## What is Dolibarr ?

Dolibarr ERP & CRM is a modern software package to manage your organization's activity (contacts, suppliers, invoices, orders, stocks, agenda, ...).

> [More informations](https://github.com/dolibarr/dolibarr)

## How to run this image ?

This image is based on the [officiel PHP repository](https://registry.hub.docker.com/_/php/) and inspired from [tuxgasy/docker-dolibarr](https://github.com/tuxgasy/docker-dolibarr).

This image does not contain the database for Dolibarr. You need to use either an existing database or a database container.

It also does not provide an initialization mechanisms on first startup. You can either use the web interface for setup or get a look at [tuxgasy docker-run.sh](https://github.com/tuxgasy/docker-dolibarr/blob/master/docker-run.sh) for install script.

### Docker

```bash
docker run -d \
    -e DOLI_DB_HOST=localhost \
    -e DOLI_DB_NAME=dolibarr \
    -e DOLI_DB_USER=dolibarr \
    -e DOLI_DB_PASSWORD=password \
    madmath03/docker-dolibarr
```

### Docker Compose

#### Simple usage: MariaDB/MySQL

Let's use [Docker Compose](https://docs.docker.com/compose/) to integrate it with [MariaDB](https://hub.docker.com/_/mariadb/) (you can also use [MySQL](https://hub.docker.com/_/mysql/) if you prefer).

Create `docker-compose.yml` file as following:

```yml
mariadb:
    image: mariadb:latest
    restart: always
    environment:
        - MYSQL_ROOT_PASSWORD: 'root'
        - MYSQL_DATABASE: 'dolibarr'

dolibarr:
    image: madmath03/docker-dolibarr
    depends_on:
        - mariadb
    ports:
        - "80:80"
    environment:
        - DOLI_DB_HOST: 'mariadb'
        - DOLI_DB_NAME: 'dolibarr'
        - DOLI_DB_USER: 'root'
        - DOLI_DB_PASSWORD: 'root'
```

Then run all services `docker-compose up -d`. Now, go to http://localhost to access the new Dolibarr installation.

#### Advanced usage: PostgreSQL with persistent data

Let's now use [Docker Compose](https://docs.docker.com/compose/) to integrate it with [PostgreSQL](https://hub.docker.com/_/postgres/) and make your data persistent to upgrading and get access for backups.

Create `docker-compose.yml` file as following:

```yml
postgres:
    image: postgres:latest
    restart: always
    environment:
        - "POSTGRES_DB=dolibarr"
        - "POSTGRES_USER=dolibarr"
        - "POSTGRES_PASSWORD=password"
    volumes:
        - /srv/postgres/data:/var/lib/postgresql/data

dolibarr:
    image: madmath03/docker-dolibarr
    depends_on:
        - postgres
    ports:
        - "80:80"
    environment:
        - DOLI_DB_TYPE: 'pgsql'
        - DOLI_DB_HOST: 'postgres'
        - DOLI_DB_PORT: 5432
        - DOLI_DB_NAME: 'dolibarr'
        - DOLI_DB_USER: 'dolibarr'
        - DOLI_DB_PASSWORD: 'password'
        - DOLI_URL_ROOT: 'http://0.0.0.0'
        - PHP_INI_DATE_TIMEZONE: 'Europe/Paris'
    volumes:
        - /srv/dolibarr/html:/var/www/html
        - /srv/dolibarr/documents:/var/www/documents
```

## Create your own image

You can clone this repository and use the [update.sh](update.sh) shell script to generate a new Dockerfile based on your own needs.

For instance, you could build a container on Dolibarr develop branch by setting the versions like this:
```bash
versions=( "latest" )

...
```

Then simply call [update.sh](update.sh) script.

## Environment variables summary

Most environment variables are used to initialize Dolibarr `config.php`.
See [conf.php.example](https://github.com/Dolibarr/dolibarr/blob/develop/htdocs/conf/conf.php.example).


#### Main parameters

##### DOLI_DB_TYPE

*Default value*: `mysqli`

*Possible values*: `mysqli`, `pgsql`

This parameter contains the name of the driver used to access your Dolibarr database.

Examples:
```
DOLI_DB_TYPE='mysqli'
DOLI_DB_TYPE='pgsql'
```

##### DOLI_DB_HOST

*Default value*: `mysql`

This parameter contains host name or ip address of Dolibarr database server.

Examples:
```
DOLI_DB_HOST='localhost'
DOLI_DB_HOST='127.0.0.1'
DOLI_DB_HOST='192.168.0.10'
DOLI_DB_HOST='mysql.myserver.com'
```

##### DOLI_DB_PORT

*Default value*: `3306`

This parameter contains the port of the Dolibarr database.

Examples:
```
DOLI_DB_PORT='3306'
```

##### DOLI_DB_NAME

*Default value*: `dolidb`

This parameter contains name of Dolibarr database.

Examples:
```
DOLI_DB_NAME='dolibarr'
DOLI_DB_NAME='mydatabase'
```

##### DOLI_DB_USER

*Default value*: `doli`

This parameter contains user name used to read and write into Dolibarr database.

Examples:
```
DOLI_DB_USER='admin'
DOLI_DB_USER='dolibarruser'
```

##### DOLI_DB_PASSWORD

*Default value*: `doli_pass`

This parameter contains password used to read and write into Dolibarr database.

Examples:
```
DOLI_DB_PASSWORD='myadminpass'
DOLI_DB_PASSWORD='myuserpassword'
```

##### DOLI_DB_PREFIX

*Default value*: `llx_`

This parameter contains prefix of Dolibarr database.

Examples:
```
DOLI_DB_PREFIX='llx_'
```

##### DOLI_URL_ROOT

*Default value*: `http://localhost`

This parameter defines the root URL of your Dolibarr index.php page without ending "/".
It must link to the directory htdocs.
In most cases, this is autodetected but it's still required 
* to show full url bookmarks for some services (ie: agenda rss export url, ...)
* or when using Apache dir aliases (autodetect fails)
* or when using nginx (autodetect fails)

Examples:
```
DOLI_URL_ROOT='http://localhost'
DOLI_URL_ROOT='http://mydolibarrvirtualhost'
DOLI_URL_ROOT='http://myserver/dolibarr/htdocs'
DOLI_URL_ROOT='http://myserver/dolibarralias'
```


#### Login

##### DOLI_AUTH

*Default value*: `dolibarr`

*Possible values*: Any values found in files in htdocs/core/login directory after the `function_` string and before the `.php` string, **except forceuser**. You can also separate several values using a `,`. In this case, Dolibarr will check login/pass for each value in order defined into value. However, note that this can't work with all values.

This parameter contains the way authentication is done.
If value "ldap" is used, you must also set parameters DOLI_LDAP_*

Examples:
```
DOLI_AUTH='http'
DOLI_AUTH='dolibarr'
DOLI_AUTH='ldap'
DOLI_AUTH='openid,dolibarr'
```

##### DOLI_LDAP_HOST

*Default value*: `127.0.0.1`

You can define several servers here separated with a comma.

Examples:
```
DOLI_LDAP_HOST=localhost
DOLI_LDAP_HOST=ldap.company.com
DOLI_LDAP_HOST=ldaps://ldap.company.com:636,ldap://ldap.company.com:389
```

##### DOLI_LDAP_PORT

*Default value*: `389`

##### DOLI_LDAP_VERSION

*Default value*: `3`

##### DOLI_LDAP_SERVERTYPE

*Default value*: `openldap`
*Possible values*: `openldap`, `activedirectory` or `egroupware`

##### DOLI_LDAP_DN

*Default value*: `ou=People,dc=company,dc=com`

Examples:
```
DOLI_LDAP_DN=ou=People,dc=company,dc=com
```

##### DOLI_LDAP_LOGIN_ATTRIBUTE

*Default value*: `uid`

Ex: uid or samaccountname for active directory

##### DOLI_LDAP_FILTER

*Default value*: 

If defined, the two previous parameters are not used to find a user into LDAP.

Examples:
```
DOLI_LDAP_FILTER=(uid=%1%)
DOLI_LDAP_FILTER=(&(uid=%1%)(isMemberOf=cn=Sales,ou=Groups,dc=company,dc=com))
```

##### DOLI_LDAP_ADMIN_LOGIN

*Default value*: 

Required only if anonymous bind disabled.

Examples:
```
DOLI_LDAP_ADMIN_LOGIN=cn=admin,dc=company,dc=com
```

##### DOLI_LDAP_ADMIN_PASS

*Default value*: 

Required only if anonymous bind disabled. Ex: 

Examples:
```
DOLI_LDAP_ADMIN_PASS=secret
```

##### DOLI_LDAP_DEBUG

*Default value*: `false`


#### Security

##### DOLI_HTTPS

*Default value*: `0`

*Possible values*: `0`, `1`, `2` or `'https://my.domain.com'`

This parameter allows to force the HTTPS mode.
0 = No forced redirect
1 = Force redirect to https, until SCRIPT_URI start with https into response
2 = Force redirect to https, until SERVER["HTTPS"] is 'on' into response
'https://my.domain.com' = Force reditect to https using this domain name.

*Warning*: If you enable this parameter, your web server must be configured to
respond URL with https protocol. 
According to your web server setup, some values may work and other not. Try 
different values (1,2 or 'https://my.domain.com') if you experience problems.

Examples:
```
DOLI_HTTPS='0'
```

##### DOLI_PROD

*Default value*: `0`

*Possible values*: `0` or `1`

When this parameter is defined, all errors messages are not reported.
This feature exists for production usage to avoid to give any information to hackers.

Examples:
```
DOLI_PROD='0'
```


#### Other

##### PHP_INI_DATE_TIMEZONE

*Default value*: `UTC`

Default timezone on PHP.

##### WWW_USER_ID

*Default value*: `33`

ID of user www-data. ID will not change if left empty. During development, it is very practical to put the same ID as the host user.

##### WWW_GROUP_ID

*Default value*: `33`

ID of group www-data. ID will not change if left empty.
