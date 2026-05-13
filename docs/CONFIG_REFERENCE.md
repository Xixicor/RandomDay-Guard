# Configuration Reference

This file explains the important `config.lua` areas in operator terms. Defaults are public-safe and review-first.

## First settings most admins should check

### `SavedRoot.txt`

Use `SavedRoot.txt` when automatic path detection cannot find the server's `AbioticFactor/Saved` folder.

Correct:

```text
/AMP/<server>/AbioticFactor/Saved
Z:/AMP/<server>/AbioticFactor/Saved
```

Do not point it to the world folder. RandomDayGuard needs logs, `Admin.ini`, Worlds, PlayerData, and Backups.

### Enforcement defaults

Keep these while testing:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

This records evidence without editing `Admin.ini`.

### Trusted IDs

Add server owners and trusted moderators before enabling enforcement:

```lua
whitelist = {
    ["<trusted_account_id>"] = true,
}
```

## Config areas

| Area | Set this when... | Important options |
|---|---|---|
| `saved` | Saved root detection or scan file families need adjustment. | `root_candidates`, `direct_known_files`, `scan_world_saves`, `scan_player_data`, `scan_backups` |
| `log_tail` | You want live session/crash/reconnect tracking. | `enabled`, `start_at_end_on_first_run`, `tail_backup_logs`, `max_lines_per_poll`, `max_bytes_per_poll` |
| `runtime` | You want to tune the poll loop. | `poll_interval_ms`, `max_poll_runtime_ms`, `max_events_per_poll` |
| `scanning` | You want baseline scan, resume, and changed-file refresh. | `full_scan_on_start`, `resume_incomplete_scan`, `reuse_completed_baseline`, `incremental_refresh_after_baseline` |
| `logging` | You want to reduce low-importance output volume. | `low_importance_mode`, `write_low_importance_raw_events`, `max_actor_touch_events_per_session` |
| `retention` | You want to control disk growth and history length. | `detailed_retention_days`, `rotate_jsonl_when_bytes_exceed`, `keep_evidence_forever` |
| `forensic_rollup` | You want one quick daily folder for forensic review and plain-language final logs. | `enabled`, `update_interval_seconds`, `daily_root`, `final_log_root`, `atomic_write` |
| `crash_correlation` | You want repeated crash/reconnect review. | `active_before_failure_minutes`, `repeated_failure_review_count`, `repeated_failure_ban_count` |
| `join_leave` | You want churn and join-wave tracking. | `join_wave_window_minutes`, `join_wave_min_accounts`, `churn_alone_never_bans` |
| `warning_bursts` | You want warning-burst review context. | `actor_channel_failure`, `update_actor_to_worldsave`, `deployable_save_warning` |
| `object_registry` | You want class/object/world-token context. | `enabled`, `scan_patterns`, `new_class_enforcement` |
| `world_state` | You want boot/current/session world snapshots. | `write_boot_state`, `write_current_state`, `write_session_join_state` |
| `enforcement` | You want Admin.ini writing. | `review_only_mode`, `auto_ban`, `write_admin_ini`, `require_clean_ban_id` |
| `admin_ini` | You want safe Admin.ini backup/write behavior. | `backup_before_write`, `prevent_duplicates`, `preserve_external_changes`, `atomic_write` |
| `amp` | You want AMP restart marker files after bans. | `request_restart_after_ban`, `restart_marker_file`, `max_restarts_per_hour` |

## Useful profiles

### Safe first install

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
start_at_end_on_first_run = true
tail_backup_logs = false
resume_incomplete_scan = true
reuse_completed_baseline = true
```

Use this until you confirm session evidence, scan progress, and report output.

### Live defense only

```lua
log_tail.enabled = true
scanning.full_scan_on_start = false
review_only_mode = true
```

This keeps session/crash/reconnect tracking active while delaying the heavier world scan.

### Full baseline mode

```lua
scanning.full_scan_on_start = true
scanning.resume_incomplete_scan = true
scanning.reuse_completed_baseline = true
scanning.incremental_refresh_after_baseline = true
```

This builds object/world context. First scan may take time; later refreshes should use baseline information.

### Enforcement enabled

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

Use only after trusted IDs are configured and reports are verified.

### Daily forensic rollup

```lua
forensic_rollup = {
    enabled = true,
    write_current_today = true,
    write_daily_folder = true,
        update_interval_seconds = 30,
    daily_root = "runtime/forensic_days",
    final_log_root = "runtime/final_logs",
    atomic_write = true,
}
```

This writes an updated daily review package under:

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
runtime/current/forensic_today.txt
```

Use it when you want to upload one folder for a fast forensic check. Source evidence remains authoritative.

## Gate behavior

### Active log gate

The startup scan should begin only after the active log is caught up.

```text
active_log_unread_bytes == 0
active_log_caught_up == true
log_backlog_pending == false
```

If unread bytes are zero and backlog is still true, that is a bug.

### Auto-ban gate

Admin.ini writing requires all of these:

```text
auto_ban == true
write_admin_ini == true
review_only_mode == false
ban_id is clean numeric
identity is mapped
threshold is met
account is not trusted/moderator
account-specific evidence exists
```

Default mode does not write bans.

## Output checks

| File | Meaning |
|---|---|
| `runtime/current/poll_status.json` | Watchdog health and scan gate state. |
| `runtime/current/live_defense_state.json` | Session/crash/churn review state. |
| `runtime/scan_progress.json` | Current scan phase and file progress. |
| `runtime/scan_checkpoint.json` | Resume point for interrupted scans. |
| `runtime/world_state/current/world_state_latest.json` | Partial or completed world-state summary. |
| `runtime/baselines/file_manifest.tsv` | Changed-file refresh manifest after baseline. |

## Evidence standard

RandomDayGuard records what the server exposes through logs and Saved files. Indirect signals are review context. Direct claims require direct readable evidence.
