<a id="forensic-daily-rollups"></a>
# Resúmenes diarios forenses

> **Fuente canónica en inglés:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


El resumen diario es un índice reconstruible. La fuente de evidencia sigue siendo autorizada; la carpeta diaria y el registro final son paquetes de revisión rápida generados a partir de evidencia en tiempo de ejecución.

Utilice esta página cuando desee cargar una carpeta para un análisis rápido.

<a id="what-it-is"></a>
## Qué es
El resumen diario es un resumen reconstruible de la evidencia sin procesar de un día.

No reemplaza la evidencia sin procesar.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## Dónde escribe
Día actual:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Paquete diario:

```text
runtime/forensic_days/YYYY-MM-DD/
- forensic_day_summary.json
- forensic_day_summary.md
- forensic_day_summary.txt
- players.tsv
- sessions.tsv
- crash_reconnects.tsv
- warning_bursts.tsv
- raid_cases.tsv
- world_context.tsv
- ban_recommendations.tsv
- enforcement_audit.tsv
- evidence_index.json

## Final log contents
```text
runtime/final_logs/YYYY-MM-DD/
- final_forensic_log.txt
- final_forensic_log.md
- final_forensic_log.json

El TXT está escrito en un lenguaje sencillo para que el operador pueda revisarlo rápidamente.

<a id="what-the-final-txt-should-answer"></a>
## Qué debe responder el TXT final
```text
Did the guard run?
Was the scan partial or complete?
Who joined?
Who left cleanly?
Who did not leave cleanly?
Who rapidly reconnected?
Who overlapped crashes?
Who returned after crashes?
Who had warning overlap?
Who appears in a cluster?
Who is REVIEW?
Who is BAN-ELIGIBLE?
Which BannedPlayer=<ID> lines are candidates?
Which gates blocked enforcement?
What evidence files support each recommendation?
```

<a id="source-files-used"></a>
## Archivos fuente utilizados
El resumen puede leerlos cuando estén presentes:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
runtime/warning_events.jsonl
runtime/raid_cases/
runtime/world_state/current/world_state_latest.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry.json
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

Los archivos faltantes deben marcarse como faltantes, no tratarse como fatales.

<a id="update-behavior"></a>
## Comportamiento de actualización
Para el mismo día, el guardia actualiza los mismos archivos.

Correcto:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Incorrecto:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## Crash-safety
El guardia debe escribir archivos temporales primero y luego cambiarles el nombre:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

Esto protege el último buen resumen si el servidor falla a mitad de escritura.

<a id="playerstsv-columns"></a>
## `players.tsv` columnas
```text
date
account_id
ban_id
name
identity_confidence
playerdata_verified
first_seen
last_seen
join_count
leave_count
clean_leave_count
unclean_disconnect_count
rapid_rejoin_count
crash_overlap_count
post_crash_reconnect_count
warning_overlap_count
raid_case_count
world_context_count
score
status
recommended_action
ban_eligible
already_enforced
admin_ini_line
```

<a id="ban_recommendationstsv-columns"></a>
## `ban_recommendations.tsv` columnas
```text
date
account_id
ban_id
name
status
recommended_action
reason
admin_ini_line
gates_passed
blocked_by
evidence_files
```

<a id="review-rule"></a>
## Regla de revisión
Un resumen diario puede agilizar la revisión, pero no debe ser la única evidencia.

Cuando una recomendación es importante, verifíquela con:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## Documentos relacionados
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](ECONOM%C3%8DA_DE_MEMORIA_Y_SALIDAS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUJO_DE_TRABAJO_DE_REVISI%C3%93N_DEL_REPRODUCTOR.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md)
