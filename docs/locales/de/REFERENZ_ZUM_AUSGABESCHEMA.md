<a id="output-and-state-schema-reference"></a>
# Ausgabe- und Statusschema-Referenz

> **Kanonisch-englische Quelle:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Dies ist der kanonische Vertrag für generierte, bedienerorientierte Dateien. Es allein besitzt genaue Ausgabepfade, Feldnamen, zulässige Werte, Abstammungsanforderungen und Routenschemata. Verfahrensleitfäden verlinken hier, anstatt diese Fakten neu zu definieren.

Laufzeitbeweise sind maßgeblich; Ein Dateiname, ein Scheduler-Heartbeat, ein übersetzter Bericht oder ein lokales Postausgangsobjekt beweist nicht mehr als seine eigenen Felder und seine Herkunft.

<a id="public-report-routes"></a>
## Öffentliche Berichtsrouten

Der Berichtsarbeiter besitzt fünf Routen unter `runtime/final_logs/`:

| Route | Vertrag | `full` Anforderung | Erwartete-Leer-Bedeutung |
|---|---|---|---|
| `server_status` | Aktueller Planer, aktives Protokoll, Scan ausstehend und Status der Quellenabdeckung. | Aktuelle boot/epoch/poll Herkunft, neues aktives Protokoll, accounting/history Schreibvorgänge und das JSON/TXT Paar. | Wird nicht für einen ansonsten fehlerfreien aktuellen Zyklus verwendet; fehlende Abstammung ist `missing`. |
| `daily_rollup` | Aktuelle day/window Kontinuität über Server, Spieler, Fälle, Scan und Abdeckung hinweg. | Historisches Abrechnungsterminal reicht für die Route aus und der aktuelle Zyklusnachweis ist abgeschlossen. | Keine zurückbehaltenen Spieler und keine Überprüfungsfälle. |
| `player_activity` | Aktuelle und historische trennen player/account Beobachtungen. | Beweis für den aktuellen Zyklus plus eine oder mehrere current/historical Zeilen. | Keine berechtigten Spielerzeilen in begrenzten Eingaben; kein synthetisches Subjekt. |
| `case_review` | Benannte beibehaltene Fälle und aktuelle review/BAN-ELIGIBLE Kandidaten. | Aktueller Zyklusnachweis plus ein oder mehrere benannte Fälle mit Quellenverweisen. | Kein benannter Fall erfüllte die Überprüfungskriterien; kein synthetischer Fall. |
| `critical_guard` | Aktueller Startplaner, Start, Abfrage oder Beweisintegritätsfehler. | Stromzyklusnachweis plus ein aktueller kritischer Fehler. | Kein aktueller kritischer Fehler; Alte Textfehler besitzen diese Route nicht. |

Jede aktivierte Route schreibt `<route>_latest.json` und `<route>_latest.txt`. Das Paar wird erst vervollständigt, wenn `runtime/final_logs/route_proof.json` die gleiche Version, den gleichen Start, die gleiche Epoche, die gleiche Umfrage und die gleiche Quellaktualität aufzeichnet.

<a id="report-json-schema"></a>
## Bericht JSON Schema

Alle Routenpfade JSON verwendet `schema="randomdayguard.report/v1"`.

| Feld | Typ | Bedeutung und Invariante |
|---|---|---|
| `schema` | Zeichenfolge wieder her. | Genau `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | Zeichenfolge wieder her. | Generierungszeitstempel und Berichtsdatum. |
| `version` | Zeichenfolge wieder her. | Runtime/package Identität für diesen Zyklus. |
| `boot_id`, `epoch_id` | Zeichenfolge wieder her. | Aktuelle Prozessstart- und Serverkontinuitätsepoche. Beide sind zur Vervollständigung erforderlich. |
| `poll_id` | integer | Positive aktuelle Umfragekennung. Zero/missing kann eine Route nicht abschließen. |
| `source_freshness` | Objekt | `status`, `checked_ts`, Aktivprotokollstatus, Zeitstempel der letzten Umfrage und Zeitstempel der letzten abgeschlossenen Umfrage. |
| `current_cycle_proof_complete` | boolean | Nur wahr, wenn Abstammung und frische active-log/current-poll Beweise übereinstimmen. |
| `route` | enum | Eine der fünf Routen oben. |
| `route_proof_status` | enum | `full`, `limited_expected_empty` oder `missing`. |
| `coverage_status` | enum | Genau `complete`, `complete_with_gaps`, `partial` oder `unavailable`. |
| `completed`, `expected_empty` | boolean | `completed` ist nur falsch für `missing`; `expected_empty` ist nur wahr für `limited_expected_empty`. |
| `observed` | Array von Zeichenfolgen | Konkret beibehalten facts/counts/statuses. |
| `interpretation` | Array von Zeichenfolgen | Vorsichtige Bedeutung, abgestimmt auf die Beweise. |
| `unknown` | Array von Zeichenfolgen | Fehlende Identität, Verlauf, Quelle oder Kontext. |
| `does_not_prove` | Array von Zeichenfolgen | Schlussfolgerungen, die die Beweise nicht stützen können. |
| `next_action` | Zeichenfolge wieder her. | Sicherste begrenzte Operatoraktion. |
| `source_references` | Array von Zeichenfolgen | Sortierte eindeutige runtime/Saved Referenzen. |
| `enforcement_authority` | boolean | Immer falsch. Ein Bericht autorisiert niemals einen Schreibvorgang. |
| `output_paths` | zwei Zeichenfolgen | JSON und TXT, die vor gepaarten Schreibvorgängen hinzugefügt wurden. |

`coverage_status` dient nur zur Abrechnung auf oberster Ebene. Quelldatensätze besitzen separat `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` übereinstimmen, und `error`. Route Proof besitzt separat `full`, `limited_expected_empty` übereinstimmen, und `missing`; Werte überschreiten diese Grenzen nie.

Routenerweiterungen:

- `server_status`: `scheduler_status`, `active_log_status` übereinstimmen, und `server_metrics`. Die Metriken zeichnen den aktuellen Epochenstart, den Zeitstempel und die ID der letzten abgeschlossenen Umfrage, die Anzahl der aktiven Spieler, active/backup-log Zählungen, Scan-Werte pending/progress und configured/usable/unavailable Quellengruppenabrechnung auf. Sie erfinden keine Betriebszeit, Neustartanzahl, Backup-Zeitstempel oder Ausfalldauer, wenn keine Quelle diese Fakten preisgibt.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players` und Kompatibilitätsarray `players`. Jede Sitzung am selben Tag behält ihre Sitzungs-ID, Konto-ID, den Anzeigenamen, sofern bekannt, join/leave Zeitstempel, Clean-Exit- und Lebenszyklus-Flags sowie Quellreferenzen. Behaltene Identität und PlayerDataPräsenz bleiben Kontext, kein Beweis für Aktivität heute.
- `case_review`: `cases`, `review_subjects`, `current_case_count` übereinstimmen, und `retained_case_count`. Ein aktueller Überprüfungsgegenstand zeichnet seine case/account ID, seinen Anzeigenamen, sofern bekannt, Status, Bewertung, Identitätsvertrauen, first/last Beobachtungen, Warnungsanzahlen, Gründe, Aktuelle-Live-Flagge und Quellenverweise auf. Beibehaltene Fälle erstellen selbst keinen aktuellen Betreff.
- `critical_guard`: `critical_failure_present` und `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window` übereinstimmen, und `daily_metrics`. Die Metriken zeichnen das Berichtsdatum, aktive Spieler, Konten mit Aktivität am selben Tag, Beitritte, Austritte, saubere und unsaubere Ausgänge, Lebenszyklusrückgaben, aktuell benannte Überprüfungsthemen, beibehaltene Fälle, current/retained Identitätszahlen und Quellgruppenabdeckung auf.

<a id="translated-txt-schema"></a>
## Übersetzt TXT Schema

Die gepaarte Textdatei führt mit dem vom Bediener lesbaren Ergebnis und verschiebt Abstammungsdetails bis zum Ende. Es behält genau diese Abschnittsreihenfolge bei:

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

Die Übersetzung verwendet nur die strukturierten Berichtsfelder und genehmigten Wörterbuchzuordnungen. Es können keine Spieler, Fälle, Lieferung, Ursache, Eigentum, Absicht oder Durchsetzungsberechtigung hinzugefügt werden, die nicht im strukturierten Bericht enthalten sind. Technische Details bleiben verfügbar, ohne das lesbare Ergebnis zu verdrängen.

<a id="source-accounting-schema"></a>
## Quellabrechnungsschema

`runtime/final_logs/source_accounting_latest.json` verwendet `randomdayguard.source-accounting/v1` mit Generierungsgrund reason/status, enablement/disabled, current/historical Unterscheidung, Manifest der geänderten Dateien, Quelldatensätze, usable/unavailable Klassenlisten und eine Anspruchsbeschränkung.

Jeder Quelldatensatz enthält:

| Feld | Typ | Bedeutung |
|---|---|---|
| `source_class` | Zeichenfolge wieder her. | Eine der folgenden acht Klassen. |
| `scope` | `current` oder `historical` | Zeitbesitz; Bereiche werden niemals stillschweigend zusammengeführt. |
| `required` | boolean | Nur `active_log` ist für die Aktualität der Route des aktuellen Zyklus erforderlich. |
| `status` | enum | Quellenergebnis unten aufgeführt. |
| `terminal` | boolean | Nur falsch für `partial` und `deferred`. |
| `available`, `readable` | boolean | Nur wahr für `available` und `expected_empty`. |
| `file_count` | integer | Begrenzt berücksichtigt file/reference Anzahl. |
| `source_references` | Array | Sortierte eindeutige Quelle paths/references. |
| `detail` | Zeichenfolge wieder her. | Begrenzte Ergebnis- oder Fehlerdetails. |
| `does_not_prove` | Zeichenfolge wieder her. | Verfügbarkeit ist kein Beweis für Absicht, Eigentum, Beschädigung, Vervielfältigung oder Durchsetzung. |

Quellklassen:

| Quellklasse | Umfang | Was es beiträgt | Was es nicht beweisen kann |
|---|---|---|---|
| `active_log` | aktuell, erforderlich | Lesbares aktives Serverprotokoll und frische Umfragelinie. | Vollständiger Verlauf oder Spielerverschulden. |
| `admin_ini` | aktuell, optional | Strukturell gültiger Strom moderator/banStatus oder erwartete Abwesenheit. | Metadaten zum Spielerverhalten oder zu gültigen Gründen. |
| `recent_backup_logs` | historisch | Lesbare rotated/backup Protokollverweise. | Aktuelle Anwesenheit oder aktueller Startstatus. |
| `playerdata_filenames` | aktuell Kontext | Begrenzte lesbare Dateinamenverweise unter dem ausgewählten gespeicherten Stammverzeichnis. | Dateieigentum, Live-Präsenz, Identitätsinhalt oder Fehlverhalten. |
| `existing_cases` | historisch | Behaltene benannte Falldatensätze files/indexvor aktuellen Ausgaben erfasst. | Aktuelle Aktivität oder Korrektheit der alten Schlussfolgerungen. |
| `existing_reports` | historisch | Behaltene final/forensic/warningBerichtsverweise. | Authoritative Quellenersetzung. |
| `existing_evidence` | historisch | Behaltene Beweisverweise. | Vollständigkeit der Ereignisse, die der Server nie offengelegt hat. |
| `world_save_scan` | historisch | Vollständig, teilweise, Zurückgestellter oder nicht verfügbarer begrenzter scan/checkpoint Zustand. | Die Aktion oder der Besitz eines bestimmten Spielers. |

Quellstatuswerte:

| Status | Terminal | Operatorbedeutung und -aktion |
|---|---:|---|
| `available` | ja | Lesbare nützliche Quelle vorhanden; Überprüfen Sie die Referenzen. |
| `expected_empty` | ja | Optionale Quelle wurde überprüft und rechtmäßig absent/empty. Erfinden Sie keine Daten. |
| `partial` | Nein | Begrenzte Arbeit oder Inventarlimit ist unvollständig; Lebenslauf zulassen. |
| `deferred` | Nein | Arbeit ist absichtlich ausstehend; Warten Sie auf den besitzenden Worker. |
| `unavailable` | ja | Source/path/tool fehlt oder ist unbrauchbar; Reparatur nur, wenn die Route dies erfordert. |
| `malformed` | ja | Inhalt hat strukturelle Validierung nicht bestanden; Bewahren Sie es auf und reparieren Sie das Format. |
| `permission_denied` | ja | Der Zugriff wurde ausdrücklich verweigert; Wiederherstellen des Lesezugriffs mit den geringsten Rechten. |
| `error` | ja | Begrenzte Quellebene probe/read unerwartet fehlgeschlagen; Inspizieren Sie `detail`, ohne Geheimnisse preiszugeben. |

Die oberste Ebene `coverage_status` ist genau `complete`, `complete_with_gaps`, `partial` oder `unavailable`. Eine erforderliche Quellebene `error`, `malformed` oder `permission_denied` wird zur obersten Ebene `unavailable` zusammengefasst; Quellebene `deferred` wird zur obersten Ebene `partial`. Das Deaktivieren der Quellbuchhaltung schreibt immer noch einen Nichtverfügbarkeitsstatus und erzwingt jede Route zum `missing`.

<a id="historical-status-schema"></a>
## Historischen Statusschema

`runtime/final_logs/historical_backfill_latest.json` verwendet `randomdayguard.history/v1`: `generated_ts`, der Buchhaltung `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, dem Quellbuchhaltungsarray, nicht verfügbaren Klassen und einem begrenzten `next_action`.

`runtime/history/public_accounts.tsv` ist ein dauerhafter öffentlicher Verlauf mit diesem Header:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

Zeilen sind nach Konto-ID sortiert, Felder sind single-line/tab-safe und Referenzen sind sorted/unique. Diese Datei bewahrt den historischen Kontext über stille Neustarts hinweg; Es wandelt den Verlauf niemals in die aktuelle Präsenz um.

<a id="route-proof-schema"></a>
## Routensicheres Schema

`runtime/final_logs/route_proof.json` verwendet `randomdayguard.route-proof/v1` und zeichnet Zeitstempel der obersten Ebene, Version, Boot, Epoche, Umfrage, Aktualität der Quelle, Vollständigkeit des aktuellen Zyklus, zulässige Status und ein `routes` Array auf.

Jeder Routeneintrag enthält route/status, version/boot/epoch/poll, Quellfrischheitsobjekt, Vollständigkeit des aktuellen Zyklus, Ausgabepfade und Quellreferenzen. Eine deaktivierte Route zeichnet `status="missing"` und `reason="route_disabled"` auf. Wenn das routensichere Schreiben fehlschlägt, wird jede Route als incomplete/missing umgeschrieben, bevor ein Benachrichtigungskandidat akzeptiert wird.

<a id="notification-schemas"></a>
## Benachrichtigungsschemata

Der optionale öffentliche Modus ist nur der Postausgang für lokale Dateien.

`runtime/notifications/pending/<route>_latest.json` verwendet `randomdayguard.notification/v1` mit generiertem Zeitstempel, version/boot/epoch/ poll/source Aktualität, Route, `completed_output`, Routensicherheitsstatus, strukturierte und übersetzte Berichtspfade, Quellenverweise, `delivery_backend="none"` übereinstimmen, und `delivery_attempted=false`. Zulässige Ausgabe verwendet `status="ready_for_local_consumer"`, `delivery_eligible=true` übereinstimmen, und `delivery_allowed=true`. Eine konfigurierte, aber missing/ineligible-Route schreibt immer noch einen Prüfumschlag mit `status="suppressed_current_cycle"`, beiden Zustellungsflags falsch und `suppression_reason="route_or_completion_policy_blocked"`. Daher bedeutet das Vorhandensein einer Datei unter `pending/` nicht automatisch, dass sie in der Warteschlange steht oder berechtigt ist.

`runtime/notifications/notification_status.json` verwendet `randomdayguard.notification-status/v1` mit derselben Herkunft, `generic_local_outbox_only=true`, `delivery_attempted=false` und pro Route `queued`/`outcome` Zeilen. `full` ist berechtigt; „expected-empty“ ist nur zulässig, wenn `include_expected_empty=true`; `missing` ist niemals berechtigt. Bei einem routensicheren Schreibfehler lautet das Statusergebnis `route_proof_write_failed`; Ein unterdrückter Prüfumschlag kann weiterhin geschrieben werden, wird jedoch nicht als Ausgabe akzeptiert.

<a id="runtime-output-inventory"></a>
## Laufzeitausgabebestand

Der Rückverfolgbarkeitsindex verfügt über eine Maschinenzeile für jeden Pfad oder jede dynamische Dateiklasse. Dieses lesbare Inventar gruppiert Dateien nach Operatorzweck.

| Pfad oder Muster | Producer/trigger | Richtlinie und nützliche Zustände | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Loader-Eintrag. | Überschriebener Start identity/probe. | Fehlen beweist nicht die Belastung; Überprüfen Sie UE4SS Protokolle und Aktivierung. |
| `runtime/config_load_error.txt` | Fehler beim Laden der Konfiguration. | Nur Fehler, begrenzte Ursache bleibt erhalten. | Gültige öffentliche Konfiguration wiederherstellen und neu starten. |
| `runtime/saved_path_probe.json` | Auflösung des gespeicherten Stammverzeichnisses. | Candidate/readability Abrechnung verwendet wird. | Legen Sie `SavedRoot.txt` oder einen generischen Kandidaten reparieren. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Startlebenszyklus. | Letzter Start- und aktueller Startfehler. | Nur passender Start besitzt den aktuellen kritischen Status. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report Integration. | Neueste version/capability/handoff Zustand. | Versions- oder Fähigkeitsdrift blockiert Abschlussansprüche. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Abfrage finalizer/error. | Neueste poll/scheduler/in-flight Status und aktueller Startfehler. | Reparieren Sie den begrenzten Rückruf und erfordern Sie eine neuere abgeschlossene Abfrage. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Ereignisprotokollierung. | Begrenzt append/rotation. | Vorherige Bytes beibehalten; Reparieren Sie disk/retention, bevor Sie sich auf Lücken verlassen. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Protokoll tail/registry. | Neueste Offsets und kanonische Protokollidentitäten. | Sorgfältig neu erstellen; Sicherungsprotokolle bleiben historisch. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle Normalisierer. | Nur anfügen-Kontext. | Fehlender Kontext kann nicht beweisen graceful/crash Zustand. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Epochenbesitzer. | Aktuelle plus beibehaltene Server-Epochen. | Neu starten Epoche nach der Reparatur; Schreiben Sie den alten Verlauf nicht neu. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Sitzungseigentümer. | Current/historicalSitzungsereignisse und Snapshots. | Nicht zugeordnete Zeilen bleiben unbekannt; Keine Identitätserfindung. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session Aggregations- und Berichtsmodul. | Aktueller Schnappschuss und dauerhafter Verlauf. | Betrachten Sie getrennte Bereiche und stellen Sie sie anhand von Beweisen wieder her, nicht anhand von Vermutungen. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state Autoren. | Aktuelle Schnappschüsse werden überschrieben. | Stale/missing ist unbekannt, wird nicht leer erwartet. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly Aggregation. | Neuerstellbare Indizes. | Neuerstellung aus maßgeblichen Ereignissen. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Arbeiter scannen. | Gestartet, partial/deferred, Prüfpunkt, abgeschlossen oder Fehler. | Prüfpunkt fortsetzen; Neuerstellung nur mit aufgezeichnetem Grund. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Baseline-Worker. | Neueste scan/baseline und Bindung geänderter Dateien. | Stale/incompatible Manifeste erfordern eine explizite Neuerstellung. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Objektscan. | Partial/final Klassenkontext. | Zählungen sind kein Beweis für Spieleraktionen; Scan fortsetzen oder neu erstellen. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | Objektvergleich. | Nur anhängen new/deltaKontext. | Überprüfung mapping/baseline vor der Inferenz. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Gespeicherte Stammindizes. | Filename/admin Strukturkontext. | Dateinamen sind schwach; Fehlerhafter Admin-Status schließt Schreibvorgänge. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | World-State Writer. | Boot/current/session Snapshots und Diffs. | Nur Kontext; Nach scan/source Reparatur neu generieren. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence Autoren. | Begrenztes Anhängen und per-player/sessionÜberprüfen von Dateien. | Fehlender Bericht ist kein fehlender Ereignisnachweis; Überprüfen Sie die Quellenbeweise. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review Aggregation. | Benanntes Überprüfungsmaterial und Warteschlangenkandidaten. | Fall membership/threshold umgeht niemals kontospezifische Tore. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Optionale Admin.ini Transaktion. | Sicherung, Erfolgsbuch oder explizit failure/rollback Beweise. | Jeder backup/write/readback/rollback Fehler schließt die Durchsetzung aus; Sicherung wiederherstellen. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Optionaler Marker-Writer. | Nur lokale Anfrage. | Kann den Verbrauch oder Neustart nicht nachweisen. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Forensisches Rollup. | Aktuelle und datierte wiederherstellbare Überprüfungsindizes. | Neuaufbau aus Quellennachweisen; Behandeln Sie die Zusammenfassung niemals als Autorität. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Arbeiter für öffentliche Berichte. | Schemas und Vervollständigungsregeln oben. | Reparieren Sie zuerst die Nichtübereinstimmung lineage/source/write; Fehlend bleibt fehlen. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Optionaler lokaler Postausgang. | Zulässiger oder explizit unterdrückter lokaler Umschlag plus Status. | Missing/ineligible Routen können unterdrückte Dateien haben, werden aber nie in die Warteschlange gestellt; Lieferflags überprüfen und auf keine externe Lieferung schließen. |

Overwrite/append/retention Das Verhalten wird durch den produzierenden Abschnitt in [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md) gesteuert. Paket-ZIPs enthalten nur leere `.gitkeep`-Platzhalter unter `runtime/`; Jedes evidence/output Byte in einem Release-Paket schlägt bei der Validierung fehl.

<a id="failure-and-recovery-matrix"></a>
## Fehler- und Wiederherstellungsmatrix

| Fehler | Erforderlicher Status | Sichere Wiederherstellung | Ungültige Schlussfolgerung |
|---|---|---|---|
| Aktuelle Abstammung absent/stale | Alle Routen `missing`. | Wiederherstellen active-log/current-poll prüfen und neu generieren. | Alte Routendateien sind keine aktuelle Vervollständigung. |
| Optionale Quelle voraussichtlich leer | Quelle `expected_empty`; Mögliche Route kann sein `limited_expected_empty`. | Keine Reparatur, es sei denn, die Quelle sollte vorhanden sein. | Leer ist nicht nicht verfügbar und beweist nicht die historische Abwesenheit. |
| Scan unvollständig | Quelle `partial` oder `deferred`. | Begrenzte Wiederaufnahme zulassen; Aktuelle Routenrichtlinie explizit beibehalten. | Teilweise ist keine Beschädigung. |
| Erforderliche Quelle nicht verfügbar | `coverage_status=unavailable`; abhängige Routen `missing`. | Ausgewählten Saved/log Zugriff reparieren. | Andere fehlerfreie Quellen ersetzen nicht die erforderliche Quelle. |
| Erforderliche Quellprüffehler | Quellstatus `error` mit begrenztem `detail`; `coverage_status=unavailable`; abhängige Routen `missing`. | Reparieren Sie den benannten source/probe und generieren Sie einen neueren Zyklus. | Ein Quellfehler ist kein fünfter Abdeckungswert der obersten Ebene. |
| Schreiben des gepaarten Berichts schlägt fehl | `coverage_status=unavailable`; Route konvergiert zu `missing`. | Dateisystem reparieren und beide Paarmitglieder neu schreiben, plus Beweis. | Eine Geschwisterdatei ist nicht vollständig und der Schreibfehler liegt nicht auf der obersten Ebene `error`. |
| Routensicheres Schreiben schlägt fehl | Jede umgeschriebene Route fehlt; kein berechtigter Postausgang; Konfigurierte Routen erhalten möglicherweise unterdrückte Prüfumschläge. | Routensicheres Schreiben reparieren und Ausgaben im gleichen Zyklus neu generieren. | Gültig aussehender Bericht JSON oder ein unterdrückter Umschlag sind nicht routensicher. |
| Schreiben der Benachrichtigung schlägt fehl | Ergebnis `local_outbox_write_failed`. | Lokales Ausgabestammverzeichnis reparieren; Aus abgeschlossenem Bericht neu generieren. | Keine externe Zustellung erfolgt. |
| Admin.iniTransaktion schlägt fehl | Durchsetzung blockiert mit backup/write/readback/rollback Beweise. | Verifizierte Sicherung wiederherstellen; bleiben nur zur Überprüfung verfügbar. | Ein Schwellenwert oder Bericht kann die Umgehung der Wiederherstellung nicht rechtfertigen. |

Siehe [`EVIDENCE_BOUNDARY.md`](BEWEISGRENZE.md), [`ARCHITECTURE.md`](ARCHITEKTUR.md) übereinstimmen, und [`SOURCE_MODULE_REFERENCE.md`](QUELLMODULREFERENZ.md).
