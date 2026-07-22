<a id="player-review-workflow"></a>
# Flujo de trabajo de revisión del jugador

> **Fuente canónica en inglés:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Utilice esta página para un jugador, cuenta o caso. El propósito es una decisión de revisión reproducible, no una acusación automatizada.

<a id="quick-path"></a>
## Ruta rápida

1. Abrir `runtime/final_logs/player_activity_latest.json`.
2. Confirma el estado de la ruta en `runtime/final_logs/route_proof.json`.
3. Identifique qué observaciones son actuales y cuáles son históricas.
4. Compruebe las referencias de fuentes de sesión e identidad citadas.
5. Revisar `case_review_latest.json` cuando exista un caso correlacionado.
6. Registre las incógnitas y `does_not_prove` antes de elegir una acción.
7. Deje la aplicación de medidas deshabilitada a menos que Se han probado puertas de control independientes.

<a id="1-confirm-route-proof"></a>
## 1. Confirmar prueba de ruta

Interprete la ruta del reproductor como:

| Estado | Acción |
|---|---|
| `full` | Continúe, mientras sigue revisando los límites de fuentes. |
| `limited_expected_empty` | Continúe solo con los sujetos realmente presentes; no invente un jugador o caso faltante. |
| `missing` | Detenga la decisión del jugador y solucione el problema de la ruta. |

Un planificador saludable no reemplaza la prueba de ruta.

<a id="2-establish-identity"></a>
## 2. Establecer identidad

Prefiera un identificador de cuenta limpio corroborado por evidencia de identidad expuesta al servidor y, cuando esté disponible, PlayerData nombres de archivos. Mantenga la referencia de la fuente sin procesar.

No aplique desde:

- un nombre para mostrar únicamente;
- un nombre visto en un panel de notificación o alojamiento;
- similitud de tiempo;
- una identidad no asignada o de confianza débil;
- un informe histórico sin corroboración actual.

<a id="3-separate-current-from-historical"></a>
## 3. Separe la evidencia actual de la histórica

La evidencia actual describe la ventana de informes activa o la época del servidor. La evidencia histórica puede explicar un patrón, pero no puede llenar silenciosamente los vacíos en la ventana actual.

Registre ambos alcances de forma independiente:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Revisar observaciones e interpretación

Lea estas secciones del informe con atención:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Vuelva a abrir la evidencia estructurada citada para cualquier decisión importante. Una traducción es navegación y explicación, no nueva evidencia.

<a id="5-calibrate-the-decision"></a>
## 5. Calibrar la decisión

| Decisión | Usar cuando |
|---|---|
| `INFO` | Observación normal o de bajo contexto. |
| `WATCH` | Señal débil o incompleta que vale la pena monitorear. |
| `REVIEW` | La evidencia correlacionada necesita el criterio del administrador. |
| `BAN-ELIGIBLE` | Se cumplen los umbrales de identidad limpia y evidencia configurada; las puertas de escritura aún se aplican. |
| `AUTO-BANNED` | La aplicación se habilitó explícitamente y la copia de seguridad, la escritura, la lectura y la auditoría se realizaron correctamente. |

Ninguna etiqueta de decisión demuestra culpabilidad o intención.

<a id="6-apply-the-evidence-boundary"></a>
## 6. Aplicar el límite de evidencia

Bloqueos, reconexiones, advertencias, object/class tokens y la agrupación de casos pueden respaldar la revisión. Por sí solos, no prueban fraude, robo, duplicación, propiedad, daño directo o causalidad del incidente.

Si la identidad, el análisis, la copia de seguridad, la escritura, la lectura o la reversión son débiles o fallan, la aplicación debe cerrarse por error.

<a id="review-note-template"></a>
## Plantilla de nota de revisión

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

<a id="related-docs"></a>
## Documentos relacionados

- [`EVIDENCE_BOUNDARY.md`](L%C3%8DMITE_DE_EVIDENCIA.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md)
- [`ADMIN_INI_ENFORCEMENT.md`](CUMPLIMIENTO_DE_ADMIN_INI.md)
- [`DETECTION_SIGNALS.md`](SE%C3%91ALES_DE_DETECCI%C3%93N.md)
