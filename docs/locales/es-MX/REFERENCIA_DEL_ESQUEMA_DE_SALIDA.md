<a id="output-and-state-schema-reference"></a>
# Referencia de esquema de estado y salida

> **Fuente canónica en inglés:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Este es el contrato canónico para archivos generados orientados al operador. Sólo él posee rutas de salida exactas, nombres de campos, valores permitidos, requisitos de linaje y esquemas de ruta. Las guías de procedimiento se vinculan aquí en lugar de redefinir esos hechos.

La evidencia en tiempo de ejecución tiene autoridad; un nombre de archivo, un latido del programador, un informe traducido o un objeto de bandeja de salida local no prueban más que sus propios campos y linaje.

<a id="public-report-routes"></a>
## Rutas de informes públicos

El trabajador del informe posee cinco rutas según el `runtime/final_logs/`:

| Ruta | Contrato | `full` requisito | Significado vacío esperado |
|---|---|---|---|
| `server_status` | Programador actual, registro activo, escaneo pendiente y estado de cobertura de origen. | Eventos actuales boot/epoch/poll linaje, registro activo nuevo, accounting/history escrituras y JSON/TXT par. | No se utiliza para un ciclo actual que de otro modo sería saludable; El linaje que falta es `missing`. |
| `daily_rollup` | Eventos actuales day/window continuidad entre el servidor, los reproductores, los casos, el escaneo y la cobertura. | Terminal de contabilidad histórica suficiente para completar la ruta y la prueba del ciclo actual. | No hay jugadores retenidos ni casos de revisión. |
| `player_activity` | Separe el actual y el histórico player/account observaciones. | Prueba del ciclo actual más una o más current/historical filas. | No hay filas de reproductor elegibles en entradas limitadas; sin sujeto sintético. |
| `case_review` | Casos retenidos nombrados y review/BAN-ELIGIBLE candidatos actuales. | Prueba del ciclo actual más uno o más casos nombrados con referencias de fuentes. | Ningún caso nombrado cumplió con los criterios de revisión; sin caso sintético. |
| `critical_guard` | Falla de integridad de evidencia, inicio, sondeo o programador de arranque actual. | Prueba de ciclo actual más una falla crítica actual. | Sin falla crítica actual; Los errores de texto antiguos no pertenecen a esta ruta. |

Cada ruta habilitada escribe `<route>_latest.json` y `<route>_latest.txt`. El par no se completa hasta que `runtime/final_logs/route_proof.json` registre la misma versión, arranque, época, sondeo y actualización de la fuente.

<a id="report-json-schema"></a>
## Informe JSON esquema

Todas las rutas JSON usos `schema="randomdayguard.report/v1"`.

| Campo | Tipo | Significado e invariante |
|---|---|---|
| `schema` | cadena | Exactamente `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | cadena | Marca de tiempo de generación y fecha del informe. |
| `version` | cadena | Runtime/package identidad para este ciclo. |
| `boot_id`, `epoch_id` | cadena | Epoca de continuidad del servidor y arranque del proceso actual. Ambos son necesarios para completarse. |
| `poll_id` | entero | Identificador de encuesta actual positivo. Zero/missing no puede completar una ruta. |
| `source_freshness` | objeto | `status`, `checked_ts`, estado del registro activo, marca de tiempo de la última encuesta y marca de tiempo de la última encuesta completada. |
| `current_cycle_proof_complete` | booleanos | Verdadero solo cuando el linaje y la evidencia nueva active-log/current-poll coinciden. |
| `route` | enum | Una de las cinco rutas arriba. |
| `route_proof_status` | enum | `full`, `limited_expected_empty`, o `missing`. |
| `coverage_status` | enum | Exactamente `complete`, `complete_with_gaps`, `partial`, o `unavailable`. |
| `completed`, `expected_empty` | booleanos | `completed` es falso solo para `missing`; `expected_empty` es verdadero solo para `limited_expected_empty`. |
| `observed` | conjunto de cadenas | Concreto retenido facts/counts/statuses. |
| `interpretation` | conjunto de cadenas | Significado cauteloso calibrado según la evidencia. |
| `unknown` | conjunto de cadenas | Identidad faltante, historial, fuente o contexto. |
| `does_not_prove` | conjunto de cadenas | Conclusiones que la evidencia no puede respaldar. |
| `next_action` | cadena | Acción del operador delimitada más segura. |
| `source_references` | conjunto de cadenas | Referencias únicas clasificadas runtime/Saved. |
| `enforcement_authority` | booleanos | Siempre falso. Un informe nunca autoriza una escritura. |
| `output_paths` | dos cadenas | JSON y TXT rutas agregadas antes de las escrituras emparejadas. |

`coverage_status` es solo contabilidad de nivel superior. Registros fuente propios por separado`available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` y `error`. Prueba de ruta posee por separado`full`, `limited_expected_empty` y `missing`; los valores nunca cruzan estos límites.

Extensiones de ruta:

- `server_status`: `scheduler_status`, `active_log_status` y `server_metrics`. Las métricas registran el inicio de la época actual, la marca de tiempo y el ID de la última encuesta completada, el recuento de jugadores activos, active/backup-log cuenta, escanea pending/progress valores y configured/usable/unavailable contabilidad del grupo de origen. No inventan el tiempo de actividad, los recuentos de reinicios, las marcas de tiempo de las copias de seguridad ni la duración de las interrupciones cuando ninguna fuente expone esos hechos.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players` y matriz de compatibilidad `players`. Cada sesión del mismo día mantiene su ID de sesión, ID de cuenta y nombre para mostrar cuando se conoce, join/leave marcas de tiempo, indicadores de salida limpia y ciclo de vida, y referencias de origen. La identidad retenida y la PlayerData presencia siguen siendo contexto, no prueba de actividad actual.
- `case_review`: `cases`, `review_subjects`, `current_case_count` y `retained_case_count`. Un sujeto de revisión actual registra su case/account ID, nombre para mostrar cuando se conozca, estado, puntuación, confianza de identidad, first/last observación, recuentos de advertencias, motivos, indicador de actividad actual y referencias de fuentes. Los casos retenidos no crean un asunto actual por sí solos.
- `critical_guard`: `critical_failure_present` y `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window` y `daily_metrics`. Las métricas registran la fecha del informe, jugadores activos, cuentas con actividad el mismo día, altas, bajas, salidas limpias y sucias, devoluciones del ciclo de vida, sujetos de revisión nombrados actuales, casos retenidos, current/retained recuentos de identidad y cobertura del grupo de origen.

<a id="translated-txt-schema"></a>
## Traducido TXT esquema

El archivo de texto emparejado comienza con el resultado legible por el operador y mueve los detalles del linaje al final. Conserva este orden exacto de las secciones:

```text
RandomDayGuard <route title>
Generated: <timestamp>

Summary
<one plain-language route summary>

What Guard observed
- ...

What it means
- ...

What remains unknown
- ...

Recommended next step
...

Evidence boundary
- ...

Rating explanation
- ...

Technical record
- Route: <route>
- Version: <version>
- Cycle: boot=<boot> epoch=<epoch> poll=<poll>
- Source freshness: <status>
- Route result: <full|limited_expected_empty|missing>
- Coverage: <status>

Translation notes
- ...

Source references
- ...
```

La traducción utiliza solo los campos estructurados del informe y las asignaciones de diccionario aprobadas. No puede agregar jugadores, casos, entrega, causalidad, propiedad, intención o elegibilidad de ejecución ausentes del informe estructurado. Los detalles técnicos permanecen disponibles sin desplazar el resultado legible.

<a id="source-accounting-schema"></a>
## Esquema de contabilidad de origen

`runtime/final_logs/source_accounting_latest.json` usos `randomdayguard.source-accounting/v1` con generación reason/status, enablement/disabled motivo, current/historical distinción, manifiesto de archivo modificado, registros de origen, usable/unavailable listas de clases y un límite de reclamaciones.

Cada registro fuente contiene:

| Campo | Tipo | Significado |
|---|---|---|
| `source_class` | cadena | Una de las ocho clases siguientes. |
| `scope` | `current` o `historical` | Propiedad del tiempo; los ámbitos nunca se fusionan de forma silenciosa. |
| `required` | booleanos | Solo `active_log` es necesario para la actualización de la ruta del ciclo actual. |
| `status` | enum | Resultado fuente que se enumera a continuación. |
| `terminal` | booleanos | Falso solo para `partial` y `deferred`. |
| `available`, `readable` | booleanos | Verdadero solo para `available` y `expected_empty`. |
| `file_count` | entero | Contabilizado limitado file/reference recuento. |
| `source_references` | matriz | Fuente única ordenada paths/references. |
| `detail` | cadena | Resultado limitado o detalle de error. |
| `does_not_prove` | cadena | La disponibilidad no es intención, propiedad, daño, duplicación o prueba de cumplimiento. |

Clases de fuente:

| Clase de fuente | Alcance | Qué aporta | Lo que no puede probar |
|---|---|---|---|
| `active_log` | actual, requerido | Registro activo legible del servidor y linaje de encuestas actualizado. | Historia completa o culpabilidad del jugador. |
| `admin_ini` | actual, opcional | Estado actual estructuralmente válido moderator/ban o ausencia esperada. | Metadatos de comportamiento del jugador o motivo válido. |
| `recent_backup_logs` | histórico | Legible rotated/backup referencias de registro. | Presencia actual o estado de inicio actual. |
| `playerdata_filenames` | contexto actual | Referencias de nombres de archivos legibles delimitadas bajo la raíz guardada seleccionada. | Propiedad del archivo, presencia en vivo, contenido de identidad o mala conducta. |
| `existing_cases` | histórico | Caso nombrado retenido files/index registros capturados antes de los resultados actuales. | Actividad actual o corrección de conclusiones antiguas. |
| `existing_reports` | histórico | Retenido final/forensic/warning informe referencias. | Reemplazo de fuente autorizada. |
| `existing_evidence` | histórico | Referencias de evidencia retenida. | Integridad de los eventos que el servidor nunca expuso. |
| `world_save_scan` | histórico | Estado limitado completo, parcial, diferido o no disponiblescan/checkpoint. | Acción o propiedad de un jugador específico. |

Valores de estado de origen:

| Estado | Terminal | Significado y acción del operador |
|---|---:|---|
| `available` | sí | Existe una fuente útil legible; revisa sus referencias. |
| `expected_empty` | sí | La fuente opcional fue verificada y legítima absent/empty. No inventes datos. |
| `partial` | no | El límite de trabajo o inventario acotado está incompleto; permitir reanudar. |
| `deferred` | no | El trabajo está pendiente intencionalmente; espere al trabajador propietario. |
| `unavailable` | sí | Source/path/tool está ausente o inutilizable; reparar solo si la ruta lo necesita. |
| `malformed` | sí | El contenido falló en la validación estructural; conservarlo y reparar el formato. |
| `permission_denied` | sí | El acceso fue denegado explícitamente; restaurar el acceso de lectura con privilegios mínimos. |
| `error` | sí | El nivel de fuente limitado probe/read falló inesperadamente; inspeccionar `detail` sin exponer secretos. |

Nivel superior `coverage_status` es exactamente `complete`, `complete_with_gaps`, `partial`, o `unavailable`. Un nivel de fuente requerido `error`, `malformed`, o `permission_denied` se acumula al nivel superior `unavailable`; nivel de fuente `deferred` se acumula al nivel superior `partial`. Deshabilitar la contabilidad de origen aún escribe un estado de no disponible y fuerza todas las rutas al `missing`.

<a id="historical-status-schema"></a>
## esquema de estado histórico

`runtime/final_logs/historical_backfill_latest.json` usos `randomdayguard.history/v1`: `generated_ts`, la contabilidad `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, la matriz de contabilidad de origen, las clases no disponibles y un `next_action`.

`runtime/history/public_accounts.tsv` limitado es un historial público duradero con este encabezado:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

Las filas se ordenan por ID de cuenta, los campos son single-line/tab-safe y las referencias son sorted/unique. Este archivo conserva el contexto histórico durante los reinicios silenciosos; nunca convierte la historia en presencia actual.

<a id="route-proof-schema"></a>
## Esquema de prueba de ruta

`runtime/final_logs/route_proof.json` usos `randomdayguard.route-proof/v1` y registra la marca de tiempo de generación de nivel superior, la versión, el inicio, la época, la encuesta, la actualización de la fuente, la integridad del ciclo actual, los estados permitidos y una `routes` matriz.

Cada entrada de ruta contiene route/status, version/boot/epoch/poll, objeto de actualización de fuente, ciclo actual integridad, rutas de salida y referencias de fuentes. Una ruta deshabilitada registra `status="missing"` y `reason="route_disabled"`. Si falla la escritura a prueba de rutas, cada ruta se reescribe como incomplete/missing antes de que se acepte cualquier candidato a notificación.

<a id="notification-schemas"></a>
## Esquemas de notificación

El modo público opcional es solo la bandeja de salida de archivos locales.

`runtime/notifications/pending/<route>_latest.json` usos `randomdayguard.notification/v1` con marca de tiempo generada, version/boot/epoch/ poll/source frescura, ruta, `completed_output`, estado de prueba de ruta, rutas de informes estructuradas y traducidas, referencias de fuentes, `delivery_backend="none"` y `delivery_attempted=false`. La salida elegible utiliza `status="ready_for_local_consumer"`, `delivery_eligible=true` y `delivery_allowed=true`. Una ruta configurada pero missing/ineligible aún escribe un sobre de auditoría con `status="suppressed_current_cycle"`, ambas banderas de entrega son falsas y `suppression_reason="route_or_completion_policy_blocked"`. Por lo tanto, la presencia de un archivo en `pending/` no significa por sí solo que esté en cola o sea elegible.

`runtime/notifications/notification_status.json` usos `randomdayguard.notification-status/v1` con el mismo linaje, `generic_local_outbox_only=true`, `delivery_attempted=false` y filas por ruta `queued`/`outcome`. `full` es elegible; El vacío esperado es elegible solo cuando `include_expected_empty=true`; `missing` nunca es elegible. En caso de error de escritura a prueba de ruta, el resultado del estado es `route_proof_write_failed`; Aún se puede escribir un sobre de auditoría suprimido, pero no se acepta como resultado.

<a id="runtime-output-inventory"></a>
## Inventario de salida en tiempo de ejecución

El índice de trazabilidad tiene una fila de máquina para cada ruta o clase de archivo dinámico. Este inventario legible agrupa archivos según el propósito del operador.

| Ruta o patrón | Producer/trigger | Políticas y estados útiles | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Entrada del cargador. | Inicio sobrescrito identity/probe. | La falta no prueba la carga; inspeccionar UE4SS registros y habilitación. |
| `runtime/config_load_error.txt` | Error de carga de configuración. | Solo error, conserva el motivo limitado. | Restaurar la configuración pública válida y reiniciar. |
| `runtime/saved_path_probe.json` | Resolución de raíz guardada. | Candidate/readability limitada. | Establezca `SavedRoot.txt` o reparar un candidato genérico. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Ciclo de vida de inicio. | Error de inicio más reciente y de inicio actual. | Solo el arranque coincidente posee el estado crítico actual. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report integración. | Último version/capability/handoff. | La variación de versión o capacidad bloquea las reclamaciones de finalización. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Encuesta finalizer/error. | Último poll/scheduler/in-flight estado y error de arranque actual. | Reparar la devolución de llamada limitada y solicitar una encuesta completada más reciente. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Registrador de eventos. | Delimitado append/rotation. | Conserve los bytes anteriores; El comportamiento de reparación disk/retention antes de confiar en las lagunas. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Registro tail/registry. | Últimas compensaciones e identidades de registros canónicos. | Reconstruya con cuidado; los registros de copia de seguridad siguen siendo históricos. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle normalizador. | Contexto de solo agregar. | El contexto faltante no puede probarse graceful/crash. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Propietario de la época. | Épocas actuales y retenidas del servidor. | Iniciar un nuevo época después de la reparación; no reescriba el historial anterior. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Propietario de la sesión. | Current/historical eventos e instantáneas de la sesión. | Las filas no asignadas permanecen desconocidas; sin invención de identidad. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session módulo de agregación e informes. | Instantánea actual más historial duradero. | Mantenga los alcances separados y restaure a partir de evidencia, no de conjeturas. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state redactores. | Instantáneas actuales sobrescritas. | Stale/missing es desconocido, no se espera que esté vacío. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly agregación. | Índices reconstruibles. | Reconstrucción a partir de eventos autorizados. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Trabajador de escaneo. | Iniciado, partial/deferred, punto de control, completo o error. | Reanudar punto de control; reconstruir solo con el motivo registrado. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Trabajador de línea base. | Último scan/baseline y enlace de archivos modificados. | Stale/incompatible los manifiestos requieren una reconstrucción explícita. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Escaneo de objetos. | Partial/final contexto de clase. | Los recuentos no son prueba de la acción del jugador; reanudar o reconstruir el escaneo. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | Comparación de objetos. | Agregar solo new/delta contexto parcial y luego final. | Revisar mapping/baseline antes de la inferencia. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Índices raíz guardados. | Filename/admin contexto de estructura. | Los nombres de archivo son débiles; el estado de administrador con formato incorrecto cierra las escrituras. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | Escritor del estado mundial. | Boot/current/session instantáneas y diferencias. | Solo contexto; regenerar después de scan/source reparación. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence redactores. | Anexos delimitados y per-player/session archivos de revisión. | El informe que falta no es la prueba del evento que falta; inspeccionar la evidencia fuente. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review agregación. | Material de revisión nombrado y candidatos en cola. | Caso membership/threshold nunca pasa por alto las puertas específicas de la cuenta. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Transacción opcional Admin.ini. | Copia de seguridad, libro de registro de éxito o explícito failure/rollback evidencia citada. | Cualquier backup/write/readback/rollback falla cierra la aplicación; restaurar copia de seguridad. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Escritor de marcadores opcional. | Solicitud local únicamente. | No demuestra consumo ni reinicio. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Resumen forense. | Índices de revisión reconstruibles actuales y fechados. | Reconstrucción desde el origen evidencia; nunca trate el resumen como autoridad. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Trabajador de informes públicos. | Esquemas y reglas de finalización anteriores. | Reparar el primer no coincidente lineage/source/write; faltante permanece faltante. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Bandeja de salida local opcional. | Sobre local elegible o explícitamente suprimido más estado. | Missing/ineligible las rutas pueden tener archivos suprimidos pero nunca están en cola; inspeccionar los indicadores de entrega y no inferir que no hay entrega externa. |

Overwrite/append/retention está controlado por la sección de producción en [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURACI%C3%93N.md). Los paquetes ZIP solo contienen `.gitkeep` vacíos en `runtime/`; cualquier evidence/output byte en un paquete de versión no supera la validación.

<a id="failure-and-recovery-matrix"></a>
## Matriz de fallos y recuperación

| Fallo | Estado requerido | Recuperación segura | Inferencia no válida |
|---|---|---|---|
| Linaje actual absent/stale | Todas las rutas `missing`. | Restaurar active-log/current-poll comprobar y regenerar. | Los archivos de ruta antiguos no están completos actualmente. |
| Se espera que la fuente opcional esté vacía | Fuente `expected_empty`; la ruta elegible puede ser `limited_expected_empty`. | No hay reparación a menos que la fuente exista. | Vacío no está disponible y no prueba una ausencia histórica. |
| Escaneo incompleto | Fuente `partial` o `deferred`. | Permitir currículum limitado; mantenga explícita la política de ruta actual. | Parcial no es corrupción. |
| Fuente requerida no disponible | `coverage_status=unavailable`; rutas dependientes `missing`. | Reparación seleccionada Saved/log acceso. | Otras fuentes en buen estado no reemplazan la fuente requerida. |
| Errores de sondeo de fuente requerida | Estado de la fuente `error` con `detail`; `coverage_status=unavailable`; rutas dependientes `missing`. | reparar el source/probe nombrado y generar un ciclo más nuevo. | Un error de origen no es un quinto valor de cobertura de nivel superior. |
| La escritura del informe emparejado falla | `coverage_status=unavailable`; la ruta converge para `missing`. | Reparar el sistema de archivos y reescribir ambos miembros del par más la prueba. | Un archivo hermano no está completo y el error de escritura no es de nivel superior `error`. |
| La escritura a prueba de ruta falla | Faltan todas las rutas reescritas; sin bandeja de salida elegible; las rutas configuradas pueden recibir sobres de auditoría suprimidos. | Reparar la escritura a prueba de ruta y regenerar salidas del mismo ciclo. | Informe de aspecto válido JSON o un sobre suprimido no es prueba de ruta. |
| La escritura de notificación falla | Resultado `local_outbox_write_failed`. | Reparar la raíz de salida local; regenerar a partir del informe completado. | No se produjo ninguna entrega externa. |
| Admin.ini la transacción falla | Aplicación bloqueada con backup/write/readback/rollback evidencia citada. | Restaurar copia de seguridad verificada; permanecen solo para revisión. | Un umbral o informe no puede justificar eludir la recuperación. |

Ver [`EVIDENCE_BOUNDARY.md`](L%C3%8DMITE_DE_EVIDENCIA.md), [`ARCHITECTURE.md`](ARQUITECTURA.md) y [`SOURCE_MODULE_REFERENCE.md`](REFERENCIA_DEL_M%C3%93DULO_FUENTE.md).
