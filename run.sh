export HOST_PROJECT_PATH=$(pwd)
export MD5_MAKE=$(md5sum ./dev/docker/make/Dockerfile | cut -d ' ' -f 1 | cut -c 1-8)

docker compose run \
  --rm --no-deps \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e HOST_PROJECT_PATH="$HOST_PROJECT_PATH" \
  make \
  make $@