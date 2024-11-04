#!/usr/bin/env bash

#
set -e

source "$(dirname "$0")/env.sh"

check_container;

echo "node version $(node --version)"

mkdir -p $(dirname "${astro_path}")

if [ -d "${astro_path}" ]; then
  echo "La cartella ${astro_path} esiste perciò non invoco npm create app"
else
  echo "npm create app"
  npm create astro@${astro_version} --yes ${astro_path}
fi


# Directory dei file personalizzati
CUSTOM_FILES_DIR="$(dirname "$0")/astro"

# Funzione per copiare i file mantenendo la struttura delle directory
copy_custom_files() {
    local src_dir="$1"
    local dest_dir="$2"

    # Usa rsync per copiare i file mantenendo la struttura delle directory
    # L'opzione --backup crea backup dei file esistenti con l'estensione specificata
    rsync -av --backup --suffix=".old" --exclude=".git/" "$src_dir/" "$dest_dir/"
}

if [ -d "$CUSTOM_FILES_DIR" ]; then
    echo "Inizio la copia di tutti i file personalizzati da $CUSTOM_FILES_DIR a $astro_path"

    copy_custom_files "$CUSTOM_FILES_DIR" "$astro_path"

    echo "Copia completata."
else
    echo "La cartella $CUSTOM_FILES_DIR non esiste. Nessun file personalizzato verrà copiato."
fi


cd ${astro_path}

jq \
'
.scripts.dev="astro dev --host 0.0.0.0"
|.scripts.disable_telemetry= "astro telemetry disable"
' package.json \
 > package_modified.json && mv package_modified.json package.json

npm install

npm run disable_telemetry

