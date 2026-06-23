# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/),
y este proyecto se adhiere al [Versionado Semántico](https://semver.org/lang/es/):

- **MAYOR** (`X.0.0`) — cambios incompatibles (rompen la compatibilidad hacia atrás).
- **MENOR** (`0.X.0`) — nueva funcionalidad compatible hacia atrás.
- **PARCHE** (`0.0.X`) — correcciones de errores compatibles hacia atrás.

## [Unreleased]

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

[Unreleased]: https://github.com/GHEgar/mapaengine/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/GHEgar/mapaengine/releases/tag/v0.1.0
