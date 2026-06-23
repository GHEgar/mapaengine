# Cabeceras de licencia para archivos fuente

Pega el bloque correspondiente al **inicio de cada archivo fuente** de tu motor
(no en las dependencias de terceros, solo en tu código).

Los bloques de abajo ya están rellenados para **MapaEngine**:

- Motor: **MapaEngine**
- Copyright: **2026  Edgar Alejandro Villarreal Padilla**


---

## Python (FastAPI, pycsw config, scripts, etc.)

```python
# MapaEngine - motor open-source para construir portales geoespaciales como configuración
# Copyright (C) 2026  Edgar Alejandro Villarreal Padilla
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
```

---

## JavaScript / TypeScript (React, OpenLayers, config del frontend)

```javascript
/*
 * MapaEngine - motor open-source para construir portales geoespaciales como configuración
 * Copyright (C) 2026  Edgar Alejandro Villarreal Padilla
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
```

---

## Versión corta (alternativa con SPDX)

Si prefieres no repetir el bloque largo en cada archivo, hoy es aceptado usar
un identificador SPDX en la primera línea, siempre que el `LICENSE` completo
esté en la raíz del repositorio:

```python
# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026  Edgar Alejandro Villarreal Padilla
```

```javascript
// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright (C) 2026  Edgar Alejandro Villarreal Padilla
```

> Nota: `AGPL-3.0-or-later` corresponde a "versión 3 o cualquier posterior".
> Si quieres fijar **solo** la v3 sin futuras versiones, usa `AGPL-3.0-only`.
> Para un motor que vas a mantener años, `-or-later` suele ser la opción cómoda.
