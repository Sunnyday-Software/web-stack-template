#!/usr/bin/env bash
set -e

source "$(dirname "$0")/../../.env"

export keystone_version
export keystone_path

export astro_version
export astro_path

export d_npm="docker compose run --rm --no-deps nodejs npm"


is_in_container() {
    # Metodo 1: Verifica se esiste il file /.dockerenv
    if [ -f "/.dockerenv" ]; then
        return 0
    fi

    # Metodo 2: Controlla se i cgroup indicano un container Docker o LXC
    if grep -qE '/docker|/lxc' /proc/1/cgroup; then
        return 0
    fi

    # Metodo 3: Verifica se il file /proc/self/cgroup contiene indicazioni di container
    if grep -qE 'docker|lxc' /proc/self/cgroup; then
        return 0
    fi

    # Non siamo in un container
    return 1
}


check_container() {
if is_in_container; then
    echo "Sei all'interno di un container."
else
    echo "Errore: Questo script deve essere eseguito all'interno di un container Docker." >&2
    exit 1
fi
}