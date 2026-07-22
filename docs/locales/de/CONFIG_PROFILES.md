<a id="configuration-profiles"></a>
# Konfigurationsprofile

> **Kanonisch-englische Quelle:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Verwenden Sie diese Anleitung, um ein praktisches Konfigurationsprofil auszuwählen und anzuwenden. Eine Erklärung zur Interaktion von Einstellungsgruppen finden Sie unter [`CONFIG_REFERENCE.md`](CONFIG_REFERENZ.md). Für genaue Felder, Standardwerte, Typen und Invarianten verwenden Sie das generierte [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md).

Jeder Lua-Block unten ist ein Satz von Einträgen der obersten Ebene, die die übereinstimmenden Einträge in der mitgelieferten `return { ... }` Tabelle eingefügt werden kann.

<a id="profile-chooser"></a>
## Profilauswahl

| Situation | Verwenden Sie dieses Profil |
|---|---|
| zuerst ersetzen können installieren | Sichere Erstinstallation |
| Server ist instabil und stürzt häufig ab | Aktuelle Beweise ohne langsamen Scan |
| Sie möchten object/world Kontext | Vollständige Baseline |
| Sie möchten Überprüfen Sie alte Protokolle | Forensisches Backfill |
| Sie möchten Empfehlungen, aber keine Schreibvorgänge | Durchsetzungstests |
| Sie sind bereit, den Wächter Schreibverbote zuzulassen | Durchsetzung aktiviert |
| Festplatte ist begrenzt | Geringes Festplattenwachstum |
| Sie haben eine saubere Baseline abgeschlossen | Sticky Backup-Setup |

<a id="safe-first-install"></a>
## Sichere Erstinstallation

Verwenden Sie dies zuerst auf einem Live-Server.

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

Was dies bewirkt:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Aktuelle Beweise ohne langsamen Scan

Verwenden Sie dies, wenn der Server instabil ist und Sie crash/reconnect Beweise vor einem umfangreichen Scan benötigen.

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

Was dies bewirkt:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Vollständige Baseline

Verwenden Sie dies, nachdem der Server lange genug zum Scannen aktiv bleiben kann.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

Was dies bewirkt:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Forensisches Backfill

Verwenden Sie dies nur, wenn Sie absichtlich historische Protokolle überprüfen.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Vor der Verwendung:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Durchsetzungstests

Verwenden Sie dies vor dem eigentlichen Admin.ini Schreiben.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

Was zu überprüfen ist:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Durchsetzung aktiviert

Verwenden Sie dies nur, nachdem die Überprüfungsausgabe korrekt ist.

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

Vor dem Aktivieren:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
## Geringes Festplattenwachstum

Verwenden Sie dies, wenn die Laufzeitdateien zu schnell wachsen.

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
## Sticky Backup-Setup

Verwenden Sie diese Option nach der ersten abgeschlossenen Baseline.

Überprüfen Sie, ob diese vorhanden sind:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Dann sichern Sie sie mit `config.lua`, `SavedRoot.txt` übereinstimmen, und `Admin.ini`.

<a id="related-docs"></a>
## Verwandte Dokumente

* [`CONFIG_REFERENCE.md`](CONFIG_REFERENZ.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSISCHE_TAGESROLLUPS.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
