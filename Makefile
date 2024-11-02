#!make

# Macro per calcolare il checksum sui file docker
define CALC_MD5
    $(eval MD5_MAKE=$(shell md5sum /app/dev/docker/make/Dockerfile | cut -d ' ' -f 1 | cut -c 1-8))
    $(eval MD5_NODEJS=$(shell md5sum /app/dev/docker/nodejs/Dockerfile | cut -d ' ' -f 1 | cut -c 1-8))
    export MD5_MAKE MD5_NODEJS
	export MD5_NODEJS
endef

# Imposta le variabili d'ambiente all'inizio
$(eval $(call CALC_MD5))

$(shell find ./dev/scripts -type f -name "*.sh" -exec chmod +x {} +)

init:
	[ -f dev/scripts/create-keystone-project.sh ] && \
	docker compose run --rm --no-deps nodejs dev/scripts/create-keystone-project.sh

run:
	[ -f dev/scripts/run-keystone-project.sh ] && \
	docker compose run --rm --no-deps nodejs dev/scripts/run-keystone-project.sh

config:
	docker compose config
	docker ps