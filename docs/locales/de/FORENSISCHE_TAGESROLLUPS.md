<a id="forensic-daily-rollups"></a>
# Forensische tägliche Rollups

> **Kanonisch-englische Quelle:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Der tägliche Rollup ist ein neu erstellbarer Index. Quellennachweise bleiben maßgeblich; Der Tagesordner und das Abschlussprotokoll sind schnelle Überprüfungspakete, die aus Laufzeitbeweisen generiert werden.

Verwenden Sie diese Seite, wenn Sie einen Ordner zur schnellen Analyse hochladen möchten.

<a id="what-it-is"></a>
## Was es ist
Das tägliche Rollup ist eine wiederaufbaubare Zusammenfassung der Rohbeweise für einen Tag.

Es ersetzt keine Rohbeweise.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## Wohin geschrieben wird
Aktueller Tag:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Tagespaket:

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

Der TXT ist zur schnellen Überprüfung durch den Bediener im Klartext geschrieben.

<a id="what-the-final-txt-should-answer"></a>
## Was soll der endgültige TXT beantworten?
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
## Verwendete Quelldateien
Das Rollup kann diese lesen, wenn vorhanden:

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

Fehlende Dateien sollten als fehlend markiert und nicht als schwerwiegend behandelt werden.

<a id="update-behavior"></a>
## Aktualisierungsverhalten
Für denselben Tag aktualisiert der Wächter dieselben Dateien.

Richtig:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Falsch:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## Absturzsicherheit
Der Wächter sollte zuerst temporäre Dateien schreiben und dann umbenennen:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

Dies schützt die letzte gute Zusammenfassung, wenn der Server während des Schreibens abstürzt.

<a id="playerstsv-columns"></a>
## `players.tsv` Spalten
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
## `ban_recommendations.tsv` Spalten
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
## Überprüfungsregel
Ein tägliches Rollup kann die Überprüfung beschleunigen, sollte aber nicht der einzige Beweis sein.

Wenn eine Empfehlung wichtig ist, überprüfen Sie sie mit:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## Verwandte Dokumente
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](SPEICHER%C3%96KONOMIE_UND_AUSGABEN.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](WORKFLOW_ZUR_PLAYER-%C3%9CBERPR%C3%9CFUNG.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md)
