# AGENTS.md — Contexto del proyecto para agentes de IA

> Este archivo es la **fuente única de verdad** del contexto del proyecto para
> todos los agentes (Claude Code y opencode). `CLAUDE.md` es un symlink a este
> archivo. Mantenlo actualizado.

---

## 1. Descripción del proyecto

**MapaEngine** es un motor open-source para construir y desplegar portales
geoespaciales **como configuración, no como código**. Hay un **núcleo** común y
reutilizable (infraestructura + código que no cambia entre proyectos) y cada
**portal** concreto se define mediante un archivo de configuración (capas, mapas
base, herramientas, roles, branding).

Regla mental: si te ves *hardcodeando* algo específico de un portal dentro del
núcleo, eso debería ser configuración.

> ⚠️ **Estado actual: solo documentación.** Todavía NO hay código de aplicación
> en el repositorio (sin `package.json`, `pyproject.toml`, ni `docker-compose.yml`).
> El stack y la estructura de abajo son el **objetivo de diseño**, no algo ya
> implementado. Cuando se haga el scaffolding, actualiza las secciones marcadas.

---

## 2. Stack (objetivo)

| Capa | Tecnología |
|------|-----------|
| Datos | PostgreSQL + PostGIS (única fuente de verdad) |
| Servicios geoespaciales | GeoServer (GeoWebCache + ext. Vector Tiles / MVT) |
| Catálogo / metadatos | pycsw (CSW + OGC API Records) |
| Identidad | Authentik (OIDC / OAuth2) |
| Backend / Gateway | Python + FastAPI |
| Frontend | TypeScript + React + OpenLayers |
| Orquestación | Docker + Docker Compose |

- **Lenguajes:** Python (backend) y TypeScript (frontend).
- **Gestor de paquetes:** TODO — definir (backend: pip/uv/poetry; frontend: npm/pnpm/yarn).

---

## 3. Estructura de carpetas (objetivo)

```
.
├── backend/          # API FastAPI, validación de tokens, permisos, config de portales, pycsw
├── frontend/         # React + OpenLayers; componentes que leen SOLO de la configuración
├── portales/         # Definición de cada portal como YAML/JSON (config, no código)
├── docker-compose.yml
├── .env.example      # Plantilla de variables de entorno (sin valores reales)
├── AGENTS.md         # Este archivo (contexto compartido)
├── CLAUDE.md         # Symlink → AGENTS.md
├── .claude/          # Config de Claude Code (agente principal, modelos Claude)
└── .opencode/        # Config de opencode (solo Qwen + DeepSeek)
```

> Hoy solo existen los archivos de documentación/licencia y de configuración de
> agentes. El resto está pendiente de implementación.

---

## 4. Comandos clave

> ⚠️ Estos comandos son los **previstos** según el toolchain elegido; no funcionan
> hasta que exista el código y su configuración. Actualízalos al hacer scaffolding.

**Backend (Python · Ruff · mypy · pytest):**
```bash
ruff format .          # formatear
ruff check .           # lint (usa --fix para autocorregir)
mypy .                 # type-checking estricto
pytest                 # tests
```

**Frontend (TypeScript · Biome · React):**
```bash
biome format --write .   # formatear
biome check .            # lint + format check (usa --write para autocorregir)
tsc --noEmit             # type-checking estricto
# test/build: TODO — definir runner (vitest/jest) y bundler (vite) al hacer scaffolding
```

**Stack local (Docker + Makefile):**
```bash
make secrets   # genera las credenciales en ./secrets/ (idempotente)
make up        # levanta DEVELOP  (proyecto mapaengine-dev, puertos estándar)
make deploy    # levanta PRODUCTION (proyecto mapaengine, puertos +10000); corre a la vez que dev
make down      # baja AMBOS entornos
make clean     # baja AMBOS y borra volúmenes/datos (pide confirmación)
make ps        # estado de ambos entornos
make help      # todos los comandos (auxiliares como logs/psql aceptan ENV=dev|prod)
```
Arquitectura dev/prod: `docker-compose.yml` (base común) + `docker-compose.dev.yml`
y `docker-compose.prod.yml` (puertos y restart por entorno). Secretos compartidos;
los datos quedan separados por proyecto. El contenedor `db-init` corre una vez
(crea rol+base de Authentik) y se autoelimina tras completar.
Las **credenciales** se manejan con **Docker secrets** (archivos en `./secrets/`,
montados en `/run/secrets/<nombre>`), nunca como variables en texto plano. La
config no sensible va en `.env`. Ver [`secrets/README.md`](./secrets/README.md).

---

## 5. Convenciones de código

### Python (backend)
- **Formato + lint:** **Ruff** (todo-en-uno; reemplaza black + isort + flake8).
- **Tipado:** type hints **obligatorios**, verificados con **mypy en modo strict**.
- **Docstrings:** estilo **Google**.
- **Naming:** `snake_case` para variables/funciones/módulos, `PascalCase` para
  clases, `UPPER_SNAKE_CASE` para constantes.

### TypeScript / JavaScript (frontend)
- **Formato + lint:** **Biome** (todo-en-uno; reemplaza ESLint + Prettier).
- **Tipado:** `tsconfig` con **`strict: true`**; **prohibido `any`** salvo
  justificación explícita en comentario.
- **Naming:** `camelCase` para variables/funciones, `PascalCase` para componentes
  React y tipos/interfaces, `UPPER_SNAKE_CASE` para constantes.

### Común
- **Comentarios al mínimo:** evita comentar el código salvo que sea
  *estrictamente necesario* (lógica no obvia, una decisión contraintuitiva, un
  *workaround* con su porqué). El código debe explicarse por sí mismo con buenos
  nombres y funciones pequeñas; no escribas comentarios que repiten lo que el
  código ya dice. La cabecera de licencia AGPL no cuenta como comentario y sí es
  obligatoria.
- Todo archivo fuente nuevo lleva la **cabecera de licencia AGPL** (ver
  [`CABECERAS.md`](./CABECERAS.md)).
- Commits estilo **Conventional Commits** (`feat:`, `fix:`, `docs:`…), de
  **máximo 2 líneas** (idealmente solo el *subject*). Nada de cuerpos largos:
  si hace falta más detalle, va en el PR o en el CHANGELOG, no en el commit.
- Cambios notables se registran en [`CHANGELOG.md`](./CHANGELOG.md)
  (Keep a Changelog + SemVer).

---

## 6. Qué NUNCA hacer

- ❌ **No** ejecutar `git commit`, `push`, `merge`, `rebase`, `reset --hard`,
  `checkout`, `clean` ni operaciones destructivas/de publicación **sin que el
  responsable lo pida explícitamente en ese momento**. Una autorización previa no
  cubre operaciones futuras.
- ❌ **No** agregar atribución al asistente en los mensajes de commit
  (`Co-Authored-By: Claude`, `🤖 Generated with…`, etc.). Mensajes limpios.
- ❌ **No** hardcodear nada específico de un portal dentro del núcleo: debe ser
  configuración.
- ❌ **No** commitear secretos: `.env`, claves (`*.key`, `*.pem`, `*.p12`),
  tokens, credenciales. Usa siempre `.env.example` con nombres sin valores.
- ❌ **No** poner modelos **Claude** en la config de **opencode**, ni modelos
  **Qwen/DeepSeek** en la config de **Claude Code**. Cada herramienta tiene sus
  proveedores asignados (ver sección 7).
- ❌ **No** escribir claves de API en texto plano en ningún archivo versionado;
  usa referencias `{env:NOMBRE_VAR}`.
- ❌ **No** poner valores reales en [`.env.example`](./.env.example): es una
  plantilla, solo marcadores `<descripción>`. Los valores reales van en `.env`
  (ignorado) y las credenciales en Docker secrets (`./secrets/`).
- ❌ **No** convertir el proyecto en producto cerrado/propietario (la licencia es
  AGPL; ver [`README-licencia.md`](./README-licencia.md)).

---

## 7. Agentes de IA

- **Claude Code** = agente **principal**, exclusivamente con **modelos Claude**.
  Config en [`.claude/`](./.claude/) (settings compartidos + subagentes).
- **opencode** = exclusivamente **Qwen** y **DeepSeek** (sin modelos Claude).
  Config en [`opencode.json`](./opencode.json) y [`.opencode/agent/`](./.opencode/agent/).

---

## 8. Lógica sensible (extra cuidado al tocar)

- **Autenticación / autorización:** validación de tokens OIDC (Authentik) y
  aplicación de permisos por rol en el backend FastAPI. Un error aquí es un
  agujero de seguridad.
- **Resolución de configuración de portal:** el backend sirve la config que el
  frontend consume; controla qué ve cada rol.
- **Secretos y `.env`:** credenciales de base de datos, GeoServer, Authentik y
  claves de API. Nunca exponer ni versionar.
- **Contribuciones externas:** requieren CLA firmado (ver
  [`CONTRIBUTING.md`](./CONTRIBUTING.md) y [`CLA.md`](./CLA.md)).

---

## 9. Mantenimiento de documentación

**Regla (cuándo documentar):** NO actualices la documentación en cada cambio ni en
cada commit local. Durante el desarrollo se experimenta libremente y muchas cosas
se descartan; documentar eso es ruido. La documentación se actualiza **solo al
preparar un `push`**: antes de hacer push, revisa qué cambios **sobrevivieron** y
actualiza únicamente lo que quedó en pie. Lo que probaste y tiraste no se documenta.

**Qué actualizar (al hacer push):** revisa si alguno de estos archivos quedó
desactualizado por los cambios que sí se conservan, y corrígelo:

| Si cambiaste… | Actualiza… |
|---------------|-----------|
| Stack, comandos (test/lint/build/run), estructura de carpetas, convenciones, gestor de paquetes | **`AGENTS.md`** (este archivo; `CLAUDE.md` lo refleja vía symlink) |
| Cualquier funcionalidad o cambio notable (feat, fix, breaking change, deprecación, seguridad) | **`CHANGELOG.md`** → entrada bajo `[Unreleased]` en el grupo correcto (Added/Changed/Deprecated/Removed/Fixed/Security) |
| Algo de cara al usuario: instalación, uso, características, arquitectura, ejemplo de config de portal | **`README.md`** |
| Términos de licencia, contacto comercial, proceso de contribución o CLA | `README-licencia.md`, `CONTRIBUTING.md`, `CLA.md` |
| El formato de cabecera de licencia o datos del titular | `CABECERAS.md` |

Notas:
- **CHANGELOG:** sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y
  **[SemVer](https://semver.org/lang/es/) estándar**: **MAYOR** = cambios
  incompatibles (*breaking*); **MENOR** = nueva funcionalidad compatible; **PARCHE**
  = correcciones compatibles. El *bump* se hace por cada cambio que llega al `push`,
  no por commits locales ni experimentos descartados. **No incrementes MAYOR por tu
  cuenta**: un *breaking change* es una decisión importante; señálalo y déjalo al
  responsable.
- Si lo que vas a pushear no toca ninguno de estos puntos, no inventes entradas:
  documentar de más también es ruido.
- Esta regla aplica a **todos los agentes** (Claude Code y opencode) y a cualquier
  contribución humana.
