<a id="configuration-profiles"></a>
# Configurationis perfiles

> **Canonicum Anglicum fontem:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


 Hoc modo utere ut ducas ad eligendam et applicandam figuram practicam. Explicatio quomodo coetus inter se occurrunt, lege [`CONFIG_REFERENCE.md`](MANDO_REFERENCE.md). Pro agris, defaltis, speciebus, et immutationibus accuratis, generatis [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOGUE.md).

Lua quisque clausus infra est copia viscus top-level qui reponere possunt intra introitus congruentes uit `return { ... }` table.

<a id="profile-chooser"></a>
## Profile eligentis

| Situs | Hoc profile |
|---|---|
| Primo install | Tutus primum install |
| Servi instabilis est et saepe inruerit | Current testimonia sine lento scan |
| Vis object/world contextu | Full baseline |
| Vis acta vetera recensere | Forense backfill |
| Vestis commendationes sed nullas scribit | Exactio probatio |
| Paratus es ut praetoriani scribant banna | Exactio enabled |
| Disk limitatur |  orbis terrae inferioris incrementum |
| Perfecisti baseline munda | Sticky tergum setup |

<a id="safe-first-install"></a>
## Tutus primum install

Hoc primo utere in servo vivo.

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

Quid hoc facit:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Current testimonia sine lento scan

Hoc utere si servo instabilis est et debescrash/reconnect argumento ante scan grave.

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

Quid hoc facit:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Full baseline

Hoc utere postquam servo satis diu morari potest.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

Quid hoc facit:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Forense backfill

 Hoc tantum utere cum acta historica consulto recensebimus.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Antequam utatur:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Exactio probatio

 Hoc utere ante actualem Admin.ini scripto.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

Quid inspicere:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Exactio enabled

Hoc tantum utere post recognitionem output verum est.

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

Antequam possit:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
##  orbis terrae inferioris incrementum

Hoc utere, cum fasciculi runtime nimis cito crescant.

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
## Sticky tergum setup

Usus primo baseline completo.

Reprehendo haec esse:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Tunc rursus eos cum `config.lua`, `SavedRoot.txt`, et `Admin.ini`.

<a id="related-docs"></a>
## Related docs

* [`CONFIG_REFERENCE.md`](MANDO_REFERENCE.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_EFFECTUS.md)
