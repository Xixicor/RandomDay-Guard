# Config reference

This is the quick operator reference for the major config areas.

For presets, use [`CONFIG_PROFILES.md`](CONFIG_PROFILES.md).

## Reading this page

Each config area answers:

```text
What it controls
When it runs
What to check
What can go wrong
```

## Top-level safety

| Option | Default | Meaning |
|---|---:|---|
| `enabled` | `true` | Master switch for the guard |
| `review_only_mode` | `true` | Record/recommend only |
| `auto_ban` | `false` | Do not automatically ban by default |
| `write_admin_ini` | `false` | Do not write Admin.ini by default |

Keep these safe until the server owner has reviewed output.

## `saved`

Controls how the guard finds the server `Saved/` folder and which file families it can scan.

Use when:

```text
Saved root auto-detection fails.
World folder changed.
Hostinger/AMP path is unusual.
```

Check:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Rule:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

## `log_tail`

Controls live log reading.

Useful options:

| Option | Safe value | Why |
|---|---|---|
| `enabled` | `true` | Needed for live defense |
| `start_at_end_on_first_run` | `true` | Avoids old logs as live events |
| `tail_backup_logs` | `false` | Backup logs are history, not live |
| `max_lines_per_poll` | bounded | Keeps poll loop responsive |

Check:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

## `runtime`

Controls polling and budgets.

Main health rule:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Check:

```text
runtime/current/poll_status.json
```

If `poll_id` stops, something is blocking the loop.

## `scanning`

Controls baseline scan, checkpointing, and changed-file refresh.

Use when:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Check:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Important settings:

```lua
resume_incomplete_scan = true
reuse_completed_baseline = true
incremental_refresh_after_baseline = true
changed_file_detection = true
```

## `forensic_rollup`

Controls the quick daily upload package and final plain-language logs.

Outputs:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Use when:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Check:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Rule:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

## `logging`

Controls event volume and low-importance aggregation.

Use when:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Safe pattern:

```lua
low_importance_mode = "aggregate"
write_low_importance_raw_events = false
```

## `retention`

Controls how long files are kept and when JSONL logs rotate.

Use when:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Important options:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

## `warning_bursts`

Controls warning-window detection.

Examples:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Rule:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

## `crash_correlation`

Controls repeated crash/reconnect review.

Safe defaults:

```lua
single_crash_never_bans = true
require_same_account = true
```

Useful counters:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

## `join_leave`

Controls churn and join-wave tracking.

Safe default:

```lua
churn_alone_never_bans = true
```

Use for:

```text
rapid reconnect loops
join waves
short-session patterns
```

## `raid_detection`

Groups accounts active in related windows.

Rule:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Each enforced account still needs account-specific evidence.

## `object_registry`

Controls object/class token extraction from readable Saved evidence.

Outputs:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Rule:

```text
Object/class context is not a ban reason by itself.
```

## `world_state`

Controls boot/current/session world-state snapshots.

Outputs:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Use for session review and world context.

## `enforcement`

Controls recommendations and actual Admin.ini writes.

Required gates for writing:

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

## `admin_ini`

Controls safe file writes.

Rules:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

## `amp`

Writes restart marker files if configured.

Outputs:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

The guard should not kill the server process directly.

## Related docs

* [`CONFIG_PROFILES.md`](CONFIG_PROFILES.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
