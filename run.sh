export HOST_PROJECT_PATH=$(pwd)
export MD5_MAKE=$(md5sum ./dev/docker/make/Dockerfile | cut -d ' ' -f 1 | cut -c 1-8)
export MD5_NODEJS=$(md5sum ./dev/docker/nodejs/Dockerfile | cut -d ' ' -f 1 | cut -c 1-8)
export MD5_POSTGRES=$(md5sum ./dev/docker/postgres/Dockerfile | cut -d ' ' -f 1 | cut -c 1-8)

docker compose run \
  --rm --no-deps \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e HOST_PROJECT_PATH="$HOST_PROJECT_PATH" \
  -e MD5_MAKE="$MD5_MAKE" \
  -e MD5_NODEJS="$MD5_NODEJS" \
  -e MD5_POSTGRES="$MD5_POSTGRES" \
  make \
  make $@