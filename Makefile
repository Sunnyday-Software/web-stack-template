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
$(shell find ./dev/scripts -type f -name "*.sh" -exec dos2unix {} +)

# Definire una variabile di aiuto che elenca i target e le loro descrizioni
HELP_TARGETS = "\n Available tasks:\n"
HELP_TARGETS += "\n help			- Mostra questo messaggio"
HELP_TARGETS += "\n init     		- Inizializza il progetto keystone"
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
	[ -f dev/scripts/create-keystone-project.sh ] && \
	docker compose run --rm --no-deps nodejs dev/scripts/create-keystone-project.sh

bash:
	docker compose run --rm --no-deps nodejs bash

up:
	docker compose up -d nodejs pgadmin s3 smtp

down:
	docker compose down -v --remove-orphans

hard-reset:
	git reset --hard
	git clean -dfx -e \!.idea

docker-config:
	docker compose config