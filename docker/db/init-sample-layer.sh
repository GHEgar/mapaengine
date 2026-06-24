#!/bin/bash
# Crea (idempotente) una tabla PostGIS de ejemplo en la base mapaengine para
# publicarla como capa en GeoServer. Corre como root en un contenedor efímero
# (patrón db-init). La tabla queda propiedad del usuario mapaengine.
set -euo pipefail

export PGPASSWORD="$(cat /run/secrets/postgres_password)"

psql -h "${POSTGRES_HOST:-db}" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 <<SQL
CREATE TABLE IF NOT EXISTS public.ejemplo_puntos (
    id   serial PRIMARY KEY,
    nombre text NOT NULL,
    geom geometry(Point, 4326) NOT NULL
);
INSERT INTO public.ejemplo_puntos (nombre, geom)
SELECT v.nombre, ST_SetSRID(ST_MakePoint(v.lon, v.lat), 4326)
FROM (VALUES
    ('Ciudad de México', -99.1332, 19.4326),
    ('Monterrey',        -100.3161, 25.6866),
    ('Guadalajara',      -103.3496, 20.6597)
) AS v(nombre, lon, lat)
WHERE NOT EXISTS (SELECT 1 FROM public.ejemplo_puntos);
SQL

echo "init-sample-layer: tabla ejemplo_puntos verificada."
