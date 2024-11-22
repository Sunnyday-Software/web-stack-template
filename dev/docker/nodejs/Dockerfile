FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive

ENV USER=sunnyday
ENV GROUP=sunnyday
ENV TZ=UTC
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# explicitly set user/group IDs
RUN set -eux; \
    groupadd -r $GROUP --gid=999; \
    useradd -r -g $GROUP --uid=999 --home-dir=/var/lib/$USER --shell=/bin/bash $USER; \
    install --verbose --directory --owner $USER --group $GROUP --mode 1777 /var/lib/$USER

RUN apt-get update -y; \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    dumb-init \
    gosu \
    tzdata \
    jq \
    bash \
    openssl \
    rsync \
    dos2unix \
    curl \
    gnupg \
    screen \
    ;

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && dpkg-reconfigure tzdata \

# installa nodejs as per https://github.com/nodesource/distributions?tab=readme-ov-file
# Le librerie di canvas danno errore con node 22,
# fare riferimento a https://github.com/Automattic/node-canvas/issues/2448
RUN set -ex; \
    curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh; \
    bash nodesource_setup.sh; \
    apt-get install -y --no-install-recommends nodejs; \
    node --version

## Configure npm
RUN npm config set fund false
RUN npm config set cache /var/npm-cache

## Npm cache
VOLUME /var/npm-cache

EXPOSE 3000

WORKDIR /app

COPY docker-entrypoint.sh /usr/local/bin/
RUN dos2unix /usr/local/bin/*.sh ; \
    chmod +x /usr/local/bin/*.sh;

ENTRYPOINT ["docker-entrypoint.sh"]

# Imposta l'entrypoint per eseguire lo script passato come parametro
CMD ["echo 'Nessuno script specificato.'"]

