#!/bin/sh
# Crea (idempotente) en GeoServer, vía REST, un workspace, un data store PostGIS
# apuntando a la base mapaengine y una capa de ejemplo. Corre como root (para
# leer los secretos 600). La password NUNCA se imprime: sin curl -v ni echo.
set -eu

GS="http://geoserver:8080/geoserver/rest"
WS="${GEOSERVER_WORKSPACE:-mapaengine}"
STORE="${GEOSERVER_DATASTORE:-mapaengine_postgis}"
LAYER="ejemplo_puntos"

admin_user="${GEOSERVER_ADMIN_USER:-admin}"
admin_pw="$(cat /run/secrets/geoserver_admin_password)"
db_pw="$(cat /run/secrets/postgres_password)"
db_host="${POSTGRES_HOST:-db}"
db_port="${POSTGRES_PORT:-5432}"
db_name="${POSTGRES_DB:-mapaengine}"
db_user="${POSTGRES_USER:-mapaengine}"

AUTH="-u ${admin_user}:${admin_pw}"

exists() {
    [ "$(curl -s -o /dev/null -w '%{http_code}' $AUTH "$1")" = "200" ]
}

if exists "${GS}/workspaces/${WS}.json"; then
    echo "geoserver-init: workspace '${WS}' ya existe."
else
    curl -sS -f $AUTH -H "Content-Type: application/json" \
        -d "{\"workspace\":{\"name\":\"${WS}\"}}" \
        "${GS}/workspaces" >/dev/null
    echo "geoserver-init: workspace '${WS}' creado."
fi

if exists "${GS}/workspaces/${WS}/datastores/${STORE}.json"; then
    echo "geoserver-init: data store '${STORE}' ya existe."
else
    curl -sS -f $AUTH -H "Content-Type: application/json" \
        -d "{\"dataStore\":{\"name\":\"${STORE}\",\"connectionParameters\":{\"entry\":[
            {\"@key\":\"host\",\"\$\":\"${db_host}\"},
            {\"@key\":\"port\",\"\$\":\"${db_port}\"},
            {\"@key\":\"database\",\"\$\":\"${db_name}\"},
            {\"@key\":\"schema\",\"\$\":\"public\"},
            {\"@key\":\"user\",\"\$\":\"${db_user}\"},
            {\"@key\":\"passwd\",\"\$\":\"${db_pw}\"},
            {\"@key\":\"dbtype\",\"\$\":\"postgis\"}
        ]}}}" \
        "${GS}/workspaces/${WS}/datastores" >/dev/null
    echo "geoserver-init: data store '${STORE}' creado."
fi

if exists "${GS}/workspaces/${WS}/datastores/${STORE}/featuretypes/${LAYER}.json"; then
    echo "geoserver-init: capa '${LAYER}' ya existe."
else
    curl -sS -f $AUTH -H "Content-Type: application/json" \
        -d "{\"featureType\":{\"name\":\"${LAYER}\",\"nativeName\":\"${LAYER}\",\"srs\":\"EPSG:4326\"}}" \
        "${GS}/workspaces/${WS}/datastores/${STORE}/featuretypes" >/dev/null
    echo "geoserver-init: capa '${LAYER}' publicada."
fi

echo "geoserver-init: completado."
