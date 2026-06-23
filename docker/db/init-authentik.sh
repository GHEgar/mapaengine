#!/bin/bash
# Crea (idempotente) el rol y la base de Authentik en la PostGIS compartida.
# Corre como root en un contenedor efímero, por eso SÍ puede leer los secretos
# (chmod 600 en el host). Se ejecuta en cada arranque; no falla si ya existen.
set -euo pipefail

export PGPASSWORD="$(cat /run/secrets/postgres_password)"
authentik_pw="$(cat /run/secrets/authentik_postgres_password)"

psql -h db -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 <<SQL
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', '${AUTHENTIK_POSTGRES_USER}', '${authentik_pw}')
  WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${AUTHENTIK_POSTGRES_USER}')\gexec
SELECT format('CREATE DATABASE %I OWNER %I', '${AUTHENTIK_POSTGRES_DB}', '${AUTHENTIK_POSTGRES_USER}')
  WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${AUTHENTIK_POSTGRES_DB}')\gexec
SQL

echo "init-authentik: rol y base de Authentik verificados."
