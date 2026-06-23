# MapaEngine

> Motor open-source para construir y desplegar portales geoespaciales como **configuración, no como código**.

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](./LICENSE)
[![Python](https://img.shields.io/badge/Python-FastAPI-009688.svg)](#)
[![Frontend](https://img.shields.io/badge/Frontend-React_+_OpenLayers-61DAFB.svg)](#)

---

## ¿Qué es esto?

**MapaEngine** es un framework para crear visores y portales geoespaciales —e Infraestructuras de Datos Espaciales (IDE)— sin reescribir la base cada vez.

Su principio central es la separación entre **núcleo** y **portal**:

- El **núcleo** es el código y la infraestructura que **no cambian** entre proyectos.
- Cada **portal** concreto es **pura configuración**: capas, mapas base, herramientas activas, roles y branding.

Así, lanzar un portal nuevo no implica copiar y pegar código, sino **describirlo** en un archivo de configuración. Si algún día te ves hardcodeando algo específico de un portal dentro del núcleo, esa es la señal de que debería ser config.

---

## Características

- 🧩 **Portales como configuración** — un esquema (YAML/JSON) define cada portal; el núcleo se mantiene intacto.
- 🗺️ **Estándares OGC de fábrica** — WMS, WFS, WMTS, vector tiles (MVT) y catálogo CSW / OGC API Records.
- 🔍 **Catálogo y filtrado de metadatos** — búsqueda estándar sobre la misma base de datos, lista para federarse con otras IDE.
- 🔐 **Autenticación centralizada** — login y roles (OIDC) compartidos entre todos los portales desde el día uno.
- 🐳 **Reproducible** — todo el stack se levanta con un solo comando vía Docker Compose.
- 🎯 **Una única fuente de verdad** — los datos y metadatos viven en PostGIS; todo lo demás lee de ahí.

---

## Arquitectura

El sistema está dividido en capas desacopladas, cada una con una responsabilidad clara:

| Capa | Tecnología | Responsabilidad |
|------|-----------|-----------------|
| **Datos** | PostgreSQL + PostGIS | Única fuente de verdad de vectores y metadatos. |
| **Servicios geoespaciales** | GeoServer (GeoWebCache + ext. Vector Tiles) | Sirve vectores (WFS), vector tiles (MVT) y raster cacheado (WMS/WMTS). |
| **Catálogo / metadatos** | pycsw | Expone búsqueda y filtrado estándar (CSW + OGC API Records) apuntando a PostGIS. |
| **Identidad** | Authentik | Login y roles (OIDC/OAuth2), una sola vez para todos los portales. |
| **Backend / Gateway** | FastAPI | Valida tokens, aplica permisos, sirve la configuración de cada portal y orquesta servicios. |
| **Frontend** | React + OpenLayers | Visor construido como componentes que leen *solo* de la configuración. |

```
┌─────────────────────────────────────────────┐
│        Frontend (React + OpenLayers)          │
│   lee la configuración del portal, nada más   │
└───────────────────────┬───────────────────────┘
                        │
┌───────────────────────▼───────────────────────┐
│              FastAPI (gateway/API)             │
│   auth · permisos · config de portal · orquesta │
└───┬───────────────┬───────────────┬───────────┘
    │               │               │
┌───▼────┐   ┌──────▼──────┐  ┌─────▼─────┐
│Authentik│   │  GeoServer  │  │   pycsw   │
│ (OIDC)  │   │ (OGC + GWC) │  │ (catálogo)│
└─────────┘   └──────┬──────┘  └─────┬─────┘
                    │               │
              ┌──────▼───────────────▼──────┐
              │   PostgreSQL + PostGIS      │
              │  (datos + metadatos = verdad)│
              └─────────────────────────────┘
```

---

## Requisitos

- [Docker](https://docs.docker.com/get-docker/) y Docker Compose
- (Opcional, para desarrollo) Node.js 20+ y Python 3.11+

---

## Inicio rápido

```bash
# 1. Clona el repositorio
git clone git@github.com:GHEgar/mapaengine.git
cd mapaengine

# 2. Copia y ajusta las variables de entorno
cp .env.example .env
#    edita .env con tus credenciales y secretos

# 3. Levanta todo el stack
docker compose up -d

# 4. Verifica que los servicios respondan
docker compose ps
```

Por defecto quedarán disponibles (ajustable en `.env`):

| Servicio | URL local |
|----------|-----------|
| Frontend | http://localhost:3000 |
| API (FastAPI) | http://localhost:8000/docs |
| GeoServer | http://localhost:8080/geoserver |
| pycsw | http://localhost:8000/csw |
| Authentik | http://localhost:9000 |

> ⚠️ Cambia **todas** las contraseñas y secretos de `.env.example` antes de exponer el stack fuera de tu máquina.

---

## Configurar un portal

Un portal se define como configuración, sin tocar el núcleo. Ejemplo mínimo:

```yaml
# portales/mi-portal.yaml
id: mi-portal
nombre: "Portal de Ejemplo"
branding:
  logo: "/assets/mi-portal/logo.svg"
  colorPrimario: "#0a7d4b"
mapaBase: "osm"
herramientas:
  - capas
  - leyenda
  - buscador
  - medicion
capas:
  - id: municipios
    titulo: "Municipios"
    tipo: "mvt"          # vector tiles servidos por GeoServer
    fuente: "geoserver:workspace:municipios"
    estilo: "municipios_default"
roles:
  publico:   [ver]
  editor:    [ver, editar]
```

El visor lee esta configuración y arma el portal en tiempo de ejecución: **nada está hardcodeado**.

---

## Estándares soportados

- **WMS / WMTS** — raster y tiles cacheados (vía GeoWebCache).
- **WFS** — descarga de vectores.
- **Vector Tiles (MVT)** — geometrías al cliente, estilado en el navegador.
- **CSW / OGC API Records** — catálogo y filtrado de metadatos.
- **OIDC / OAuth2** — identidad y autorización.

---

## Roadmap

- [ ] Plantilla `portal.yaml` validada con JSON Schema.
- [ ] Galería de mapas base y temas visuales.
- [ ] **Fase 2:** teselado dinámico de COGs con TiTiler + almacenamiento en MinIO.
- [ ] CLI para crear/scaffoldear un portal nuevo.
- [ ] Documentación de despliegue en producción.

---

## Licencia

Este proyecto está licenciado bajo la **GNU Affero General Public License v3.0 (o posterior)** — ver [`LICENSE`](./LICENSE) para el texto completo.

En resumen:

- Puedes **usar, estudiar, modificar y redistribuir** el software libremente, incluso con fines comerciales.
- **Si lo modificas y lo ofreces como servicio en red** (SaaS), debes poner el código fuente de tus modificaciones a disposición de los usuarios, bajo esta misma licencia.

En otras palabras: cualquiera puede mejorarlo e incluso venderlo, pero **nadie puede convertirlo en un producto cerrado**.

### Licencia comercial (dual licensing)

Si necesitas usar el motor **sin las obligaciones de la AGPL**, hay disponible una licencia comercial alternativa. Contacto: `rabe.edgar.gp@gmail.com`.

> Toda contribución externa requiere la firma de un **Contributor License Agreement (CLA)**; consulta [`CONTRIBUTING.md`](./CONTRIBUTING.md) antes de enviar un Pull Request.

---

## Contribuir

Las contribuciones son bienvenidas. Antes de abrir un Pull Request, lee [`CONTRIBUTING.md`](./CONTRIBUTING.md) y firma el CLA. Para reportar errores o proponer mejoras, abre un *issue*.

---

## Contacto

- **Autor / Titular:** Edgar Alejandro Villarreal Padilla
- **Correo:** `rabe.edgar.gp@gmail.com`