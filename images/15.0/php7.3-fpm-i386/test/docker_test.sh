#!/bin/sh

set -e

log() {
    echo "[$0] [$(date +%Y-%m-%dT%H:%M:%S)] $*"
}

################################################################################
# Testing docker containers

log "Waiting to ensure everything is fully ready for the tests..."
sleep 60

log "Checking main containers are reachable..."
if ! ping -c 10 -q "${DOCKER_TEST_CONTAINER}" ; then
    log 'Main container is not responding!'
    # TODO Display logs to help bug fixing
    #log 'Check the following logs for details:'
    #tail -n 100 logs/*.log
    exit 2
fi


################################################################################
# Success
log 'Docker tests successful'


################################################################################
# Automated Service Unit tests
# https://docs.docker.com/docker-hub/builds/automated-testing/
################################################################################

if [ -n "${DOCKER_WEB_CONTAINER}" ]; then

    if ! ping -c 10 -q "${DOCKER_WEB_CONTAINER}" ; then
        log 'Web container is not responding!'
        # TODO Display logs to help bug fixing
        #log 'Check the following logs for details:'
        #tail -n 100 logs/*.log
        exit 2
    fi

    DOCKER_WEB_CONTAINER_BASE_URL=http://${DOCKER_WEB_CONTAINER}:${DOCKER_WEB_PORT:-80}/
    log "Checking Health API: ${DOCKER_WEB_CONTAINER_BASE_URL}"
    curl "${DOCKER_WEB_CONTAINER_BASE_URL}"
    #curl --fail "${DOCKER_WEB_CONTAINER_BASE_URL}" | grep -q -e 'Login' || exit 1


    if [ ! -f /var/www/documents/install.lock ]; then
        log 'Installing Dolibarr...'

        mkdir -p /tmp/logs

        log 'Calling Dolibarr install (step 2)...'
        set +e
        curl -kL -o /tmp/logs/install_step2.html -s -w "%{http_code}" \
            -X POST "${DOCKER_WEB_CONTAINER_BASE_URL}/install/step2.php" \
            --data "testpost=ok&action=set&dolibarr_main_db_character_set=utf8&dolibarr_main_db_collation=utf8_unicode_ci&selectlang=fr_FR" \
            > /tmp/logs/install_step2.status
        set -e

        if ! grep -q 200 /tmp/logs/install_step2.status; then 
            log "Something went wrong during Dolibarr database installation. Check the logs for details: $(cat /tmp/logs/install_step2.html)"
            exit 1
        fi

        log 'Calling Dolibarr install (step 5)...'
        set +e
        curl -kL -o /tmp/logs/install_step5.html -s -w "%{http_code}" \
            -X POST "${DOCKER_WEB_CONTAINER_BASE_URL}/install/step5.php" \
            --data "testpost=ok&action=set&selectlang=fr_FR&pass=${DOLI_DB_PASSWORD}&pass_verif=${DOLI_DB_PASSWORD}" \
            > /tmp/logs/install_step5.status
        set -e

        if ! grep -q 200 /tmp/logs/install_step5.status; then 
            log "Something went wrong during Dolibarr administration setup. Check the logs for details: $(cat /tmp/logs/install_step5.html)"
            exit 1
        fi

        if [ ! -f /var/www/documents/install.lock ]; then
            log 'Something went wrong during Dolibarr install. Check the logs for details.'
            exit 1
        fi

    else
        log "Dolibarr already installed: $(cat /var/www/documents/install.lock)"
    fi

    log "Check Dolibarr app home page..."
    wget "${DOCKER_WEB_CONTAINER_BASE_URL}"

fi

################################################################################
# Success
echo "Docker app '${DOCKER_TEST_CONTAINER}' tests finished"
echo 'Check the CI reports and logs for details.'
exit 0
