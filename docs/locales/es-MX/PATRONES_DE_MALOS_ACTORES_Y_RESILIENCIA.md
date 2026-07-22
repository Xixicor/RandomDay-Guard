<a id="bad-actor-patterns-and-resilience"></a>
# Patrones de malos actores y resiliencia

> **Fuente canónica en inglés:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Utilice esta página para comprender cómo el guardia ayuda a revisar el abuso de fallos, el comportamiento adyacente a exploits y la planificación de recuperación.

<a id="what-the-guard-can-help-with"></a>
## Con qué puede ayudar el guardia

| Patrón | Qué comprobar |
|---|---|
| Devoluciones relacionadas con fallos | La misma cuenta activa antes de los fallos y que regresa después del reinicio |
| Sondeo de reconexión rápida | Bucles repetidosjoin/leave o timeout/reconnect |
| Clústeres de cuentas múltiples | Unir oleadas, ventanas de advertencia compartidas, ventanas de falla compartidas |
| Estrés de ráfaga de advertencia | Bucles repetidosActorChannelFailure o ventanas de advertencia de guardado |
| Contexto fuera de límites | PlayerData/map/world contexto cuando es legible |
| Superposición de toque de guardado | Contexto de guardado mundial que superpone sesiones mapeadas |
| Confusión de identidad | Nombres que necesitan mapeo de ConnectID |

<a id="why-it-avoids-memory-access"></a>
## Por qué evita el acceso a la memoria

RandomDayGuard funciona desde archivos propiedad del servidor:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Esto lo hace menos dependiente del estado de la memoria del lado del cliente y menos frágil en las actualizaciones del juego.

Compensación:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Retornos correlacionados con fallas

Patrón:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Archivos útiles:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Reconexión rápida probers

Patrón:

```text
join -> leave -> join -> leave -> join
```

Archivos útiles:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Clústeres de cuentas múltiples

Patrón:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Archivos útiles:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Regla:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Recomendación de copia de seguridad fija

Crear una copia de seguridad fija después de:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Copia de seguridad:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Modelo de recuperación

```text
Clean install
-> verify live defense
-> complete first baseline
-> create sticky backup
-> run server normally
-> use daily rollups for review
-> restore sticky backup if needed
```

<a id="related-docs"></a>
## Documentos relacionados

* [`FORENSIC_DAILY_ROLLUPS.md`](RES%C3%9AMENES_DIARIOS_FORENSES.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUJO_DE_TRABAJO_DE_REVISI%C3%93N_DEL_REPRODUCTOR.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](CAMBIOS_EN_LA_CARPETA_WORLD_SAVE.md)
