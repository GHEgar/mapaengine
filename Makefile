SHELL := /usr/bin/env bash
COMPOSE := docker compose
SECRETS_DIR := secrets
SECRETS := postgres_password authentik_postgres_password geoserver_admin_password authentik_secret_key oidc_client_secret fastapi_secret_key redis_password
PG_USER ?= mapaengine
PG_DB ?= mapaengine

.DEFAULT_GOAL := help
.PHONY: help secrets check-secrets up up-portal down restart build pull ps logs psql backup-db restore-db clean

help: ## Lista las reglas disponibles
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

secrets: ## Genera los secretos faltantes en ./secrets (idempotente, chmod 600)
	@mkdir -p $(SECRETS_DIR)
	@for s in $(SECRETS); do \
		f="$(SECRETS_DIR)/$$s"; \
		if [ -f "$$f" ]; then \
			echo "= ya existe  $$f"; \
		else \
			openssl rand -hex 32 > "$$f" && chmod 600 "$$f" && echo "+ creado    $$f"; \
		fi; \
	done

check-secrets:
	@missing=0; \
	for s in $(SECRETS); do \
		[ -f "$(SECRETS_DIR)/$$s" ] || { echo "FALTA: $(SECRETS_DIR)/$$s"; missing=1; }; \
	done; \
	if [ "$$missing" -ne 0 ]; then echo ">> Ejecuta 'make secrets' primero."; exit 1; fi

up: check-secrets ## Levanta la infraestructura (db, redis, geoserver, pycsw, authentik)
	$(COMPOSE) up -d

up-portal: check-secrets ## Levanta todo, incluyendo backend y frontend (profile 'portal')
	$(COMPOSE) --profile portal up -d

down: ## Baja el stack
	$(COMPOSE) down

restart: ## Reinicia el stack
	$(COMPOSE) restart

build: ## Construye las imágenes locales (backend/frontend)
	$(COMPOSE) --profile portal build

pull: ## Actualiza las imágenes remotas
	$(COMPOSE) pull

ps: ## Estado de los servicios
	$(COMPOSE) ps

logs: ## Sigue los logs (todo, o uno: make logs s=geoserver)
	$(COMPOSE) logs -f $(s)

psql: ## Abre una shell psql contra la base principal
	$(COMPOSE) exec db psql -U $(PG_USER) -d $(PG_DB)

backup-db: ## Respalda la base en ./backups/backup-<fecha>.sql.gz
	@mkdir -p backups
	@f="backups/backup-$$(date +%Y%m%d-%H%M%S).sql.gz"; \
	$(COMPOSE) exec -T db pg_dump -U $(PG_USER) $(PG_DB) | gzip > "$$f" && echo "Respaldo: $$f"

restore-db: ## Restaura un respaldo: make restore-db f=backups/archivo.sql.gz
	@[ -n "$(f)" ] || { echo "Uso: make restore-db f=backups/archivo.sql.gz"; exit 1; }
	gunzip -c "$(f)" | $(COMPOSE) exec -T db psql -U $(PG_USER) -d $(PG_DB)

clean: ## Baja el stack y ELIMINA los volúmenes (pide confirmación)
	@read -r -p "Esto borra TODOS los datos (volúmenes). ¿Seguro? [y/N] " a; \
	[ "$$a" = "y" ] || [ "$$a" = "Y" ] || { echo "Cancelado."; exit 1; }
	$(COMPOSE) down -v
