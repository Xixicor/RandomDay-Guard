<a id="evidence-boundary"></a>
# Límite de evidencia

> **Fuente canónica en inglés:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Utilice esta página para decidir qué RandomDayGuard puede informar y lo que aún requiere revisión humana.

<a id="core-rule"></a>
## Regla principal

RandomDayGuard registra observaciones delimitadas de archivos propiedad del servidor. Debe identificar la fuente, el alcance, el estado de la recopilación y los límites de cada conclusión material.

La evidencia estructurada tiene autoridad. Un informe traducido explica la evidencia; no puede agregar hechos que están ausentes del registro estructurado.

<a id="evidence-source-classes"></a>
## Clases de fuente de evidencia

| Clase de fuente | Uso típico | No prueba por sí sola |
|---|---|---|
| `admin_ini` | Estado de administración existente y auditado write/readback contexto | Quién causó una incidente |
| `active_log` | Eventos actuales server/session visibles en el registro activo | Intención, propiedad o daño directo |
| `recent_backup_logs` | Contexto del registro histórico | Ocurrió un evento actual |
| `playerdata_filenames` | Corroboración de que un identificador de cuenta limpio existe | Comportamiento, culpa o propiedad de la identidad más allá del identificador expuesto |
| `existing_cases` | Contexto de revisión anterior | Que una interpretación anterior sigue siendo correcta |
| `existing_reports` | Resúmenes y decisiones anteriores | Verdad actual sin corroboración actual |
| `existing_evidence` | Evidencia estructurada histórica | Actividad actual |
| escaneo limitado de guardado del mundo | Lento world/class contexto | Acción del jugador, propiedad, robo, duplicación o daño |

Cada registro fuente availability/readability, recuento de archivos, referencias de fuentes, alcance actual o histórico y un `does_not_prove` explícito declaración.

<a id="source-states"></a>
## Estados de la fuente

| Estado | Significado del operador |
|---|---|
| `available` | La fuente era legible y se recopilaron pruebas. |
| `expected_empty` | La fuente era legible y legítimamente no tenía ningún registro coincidente. |
| `partial` | Se recopilaron algunas pruebas; la cobertura está incompleta. |
| `deferred` | El trabajo limitado se pospuso intencionalmente. |
| `unavailable` | La fuente no está presente en este entorno. |
| `malformed` | La fuente existe pero no se puede analizar de forma segura. |
| `permission_denied` | El organismo de control carece de permiso de lectura. |
| `error` | Error en la recopilación de otro registro motivo. |

El vacío esperado es una observación válida. Nunca debe convertirse en un jugador, caso, incidente o acusación fabricado.

<a id="current-versus-historical-evidence"></a>
## Evidencia actual versus histórica

La evidencia actual pertenece a la ventana de recopilación activa o a la época del servidor. La evidencia histórica proviene de registros, casos, informes, registros de evidencia, copias de seguridad o líneas de base anteriores.

La evidencia histórica puede proporcionar contexto. No puede llenar silenciosamente un vacío de evidencia actual. Los informes deben etiquetar ambos ámbitos y citar sus fuentes por separado.

<a id="corroboration-rule"></a>
## Regla de corroboración

Estos son un contexto útil pero no son una prueba directa por sí mismos:

- mostrar nombres o similitud de nombres;
- coincidencia temporal;
- desconectar o volver a conectar el abandono;
- una falla o ráfaga de advertencia;
- tokens de clase, ruta, actor, mapa o recuento de objetos;
- membresía en un caso agrupado automáticamente;
- informes anteriores sin confirmación de fuente actual.

No reclame culpa, intención, trampa, propiedad, robo, duplicación, daño directo, uso directo de contenedores, acción directa de inventario, coordenadas en vivo exactas, ping en vivo o comportamiento a nivel de memoria sin evidencia que exponga directamente el hecho.

<a id="truthful-report-language"></a>
## Lenguaje de informe veraz

Uso:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Evitar:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Orden de lectura del informe

Cada informe público debe explicar:

1. Significado simple.
2. Por qué es importante.
3. Pruebas técnicas y referencias de fuentes.
4. Próxima acción.
5. Límites, incógnitas y afirmaciones no probadas.

<a id="related-docs"></a>
## Documentos relacionados

- [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](FLUJO_DE_TRABAJO_DE_REVISI%C3%93N_DEL_REPRODUCTOR.md)
- [`BAN_ID_MAPPING.md`](ASIGNACI%C3%93N_DE_ID_DE_PROHIBICI%C3%93N.md)
- [`DETECTION_SIGNALS.md`](SE%C3%91ALES_DE_DETECCI%C3%93N.md)
