SHELL := /usr/bin/env bash
SECRETS_DIR := secrets
SECRETS := postgres_password authentik_postgres_password geoserver_admin_password authentik_secret_key oidc_client_secret fastapi_secret_key redis_password pycsw_db_password
PG_USER ?= mapaengine
PG_DB ?= mapaengine

# Invocaciones de cada entorno (proyecto + base + override).
DC_DEV  := docker compose -p mapaengine-dev -f docker-compose.yml -f docker-compose.dev.yml
DC_PROD := docker compose -p mapaengine     -f docker-compose.yml -f docker-compose.prod.yml

# Para targets auxiliares (logs, psql, build…), ENV elige el stack (default dev).
ENV ?= dev
ifeq ($(ENV),prod)
DC := $(DC_PROD)
else
DC := $(DC_DEV)
endif

.DEFAULT_GOAL := help
.PHONY: help secrets check-secrets up deploy down clean ps up-portal restart build pull logs psql backup-db restore-db

help: ## Lista las reglas (auxiliares aceptan ENV=dev|prod, default dev)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

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

up: check-secrets ## Levanta DEVELOP (puertos estándar)
	$(DC_DEV) up -d
	-@$(DC_DEV) rm -fs db-init >/dev/null 2>&1 && echo "db-init (dev) completado y removido"

deploy: check-secrets ## Levanta PRODUCTION (puertos +10000)
	$(DC_PROD) up -d
	-@$(DC_PROD) rm -fs db-init >/dev/null 2>&1 && echo "db-init (prod) completado y removido"

down: ## Baja AMBOS entornos (el que no esté arriba se ignora)
	-$(DC_DEV) down
	-$(DC_PROD) down

clean: ## Baja AMBOS y ELIMINA sus volúmenes/datos (pide confirmación)
	@read -r -p "Esto borra los datos (volúmenes) de DEV y PROD. ¿Seguro? [y/N] " a; \
	[ "$$a" = "y" ] || [ "$$a" = "Y" ] || { echo "Cancelado."; exit 1; }
	-$(DC_DEV) down -v
	-$(DC_PROD) down -v

ps: ## Estado de AMBOS entornos
	@echo "── develop ──";    $(DC_DEV) ps
	@echo "── production ──"; $(DC_PROD) ps

up-portal: check-secrets ## Levanta un entorno con backend+frontend (profile 'portal'); ENV=dev|prod
	$(DC) --profile portal up -d

restart: ## Reinicia un entorno (ENV=dev|prod)
	$(DC) restart

build: ## Construye las imágenes locales backend/frontend (ENV=dev|prod)
	$(DC) --profile portal build

pull: ## Actualiza las imágenes remotas (ENV=dev|prod)
	$(DC) pull

logs: ## Sigue logs de un entorno (ENV=dev|prod; uno: make logs s=geoserver)
	$(DC) logs -f $(s)

psql: ## Abre psql contra la base de un entorno (ENV=dev|prod)
	$(DC) exec db psql -U $(PG_USER) -d $(PG_DB)

backup-db: ## Respalda la base de un entorno en ./backups/<env>-<fecha>.sql.gz
	@mkdir -p backups
	@f="backups/$(ENV)-$$(date +%Y%m%d-%H%M%S).sql.gz"; \
	$(DC) exec -T db pg_dump -U $(PG_USER) $(PG_DB) | gzip > "$$f" && echo "Respaldo: $$f"

restore-db: ## Restaura: make restore-db f=backups/archivo.sql.gz [ENV=dev|prod]
	@[ -n "$(f)" ] || { echo "Uso: make restore-db f=backups/archivo.sql.gz"; exit 1; }
	gunzip -c "$(f)" | $(DC) exec -T db psql -U $(PG_USER) -d $(PG_DB)
