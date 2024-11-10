#!/usr/bin/env bash
set -e

source "$(dirname "$0")/../../.env"


if [ -f "./application/.init.touch" ]; then
    echo "Error: File ./application/.init.touch exists."
    exit 1
fi



# Directory dei file personalizzati
RUNTIME_FILES_DIR="/app/.runtime"
CUSTOM_FILES_DIR="/app/dev/assets/runtime"

# Funzione per copiare i file mantenendo la struttura delle directory
copy_custom_files() {
    local src_dir="$1"
    local dest_dir="$2"

    # Usa rsync per copiare i file mantenendo la struttura delle directory
    # L'opzione --backup crea backup dei file esistenti con l'estensione specificata
    rsync -av --backup --suffix=".old" --exclude=".git/" "$src_dir/" "$dest_dir/"
}

if [ -d "$CUSTOM_FILES_DIR" ]; then
    echo "Inizio la copia di tutti i file di runtime da $CUSTOM_FILES_DIR a $RUNTIME_FILES_DIR"

    copy_custom_files "$CUSTOM_FILES_DIR" "$RUNTIME_FILES_DIR"

    echo "Copia completata."
else
    echo "La cartella $CUSTOM_FILES_DIR non esiste. Nessun file di runtime verrà copiato."
fi
