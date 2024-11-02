FROM ubuntu:noble

RUN apt-get update -y; \
    apt-get install -y --no-install-recommends \
    bash \
    nodejs npm \
    openssl \
    ;

EXPOSE 3000

WORKDIR /app


# Imposta l'entrypoint per eseguire lo script passato come parametro
ENTRYPOINT ["bash", "-c"]
CMD ["echo 'Nessuno script specificato.'"]
