<a id="memory-economy-and-output-files"></a>
# Memoria oeconomiae et imaginum output

> **Canonicum Anglicum fontem:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


 Haec pagina explicat quae fasciculi crescunt, quae fasciculi overscripte sunt, et quid ad recensionem vividam notandam.

<a id="fast-answer"></a>
## Fast responsum

| Quaestio | Open |
|---|---|
| Estne custodia? | `runtime/current/poll_status.json` |
| Quis videtur? | `runtime/account_evidence.json` |
| Quid accidit in sessionibus? | `runtime/evidence/session_events.jsonl` |
| Quid hodie factum est? | `runtime/forensic_days/YYYY-MM-DD/` |
| Quid est plani sermonis summarium? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| Quid est progressus scan? | `runtime/scan_progress.json` |
| Quid est contextus mundi? | `runtime/world_state/current/world_state_latest.json` |
| Quae scripta sunt? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Output exemplar

| Type | Moribus | Exempla |
|---|---|---|
| Current snapshots | Operscripta | `runtime/current/*.json` |
| Tabulae Vicis | Appendite solum | `runtime/evidence/*.jsonl` |
| Tabulae | Renovata vel appensa | `*.tsv` |
| Baselines | Reused post completionem | `runtime/baselines/*` |
| Cotidie rollups | Renovata in loco | `runtime/forensic_days/YYYY-MM-DD/*` |
| Tabulae finales | Planae-linguae cotidie summarium | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Current snapshots

 Haec parva manent et responde "quod nunc verum est."

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
## Play summaria

Hae sunt primae fasciculi ad retractationem retractandam.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Summae:

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
## Tabulae Vicis

Haec tempora serva.

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
## Cotidie rotulae forenses

Hae sunt fasciculi velox fasciculi impositi.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

 Upload unum ex illis folder cum vis celeri temporis analysis.

<a id="scan-and-baseline-files"></a>
## Scan et fasciculi baseline

 His utere ad intelligendum utrum contextus mundus sit partialis an completus.

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
## exactio imaginum

His tantum utere, cum necessitas datur.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` tantum recipere debet:

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## Quae updates cum histrio iungit

expectata updates:

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
## Quae updates cum server inruerit vel restarts

expectata updates:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## Quae updates cum scan progreditur

expectata updates:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## Quae sunt necessariae analysis

Optimus sarcina:

```text
runtime/final_logs/YYYY-MM-DD/
```

Magis sarcina integra:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Fulle argumenti sarcina:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## Related docs

* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
