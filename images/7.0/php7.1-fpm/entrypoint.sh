#!/bin/bash
set -e

# version_greater A B returns whether A > B
function version_greater() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" ]];
}

# return true if specified directory is empty
function directory_empty() {
	[ -n "$(find "$1"/ -prune -empty)" ]
}

function run_as() {
	if [[ $EUID -eq 0 ]]; then
		su - www-data -s /bin/bash -c "$1"
	else
		bash -c "$1"
	fi
}


usermod -u $WWW_USER_ID www-data
groupmod -g $WWW_GROUP_ID www-data

if [ ! -d /var/www/documents ]; then
	mkdir -p /var/www/documents
fi

chown -R www-data:www-data /var/www


if [ ! -f /usr/local/etc/php/php.ini ]; then
	cat <<EOF > /usr/local/etc/php/php.ini
date.timezone = "${PHP_INI_DATE_TIMEZONE}"
memory_limit = "${PHP_MEMORY_LIMIT}"
upload_max_filesize = "${PHP_MAX_UPLOAD}"
max_execution_time = "${PHP_MAX_EXECUTION_TIME}"
sendmail_path = /usr/sbin/sendmail -t -i
extension = calendar.so
EOF
fi

if [ ! -d /var/www/html/conf/ ]; then
	mkdir -p /var/www/html/conf/
fi

# Create a default config if autoconfig enabled
if [ -n "$DOLI_AUTO_CONFIGURE" ] && [ ! -f /var/www/html/conf/conf.php ]; then
	cat <<EOF > /var/www/html/conf/conf.php
<?php
// Config file for Dolibarr ${DOLI_VERSION} ($(date --iso-8601=seconds))

// ###################
// # Main parameters #
// ###################
\$dolibarr_main_url_root='${DOLI_URL_ROOT}';
\$dolibarr_main_document_root='/var/www/html';
\$dolibarr_main_url_root_alt='/custom';
\$dolibarr_main_document_root_alt='/var/www/html/custom';
\$dolibarr_main_data_root='/var/www/documents';
\$dolibarr_main_db_host='${DOLI_DB_HOST}';
\$dolibarr_main_db_port='${DOLI_DB_PORT}';
\$dolibarr_main_db_name='${DOLI_DB_NAME}';
\$dolibarr_main_db_prefix='${DOLI_DB_PREFIX}';
\$dolibarr_main_db_user='${DOLI_DB_USER}';
\$dolibarr_main_db_pass='${DOLI_DB_PASSWORD}';
\$dolibarr_main_db_type='${DOLI_DB_TYPE}';
\$dolibarr_main_db_character_set='${DOLI_DB_CHARACTER_SET}';
\$dolibarr_main_db_collation='${DOLI_DB_COLLATION}';

// ##################
// # Login          #
// ##################
\$dolibarr_main_authentication='${DOLI_AUTH}';
\$dolibarr_main_auth_ldap_host='${DOLI_LDAP_HOST}';
\$dolibarr_main_auth_ldap_port='${DOLI_LDAP_PORT}';
\$dolibarr_main_auth_ldap_version='${DOLI_LDAP_VERSION}';
\$dolibarr_main_auth_ldap_servertype='${DOLI_LDAP_SERVERTYPE}';
\$dolibarr_main_auth_ldap_login_attribute='${DOLI_LDAP_LOGIN_ATTRIBUTE}';
\$dolibarr_main_auth_ldap_dn='${DOLI_LDAP_DN}';
\$dolibarr_main_auth_ldap_filter ='${DOLI_LDAP_FILTER}';
\$dolibarr_main_auth_ldap_admin_login='${DOLI_LDAP_ADMIN_LOGIN}';
\$dolibarr_main_auth_ldap_admin_pass='${DOLI_LDAP_ADMIN_PASS}';
\$dolibarr_main_auth_ldap_debug='${DOLI_LDAP_DEBUG}';

// ##################
// # Security       #
// ##################
\$dolibarr_main_prod='${DOLI_PROD}';
\$dolibarr_main_force_https='${DOLI_HTTPS}';
\$dolibarr_main_restrict_os_commands='mysqldump, mysql, pg_dump, pgrestore';
\$dolibarr_nocsrfcheck='${DOLI_NO_CSRF_CHECK}';
\$dolibarr_main_cookie_cryptkey='$(openssl rand -hex 32)';
\$dolibarr_mailing_limit_sendbyweb='0';
EOF

	chown www-data:www-data /var/www/html/conf/conf.php
	chmod 766 /var/www/html/conf/conf.php
fi

# Detect installed version (docker specific solution)
installed_version="0.0.0~unknown"
if [ -f /var/www/documents/install.version ]; then
	installed_version=$(cat /var/www/documents/install.version)
fi
image_version=${DOLI_VERSION}

if version_greater "$installed_version" "$image_version"; then
	echo "Can't start Dolibarr because the version of the data ($installed_version) is higher than the docker image version ($image_version) and downgrading is not supported. Are you sure you have pulled the newest image version?"
	exit 1
fi

# Initialize image
if version_greater "$image_version" "$installed_version"; then
	echo "Dolibarr initialization..."
	if [[ $EUID -eq 0 ]]; then
		rsync_options="-rlDog --chown www-data:root"
	else
		rsync_options="-rlD"
	fi

	mkdir -p /var/www/scripts
	rsync $rsync_options /usr/src/dolibarr/scripts/ /var/www/scripts/
	rsync $rsync_options --delete --exclude /conf/ --exclude /custom/ --exclude /theme/ /usr/src/dolibarr/htdocs/ /var/www/html/

	for dir in conf custom; do
		if [ ! -d /var/www/html/"$dir" ] || directory_empty /var/www/html/"$dir"; then
			rsync $rsync_options --include /"$dir"/ --exclude '/*' /usr/src/dolibarr/htdocs/ /var/www/html/
		fi
	done

	# The theme folder contains custom and official themes. We must copy even if folder is not empty, but not delete content either
	for dir in theme; do
		rsync $rsync_options --include /"$dir"/ --exclude '/*' /usr/src/dolibarr/htdocs/ /var/www/html/
	done

	if [ "$installed_version" != "0.0.0~unknown" ]; then
		# Call upgrade if needed
		# https://wiki.dolibarr.org/index.php/Installation_-_Upgrade#With_Dolibarr_.28standard_.zip_package.29
		echo "Dolibarr upgrade from $installed_version to $image_version..."

		if [ -f /var/www/documents/install.lock ]; then
			rm /var/www/documents/install.lock
		fi

		base_version=(${installed_version//./ })
		target_version=(${image_version//./ })

		run_as "cd /var/www/html/install/ && php upgrade.php ${base_version[0]}.${base_version[1]}.0 ${target_version[0]}.${target_version[1]}.0"
		run_as "cd /var/www/html/install/ && php upgrade2.php ${base_version[0]}.${base_version[1]}.0 ${target_version[0]}.${target_version[1]}.0"
		run_as "cd /var/www/html/install/ && php step5.php ${base_version[0]}.${base_version[1]}.0 ${target_version[0]}.${target_version[1]}.0"

		echo 'This is a lock file to prevent use of install pages (generated by container entrypoint)' > /var/www/documents/install.lock
		chown www-data:www-data /var/www/documents/install.lock
		chmod 400 /var/www/documents/install.lock
	elif [ ! -f /var/www/documents/install.lock ]; then
			# Create forced values for first install
			cat <<EOF > /var/www/html/install/install.forced.php
<?php
// Forced install config file for Dolibarr ${DOLI_VERSION} ($(date --iso-8601=seconds))

/** @var bool Hide PHP informations */
\$force_install_nophpinfo = true;

/** @var int 1 = Lock and hide environment variables, 2 = Lock all set variables */
\$force_install_noedit = 2;

/** @var string Information message */
\$force_install_message = 'Dolibarr installation';

/** @var string Data root absolute path (documents folder) */
\$force_install_main_data_root = '/var/www/documents';

/** @var bool Force HTTPS */
\$force_install_mainforcehttps = !empty('${DOLI_HTTPS}');

/** @var string Database name */
\$force_install_database = '${DOLI_DB_NAME}';

/** @var string Database driver (mysql|mysqli|pgsql|mssql|sqlite|sqlite3) */
\$force_install_type = '${DOLI_DB_TYPE}';

/** @var string Database server host */
\$force_install_dbserver = '${DOLI_DB_HOST}';

/** @var int Database server port */
\$force_install_port = '${DOLI_DB_PORT}';

/** @var string Database tables prefix */
\$force_install_prefix = '${DOLI_DB_PREFIX}';

/** @var string Database username */
\$force_install_databaselogin = '${DOLI_DB_USER}';

/** @var string Database password */
\$force_install_databasepass = '${DOLI_DB_PASSWORD}';

/** @var bool Force database user creation */
\$force_install_createdatabase = '${DOLI_DB_CREATE_USER}';
\$force_install_createdatabase = '${DOLI_DB_CREATE_DB}';

/** @var bool Force database creation */
\$force_install_createdatabase = '${DOLI_DB_CREATE_DB}';

/** @var string Database root username */
\$force_install_databaserootlogin = '${DOLI_DB_ROOT_LOGIN}';

/** @var string Database root password */
\$force_install_databaserootpass = '${DOLI_DB_ROOT_PASSWORD}';

/** @var string Dolibarr super-administrator username */
\$force_install_dolibarrlogin = '${DOLI_ADMIN_LOGIN}';

/** @var bool Force install locking */
\$force_install_lockinstall = true;

/** @var string Enable module(s) (Comma separated class names list) */
\$force_install_module = '${DOLI_MODULES}';
EOF

		# Add a symlink to /var/www/htdocs
		ln -s /var/www/html /var/www/htdocs

		echo "You shall complete Dolibarr install manually at '${DOLI_URL_ROOT}/install'"
	fi
fi

if [ ! -d /var/www/scripts ]; then
	cp /usr/src/dolibarr/scripts /var/www/scripts
fi

if [ -f /var/www/documents/install.lock ]; then
	echo $image_version > /var/www/documents/install.version
fi

exec "$@"
