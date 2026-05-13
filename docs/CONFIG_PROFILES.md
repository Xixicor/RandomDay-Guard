# Configuration Profiles

This guide gives practical config presets.

Use these as starting points. Do not copy blindly into a live server without checking trusted IDs and host paths.

---

## Profile 1 — Safe First Install

Use this when installing for the first time.

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

What it does:

```text
Records live evidence.
Starts the baseline scan.
Does not write Admin.ini.
Avoids treating old backup logs as new live events.
```

Use this until:

```text
poll_id increases
session events are recorded correctly
account_evidence.json looks correct
scan_progress.json updates
world_state_latest.json appears
```

---

## Profile 2 — Live Defense Only

Use this when you want join/leave/crash/reconnect monitoring immediately but want to delay heavy world scanning.

```lua
log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
}

scanning = {
    full_scan_on_start = false,
    incremental_scan_enabled = false,
}

review_only_mode = true
auto_ban = false
write_admin_ini = false
```

What it does:

```text
Tracks login identity.
Tracks sessions.
Tracks reconnects.
Tracks crash/restart overlap.
Does not run broad baseline scan at startup.
```

Use this on unstable servers where the first priority is watching who connects around crashes.

---

## Profile 3 — Full Baseline Mode

Use this when the server is stable enough to build the full world/object baseline.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    baseline_manifest_enabled = true,
    per_file_entry_cache_enabled = true,
    changed_file_detection = true,
}
```

What it does:

```text
Builds object registry.
Builds world-state summary.
Writes scan checkpoint.
Writes file manifest.
Allows later changed-file refresh.
```

Use this before creating a sticky backup.

---

## Profile 4 — Forensic Backfill

Use this when reviewing historical logs, not during normal live operation.

```lua
log_tail = {
    enabled = true,
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
}
```

Before using:

```text
Back up runtime/log_offsets.tsv.
Expect older logs to be reprocessed.
Do not run this blindly on a busy production server.
```

What it does:

```text
Reads historical log content.
Can reconstruct older session evidence if logs are still retained.
Can create many events if old logs are large.
```

Return to normal after review:

```lua
start_at_end_on_first_run = true
tail_backup_logs = false
backfill_backup_logs_on_start = false
```

---

## Profile 5 — Enforcement Testing

Use this before enabling actual Admin.ini writes.

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false

enforcement = {
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
    require_account_specific_evidence = true,
}
```

What it does:

```text
Lets the guard score and recommend.
Does not write bans.
Lets admins inspect what would have happened.
```

Check:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/evidence/
runtime/enforced_bans.jsonl
```

`enforced_bans.jsonl` should remain absent or unchanged while writing is disabled.

---

## Profile 6 — Enforcement Enabled

Use only after testing.

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true

enforcement = {
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
    require_account_specific_evidence = true,
    ban_from_lag_alone = false,
    ban_from_ping_alone = false,
    ban_from_object_count_alone = false,
    ban_from_single_crash = false,
    ban_from_single_warning_burst = false,
}
```

Before enabling:

```text
Trusted IDs configured.
Moderator IDs preserved.
Admin.ini backup behavior verified.
Evidence reports are readable.
The server owner accepts the thresholds.
```

Expected Admin.ini output:

```ini
BannedPlayer=<ID>
```

No comments. No names. No suffixes.

---

## Profile 7 — Low Disk Growth

Use this when the server has limited storage.

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
}

retention = {
    detailed_retention_days = 7,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    max_low_importance_events_per_day = 5000,
    compact_json_outputs = true,
}
```

What it does:

```text
Keeps current snapshots small.
Aggregates low-importance spam.
Rotates or limits large append-only event files.
Preserves important evidence longer.
```

---

## Profile 8 — Sticky Backup Setup

Use after a completed baseline.

```lua
scanning = {
    reuse_completed_baseline = true,
    resume_incomplete_scan = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
}
```

Create a sticky backup after these exist:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Backup:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```
## Forensic Rollup Profile

Keep daily forensic rollups enabled for operator review:

```lua
forensic_rollup.enabled = true
forensic_rollup.daily_root = "runtime/forensic_days"
forensic_rollup.final_log_root = "runtime/final_logs"
```

These outputs update in place and do not replace raw evidence.
