#!/bin/bash
# Crea (idempotente) el rol 'pycsw' y su esquema 'pycsw' dentro de la base
# mapaengine. Igual que init-authentik.sh: corre como root en un contenedor
# efímero, por eso SÍ puede leer los secretos (chmod 600). No falla si ya existen.
set -euo pipefail

export PGPASSWORD="$(cat /run/secrets/postgres_password)"
pycsw_pw="$(cat /run/secrets/pycsw_db_password)"

psql -h "${POSTGRES_HOST:-db}" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 <<SQL
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', '${PYCSW_DB_USER}', '${pycsw_pw}')
  WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${PYCSW_DB_USER}')\gexec
GRANT CONNECT ON DATABASE ${POSTGRES_DB} TO ${PYCSW_DB_USER};
GRANT USAGE ON SCHEMA public TO ${PYCSW_DB_USER};
CREATE SCHEMA IF NOT EXISTS pycsw AUTHORIZATION ${PYCSW_DB_USER};
SQL

echo "init-pycsw: rol y esquema de pycsw verificados."
