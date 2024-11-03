#!/usr/bin/env bash

#
set -e

source "$(dirname "$0")/env.sh"

check_container;

echo "node version $(node --version)"

mkdir -p $(dirname "${keystone_path}")

if [ -d "${keystone_path}" ]; then
  echo "La cartella ${keystone_path} esiste perciò non invoco npm create app"
else
  echo "npm create app"
  npm create keystone-app@${keystone_version} --yes ${keystone_path}
fi


# Directory dei file personalizzati
CUSTOM_FILES_DIR="$(dirname "$0")/keystone"

# Funzione per copiare i file mantenendo la struttura delle directory
copy_custom_files() {
    local src_dir="$1"
    local dest_dir="$2"

    # Usa rsync per copiare i file mantenendo la struttura delle directory
    # L'opzione --backup crea backup dei file esistenti con l'estensione specificata
    rsync -av --backup --suffix=".old" --exclude=".git/" "$src_dir/" "$dest_dir/"
}

if [ -d "$CUSTOM_FILES_DIR" ]; then
    echo "Inizio la copia di tutti i file personalizzati da $CUSTOM_FILES_DIR a $keystone_path"

    copy_custom_files "$CUSTOM_FILES_DIR" "$keystone_path"

    echo "Copia completata."
else
    echo "La cartella $CUSTOM_FILES_DIR non esiste. Nessun file personalizzato verrà copiato."
fi


cd ${keystone_path}

jq \
'
.scripts.telemetry_disable="keystone telemetry disable"
|.scripts.build= "keystone build"
|.scripts.dev= "keystone dev"
|.scripts.DNW_postinstall= "keystone postinstall"
|.scripts.generate= "keystone prisma migrate dev"
|.scripts.start= "keystone start --with-migrations"
|.scripts.deploy= "keystone build && keystone prisma migrate deploy"
' package.json \
 > package_modified.json && mv package_modified.json package.json

npm install
npm run telemetry_disable

