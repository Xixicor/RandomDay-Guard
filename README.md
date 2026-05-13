# RandomDayGuard

RandomDayGuard is a separately installable guard addon for AMP / Hostinger / Abiotic Factor dedicated servers running the RandomDay Mod.

RandomDay Mod changes the server experience. RandomDayGuard watches the server evidence layer: logs, Admin.ini, PlayerData, world saves, backups, sessions, crashes, and reconnect behavior.

Use this README as the operator path: install it, set the first few options, check that it is alive, then decide whether to leave it in review mode or enable enforcement later.

---

## What You Get

| Feature | What it helps with |
|---|---|
| Live defense | Tracks joins, leaves, reconnects, crashes, and suspicious churn immediately. |
| Identity mapping | Maps player names to account IDs and clean ban IDs from server login evidence. |
| World baseline | Builds object/class/world context from Saved files. |
| Resume scan | Keeps scan progress through crashes and restarts. |
| Changed-file refresh | Avoids rescanning everything after a full baseline exists. |
| Evidence reports | Writes admin-readable runtime files for review. |
| Optional Admin.ini enforcement | Writes clean `BannedPlayer=<ID>` lines only when explicitly enabled. |

Default mode is review-first:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

---

## Fast Install

1. Stop the server.
2. Delete the old `RandomDayGuard` folder if one exists.
3. Extract the ZIP into:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/
```

4. Confirm the final path is:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

5. Enable the mod in `mods.txt`:

```text
RandomDayGuard : 1
```

6. Configure `SavedRoot.txt` if auto-detection cannot find the server `Saved/` folder.
7. Start the server.
8. Check:

```text
runtime/current/poll_status.json
```

Replacing files while the server is running does not guarantee UE4SS reloads the Lua code. Stop, replace, verify, then start.

---

## The First Three Settings To Check

### 1. `SavedRoot.txt`

`SavedRoot.txt` should point to the server's `AbioticFactor/Saved` folder.

Correct examples:

```text
/AMP/<server>/AbioticFactor/Saved
Z:/AMP/<server>/AbioticFactor/Saved
```

Wrong example:

```text
Saved/SaveGames/Server/Worlds/<WorldName>
```

Reason: RandomDayGuard needs access to logs, `Admin.ini`, Worlds, PlayerData, and Backups. Pointing directly at the world folder hides the rest of the evidence.

### 2. Enforcement defaults

Keep these while testing:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

This means RandomDayGuard records evidence and recommendations but does not edit `Admin.ini` yet.

### 3. Whitelist / trusted IDs

Add server owners and trusted moderators before enabling enforcement:

```lua
whitelist = {
    ["<trusted_account_id>"] = true,
}
```

Trusted IDs can still appear in evidence, but they should be protected from automated enforcement.

---

## Configuration Guide

| Config area | Set this when... | Important options |
|---|---|---|
| `saved` | The guard cannot find the server Saved folder or you need to tune what file families are scanned. | `root_candidates`, `direct_known_files`, `scan_world_saves`, `scan_player_data`, `scan_backups` |
| `log_tail` | You want live joins, leaves, and crash-return tracking. | `enabled`, `start_at_end_on_first_run`, `tail_backup_logs`, `max_lines_per_poll` |
| `runtime` | You want to tune watchdog loop frequency and budgets. | `poll_interval_ms`, `max_poll_runtime_ms`, `max_events_per_poll` |
| `scanning` | You want baseline, resume, and changed-file behavior. | `full_scan_on_start`, `resume_incomplete_scan`, `reuse_completed_baseline`, `incremental_refresh_after_baseline` |
| `logging` | You want to control low-importance event volume. | `low_importance_mode`, `write_low_importance_raw_events`, `max_actor_touch_events_per_session` |
| `retention` | You want to control log size and history. | `detailed_retention_days`, `rotate_jsonl_when_bytes_exceed`, `keep_evidence_forever` |
| `crash_correlation` | You want repeated crash/reconnect review. | `repeated_failure_review_count`, `repeated_failure_ban_count`, `post_crash_reconnect_grace_seconds` |
| `join_leave` | You want churn and join-wave tracking. | `join_wave_window_minutes`, `join_wave_min_accounts`, `churn_alone_never_bans` |
| `warning_bursts` | You want warning burst review. | `actor_channel_failure`, `update_actor_to_worldsave`, `deployable_save_warning` |
| `object_registry` | You want class/object/world-token context. | `enabled`, `scan_patterns`, `new_class_enforcement` |
| `world_state` | You want boot/current/session snapshots. | `write_boot_state`, `write_current_state`, `write_session_join_state` |
| `enforcement` | You want `Admin.ini` writing. | `review_only_mode`, `auto_ban`, `write_admin_ini`, `require_clean_ban_id` |
| `admin_ini` | You want safe `Admin.ini` backup/write behavior. | `backup_before_write`, `prevent_duplicates`, `preserve_external_changes`, `atomic_write` |
| `amp` | You want AMP restart marker files after bans. | `request_restart_after_ban`, `restart_marker_file`, `max_restarts_per_hour` |

---

## Recommended Config Profiles

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

Use this when you are installing for the first time and want evidence only.

### Live defense only

```lua
log_tail.enabled = true
scanning.full_scan_on_start = false
review_only_mode = true
```

Use this when you want session/crash/reconnect tracking immediately but want to delay heavy scanning.

### Full baseline mode

```lua
scanning.full_scan_on_start = true
scanning.resume_incomplete_scan = true
scanning.reuse_completed_baseline = true
scanning.incremental_refresh_after_baseline = true
```

Use this when you want the world/object baseline and changed-file refresh. The first scan can take time; the point is to build reusable context.

### Enforcement testing

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Use this when you want to see who would be reviewed or recommended without changing `Admin.ini`.

### Enforcement enabled

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

Use this only after trusted IDs are configured, session mapping is confirmed, warning reports look correct, and `Admin.ini` backups are working.

---

## How The Guard Decides Things

### Normal session

```text
Player logs in.
Player enters.
Player leaves cleanly.
```

Result:

```text
Evidence recorded.
Status remains INFO.
No warning.
No ban.
```

### Fast reconnect loop

```text
join -> leave -> join -> leave -> join
```

Result:

```text
rapid_rejoin_count increases.
session_churn_score increases.
May become REVIEW.
Churn alone does not ban by default.
```

### Crash-return pattern

```text
Player is active.
Server crashes or restarts.
Same player reconnects quickly after restart.
Pattern repeats.
```

Result:

```text
crash overlap and post-crash return counters increase.
May become REVIEW or BAN-ELIGIBLE if repeated and account-specific.
One crash alone is not enough.
```

### World actor save touch

```text
Server log references UpdateActorToWorldSave and a deployed object class.
```

Result:

```text
Recorded as context.
Useful when correlated with sessions, crashes, warnings, or baseline deltas.
Not treated as direct proof by itself.
```

---

## Output Files And What To Check

| File | What it tells you |
|---|---|
| `runtime/runtime_version.json` | Confirms the loaded version. |
| `runtime/current/poll_status.json` | Shows whether the watchdog is alive. |
| `runtime/current/live_defense_state.json` | Shows live session/crash/churn tracking when present. |
| `runtime/current/session_state.json` | Shows current and recent session state. |
| `runtime/account_evidence.json` | Main account/player profile summary. |
| `runtime/account_evidence.tsv` | Spreadsheet-friendly account/player summary. |
| `runtime/evidence/session_events.jsonl` | Login, join, leave, and session events. |
| `runtime/scan_progress.json` | Current scan phase and progress. |
| `runtime/scan_checkpoint.json` | Resume point after crash/restart. |
| `runtime/object_registry_partial.json` | Partial object/class registry while scanning. |
| `runtime/object_registry.json` | Final object/class registry after baseline completion. |
| `runtime/world_state/current/world_state_latest.json` | Current world-state summary. |
| `runtime/baselines/file_manifest.tsv` | Changed-file tracking after baseline. |
| `runtime/enforced_bans.jsonl` | Audit trail for bans written by the guard. |

Healthy poll example:

```json
{
  "scheduler_status": "running",
  "poll_scheduled": true,
  "poll_in_flight": false
}
```

If `poll_id` increases and `poll_in_flight` returns `false`, the watchdog loop is alive.

---

## First Run Checklist

- [ ] Server stopped before install.
- [ ] ZIP extracted into `ue4ss/Mods/RandomDayGuard`.
- [ ] `mods.txt` contains `RandomDayGuard : 1`.
- [ ] `SavedRoot.txt` points to `Saved/` or is blank for auto-detection.
- [ ] `runtime/runtime_version.json` exists.
- [ ] `runtime/current/poll_status.json` shows `scheduler_status=running`.
- [ ] `poll_id` increases.
- [ ] `poll_in_flight` returns `false`.
- [ ] `runtime/current/live_defense_state.json` or `runtime/account_evidence.json` exists after player activity.
- [ ] `runtime/scan_progress.json` exists after scan starts.
- [ ] `runtime/world_state/current/world_state_latest.json` appears.
- [ ] Enforcement remains disabled until verified.

---

## Single World Save Folder

RandomDayGuard supports a single active world folder. It discovers the world under:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

Typical contents:

```text
WorldSave_*.sav
PlayerData/Player_*.sav
```

Set:

```text
SavedRoot.txt -> Saved/
```

Do not set:

```text
SavedRoot.txt -> Saved/SaveGames/Server/Worlds/<WorldName>/
```

RandomDayGuard needs the wider `Saved/` root so it can see logs, `Admin.ini`, world files, PlayerData, and backups.

---

## If The World Folder Changes

### Renamed same world

RandomDayGuard should reuse cached evidence where fingerprints match and rescan paths whose cache no longer matches.

### Restored backup or different world

RandomDayGuard should preserve the old baseline and start a new baseline generation.

### Partial scan existed before the change

RandomDayGuard should mark the old checkpoint stale, preserve the partial evidence, and start a new baseline for the current world.

### Completed baseline existed before the change

RandomDayGuard should load the old baseline for visibility, mark it as previous-world context, and build a new baseline safely.

---

## Ban ID Guide

Display name is not the ban ID.

Best source:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

If the raw connection ID contains extra session/auth metadata, only the clean leading numeric ID belongs in `Admin.ini`.

Correct `Admin.ini` line:

```ini
BannedPlayer=2535422284688820
```

Never write a display name, URL, reason, comment, or raw suffix into `Admin.ini`.

---

## Memory Economy And Output Logs

RandomDayGuard separates output so it can run for long periods without turning every poll into a new giant file.

| Output type | Example | Behavior |
|---|---|---|
| Current snapshots | `runtime/current/poll_status.json` | Overwritten with latest state. |
| Player summaries | `runtime/account_evidence.json`, `runtime/account_evidence.tsv` | Updated when account/session state changes. |
| Event logs | `runtime/evidence/session_events.jsonl` | Append-only timeline. |
| Scan progress | `runtime/scan_progress.json`, `runtime/scan_checkpoint.json` | Updated while scan runs. |
| Baseline files | `runtime/baselines/file_manifest.tsv` | Used to avoid rescanning unchanged files. |
| Enforcement audit | `runtime/enforced_bans.jsonl` | Permanent audit trail when enforcement is used. |

When a player joins or leaves, check:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/current/session_state.json
```

When the scan changes state, check:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

For the full output map, see:

```text
docs/MEMORY_ECONOMY_AND_OUTPUTS.md
```

---

## Evidence Standards

RandomDayGuard is evidence-first. It records what the server exposes through logs and Saved files.

Some facts require direct evidence. For example, the guard should not label a player as duplicating items, damaging objects, opening a container, or using exact coordinates unless readable server evidence actually exposes that fact.

When evidence is indirect, RandomDayGuard stores it as context. Context can support review, but it is not the same as direct proof.

---

## Relationship To RandomDay Mod

RandomDay Mod runs the rotating server experience. RandomDayGuard watches the server evidence layer and helps administrators review abuse, crashes, reconnects, world context, and enforcement decisions.

---

## Disclaimer

RandomDayGuard is an independent community server-administration utility. It is not affiliated with or endorsed by Deep Field Games, Playstack, UE4SS, AMP, Hostinger, or any platform provider.
