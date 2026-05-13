# RandomDayGuard

**RandomDayGuard** is a separately installable guard addon for **Abiotic Factor dedicated servers** running the **RandomDay Mod**.

RandomDay Mod changes the server experience. RandomDayGuard watches the server evidence layer: logs, `Admin.ini`, PlayerData, world saves, backups, sessions, crashes, and reconnect behavior.

It is meant for AMP, Hostinger VPS, Wine, and Windows dedicated-server layouts.

---

## What You Get

| Feature | What it helps with |
|---|---|
| Live defense | Tracks joins, leaves, reconnects, crashes, and suspicious session churn immediately. |
| Identity mapping | Maps player names to account IDs and clean ban IDs from server login evidence. |
| World baseline | Builds object/class/world context from Saved files. |
| Resume scan | Keeps scan progress through crashes and restarts. |
| Changed-file refresh | Avoids rescanning everything after a full baseline exists. |
| Evidence reports | Writes admin-readable runtime files for review. |
| Optional Admin.ini enforcement | Writes clean `BannedPlayer=<ID>` lines only when explicitly enabled. |

Default mode is evidence and review only:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

---

## Fast Install

1. Stop the server.
2. Delete the old `RandomDayGuard` folder from `ue4ss/Mods/`.
3. Extract `RandomDayGuard_v0.4.11-alpha.zip` into:

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

6. Set `SavedRoot.txt` if auto-detection does not find the server `Saved/` folder.
7. Start the server.
8. Check `runtime/current/poll_status.json`.

Replacing files while the server is running does not guarantee UE4SS reloads the Lua code. Stop the server, replace the folder, verify files, then start the server.

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

Reason: RandomDayGuard needs logs, `Admin.ini`, world folders, PlayerData, and backups. Pointing directly at a world folder hides the rest of the evidence.

### 2. Enforcement defaults

Keep these until you have confirmed the reports and identity mapping on your server:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

This means RandomDayGuard records evidence and recommendations, but does not edit `Admin.ini`.

### 3. Trusted IDs

Before enabling enforcement, add server owners and trusted moderators:

```lua
whitelist = {
    ["<trusted_account_id>"] = true,
}
```

Trusted IDs can still appear in evidence, but they should not be automatically punished.

---

## Configuration Guide

Most settings live in:

```text
RandomDayGuard/config.lua
```

| Config area | Set this when... | Important options |
|---|---|---|
| `saved` | The guard cannot find the server `Saved/` folder, or you want to control what file families are scanned. | `root_candidates`, `direct_known_files`, `scan_world_saves`, `scan_player_data`, `scan_backups` |
| `log_tail` | You want live joins, leaves, crashes, and reconnect tracking. | `enabled`, `start_at_end_on_first_run`, `tail_backup_logs`, `max_lines_per_poll` |
| `runtime` | You need to adjust how often the watchdog polls. | `poll_interval_ms`, `max_poll_runtime_ms`, `max_events_per_poll` |
| `scanning` | You want baseline, resume, and changed-file behavior. | `full_scan_on_start`, `resume_incomplete_scan`, `reuse_completed_baseline`, `incremental_refresh_after_baseline` |
| `logging` | You want to control low-importance event volume. | `low_importance_mode`, `write_low_importance_raw_events`, `max_actor_touch_events_per_session` |
| `retention` | You want to control file growth and history length. | `detailed_retention_days`, `rotate_jsonl_when_bytes_exceed`, `keep_evidence_forever` |
| `crash_correlation` | You want repeated crash/reconnect review. | `active_before_failure_minutes`, `repeated_failure_review_count`, `repeated_failure_ban_count` |
| `join_leave` | You want churn and join-wave tracking. | `join_wave_window_minutes`, `join_wave_min_accounts`, `churn_alone_never_bans` |
| `warning_bursts` | You want review signals from repeated server warnings. | `actor_channel_failure`, `update_actor_to_worldsave`, `deployable_save_warning` |
| `object_registry` | You want class/object/world-token context. | `enabled`, `scan_patterns`, `new_class_enforcement` |
| `world_state` | You want boot/current/session world snapshots. | `write_boot_state`, `write_current_state`, `write_session_join_state` |
| `enforcement` | You want Admin.ini writing. | `review_only_mode`, `auto_ban`, `write_admin_ini`, `require_clean_ban_id` |
| `admin_ini` | You want safe Admin.ini backup/write behavior. | `backup_before_write`, `prevent_duplicates`, `preserve_external_changes`, `atomic_write` |
| `amp` | You want AMP restart marker files after bans. | `request_restart_after_ban`, `restart_marker_file`, `max_restarts_per_hour` |

---

## Recommended Config Profiles

### Safe first install

Use this when installing for the first time:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
start_at_end_on_first_run = true
tail_backup_logs = false
resume_incomplete_scan = true
reuse_completed_baseline = true
```

Result: evidence is recorded, but no ban lines are written.

### Live defense only

Use this if you want session/crash/reconnect tracking first and want to delay heavy scanning:

```lua
log_tail.enabled = true
scanning.full_scan_on_start = false
review_only_mode = true
```

Result: live-defense files update from logs, but the world baseline does not start automatically.

### Full baseline mode

Use this when you want the object/world baseline and future changed-file refresh:

```lua
scanning.full_scan_on_start = true
scanning.resume_incomplete_scan = true
scanning.reuse_completed_baseline = true
scanning.incremental_refresh_after_baseline = true
```

Result: the first scan may take time, but progress is saved and later refreshes can reuse baseline data.

### Enforcement testing

Use this when you want to see who would be reviewed without changing `Admin.ini`:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Result: evidence and recommendations are written, but `Admin.ini` is untouched.

### Enforcement enabled

Use this only after trusted IDs are configured, session mapping is confirmed, reports look correct, and `Admin.ini` backups are working:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

Result: if all configured gates pass, RandomDayGuard may write clean ban lines to `Admin.ini`.

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
rapid_rejoin_count increases
session_churn_score increases
may become REVIEW
```

Churn by itself does not ban by default:

```lua
churn_alone_never_bans = true
```

### Crash-return pattern

```text
Player is active.
Server crashes.
Same player reconnects quickly after restart.
Pattern repeats.
```

Result:

```text
crash overlap counters increase
post-crash return counters increase
may become REVIEW or BAN-ELIGIBLE if repeated and account-specific
```

One crash alone is not enough:

```lua
single_crash_never_bans = true
```

### World actor save touch

```text
Server log references UpdateActorToWorldSave and a deployed container class.
```

Result:

```text
Recorded as context.
Useful when correlated with mapped sessions, crashes, warnings, or baseline deltas.
Not direct proof of theft, duplication, damage, or container use by itself.
```

---

## Output Files And What To Check

| File | What it tells you |
|---|---|
| `runtime/runtime_version.json` | Confirms the loaded version. |
| `runtime/current/poll_status.json` | Shows whether the watchdog loop is alive. |
| `runtime/current/live_defense_state.json` | Shows live session/crash/churn tracking. |
| `runtime/evidence/session_events.jsonl` | Login, join, leave, and session events. |
| `runtime/evidence/live_defense_events.jsonl` | Churn, reconnect, and review signals. |
| `runtime/evidence/crash_reconnect_events.jsonl` | Crash/restart continuity and post-crash returns. |
| `runtime/scan_progress.json` | Current scan phase and file progress. |
| `runtime/scan_checkpoint.json` | Resume point after crash/restart. |
| `runtime/object_registry_partial.json` | Partial object/class registry while scanning. |
| `runtime/object_registry.json` | Final object/class registry after baseline completion. |
| `runtime/world_state/current/world_state_latest.json` | Current world-state summary. |
| `runtime/baselines/file_manifest.tsv` | Changed-file tracking after baseline. |
| `runtime/enforced_bans.jsonl` | Audit trail for bans written by the guard. |

Healthy poll status looks like this:

```json
{
  "scheduler_status": "running",
  "poll_scheduled": true,
  "poll_in_flight": false
}
```

If `poll_id` keeps increasing and `poll_in_flight` returns to `false`, the watchdog loop is alive.

---

## First Run Checklist

- [ ] Server stopped before install.
- [ ] ZIP extracted into `ue4ss/Mods/RandomDayGuard`.
- [ ] `mods.txt` contains `RandomDayGuard : 1`.
- [ ] `SavedRoot.txt` points to `Saved/` or is blank for auto-detection.
- [ ] `runtime/runtime_version.json` exists.
- [ ] `runtime/current/poll_status.json` shows `scheduler_status="running"`.
- [ ] `poll_id` increases.
- [ ] `poll_in_flight` returns to `false`.
- [ ] `runtime/current/live_defense_state.json` exists.
- [ ] `runtime/scan_progress.json` exists after scan starts.
- [ ] `runtime/world_state/current/world_state_latest.json` appears.
- [ ] Enforcement remains disabled until reports are verified.

---

## Single World Save Folder

RandomDayGuard supports a single active world folder.

Typical layout:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

Inside it:

```text
WorldSave_*.sav
PlayerData/Player_*.sav
```

Admin setup should be:

```text
SavedRoot.txt -> Saved/
```

Do not put `<WorldName>` into public defaults. RandomDayGuard discovers world folders under `Saved/`.

---

## If The World Folder Changes

### Renamed same world

RandomDayGuard should reuse cached evidence where fingerprints match and rescan mismatched paths.

### Restored backup or different world

RandomDayGuard should preserve the old baseline and start a new baseline generation.

### Partial scan existed before the change

RandomDayGuard should mark the old checkpoint stale and preserve the partial evidence.

### Completed baseline existed before the change

RandomDayGuard should load the old baseline for visibility, then build a new baseline safely.

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

If `ConnectID` is:

```text
2535422284688820_+_|0002d07b...
```

`Admin.ini` gets:

```ini
BannedPlayer=2535422284688820
```

Never use a display name as the ban value, and do not use the full suffixed `ConnectID`. Use only the clean numeric prefix.

---

## Admin.ini Enforcement

When enforcement is disabled, RandomDayGuard writes evidence only.

When enforcement is enabled and all gates pass, `Admin.ini` receives only:

```ini
BannedPlayer=<ID>
```

No comments. No reasons. No display names. No suffixes.

Evidence goes here instead:

```text
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/evidence/
runtime/warnings/
```

---

## Evidence Standards

RandomDayGuard is evidence-first. It records what the server exposes through logs and Saved files.

Some facts require direct evidence. For example, the guard should not label a player as duplicating items, damaging objects, opening a container, or using exact coordinates unless readable server evidence actually exposes that fact.

When evidence is indirect, RandomDayGuard stores it as context. Context can support review, but it is not the same as direct proof.

---

## Terminal Checks

From the installed folder:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
grep -n "local VERSION" RandomDayGuard/scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
cat RandomDayGuard/SavedRoot.txt
```

Expected version:

```text
v0.4.11-alpha
```

---

## Relationship To RandomDay Mod

```text
RandomDay Mod runs the rotating server experience.
RandomDayGuard watches, records, and protects the dedicated-server evidence layer.
```

---

## Disclaimer

RandomDayGuard is an independent community server-administration utility.

It is not affiliated with or endorsed by Deep Field Games, Playstack, UE4SS, AMP, Hostinger, or any platform provider.
