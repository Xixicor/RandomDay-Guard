<a id="configuration-concepts"></a>
# Konfigurationskonzepte

> **Kanonisch-englische Quelle:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Diese Erklärung beschreibt, was jeder große Konfigurationsbereich steuert, wann er ausgeführt wird und wie er mit Beweisen und Sicherheitstoren interagiert. Es verfügt nicht über den genauen Feldkatalog oder die Profilprozeduren.

Für aufgabenorientierte Voreinstellungen und sichere Änderungsschritte verwenden Sie [`CONFIG_PROFILES.md`](CONFIG_PROFILES.md). Verwenden Sie für jedes genaue Quellfeld, jeden Standard, jeden Typ, jede Invariante, jeden Ausgabeeffekt und jede Wiederherstellungsregel den generierten [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md); Der Validator benötigt dort eine Zeile für jeden versendeten `config.lua`Blattfeld.

<a id="reading-this-page"></a>
## Diese Seite wird gelesen

Jeder Konfigurationsbereich antwortet:

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## Sicherheit auf höchstem Niveau

| Option | Standard | Bedeutung |
|---|---:|---|
| `enabled` | `true` | Hauptschalter für den Wächter |
| `enforcement.review_only_mode` | `true` | Record/recommend |
| `enforcement.auto_ban` | `false` | Standardmäßig nicht automatisch sperren |
| `enforcement.write_admin_ini` | `false` | Nicht schreibenAdmin.inistandardmäßig |

Bewahren Sie diese sicher auf, bis der Serverbesitzer die Ausgabe überprüft hat.

<a id="saved"></a>
## `saved`

Steuert, wie der Wächter den Server findet `Saved/` Ordner und welche Dateifamilien gescannt werden können.

Verwenden Sie, wenn:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Prüfen:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Regel:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Steuert das Lesen des Live-Protokolls.

Nützliche Optionen:

| Option | Sicherer Wert | Warum |
|---|---|---|
| `enabled` | `true` | Wird zur Live-Verteidigung benötigt |
| `start_at_end_on_first_run` | `true` | Vermeidet alte Protokolle als Live-Ereignisse |
| `tail_backup_logs` | `false` | Sicherungsprotokolle sind Verlaufsprotokolle, nicht live |
| `max_lines_per_poll` | begrenzt | Sorgt dafür, dass die Umfrageschleife reagiert |

Prüfen:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Kontrolliert Umfragen und Budgets.

Hauptzustandsregel:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Prüfen:

```text
runtime/current/poll_status.json
```

Wenn `poll_id` stoppt, blockiert etwas die Schleife.

<a id="source_accounting"></a>
## `source_accounting`

Steuert die explizite Abdeckung und den Umfang der Beweisquelle.

| Schlüssel | Standard | Bedeutung |
|---|---:|---|
| `enabled` | `true` | Schreibt Quellenbuchhaltung für öffentliche Routenberichte. |
| `require_terminal_status` | `true` | Erfordert, dass jede Quelle ein explizites Terminal offenlegt oder unvollständig ist Status. |
| `distinguish_current_from_historical` | `true` | Trennt aktuelle und historische Beweise. |
| `slow_world_scan_blocks_current_reports` | `false` | Ermöglicht aktuellen Berichten die Angabe, dass das Scannen der begrenzten Welt verzögert oder teilweise erfolgt. |
| `changed_file_manifest` | Basismanifestpfad | Referenz, die für die begrenzte historical/world Abrechnung verwendet wird. |

Quellstatus sind `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` oder `error`.

Einstellung `source_accounting.enabled = false` entfernt die Statusausgabe nicht stillschweigend. Die Pipeline schreibt weiterhin `runtime/final_logs/source_accounting_latest.json` mit `enabled=false`, `status="unavailable"` übereinstimmen, und `disabled_reason="source_accounting_disabled"`. Außerdem wird der historische Statusdatensatz mit nicht verfügbarer Abrechnung geschrieben. Da die Quellenabrechnung Teil des Berichtsvertrags ist, schlägt jede Route geschlossen auf `missing`; Während die Abrechnung deaktiviert ist, wird keine Route als abgeschlossen behandelt.

<a id="reports"></a>
## `reports`

Steuert die generische lokale Berichtspipeline.

Standardmäßig aktivieren alle fünf Routen und schreiben unter `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Jede Route muss eine strukturierte und übersetzte Ausgabe plus Proof in `route_proof.json` schreiben. Das Deaktivieren einer Route führt zu einem `missing`Beweis, anstatt vorzutäuschen, dass sie abgeschlossen wurde.

<a id="notification"></a>
## `notification`

Optionaler generischer lokaler Dateiausgang. Es ist standardmäßig deaktiviert und sendet nichts an einen externen Anbieter.

Standardeinstellungen:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Jede Benachrichtigungsroute ist standardmäßig deaktiviert. Bei bewusster Aktivierung kann der Postausgang nach dem Schreiben von `route_proof.json` möglicherweise nur einen vollständig übersetzten Bericht verarbeiten. Lokale Beweise und Berichte bleiben maßgeblich. Anbieterspezifische Zustellung, Zustellungsendpunkte, Anmeldeinformationen und Brücken sind nicht Teil des öffentlichen unabhängigen Watchdog-Vertrags.

<a id="scanning"></a>
## `scanning`

Steuert Baseline-Scan, Prüfpunkte und Aktualisierung geänderter Dateien.

Verwenden Sie, wenn:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Prüfen:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Wichtige Einstellungen:

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

Steuert das schnelle tägliche Upload-Paket und endgültige Klartextprotokolle.

Ausgaben:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Verwenden Sie, wenn:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Prüfen:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Regel:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Steuert das Ereignisvolumen und die Aggregation von geringer Wichtigkeit.

Verwenden Sie, wenn:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Sicheres Muster:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Steuert, wie lange Dateien aufbewahrt werden und wann JSONL Protokolle rotieren.

Verwenden Sie, wenn:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Wichtige Optionen:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

Steuert Erkennung von Warnfenstern.

Beispiele:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Regel:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

Kontrolliert wiederholte crash/reconnect Überprüfungen.

Sichere Standardeinstellungen:

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Nützliche Zähler:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Kontrolliert Abwanderung und Join-Wave Tracking.

Sichere Standardeinstellung:

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Verwenden für:

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

Gruppiert Konten, die in zugehörigen Fenstern aktiv sind.

Regel:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Jedes erzwungene Konto benötigt weiterhin kontospezifische Beweise.

<a id="object_registry"></a>
## `object_registry`

Kontrollelemente object/classToken-Extraktion aus lesbaren gespeicherten Beweisen.

Ausgaben:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Regel:

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Kontrollelemente boot/current/sessionWeltzustands-Snapshots.

Ausgaben:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Für Sitzung verwenden Rezension und Weltkontext.

<a id="enforcement"></a>
## `enforcement`

Kontrolliert Empfehlungen und tatsächliche Admin.ini Schreibvorgänge.

Bevor Guard ein Verbot hinzufügen kann, müssen alle folgenden Aussagen wahr sein:

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

Wenn eine Aussage falsch ist oder nicht überprüft werden kann, lässt Guard `Admin.ini` unverändert und zeichnet den Grund auf.

<a id="admin_ini"></a>
## `admin_ini`

Steuert sichere Dateischreibvorgänge.

Regeln:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Steuert optionale lokale Markierungsdateien, die ein anderer betreibereigener Prozess überprüfen kann. Der Server wird nicht neu gestartet oder beendet.

Standardeinstellungen:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Ausgaben:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

Es ist kein Hosting-Panel, keine Provider-Brücke oder keine Neustartautomatisierung im Paket enthalten. Das Aktivieren der Markererstellung beweist nicht, dass ein externer Prozess die Anfrage verarbeitet oder den Server neu gestartet hat.

<a id="related-docs"></a>
## Verwandte Dokumente

* [`CONFIG_PROFILES.md`](CONFIG_PROFILES.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
