<a id="source-module-reference"></a>
# Referencia del módulo fuente

> **Fuente canónica en inglés:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Esta página asigna cada fuente, configuración, datos, cargador de compatibilidad y clase de marcador de posición de tiempo de ejecución admitidos por la lista de versiones permitidas. El índice de la máquina es [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json); esta página es la explicación canónica legible. Cada fila de máquina generada nombra un path/class, un propósito, un bloque de origen propietario, configuraciones públicas, efectos secundarios, estados visibles para el operador, fallas, recuperación y un documento canónico distinto.

<a id="packaged-file-map"></a>
## Mapa de archivos empaquetados

| Ruta | Responsabilidad | Punto de entrada o llamante | Entradas | Salidas y efectos secundarios | Comportamiento de falla | Editable por el usuario |
|---|---|---|---|---|---|---|
| `LICENSE` | Licencia del proyecto enviada en la raíz del archivo. | Instalador, redistribuidor y operador. | Revisado texto de licencia del repositorio. | Indica los términos que se aplican al paquete; sin mutación en tiempo de ejecución. | La omisión hace que el paquete de lanzamiento esté legalmente incompleto y bloquea la lista de permitidos. | No. |
| `NOTICE.md` | Avisos de proyecto enviados en la raíz del archivo. | Instalador y operador. | Avisos de proyecto revisados. | Conserva la atribución requerida y el contexto del proyecto; sin mutación en tiempo de ejecución. | La omisión hace que el paquete de lanzamiento esté incompleto y bloquea la lista de permitidos. | No. |
| `THIRD_PARTY_NOTICES.md` | Avisos de terceros enviados a la raíz del archivo. | Instalador y redistribuidor. | Texto de atribución de terceros revisado. | Conserva atribución de dependencia; sin mutación en tiempo de ejecución. | La omisión hace que el paquete de lanzamiento esté incompleto y bloquea la lista de permitidos. | No. |
| `RandomDayGuard/enabled.txt` | UE4SS indicador de habilitación de mod. | UE4SS cargador de mod. | `1` o `0` según lo admitido UE4SS. | Habilita o deshabilita la carga; no escribe evidencia de tiempo de ejecución. | Un indicador deshabilitado o con formato incorrecto impide la prueba de inicio normal. | Sí, durante la instalación. |
| `RandomDayGuard/config.lua` | Tabla de configuración pública completa. | `Scripts/main.lua` al inicio. | campo distinto catalogado en [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURACI%C3%93N.md). | Controla el descubrimiento, los presupuestos, los informes, las puertas de revisión y los marcadores locales opcionales. | Lua/load/default la deriva bloquea la validación o hace que el inicio falle y se cierre. | Sí; mantenga una copia de seguridad. |
| `RandomDayGuard/SavedRoot.txt` | Anulación opcional explícita de raíz guardada. | Resolución de raíz guardada en `main.lua`. | Una ruta genérica del sistema de archivos para `AbioticFactor/Saved`. | Selecciona la raíz utilizada para registros, guardados, PlayerData nombres de archivos y `Admin.ini`. | Se permite la falta; las rutas inseguras, erróneas o ilegibles siguen sin comprobarse. | Sí; nunca coloque credenciales aquí. |
| `RandomDayGuard/BUILD_MARKER.txt` | Identidad del paquete legible por humanos. | Instalador, validador y operador. | Versión de lanzamiento renderizada por el constructor. | Sin mutación en tiempo de ejecución. | Empaquetado de bloques que no coinciden con la versión. | No. |
| `RandomDayGuard/MANIFEST.json` | Metadatos de diseño e identidad del paquete legibles por máquina. | Validador, constructor y herramientas de soporte. | Versión de lanzamiento renderizada por el constructor. | Sin mutación en tiempo de ejecución. | JSON o empaquetado de bloques de discrepancia de versión. | No. |
| `RandomDayGuard/README.txt` | Referencia rápida en inglés instalada. | Operador. | Rutas empaquetadas y valores predeterminados seguros. | Sin mutación en tiempo de ejecución. | Las rutas obsoletas o la redacción de seguridad fallan en la paridad de la documentación. | No. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS entrada, recopilación de evidencia, propiedad estatal, programación limitada, aplicación opcional y escritores de resultados. | UE4SS. | Configuración, Fuentes raíz guardadas, estado de ejecución actual, diccionarios y módulo de informes. | Escribe las clases de tiempo de ejecución en [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md); una ruta de aplicación aprobada puede realizar copias de seguridad y actualizaciones `Admin.ini`. | Startup/poll/write las fallas producen un estado de error explícito y nunca prueban que la ruta se completó. | No. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Contabilidad de origen, linaje del ciclo actual, traducción de informes, prueba de ruta, historial público duradero y bandeja de salida local opcional. | `main.lua` trabajador de informes. | De solo lectura state/context devoluciones de llamadas y evidencia local retenida. | Escribe informes JSON/TXT pares, source/history contabilidad, prueba de ruta, historial de cuenta duradero y notificación status/envelopes. | Linaje faltante, fuente requerida, escritura emparejada o escritura a prueba de ruta fuerza `missing` y bloquea la cola. | No. |
| `RandomDayGuard/data/detection_events.json` | Vocabulario de eventos públicos y explicaciones. | `main.lua` evento normalization/reporting. | Válido JSON diccionario. | Etiquetas de evidencia; no crea observaciones. | Missing/malformed validación del repositorio de bloques de datos. | No. |
| `RandomDayGuard/data/warning_types.json` | Vocabulario de tipo de advertencia y significado de revisión. | Advertencia normalization/reporting. | Válido JSON diccionario. | Etiquetas de evidencia de advertencia. | Missing/malformed validación del repositorio de bloques de datos. | No. |
| `RandomDayGuard/data/object_categories.json` | Object/class vocabulario de categorías. | Escaneo e informes de registro de objetos. | Válido JSON diccionario. | Etiquetas del contexto de clase extraído. | Missing/malformed validación del repositorio de bloques de datos. | No. |
| `RandomDayGuard/runtime/**/.gitkeep` | Solo marcadores de posición de diseño de instalación vacíos. | Extracción de paquetes. | Bytes vacíos. | Crea una estructura de directorio grabable; no se incluye ninguna evidencia. | Cualquier miembro del tiempo de ejecución que no sea un marcador de posición bloquea la lista de permitidos exacta. | No. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS cargador y guardián

`Scripts/main.lua` posee el inicio del guardián independiente, el descubrimiento de raíz guardada, el final del registro actual, las épocas y sesiones del servidor, el sondeo y escaneo limitados, object/world contexto, puntuación de revisión, `Admin.ini` puertas de seguridad, resultados operativos heredados y transferencia separada de informes y trabajadores. Debe mantener limitadas las encuestas en vivo mientras se reanuda de forma independiente el lento trabajo histórico. Un latido, un marcador de inicio o un `poll_id` creciente prueban solo ese componente; La finalización de la ruta requiere el mismo inicio, época, sondeo, actualización de la fuente, par de informes y prueba de ruta actuales.

La fuente y el paquete tienen una autoridad: `RandomDayGuard/Scripts/main.lua`. Una copia `scripts/` en minúsculas no forma parte del árbol de fuentes ni de la versión. Mantener una ortografía canónica evita errores de colisión de casos cuando el paquete se extrae en Windows o Linux.

<a id="public-reporting-module"></a>
## Módulo de informes públicos

`Scripts/public_pipeline.lua` recibe devoluciones de llamadas en lugar de credenciales de host o adaptadores de proveedor. Inventa ocho clases de origen, registra estados terminales e incompletos, mantiene a los reproductores actuales separados del historial retenido, traduce cada ruta en el orden `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action` y `Source references`, luego escribe prueba de ruta. El modo de notificación opcional escribe únicamente un sobre JSON local; nunca reclama la entrega ni agrupa una entrega endpoint/bridge.

El dispositivo ejecutable en `tests/lua/public_pipeline_runtime_test.lua` carga este módulo enviado con Lua, prueba rutas llenas y esperadas vacías, prueba que un ciclo de fuente de corriente faltante falla y prueba que las rutas incompletas no ingresan a la bandeja de salida.

<a id="configuration-and-data"></a>
## Configuración y datos

[`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURACI%C3%93N.md) y [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) son generadas por `tools/generate_documentation_audit.py` a partir de un análisis estructural no ejecutable de `config.lua`, la lista de paquetes permitidos y las clases de salida descubiertas en el origen. Se valida el contenido generado exacto y la cobertura uno a uno. Los tres diccionarios JSON son etiquetas y asignaciones, no fuentes de evidencia. Un operador puede editar la configuración, la selección de raíz guardada y la habilitación; el código fuente, los diccionarios, los manifiestos y los archivos Léame empaquetados son propiedad de la versión.

<a id="package-layout"></a>
## Diseño del paquete

El constructor admite solo los tres archivos legales raíz, el `RandomDayGuard/` rutas anteriores y marcadores de posición de tiempo de ejecución vacíos. Ordena los miembros byte a byte, corrige ZIP metadatos, empaqueta el cargador canónico una vez, escanea cada miembro en busca de material privado, registra un SHA-256 para cada miembro, vincula nombres y bytes en un resumen de contenido y compila dos veces. Las pruebas rechazan cada colisión entre casos y demuestran que la extracción normal produce exactamente un archivo físico por entrada de archivo.

El repositorio público conserva solo la carpeta de la versión actual. El creador verifica que ZIP, la suma de verificación, las notas, los marcadores de versión y el árbol de fuentes coincidan.

<a id="code-comment-contract"></a>
## Contrato de comentarios de código

Los comentarios en tiempo de ejecución son contratos de mantenimiento concisos, no un segundo manual. Cada módulo de tiempo de ejecución enviado debe colocar un enlace canónico en su bloque de comentarios de apertura:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Los bloques de estado no obvio, programación, write/readback/rollback, descubrimiento de fuente, traducción, evidencia, esquema de salida, cadencia de ruta y redacción utilizan comentarios enfocados con estas etiquetas cuando corresponda:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

El cargador principal también tiene un comentario de propietario enfocado para la configuración. carga, descubrimiento guardado, reemplazo atómico, aplicación y programación. Estos comentarios establecen los límites del flujo de control y de fallas; no cambian el comportamiento del tiempo de ejecución.

El validador requiere un enlace a nivel de módulo `Documentation:` para cada módulo de tiempo de ejecución, resuelve cada ruta de comentario y ancla, requiere comentarios de falla y contrato enfocados en ambos módulos de tiempo de ejecución y compara los mismos enlaces canónicos con `TRACEABILITY_INDEX.json`. Un comentario es trazabilidad, no prueba de tiempo de ejecución.

<a id="contributor-change-checklist"></a>
## Lista de verificación de cambios de colaborador

1. Actualizar un módulo propietario y su dispositivo enfocado.
2. Actualizar la configuración canónica, el esquema, la salida, la evidencia o la sección de ciclo de vida.
3. Ejecutar `python -B tools/generate_documentation_audit.py --write` después una configuración, ruta empaquetada, clase de salida generada, propietario o cambios en el contrato de recuperación.
4. Ejecutar `python -B tools/generate_documentation_audit.py --check`, pruebas unitarias enfocadas, el dispositivo real de Lua donde Lua está disponible, el validador completo, dos compilaciones deterministas independientes y `git diff --check`.
5. Revise la lista de miembros ZIP generada, la suma de verificación y el escaneo de material privado antes de crear la versión.
