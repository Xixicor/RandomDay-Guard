<a id="configuration-profiles"></a>
# Perfiles de configuración

> **Fuente canónica en inglés:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Utilice esta guía práctica para elegir y aplicar un perfil de configuración práctico. Para obtener una explicación de cómo interactúan los grupos de configuración, lea [`CONFIG_REFERENCE.md`](REFERENCIA_DE_CONFIGURACI%C3%93N.md). Para campos exactos, valores predeterminados, tipos e invariantes, utilice el [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURACI%C3%93N.md).

Cada bloque Lua a continuación generado es un conjunto de entradas de nivel superior que pueden reemplazar las entradas coincidentes dentro del `return { ... }` tabla enviada.

<a id="profile-chooser"></a>
## selector de perfil

| Situación | Usar este perfil |
|---|---|
| Primera instalación | Primera instalación segura |
| El servidor es inestable y falla con frecuencia | Evidencia actual sin escaneo lento |
| Quieres object/world contexto | Línea de base completa |
| Quieres revisar registros antiguos | Forense backfill |
| Quieres recomendaciones pero no escrituras | Pruebas de cumplimiento |
| Estás listo para dejar que el guardia escriba prohibiciones | Aplicación habilitada |
| El disco es limitado | Bajo crecimiento del disco |
| Completaste una línea de base limpia | Configuración de copia de seguridad fija |

<a id="safe-first-install"></a>
## Primera instalación segura

Utiliza esto primero en un servidor activo.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
},

scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Qué hace:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Evidencia actual sin escaneo lento

Utiliza esto si el servidor es inestable y necesitas crash/reconnect evidencia antes de una prueba pesada. escanear.

```lua
log_tail = {
    enabled = true,
},

scanning = {
    full_scan_on_start = false,
},

enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Qué hace:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Línea de base completa

Utilice esto después de que el servidor pueda permanecer activo el tiempo suficiente para escanear.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

Qué hace:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Forense backfill

Utilice esto solo cuando revise intencionalmente registros históricos.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Antes de usarlo:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Pruebas de cumplimiento

Utilice esto antes de la Admin.ini escritura real.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

Qué inspeccionar:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Aplicación habilitada

Úselo solo después de que el resultado de la revisión sea correcto.

```lua
enforcement = {
    review_only_mode = false,
    auto_ban = true,
    write_admin_ini = true,
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
},
```

Antes de habilitar:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
## Bajo crecimiento del disco

Utilice esto cuando los archivos en tiempo de ejecución crezcan demasiado rápido.

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},

retention = {
    detailed_retention_days = 7,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    compact_json_outputs = true,
},
```

<a id="sticky-backup-setup"></a>
## Configuración de copia de seguridad fija

Úselo después de la primera línea base completa.

Compruebe que existan:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Luego respaldelos con `config.lua`, `SavedRoot.txt` y `Admin.ini`.

<a id="related-docs"></a>
## Documentos relacionados

* [`CONFIG_REFERENCE.md`](REFERENCIA_DE_CONFIGURACI%C3%93N.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](RES%C3%9AMENES_DIARIOS_FORENSES.md)
* [`ADMIN_INI_ENFORCEMENT.md`](CUMPLIMIENTO_DE_ADMIN_INI.md)
