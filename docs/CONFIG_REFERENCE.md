# Configuration concepts

This explanation describes what each major configuration area controls, when it
runs, and how it interacts with evidence and safety gates. It does not own the
exact field catalog or profile procedures.

For task-oriented presets and safe change steps, use
[`CONFIG_PROFILES.md`](CONFIG_PROFILES.md). For every exact source field,
default, type, invariant, output effect, and recovery rule, use the generated
[`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md); the validator requires one
row there for every shipped `config.lua` leaf field.

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
| `enforcement.review_only_mode` | `true` | Record/recommend only |
| `enforcement.auto_ban` | `false` | Do not automatically ban by default |
| `enforcement.write_admin_ini` | `false` | Do not write Admin.ini by default |

Keep these safe until the server owner has reviewed output.

## `saved`

Controls how the guard finds the server `Saved/` folder and which file families it can scan.

Use when:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
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

## `source_accounting`

Controls explicit evidence-source coverage and scope.

| Key | Default | Meaning |
|---|---:|---|
| `enabled` | `true` | Writes source accounting for public route reports. |
| `require_terminal_status` | `true` | Requires each source to expose an explicit terminal or incomplete state. |
| `distinguish_current_from_historical` | `true` | Keeps current and historical evidence separate. |
| `slow_world_scan_blocks_current_reports` | `false` | Allows current reports to state that bounded world scanning is deferred or partial. |
| `changed_file_manifest` | baseline manifest path | Reference used for bounded historical/world accounting. |

Source states are `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, or `error`.

Setting `source_accounting.enabled = false` does not silently remove status output. The pipeline still writes `runtime/final_logs/source_accounting_latest.json` with `enabled=false`, `status="unavailable"`, and `disabled_reason="source_accounting_disabled"`. It also writes the historical-status record with unavailable accounting. Because source accounting is part of the report contract, every route fails closed to `missing`; no route is treated as completed while accounting is disabled.

## `reports`

Controls the generic local reporting pipeline.

Defaults enable all five routes and write under `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Each route must write structured and translated output plus proof in `route_proof.json`. Disabling a route produces `missing` proof rather than pretending that it completed.

## `notification`

Optional generic local-file outbox. It is disabled by default and sends nothing to an external provider.

Defaults:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Every notification route is disabled by default. When deliberately enabled, the outbox may consume only a completed translated report after `route_proof.json` is written. Local evidence and reports remain authoritative. Provider-specific delivery, delivery endpoints, credentials, and bridges are not part of the public independent-watchdog contract.

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
scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
},
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
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
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
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
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
join_leave = {
    churn_alone_never_bans = true,
},
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

Before Guard can add a ban, every statement below must be true:

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

If one statement is false or cannot be checked, Guard leaves `Admin.ini`
unchanged and records the reason.

## `admin_ini`

Controls safe file writes.

Rules:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

## `restart_request`

Controls optional local marker files that another operator-owned process may inspect. It does not restart or kill the server.

Defaults:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Outputs:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

No hosting panel, provider bridge, or restart automation is bundled. Enabling marker creation does not prove that an external process consumed the request or restarted the server.

## Related docs

* [`CONFIG_PROFILES.md`](CONFIG_PROFILES.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
