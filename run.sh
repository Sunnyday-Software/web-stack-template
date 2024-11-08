# Funzione per calcolare l'MD5 di una cartella
compute_dir_md5() {
    local dir="$1"

    # Verifica che sia stato fornito un argomento
    if [[ -z "$dir" ]]; then
        echo "Uso: compute_dir_md5 <directory>"
        return "latest"
    fi

    # Verifica che il percorso sia una directory esistente
    if [[ ! -d "$dir" ]]; then
        echo "Errore: '$dir' non è una directory valida o non esiste."
        return "latest"
    fi

    # Calcola l'MD5 combinato dei file nella directory
    # Utilizza find per trovare tutti i file, sort per garantire coerenza, e md5sum per calcolare l'hash
    local md5
    md5=$(find "$dir" -type f -print0 | sort -z | xargs -0 md5sum | md5sum | awk '{print $1}')
    md5="${md5:0:8}"
    return "$md5"
}


export HOST_PROJECT_PATH=$(pwd)
export MD5_MAKE=$(compute_dir_md5 ./dev/docker/make)
export MD5_NODEJS=$(compute_dir_md5 ./dev/docker/nodejs)
export MD5_POSTGRES=$(compute_dir_md5 ./dev/docker/postgres)

docker compose run \
  --rm --no-deps \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e HOST_PROJECT_PATH="$HOST_PROJECT_PATH" \
  -e MD5_MAKE="$MD5_MAKE" \
  -e MD5_NODEJS="$MD5_NODEJS" \
  -e MD5_POSTGRES="$MD5_POSTGRES" \
  make \
  make $@