# secrets/

Aquí viven los **secretos del stack** como archivos individuales, montados por
Docker Compose en cada contenedor bajo `/run/secrets/<nombre>`.

**Nunca se versionan.** El `.gitignore` ignora todo el contenido de esta carpeta
**excepto** `.gitkeep` y este `README.md`.

## Cómo se generan

```bash
make secrets   # crea los que falten con valores aleatorios fuertes (chmod 600)
```

Es **idempotente**: nunca sobrescribe un secreto ya existente.

## Archivos esperados

| Archivo | Lo consume | Para qué |
|---------|-----------|----------|
| `postgres_password` | db, pycsw*, backend | Password del usuario principal de PostGIS. |
| `authentik_postgres_password` | db (init), authentik | Password del usuario/DB de Authentik en la misma PostGIS. |
| `geoserver_admin_password` | geoserver | Password del admin de GeoServer. |
| `authentik_secret_key` | authentik (server+worker) | Clave de firma de Authentik. |
| `oidc_client_secret` | backend, authentik | Secreto del cliente OIDC compartido. |
| `fastapi_secret_key` | backend | Firma de sesiones/JWT del backend. |
| `redis_password` | redis, authentik | Protege Redis. |

\* La conexión de pycsw a PostGIS está pendiente (ver TODO en `docker-compose.yml`).

> El "huevo y la gallina" es esperado: estos secretos raíz (claves y passwords) se
> generan con `make secrets` y viven como archivos locales con permisos `600`. No
> hay forma de tenerlos sin que existan en algún lado; lo importante es que **nunca
> salen del entorno local ni de Git**.
