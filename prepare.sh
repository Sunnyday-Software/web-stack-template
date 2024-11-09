#!/bin/bash

# Configura queste variabili con le informazioni del tuo repository
OWNER="Sunnyday-Software"
REPO="web-stack-template"

# Determina il sistema operativo
OS=""
case "$(uname -s)" in
    Linux*)
        OS="linux"
        ;;
    Darwin*)
        OS="macos"
        ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
        OS="windows"
        ;;
    *)
        echo "Sistema operativo non supportato."
        exit 1
        ;;
esac

# Ottieni l'ultima release dall'API di GitHub
API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
ASSET_URL=$(curl -s $API_URL | grep "browser_download_url" | grep "$OS" | cut -d '"' -f 4)

if [ -z "$ASSET_URL" ]; then
    echo "Nessun asset trovato per il sistema operativo: $OS"
    exit 1
fi

echo "Scaricamento dell'asset: $ASSET_URL"

# Nome dell'asset scaricato
ASSET_NAME="$REPO-$OS-asset"

# Scarica l'asset
curl -L -o "$ASSET_NAME" "$ASSET_URL"

# Estrae l'asset direttamente nella directory corrente
if [ "$OS" = "windows" ]; then
    # Per Windows, utilizziamo unzip (assicurati che sia installato)
    unzip -j "$ASSET_NAME" -d .
else
    # Per Linux e macOS
    tar -xzf "$ASSET_NAME" -C .
fi

# Rimuove l'archivio scaricato
rm "$ASSET_NAME"

chmod +x ./project

echo "Download e estrazione completati. Il binario si trova nella directory corrente."
