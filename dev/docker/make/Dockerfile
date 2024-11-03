FROM ubuntu:noble

RUN apt-get update -y; \
    apt-get install -y --no-install-recommends \
    make \
    coreutils \
    openssl \
    ca-certificates \
    curl \
    dos2unix \
    ; \
    rm -rf /var/lib/apt/lists/* \
    ;

RUN curl -fsSL https://get.docker.com -o ./install-docker.sh; \
    chmod +x ./install-docker.sh; \
    ./install-docker.sh


WORKDIR /app

