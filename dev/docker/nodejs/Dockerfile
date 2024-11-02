FROM ubuntu:noble

RUN apt-get update -y; \
    apt-get install -y --no-install-recommends \
    bash \
    nodejs npm \
    openssl \
    jq \
    ;

## Update npm
RUN npm install -g npm && npm --version

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
