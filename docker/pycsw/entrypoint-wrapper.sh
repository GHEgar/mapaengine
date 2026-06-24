#!/bin/sh
# Wrapper de arranque de pycsw. La imagen pycsw NO soporta variables *_FILE, así
# que aquí (corriendo como root para poder leer el secreto 600) se inyecta la
# password en la cadena de conexión a PostGIS en runtime: se renderiza la
# plantilla a /tmp/pycsw.yml y se delega en el entrypoint original de la imagen,
# que crea las tablas (setup_db, idempotente) y lanza gunicorn.
set -eu

db_pw="$(cat /run/secrets/pycsw_db_password)"
db_user="${PYCSW_DB_USER:-pycsw}"
db_host="${POSTGRES_HOST:-db}"
db_port="${POSTGRES_PORT:-5432}"
db_name="${POSTGRES_DB:-mapaengine}"
db_url="postgresql://${db_user}:${db_pw}@${db_host}:${db_port}/${db_name}"

rendered="/tmp/pycsw.yml"
sed "s|__PYCSW_DATABASE_URL__|${db_url}|" /etc/pycsw/pycsw.yml.tpl > "$rendered"
chmod 600 "$rendered"
export PYCSW_CONFIG="$rendered"

exec /venv/bin/python3 /usr/local/bin/entrypoint.py "$@"
