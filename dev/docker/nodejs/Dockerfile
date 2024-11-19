FROM ubuntu:noble

ENV USER=sunnyday
ENV GROUP=sunnyday

# explicitly set user/group IDs
RUN set -eux; \
    groupadd -r $GROUP --gid=999; \
    useradd -r -g $GROUP --uid=999 $USER

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

RUN mkdir -p /etc/apt/keyrings;
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg;

RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" |  tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update -y; \
    apt-get install -y --no-install-recommends \
    nodejs \
    ;

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

