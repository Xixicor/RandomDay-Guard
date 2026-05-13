# RandomDayGuard Configuration Guide

This is the operator configuration guide for `RandomDayGuard/config.lua`.

Use it in this order:

1. Point the guard at the right `Saved/` folder.
2. Keep enforcement disabled.
3. Add trusted IDs.
4. Confirm the live watchdog is running.
5. Let the baseline scan build.
6. Review evidence output.
7. Enable enforcement only after testing.

---

## 1. First settings most admins should check

### `SavedRoot.txt`

Use `SavedRoot.txt` when automatic path detection cannot find the server's `AbioticFactor/Saved` folder.

Correct examples:

```text
/AMP/<server>/AbioticFactor/Saved
Z:/AMP/<server>/AbioticFactor/Saved
```

Do not point it to:

```text
Saved/SaveGames/Server/Worlds/<WorldName>
```

Reason: RandomDayGuard needs access to logs, `Admin.ini`, Worlds, PlayerData, and Backups. The world folder alone is too narrow.

### Enforcement defaults

Keep these while installing and testing:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Result: evidence is recorded, reports are written, and `Admin.ini` is not edited.

### Trusted IDs

Add server owners and trusted moderators before enabling enforcement:

```lua
whitelist = {
    ["<trusted_account_id>"] = true,
}
```

Trusted IDs can still appear in evidence. The setting prevents automatic punishment later.

---

## 2. Choose a configuration profile

### Safe first install

Use when you want evidence only.

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
start_at_end_on_first_run = true
tail_backup_logs = false
resume_incomplete_scan = true
reuse_completed_baseline = true
```

What happens:

```text
Live defense starts.
Baseline scan may run.
No ban lines are written.
```

### Live defense only

Use when you want session/crash/reconnect tracking before the heavy baseline scan.

```lua
log_tail.enabled = true
scanning.full_scan_on_start = false
review_only_mode = true
```

What happens:

```text
The active log is tailed.
Join/leave/crash/reconnect evidence is written.
World/object baseline waits.
```

### Full baseline mode

Use when you want object/world context.

```lua
scanning.full_scan_on_start = true
scanning.resume_incomplete_scan = true
scanning.reuse_completed_baseline = true
scanning.incremental_refresh_after_baseline = true
```

What happens:

```text
The first scan can take time.
Progress and checkpoints are written.
A completed baseline can be reused later.
```

### Enforcement dry run

Use when you want to see recommendations without touching `Admin.ini`.

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

What happens:

```text
Review status and evidence are written.
No Admin.ini changes occur.
```

### Enforcement enabled

Use only after testing.

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

Before enabling this, confirm:

- trusted IDs are configured
- login identity mapping works
- warning/review reports are understandable
- `Admin.ini` backups are being made
- server owner accepts automatic ban writing

---

## 3. Configuration map by job

| Job | Config area | Main options |
|---|---|---|
| Find the server files | `saved`, `SavedRoot.txt` | `root_candidates`, `direct_known_files`, `scan_world_saves`, `scan_player_data`, `scan_backups` |
| Tail live logs | `log_tail` | `enabled`, `start_at_end_on_first_run`, `tail_backup_logs`, `max_lines_per_poll`, `max_bytes_per_poll` |
| Keep polling responsive | `runtime` | `poll_interval_ms`, `max_poll_runtime_ms`, `max_events_per_poll` |
| Build baseline | `scanning` | `full_scan_on_start`, `resume_incomplete_scan`, `reuse_completed_baseline`, `incremental_refresh_after_baseline` |
| Reduce file bloat | `logging`, `retention` | `low_importance_mode`, `rotate_jsonl_when_bytes_exceed`, `detailed_retention_days` |
| Track crash abuse | `crash_correlation`, `server_lifecycle` | `active_before_failure_minutes`, `post_crash_reconnect_grace_seconds`, `repeated_failure_review_count` |
| Track churn | `join_leave` | `join_wave_window_minutes`, `join_wave_min_accounts`, `churn_alone_never_bans` |
| Track warning bursts | `warning_bursts` | `actor_channel_failure`, `update_actor_to_worldsave`, `deployable_save_warning` |
| Build object context | `object_registry`, `class_categories`, `high_risk_classes` | `enabled`, `scan_patterns`, `new_class_enforcement`, category patterns |
| Compare world changes | `accumulation`, `target_context` | `watched_delta_classes`, `review_delta_total`, `require_account_correlation_for_enforcement` |
| Write world snapshots | `world_state` | `write_boot_state`, `write_current_state`, `write_session_join_state`, `write_session_leave_state` |
| Write warnings | `warning_report` | `group_by_player`, `group_by_session`, `include_detector_explanations` |
| Link multi-account cases | `raid_detection` | `create_case_min_accounts`, `link_by_same_failure_window`, `require_account_specific_evidence` |
| Write bans | `enforcement`, `admin_ini` | `auto_ban`, `write_admin_ini`, `require_clean_ban_id`, `atomic_write` |
| Request AMP restart | `amp` | `request_restart_after_ban`, `restart_marker_file`, `max_restarts_per_hour` |

---

## 4. Option explanations in operator terms

### `saved`

Use this area when the guard cannot find the right files.

Important options:

| Option | Recommended starting point | What it does |
|---|---|---|
| `root_candidates` | Leave defaults, add your host path if needed. | Paths tested when `SavedRoot.txt` is blank. |
| `direct_known_files` | Keep generic log/Admin/Sandbox files. | Files used to prove the Saved root exists. |
| `scan_world_saves` | `true` | Allows world `.sav` files into baseline scan. |
| `scan_player_data` | `true` | Allows PlayerData into identity/world context. |
| `scan_backups` | `true` | Allows backups into historical context. |
| `allow_full_find_discovery` | `false` in `saved` | Full discovery should not run in live root/status paths. |

### `log_tail`

Use this area for live defense.

| Option | Recommended starting point | What it does |
|---|---|---|
| `enabled` | `true` | Turns live log tailing on. |
| `start_at_end_on_first_run` | `true` | Starts from current log end so old history is not treated as live. |
| `tail_backup_logs` | `false` | Prevents backup logs from becoming live events. |
| `register_backup_logs` | `true` | Keeps backup logs visible as context. |
| `max_lines_per_poll` | `500` | Limits work per poll. |
| `max_bytes_per_poll` | `262144` | Limits bytes per poll. |

### `scanning`

Use this area for the world/object baseline.

| Option | Recommended starting point | What it does |
|---|---|---|
| `full_scan_on_start` | `true` or `auto` if supported | Starts a baseline when needed. |
| `resume_incomplete_scan` | `true` | Resumes after crash/restart. |
| `reuse_completed_baseline` | `true` | Loads previous completed baseline immediately. |
| `incremental_refresh_after_baseline` | `true` | Scans changed files after baseline. |
| `write_scan_progress` | `true` | Writes progress for long scans. |
| `allow_full_find_discovery_only_in_scan_job` | `true` | Keeps heavy discovery out of live paths. |
| `targeted_token_extraction` | `true` | Extracts relevant tokens without broad binary token spam. |
| `fallback_broad_token_scan` | `false` | Avoids slow broad scanning unless explicitly enabled. |

### `enforcement`

Use this area last.

| Option | Safe default | What it does |
|---|---|---|
| `review_only_mode` | `true` | Blocks automatic enforcement. |
| `auto_ban` | `false` | Prevents automatic bans. |
| `write_admin_ini` | `false` | Prevents Admin.ini editing. |
| `require_clean_ban_id` | `true` | Requires numeric clean ID. |
| `preserve_moderators` | `true` | Protects moderators. |
| `preserve_existing_bans` | `true` | Keeps existing bans. |
| `require_account_specific_evidence` | `true` | Prevents group-only evidence from banning a person. |

---

## 5. Gates and what they mean

### Startup scan gate

The scan can start when the live log is caught up and the poll loop is stable.

Expected state:

```text
poll_id > 1
prior_poll_completed == true
log_backlog_pending == false
active_log_caught_up == true
active_log_unread_bytes == 0
```

If `active_log_unread_bytes` is zero but `log_backlog_pending` is still true, something is wrong.

### Auto-ban gate

Admin.ini writing requires all conditions:

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

If any condition fails, the guard should write evidence/recommendations only.

---

## 6. Output checks after changing config

| File | What to check |
|---|---|
| `runtime/current/poll_status.json` | `scheduler_status=running`, `poll_id` increasing, `poll_in_flight=false`. |
| `runtime/current/live_defense_state.json` | Live counters and account/session state. |
| `runtime/evidence/session_events.jsonl` | Login, join, leave, and session records. |
| `runtime/scan_progress.json` | Scan phase, file count, current file, entries seen. |
| `runtime/scan_checkpoint.json` | Resume information during long scan. |
| `runtime/world_state/current/world_state_latest.json` | Partial or complete world state. |
| `runtime/baselines/file_manifest.tsv` | Changed-file tracking after completed baseline. |
| `runtime/enforced_bans.jsonl` | Only appears/useful when enforcement writes bans. |

---

## 7. Common mistakes

| Mistake | Result | Fix |
|---|---|---|
| `SavedRoot.txt` points to the world folder. | Logs/Admin.ini/backups are hidden. | Point it to `AbioticFactor/Saved`. |
| Enforcement enabled before trusted IDs. | Risk of punishing admins/moderators. | Add whitelist/trusted IDs first. |
| `tail_backup_logs=true` on live server. | Old events may look fresh. | Keep false unless doing forensic backfill. |
| Replacing files while server runs. | UE4SS may keep old Lua loaded. | Stop, replace, verify, start. |
| Expecting full world context immediately. | First baseline may still be scanning. | Check partial `world_state_latest.json` and `scan_progress.json`. |
| Treating context as proof. | Overstates evidence. | Use context for review unless direct evidence exists. |

---

## 8. Evidence standard

RandomDayGuard records what the server exposes through logs and Saved files.

Direct evidence can support direct statements.

Indirect evidence is stored as context.

Context can support review, but context is not the same as direct proof.
