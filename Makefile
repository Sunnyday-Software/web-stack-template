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
$(shell dos2unix .env > /dev/null 2>&1)
$(shell find ./dev/scripts -type f -name "*.sh" -exec chmod +x {} + > /dev/null 2>&1)
$(shell find ./dev/scripts -type f -name "*.sh" -exec dos2unix {} + > /dev/null 2>&1)

# Definire una variabile di aiuto che elenca i target e le loro descrizioni
HELP_TARGETS = "\n Available tasks:\n"
HELP_TARGETS += "\n help			- Mostra questo messaggio"
HELP_TARGETS += "\n init     		- Inizializza i progetti dello stack"
HELP_TARGETS += "\n up      		- Avvia il progetto "
HELP_TARGETS += "\n down      		- Ferma il progetto "
HELP_TARGETS += "\n hard-reset 		- Ripulisce il progetto cancellando tutto quello che non è in git (db compreso)"
HELP_TARGETS += "\n docker-config	- Stampa la configurazione di docker compose"

# Target predefinito
.DEFAULT_GOAL := help

# Target che stampa l'help
help:
	@echo $(HELP_TARGETS)

init:
	@[ -f dev/scripts/pre-init.sh ] && \
	docker compose run --rm --no-deps nodejs dev/scripts/pre-init.sh
	@[ -f dev/scripts/create-keystone-project.sh ] && \
	docker compose run --rm --no-deps keystone dev/scripts/create-keystone-project.sh
	@[ -f dev/scripts/create-astro-project.sh ] && \
    docker compose run --rm --no-deps astro dev/scripts/create-astro-project.sh
	@[ -f dev/scripts/post-init.sh ] && \
	docker compose run --rm --no-deps nodejs dev/scripts/post-init.sh

bash:
	docker compose run --rm --no-deps nodejs bash

up:
	@[ -f dev/scripts/pre-up.sh ] && \
	docker compose run --rm --no-deps nodejs dev/scripts/pre-up.sh
	@docker compose up -d keystone astro pgadmin s3 smtp vault
	@[ -f dev/scripts/post-up.sh ] && \
    docker compose run --rm --no-deps nodejs dev/scripts/post-up.sh

down:
	@[ -f dev/scripts/pre-down.sh ] && \
	docker compose run --rm --no-deps nodejs dev/scripts/pre-down.sh
	@docker compose stop
	@docker compose down -v  --remove-orphans
	@[ -f dev/scripts/post-down.sh ] && \
	docker compose run --rm --no-deps nodejs dev/scripts/post-down.sh

hard-reset:
	git reset --hard
	git clean -dfx -e \!.idea

docker-config:
	docker compose config