#!/bin/sh

set -e

function log() {
    echo "[$0] [$(date -u +%Y-%m-%dT%H:%M:%SZ)] ${@}"
}

log "Waiting to ensure everything is fully ready for the tests..."
sleep 60

log "Checking main containers are reachable..."
if ! ping -c 10 -q dolibarr_db ; then
    log 'Dolibarr Database container is not responding!'
    # TODO Display logs to help bug fixing
    #echo 'Check the following logs for details:'
    #tail -n 100 logs/*.log
    exit 1
fi

if ! ping -c 10 -q dolibarr ; then
    log 'Dolibarr Main container is not responding!'
    # TODO Display logs to help bug fixing
    #echo 'Check the following logs for details:'
    #tail -n 100 logs/*.log
    exit 2
fi

# Add your own tests
# https://docs.docker.com/docker-hub/builds/automated-testing/
log "Check Dolibarr app home page..."
wget http://dolibarr:80

if [ ! -f /srv/dolibarr/documents/install.lock ]; then
    log 'Installing Dolibarr...'

    mkdir -p /tmp/logs

    log 'Calling Dolibarr install (step 2)...'
    curl -kL -o /tmp/logs/install_step2.html -s -w "%{http_code}" \
        -X POST "http://dolibarr:80/install/step2.php" \
        --data "testpost=ok&action=set&dolibarr_main_db_character_set=utf8&dolibarr_main_db_collation=utf8_unicode_ci&selectlang=fr_FR" > /tmp/logs/install_step2.status

    if ! grep -q 200 /tmp/logs/install_step2.status; then 
        log 'Something went wrong during Dolibarr database installation. Check the logs for details.' 2
        cat /tmp/logs/install_step2.html
        exit 1
    fi

    log 'Calling Dolibarr install (step 5)...'
    curl -kL -o /tmp/logs/install_step5.html -s -w "%{http_code}" \
        -X POST "http://dolibarr:80/install/step5.php" \
        --data "testpost=ok&action=set&selectlang=fr_FR&pass=${DOLIBARR_DB_PASSWORD}&pass_verif=${DOLIBARR_DB_PASSWORD}" > /tmp/logs/install_step5.status

    if ! grep -q 200 /tmp/logs/install_step5.status; then 
        log 'Something went wrong during Dolibarr administration setup. Check the logs for details.' 2
        cat /tmp/logs/install_step5.html
        exit 1
    fi

    if [ ! -f /srv/dolibarr/documents/install.lock ]; then
        log 'Something went wrong during Dolibarr install. Check the logs for details.' 2
        exit 1
    fi

else
    log 'Dolibarr already installed: $(cat /srv/dolibarr/documents/install.lock)'
fi

# Success
log 'Docker tests successful'
exit 0
