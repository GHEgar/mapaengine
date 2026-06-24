# Plantilla de configuración de pycsw 3.0 (YAML). NO contiene la password:
# el marcador __PYCSW_DATABASE_URL__ lo sustituye en arranque el wrapper
# (docker/pycsw/entrypoint-wrapper.sh) leyendo el secreto pycsw_db_password.
# El resultado se escribe en /tmp/pycsw.yml y se apunta con PYCSW_CONFIG.

server:
    url: http://localhost:8000/
    mimetype: application/xml; charset=UTF-8
    encoding: UTF-8
    language: es-MX
    maxrecords: 10
    timeout: 30
    gzip_compresslevel: 9

logging:
    level: INFO

profiles:
    - apiso

manager:
    transactions: false
    allowed_ips:
        - 127.0.0.1

metadata:
    identification:
        title: MapaEngine — Catálogo geoespacial
        description: Servicio de catálogo CSW / OGC API Records de MapaEngine
        keywords:
            - catalogo
            - metadatos
            - geoespacial
        keywords_type: theme
        fees: None
        accessconstraints: None
        url: http://localhost:8000/
    license:
        name: CC-BY 4.0
        url: https://creativecommons.org/licenses/by/4.0
    provider:
        name: MapaEngine
        url: http://localhost:8000/
    contact:
        name: MapaEngine
        email: admin@example.org
        role: pointOfContact
    inspire:
        enabled: false

repository:
    database: __PYCSW_DATABASE_URL__
    table: pycsw.records
