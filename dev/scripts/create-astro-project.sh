#!/usr/bin/env bash

#
set -e

source "$(dirname "$0")/env.sh"

check_container;

echo "node version $(node --version)"
echo "Astro project: ${astro_project_name}"
astro_full_path="${astro_path}/${astro_project_name}"

mkdir -p $(dirname "${astro_full_path}")

if [ -d "${astro_full_path}" ]; then
  echo "La cartella ${astro_full_path} esiste perciò non invoco npm create app"
else
  echo "npm create app"
  cd "${astro_path}"
  npm create astro@${astro_version} "${astro_project_name}" -- \
    --template ${astro_template} \
    --install \
    --no-git \
    --typescript strict \
    --yes
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
    echo "Inizio la copia di tutti i file personalizzati da $CUSTOM_FILES_DIR a $astro_full_path"

    copy_custom_files "$CUSTOM_FILES_DIR" "$astro_full_path"

    echo "Copia completata."
else
    echo "La cartella $CUSTOM_FILES_DIR non esiste. Nessun file personalizzato verrà copiato."
fi


cd ${astro_full_path}

jq \
'
.scripts.dev="astro dev --host 0.0.0.0"
|.scripts.disable_telemetry= "astro telemetry disable"
' package.json \
 > package_modified.json && mv package_modified.json package.json

npm install

npm run disable_telemetry

