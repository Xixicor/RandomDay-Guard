<a id="memory-economy-and-output-files"></a>
# Ahorro de memoria y archivos de salida

> **Fuente canónica en inglés:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Esta página explica qué archivos crecen, qué archivos se sobrescriben y qué cargar para una revisión rápida.

<a id="fast-answer"></a>
## Respuesta rápida

| Pregunta | Abrir |
|---|---|
| ¿Está vivo el guardia? | `runtime/current/poll_status.json` |
| ¿Quién fue visto? | `runtime/account_evidence.json` |
| ¿Qué pasó con las sesiones? | `runtime/evidence/session_events.jsonl` |
| ¿Qué pasó hoy? | `runtime/forensic_days/YYYY-MM-DD/` |
| ¿Cuál es el lenguaje sencillo? ¿Resumen? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| ¿Qué es el progreso del análisis? | `runtime/scan_progress.json` |
| ¿Cuál es el contexto mundial? | `runtime/world_state/current/world_state_latest.json` |
| ¿Qué prohibiciones se escribieron? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Modelo de salida

| Tipo | Comportamiento | Ejemplos |
|---|---|---|
| Instantáneas actuales | Sobrescritas | `runtime/current/*.json` |
| Registros de eventos | Solo agregar | `runtime/evidence/*.jsonl` |
| Tablas | Actualizadas o agregadas | `*.tsv` |
| Líneas de base | Reutilizadas una vez finalizado | `runtime/baselines/*` |
| Resúmenes diarios | Actualizados en el lugar | `runtime/forensic_days/YYYY-MM-DD/*` |
| Registros finales | Resumen diario en lenguaje sencillo | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Instantáneas actuales

Estos son pequeños y responden a "lo que es cierto ahora".

```text
runtime/current/poll_status.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

<a id="player-summaries"></a>
## Resúmenes de los jugadores

Estos son los primeros archivos que se deben verificar para la revisión de la cuenta.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Resumen:

```text
account_id
ban_id
name
identity_confidence
first_seen
last_seen
join_count
leave_count
status
score
```

<a id="event-logs"></a>
## Registros de eventos

Preservan el línea de tiempo.

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/warning_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
```

<a id="daily-forensic-rollups"></a>
## Resúmenes forenses diarios

Estos son los paquetes de carga rápida.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Sube una de esas carpetas cuando quieras un análisis de período rápido.

<a id="scan-and-baseline-files"></a>
## Archivos de escaneo y de referencia

Utilízalos para comprender si el contexto mundial es parcial o parcial. completo.

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

<a id="enforcement-files"></a>
## Archivos de cumplimiento

Úselos solo cuando el cumplimiento esté habilitado.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` debe recibir solo:

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## Qué se actualiza cuando un jugador se une

Actualizaciones esperadas:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/current/session_state.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-server-crashes-or-restarts"></a>
## Qué se actualiza cuando el servidor falla o se reinicia

Actualizaciones esperadas:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## Qué se actualiza cuando avanza el escaneo

Actualizaciones esperadas:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## Qué cargar para un análisis rápido

Mejor paquete:

```text
runtime/final_logs/YYYY-MM-DD/
```

Paquete más completo:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Paquete de evidencia completo:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## Documentos relacionados

* [`FORENSIC_DAILY_ROLLUPS.md`](RES%C3%9AMENES_DIARIOS_FORENSES.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUJO_DE_TRABAJO_DE_REVISI%C3%93N_DEL_REPRODUCTOR.md)
