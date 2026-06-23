# Contribuir a `MapaEngine`

Gracias por tu interés en contribuir. Este documento explica cómo enviar
cambios y, sobre todo, el **acuerdo de licencia de contribuyente (CLA)** que
necesitas aceptar antes de que podamos integrar tu código.

---

## Cómo contribuir

1. **Abre primero un issue** para cambios no triviales, así alineamos el enfoque
   antes de que escribas código.
2. Haz **fork** del repositorio y crea una rama descriptiva
   (`feat/buscador-catalogo`, `fix/auth-token-refresh`, etc.).
3. Haz tus cambios siguiendo los estándares de abajo.
4. Asegúrate de que **pasan los tests y el linter** localmente.
5. Abre un **Pull Request** hacia `main` describiendo *qué* cambia y *por qué*.
6. **Acepta el CLA** (ver más abajo). Sin esto no podemos fusionar tu PR.

## Estándares de código

- **Python (FastAPI / pycsw):** formato con `ruff`/`black`, type hints donde
  aporten, y tests con `pytest`.
- **TypeScript (React / OpenLayers):** `eslint` + `prettier`, componentes
  tipados, sin `any` salvo justificación.
- **Cabeceras de licencia:** todo archivo fuente nuevo debe incluir la cabecera
  AGPL (ver `CABECERAS.md`).
- **Commits:** preferimos el estilo *Conventional Commits*
  (`feat:`, `fix:`, `docs:`…).

---

## Acuerdo de Licencia de Contribuyente (CLA)

Este proyecto se distribuye bajo **AGPL-3.0-or-later** y, además, se ofrece bajo
una **licencia comercial** a quienes la necesiten (doble licencia). Para que ese
modelo siga siendo posible, necesitamos que cada persona que contribuye nos
otorgue los derechos suficientes sobre su aporte.

**Qué significa en la práctica:**

- **Conservas el copyright** de tu contribución. No nos cedes la propiedad.
- Nos concedes una **licencia amplia e irrevocable** que incluye el derecho a
  distribuir tu aporte bajo la AGPL **y** bajo otras licencias (incluida la
  comercial). Esto es lo que mantiene viva la doble licencia.
- Declaras que el código es **tuyo** y que tienes derecho a aportarlo.

El texto completo está en **[`CLA.md`](./CLA.md)**. Léelo antes de firmar.

### Cómo firmar

Al abrir tu primer Pull Request, el bot **CLA Assistant** publicará un comentario
con un enlace. Basta con que confirmes ahí para registrar tu aceptación; queda
asociada a tu cuenta para PRs futuros.

> Si contribuyes **en nombre de tu empresa** (el código es propiedad de tu
> empleador), necesitamos la variante **Corporate CLA** firmada por alguien con
> autoridad para ello. Escríbenos a `rabe.edgar.gp@gmail.com` y te la enviamos.

---

¿Dudas? Abre un issue con la etiqueta `question` o escríbenos a
`rabe.edgar.gp@gmail.com`.
