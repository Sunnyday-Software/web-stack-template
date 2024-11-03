FROM postgres:16-bookworm

# Imposta la variabile d'ambiente TZ su UTC
ENV TZ=UTC

# Aggiorna il fuso orario del sistema
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


COPY initdb /docker-entrypoint-initdb.d/

EXPOSE 5432

