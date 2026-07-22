<a id="memory-economy-and-output-files"></a>
# Speicherverbrauch und Ausgabedateien

> **Kanonisch-englische Quelle:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Auf dieser Seite wird erklärt, welche Dateien wachsen, welche Dateien überschrieben werden und was zur schnellen Überprüfung hochgeladen werden muss.

<a id="fast-answer"></a>
## Schnelle Antwort

| Frage | Öffnen |
|---|---|
| Ist der Wächter am Leben? | `runtime/current/poll_status.json` |
| Wer wurde gesehen? | `runtime/account_evidence.json` |
| Was ist mit den Sitzungen passiert? | `runtime/evidence/session_events.jsonl` |
| Was ist heute passiert? | `runtime/forensic_days/YYYY-MM-DD/` |
| Was ist die Zusammenfassung im Klartext? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| Was ist der Scanfortschritt? | `runtime/scan_progress.json` |
| Wie ist der Weltkontext? | `runtime/world_state/current/world_state_latest.json` |
| Was Verbote wurden geschrieben? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Ausgabemodell

| Typ | Verhalten | Beispiele |
|---|---|---|
| Aktuelle Snapshots | Überschrieben | `runtime/current/*.json` |
| Ereignisprotokolle | Nur anhängen | `runtime/evidence/*.jsonl` |
| Tabellen | Aktualisiert oder angehängt | `*.tsv` |
| Grundlinien | Nach Fertigstellung wiederverwendet | `runtime/baselines/*` |
| Tägliche Zusammenfassungen | An Ort und Stelle aktualisiert | `runtime/forensic_days/YYYY-MM-DD/*` |
| Endgültige Protokolle | Tageszusammenfassung im Klartext | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Aktuelle Snapshots

Diese bleiben klein und beantworten „Was ist jetzt wahr?“

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
## Spielerzusammenfassungen

Dies sind die ersten Dateien, die zur Kontoüberprüfung überprüft werden.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Sie fassen Folgendes zusammen:

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
## Ereignisprotokolle

Diese bewahren die Zeitachse.

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
## Tägliche forensische Rollups

Dies sind die Schnell-Upload-Pakete.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Laden Sie eines davon hoch Ordner, wenn Sie eine schnelle Periodenanalyse wünschen.

<a id="scan-and-baseline-files"></a>
## Scan- und Basisdateien

Verwenden Sie diese, um zu verstehen, ob der Weltkontext teilweise oder vollständig ist.

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
## Erzwingungsdateien

Verwenden Sie diese nur, wenn die Durchsetzung aktiviert ist.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` sollte nur Folgendes empfangen:

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## Was wird aktualisiert, wenn ein Spieler beitritt

Erwartete Aktualisierungen:

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
## Was wird aktualisiert, wenn der Server abstürzt oder neu startet

Erwartete Aktualisierungen:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## Was wird aktualisiert, wenn der Scan fortschreitet

Erwartete Aktualisierungen:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## Was zur schnellen Analyse hochgeladen werden soll

Bestes Paket:

```text
runtime/final_logs/YYYY-MM-DD/
```

Umfassenderes Paket:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Vollständiges Beweispaket:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## Verwandte Dokumente

* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSISCHE_TAGESROLLUPS.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](WORKFLOW_ZUR_PLAYER-%C3%9CBERPR%C3%9CFUNG.md)
