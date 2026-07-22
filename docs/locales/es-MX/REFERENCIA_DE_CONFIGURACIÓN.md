<a id="configuration-concepts"></a>
# Conceptos de configuración

> **Fuente canónica en inglés:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Esta explicación describe qué controla cada área de configuración principal, cuándo se ejecuta y cómo interactúa con las pruebas y las puertas de seguridad. No posee el catálogo de campos exacto ni los procedimientos de perfil.

Para ajustes preestablecidos orientados a tareas y pasos de cambio seguros, utilice [`CONFIG_PROFILES.md`](PERFILES_DE_CONFIGURACI%C3%93N.md). Para cada campo de origen exacto, valor predeterminado, tipo, invariante, efecto de salida y regla de recuperación, utilice el [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURACI%C3%93N.md); el validador requiere una fila allí para cada `config.lua` campo de hoja enviado.

<a id="reading-this-page"></a>
## Leyendo esta página

Cada área de configuración responde:

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## Seguridad de nivel superior

| Opción | Predeterminado | Significado |
|---|---:|---|
| `enabled` | `true` | Interruptor maestro para la protección |
| `enforcement.review_only_mode` | `true` | Record/recommend solo |
| `enforcement.auto_ban` | `false` | No prohibir automáticamente de forma predeterminada |
| `enforcement.write_admin_ini` | `false` | No escribir Admin.ini de forma predeterminada |

Manténgalos seguros hasta que el propietario del servidor haya revisado el resultado.

<a id="saved"></a>
## `saved`

Controla cómo el guardia encuentra la carpeta del servidor `Saved/` y qué familias de archivos puede escanear.

Usar cuando:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Verificar:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Regla:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Controla la lectura de registros en vivo.

Opciones útiles:

| Opción | Valor seguro | Por qué |
|---|---|---|
| `enabled` | `true` | Necesario para defensa en vivo |
| `start_at_end_on_first_run` | `true` | Evita los registros antiguos como eventos en vivo |
| `tail_backup_logs` | `false` | Los registros de respaldo son históricos, no activos |
| `max_lines_per_poll` | limitados | Mantiene el bucle de sondeo receptivo |

Verificar:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Controla los sondeos y los presupuestos.

Regla de salud principal:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Verificar:

```text
runtime/current/poll_status.json
```

Si `poll_id` se detiene, algo está bloqueando el bucle.

<a id="source_accounting"></a>
## `source_accounting`

Controla la cobertura y el alcance de las fuentes de evidencia explícitas.

| Clave | Predeterminado | Significado |
|---|---:|---|
| `enabled` | `true` | Escribe contabilidad de fuentes para informes de rutas públicas. |
| `require_terminal_status` | `true` | Requiere que cada fuente exponga un terminal o terminal explícito estado incompleto. |
| `distinguish_current_from_historical` | `true` | Mantiene la evidencia actual e histórica separada. |
| `slow_world_scan_blocks_current_reports` | `false` | Permite que los informes actuales indiquen que el escaneo del mundo delimitado es diferido o parcial. |
| `changed_file_manifest` | ruta del manifiesto de referencia | Referencia utilizada para la contabilidad historical/world limitada. |

Los estados de origen son `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, o `error`.

La configuración `source_accounting.enabled = false` no elimina silenciosamente la salida de estado. La canalización todavía escribe `runtime/final_logs/source_accounting_latest.json` con `enabled=false`, `status="unavailable"` y `disabled_reason="source_accounting_disabled"`. También escribe el registro de estado histórico con contabilidad no disponible. Debido a que la contabilidad de origen es parte del contrato de informe, todas las rutas fallan cerradas a `missing`; ninguna ruta se considera completada mientras la contabilidad está deshabilitada.

<a id="reports"></a>
## `reports`

Controla el canal de informes local genérico.

Los valores predeterminados habilitan las cinco rutas y escriben en `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Cada ruta debe escribir resultados estructurados y traducidos más pruebas en `route_proof.json`. Deshabilitar una ruta produce `missing` prueba en lugar de pretender que se completó.

<a id="notification"></a>
## `notification`

Bandeja de salida de archivo local genérica opcional. Está deshabilitado de forma predeterminada y no envía nada a un proveedor externo.

Valores predeterminados:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Todas las rutas de notificación están deshabilitadas de forma predeterminada. Cuando se habilita deliberadamente, la bandeja de salida puede consumir solo un informe traducido completo después de escribir `route_proof.json`. Las pruebas y los informes locales siguen teniendo autoridad. La entrega, los puntos finales de entrega, las credenciales y los puentes específicos del proveedor no forman parte del contrato público de vigilancia independiente.

<a id="scanning"></a>
## `scanning`

Controla el escaneo de línea base, los puntos de control y la actualización de archivos modificados.

Usar cuando:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Verificar:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Configuraciones importantes:

```lua
scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
},
```

<a id="forensic_rollup"></a>
## `forensic_rollup`

Controla el paquete de carga diaria rápida y los registros finales en lenguaje sencillo.

Salidas:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Usar cuando:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Verificar:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Regla:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Controla el volumen de eventos y la agregación de baja importancia.

Usar cuando:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Patrón seguro:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Controla cuánto tiempo se conservan los archivos y cuándo JSONL rotan los registros.

Usar cuando:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Opciones importantes:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

Controla la detección de ventanas de advertencia.

Ejemplos:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Regla:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

Controla la revisión repetida crash/reconnect.

Valores predeterminados seguros:

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Contadores útiles:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Controla el seguimiento de abandono y unión.

Seguro predeterminado:

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Usar para:

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

Cuentas de grupos activas en ventanas relacionadas.

Regla:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Cada cuenta aplicada aún necesita evidencia específica de la cuenta.

<a id="object_registry"></a>
## `object_registry`

Controla object/class extracción de tokens de evidencia guardada legible.

Salidas:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Regla:

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Controla boot/current/session instantáneas del estado mundial.

Salidas:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Uso para revisión de sesiones y contexto mundial.

<a id="enforcement"></a>
## `enforcement`

Controla las recomendaciones y las escrituras reales Admin.ini.

Antes de que Guard pueda agregar una prohibición, todas las afirmaciones siguientes deben ser verdaderas:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
account identity is mapped
not trusted
not moderator
threshold is met
```

Si una afirmación es falsa o no se puede comprobar, Guard se marcha `Admin.ini` no cambia y registra el motivo.

<a id="admin_ini"></a>
## `admin_ini`

Controla las escrituras seguras de archivos.

Reglas:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Controla los archivos de marcadores locales opcionales que otro proceso propiedad del operador puede inspeccionar. No reinicia ni cierra el servidor.

Valores predeterminados:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Salidas:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

No se incluye panel de alojamiento, puente de proveedor ni automatización de reinicio. Habilitar la creación de marcadores no prueba que un proceso externo consumió la solicitud o reinició el servidor.

<a id="related-docs"></a>
## Documentos relacionados

* [`CONFIG_PROFILES.md`](PERFILES_DE_CONFIGURACI%C3%93N.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md)
* [`ADMIN_INI_ENFORCEMENT.md`](CUMPLIMIENTO_DE_ADMIN_INI.md)
