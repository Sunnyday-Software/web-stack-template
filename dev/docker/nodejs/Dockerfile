FROM ubuntu:noble

RUN apt-get update -y; \
    apt-get install -y --no-install-recommends \
    bash \
    openssl \
    jq \
    rsync \
    dos2unix \
    curl \
    ca-certificates \
    gnupg \
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


# Imposta l'entrypoint per eseguire lo script passato come parametro
ENTRYPOINT ["bash", "-c"]
CMD ["echo 'Nessuno script specificato.'"]
