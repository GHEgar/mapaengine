# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/),
y este proyecto se adhiere al [Versionado Semántico](https://semver.org/lang/es/):

- **MAYOR** (`X.0.0`) — cambios incompatibles (rompen la compatibilidad hacia atrás).
- **MENOR** (`0.X.0`) — nueva funcionalidad compatible hacia atrás.
- **PARCHE** (`0.0.X`) — correcciones de errores compatibles hacia atrás.

## [Unreleased]

## [0.2.0] - 2026-06-24

### Added

- **Infraestructura de despliegue con Docker Compose:** archivo base
  [`docker-compose.yml`](./docker-compose.yml) más overrides
  [`docker-compose.dev.yml`](./docker-compose.dev.yml) (puertos estándar) y
  [`docker-compose.prod.yml`](./docker-compose.prod.yml) (puertos +10000,
  `restart: always`), orquestados por el [`Makefile`](./Makefile)
  (`secrets`, `up`, `deploy`, `down`, `clean`, `ps`, `up-portal`, `logs`,
  `psql`, `backup-db`, `restore-db`). Servicios: PostGIS, Redis, GeoServer,
  pycsw, Authentik (server+worker) y placeholders backend/frontend bajo el
  profile `portal`.
- **Gestión de credenciales con Docker secrets** (archivos en `./secrets/`,
  chmod 600, ignorados por git, generados de forma idempotente por
  `make secrets`); contenedor efímero `db-init` que crea el rol y la base de
  Authentik en la PostGIS compartida.
- **pycsw 3.0 conectado a PostGIS:** rol y esquema `pycsw` dedicados en la base
  `mapaengine` (contenedor `pycsw-init`, idempotente), configuración YAML por
  bind-mount y un entrypoint wrapper que inyecta la password desde el nuevo
  secreto `pycsw_db_password` en runtime (la imagen no soporta `*_FILE`).
  Healthcheck por `GetCapabilities`; expone CSW 2.0.2 y OGC API Records sobre el
  repositorio PostGIS.
- **Aprovisionamiento automático de GeoServer** vía API REST (contenedor
  `geoserver-init`): workspace `mapaengine`, data store PostGIS
  `mapaengine_postgis` apuntando a la base `mapaengine` y una capa de ejemplo
  `ejemplo_puntos` (tabla sembrada por `geodata-init`). Todo idempotente y sin
  exponer credenciales en compose ni logs. Healthcheck añadido a GeoServer.

## [0.1.0] - 2026-06-23

### Added

- Documentación inicial del proyecto en [`README.md`](./README.md): pitch,
  descripción, características, arquitectura por capas, inicio rápido con Docker,
  ejemplo de configuración de portal, estándares soportados y roadmap.
- Licenciamiento bajo **GNU AGPL-3.0-or-later** ([`LICENSE`](./LICENSE)) con
  explicación en español ([`README-licencia.md`](./README-licencia.md)) y modelo
  de **licencia comercial dual**.
- Plantillas de cabecera de licencia para archivos fuente Python y JS/TS, en
  versión larga y SPDX ([`CABECERAS.md`](./CABECERAS.md)).
- Guía de contribución ([`CONTRIBUTING.md`](./CONTRIBUTING.md)) y Acuerdo de
  Licencia de Contribuyente individual ([`CLA.md`](./CLA.md)).
- Registro de cambios ([`CHANGELOG.md`](./CHANGELOG.md)) según Keep a Changelog y
  política de versionado del proyecto.
- Configuración para agentes de IA: [`AGENTS.md`](./AGENTS.md) como contexto
  compartido (fuente única de verdad) con `CLAUDE.md` enlazado; **Claude Code**
  (`.claude/settings.json` y subagentes planner/reviewer/debugger sobre modelos
  Claude); **opencode** (`opencode.json` y `.opencode/agent/` con
  build/plan/reviewer/debugger sobre Qwen y DeepSeek vía gateway).
- `.gitignore` y [`.env.example`](./.env.example) para excluir secretos y
  documentar las variables de entorno del stack.

[Unreleased]: https://github.com/GHEgar/mapaengine/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/GHEgar/mapaengine/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/GHEgar/mapaengine/releases/tag/v0.1.0
