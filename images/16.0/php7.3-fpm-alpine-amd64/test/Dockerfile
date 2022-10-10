FROM php:7.4-cli-alpine

COPY docker_test.sh /docker_test.sh

RUN set -ex; \
    chmod 755 /docker_test.sh; \
    apk add --update \
        curl \
        git \
    ;

CMD ["/docker_test.sh"]
