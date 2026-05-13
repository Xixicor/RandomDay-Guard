# Config profiles

Use this page to pick a practical starting configuration.

## Profile chooser

| Situation | Use this profile |
|---|---|
| First install | Safe first install |
| Server is unstable and crashes often | Live defense only |
| You want object/world context | Full baseline |
| You want to review old logs | Forensic backfill |
| You want recommendations but no writes | Enforcement testing |
| You are ready to let the guard write bans | Enforcement enabled |
| Disk is limited | Low disk growth |
| You completed a clean baseline | Sticky backup setup |

## Safe first install

Use this first on a live server.

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false

log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
}

scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
}
```

What this does:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

## Live defense only

Use this if the server is unstable and you need crash/reconnect evidence before a heavy scan.

```lua
log_tail.enabled = true
scanning.full_scan_on_start = false
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

What this does:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

## Full baseline

Use this after the server can stay up long enough to scan.

```lua
scanning.full_scan_on_start = true
scanning.resume_incomplete_scan = true
scanning.reuse_completed_baseline = true
scanning.incremental_refresh_after_baseline = true
```

What this does:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

## Forensic backfill

Use this only when intentionally reviewing historical logs.

```lua
log_tail.start_at_end_on_first_run = false
log_tail.tail_backup_logs = true
log_tail.backfill_backup_logs_on_start = true
```

Before using it:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

## Enforcement testing

Use this before actual Admin.ini writing.

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

What to inspect:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

## Enforcement enabled

Use this only after review output is correct.

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

Before enabling:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

## Low disk growth

Use this when runtime files are growing too quickly.

```lua
logging.low_importance_mode = "aggregate"
logging.write_low_importance_raw_events = false

retention.detailed_retention_days = 7
retention.rotate_jsonl_when_bytes_exceed = 5242880
retention.max_raw_events_lines = 20000
retention.compact_json_outputs = true
```

## Sticky backup setup

Use after the first completed baseline.

Check that these exist:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Then back them up with `config.lua`, `SavedRoot.txt`, and `Admin.ini`.

## Related docs

* [`CONFIG_REFERENCE.md`](CONFIG_REFERENCE.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
