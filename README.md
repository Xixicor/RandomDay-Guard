# RandomDayGuard

**RandomDayGuard** is a separately installable **AMP / Hostinger / Abiotic Factor dedicated-server guard addon** for the **RandomDay Mod**.

RandomDay Mod changes the server experience. RandomDayGuard watches the server evidence layer: logs, `Admin.ini`, PlayerData, world saves, backups, sessions, crashes, reconnects, and baseline changes.

---

## Start Here: The Order That Matters

Use this order on a fresh install.

| Step | Do this | Why it matters |
|---:|---|---|
| 1 | Install the ZIP into `ue4ss/Mods/RandomDayGuard/`. | UE4SS must load the mod from the right folder. |
| 2 | Enable `RandomDayGuard : 1` in `mods.txt`. | UE4SS will not run the guard unless it is enabled. |
| 3 | Set `SavedRoot.txt` only if auto-detection fails. | The guard needs the whole `AbioticFactor/Saved` folder. |
| 4 | Keep enforcement disabled. | First boot should collect evidence, not write bans. |
| 5 | Add trusted admin IDs. | Prevents accidental action against owners/moderators later. |
| 6 | Start the server. | The live guard begins from the active log. |
| 7 | Check `poll_status.json`. | Confirms the watchdog loop is alive. |
| 8 | Let the baseline scan run. | Builds world/object context in the background. |
| 9 | Review output files. | Confirm identity mapping and reports match your server. |
| 10 | Enable enforcement only after validation. | Admin.ini writing should be the last step, not the first. |

Recommended first-run enforcement settings:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

---

## Quick Navigation

| I need to... | Go to |
|---|---|
| Install the mod | [Install in five minutes](#install-in-five-minutes) |
| Know what to configure first | [First configuration pass](#first-configuration-pass) |
| Confirm it is running | [Health checks](#health-checks) |
| Understand the first long scan | [The first baseline scan](#the-first-baseline-scan) |
| Know what each output file means | [Output file index](#output-file-index) |
| Choose safe settings | [Configuration presets](#configuration-presets) |
| Enable Admin.ini writing later | [Enforcement path](#enforcement-path) |
| Handle a world folder change | [World folder changes](#world-folder-changes) |
| Map names to ban IDs safely | [Ban ID mapping](#ban-id-mapping) |
| Understand evidence limits | [Evidence standards](#evidence-standards) |

More detailed docs:

```text
docs/INDEX.md
docs/CONFIG_REFERENCE.md
docs/HOSTINGER_AMP_INSTALL.md
docs/WORLD_SAVE_FOLDER_CHANGES.md
docs/BAN_ID_MAPPING.md
```

---

## What You Get

| Feature | What it does | When it starts |
|---|---|---|
| Live defense | Tracks joins, leaves, reconnects, crashes, and churn from the active log. | Immediately after boot. |
| Identity mapping | Maps player names to account IDs and clean ban IDs from login evidence. | As soon as login lines appear. |
| Session evidence | Stores who joined, when they left, whether the leave was clean, and which epoch they were in. | During live polling. |
| Crash/reconnect context | Links active sessions to crashes/restarts and post-crash returns. | During live polling. |
| Baseline scan | Builds object/class/world context from Saved files. | After the active log is caught up. |
| Scan checkpoint | Saves long-scan progress so restarts do not waste completed work. | During scanning. |
| Changed-file refresh | Reuses completed baseline data and scans only changed files where possible. | After a completed baseline exists. |
| Evidence reports | Writes JSON/JSONL/TSV/text outputs for admin review. | Throughout runtime. |
| Optional enforcement | Writes clean `BannedPlayer=<ID>` lines to `Admin.ini`. | Only if explicitly enabled. |

---

## What The First Hour Looks Like

### Right after server start

You should see runtime files appear.

Check:

```text
runtime/runtime_version.json
runtime/current/poll_status.json
runtime/current/live_defense_state.json
```

Expected behavior:

```text
poll_id increases
scheduler_status = running
poll_in_flight returns to false between polls
```

### When a player joins

The active log is tailed. If the server writes a login line, RandomDayGuard records the identity mapping.

Typical flow:

```text
Login request -> name + ConnectID + UniqueId
Join line      -> session starts
Leave line     -> session closes cleanly
```

### While the first scan runs

The baseline scan may take time on a large server. That is normal.

Check:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

A partial world state is useful, but it should be marked as partial:

```json
{
  "scan_complete": false,
  "generated_from_partial_scan": true
}
```

### After the baseline finishes

Completed outputs should appear:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/file_manifest.tsv
runtime/baselines/last_completed_baseline.json
runtime/world_state/current/world_state_latest.json
```

Later boots should load the completed baseline first, then scan changed files.

---

## Install In Five Minutes

1. Stop the server.
2. Delete any old `RandomDayGuard` folder from `ue4ss/Mods/`.
3. Extract the release ZIP into:

   ```text
   AbioticFactor/Binaries/Win64/ue4ss/Mods/
   ```

4. Confirm the final path is:

   ```text
   AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
   ```

5. Confirm these files exist:

   ```text
   RandomDayGuard/enabled.txt
   RandomDayGuard/config.lua
   RandomDayGuard/SavedRoot.txt
   RandomDayGuard/Scripts/main.lua
   RandomDayGuard/scripts/main.lua
   ```

6. Enable it in `mods.txt`:

   ```text
   RandomDayGuard : 1
   ```

7. Start the server.
8. Check `runtime/current/poll_status.json`.

Do not rely on replacing files while the server is already running. UE4SS may keep the old Lua code loaded until restart.

---

## First Configuration Pass

Most admins only need to check these first.

### 1. `SavedRoot.txt`

Set this only if auto-detection cannot find the server `Saved/` folder.

Correct:

```text
/AMP/<server>/AbioticFactor/Saved
Z:/AMP/<server>/AbioticFactor/Saved
```

Wrong:

```text
Saved/SaveGames/Server/Worlds/<WorldName>
```

Why: RandomDayGuard needs logs, `Admin.ini`, world saves, PlayerData, and backups. Pointing directly at the world folder hides most of the evidence.

### 2. Review-only enforcement

Keep this until you trust the output:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Result: the guard records evidence and recommendations but does not edit `Admin.ini`.

### 3. Trusted IDs

Add owners and moderators before enabling enforcement:

```lua
whitelist = {
    ["<trusted_account_id>"] = true,
}
```

Trusted IDs can still appear in evidence. The point is to block automatic punishment later.

### 4. Log tail mode

Recommended live-server defaults:

```lua
start_at_end_on_first_run = true
tail_backup_logs = false
register_backup_logs = true
```

Result: new live events are tracked, but old backup logs are not treated as fresh player activity.

### 5. Baseline scan behavior

Recommended for normal use:

```lua
reuse_completed_baseline = true
resume_incomplete_scan = true
incremental_refresh_after_baseline = true
```

Result: the first scan can be long, but restarts should not throw away progress, and later runs should reuse baseline data.

---

## Configuration Presets

### Safe first install

Use this first.

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
start_at_end_on_first_run = true
tail_backup_logs = false
resume_incomplete_scan = true
reuse_completed_baseline = true
```

Expected result:

```text
Evidence is collected.
No Admin.ini ban lines are written.
The baseline scan can run in the background.
```

### Live defense first, heavy scan later

Use when you want session/crash/reconnect tracking before running a broad baseline.

```lua
log_tail.enabled = true
scanning.full_scan_on_start = false
review_only_mode = true
```

Expected result:

```text
Live session evidence works.
World/object baseline waits until you enable scanning.
```

### Full baseline mode

Use when you are ready to build object/world context.

```lua
scanning.full_scan_on_start = true
scanning.resume_incomplete_scan = true
scanning.reuse_completed_baseline = true
scanning.incremental_refresh_after_baseline = true
```

Expected result:

```text
First scan may take time.
Progress and checkpoint files are written.
Later boots can reuse completed baseline data.
```

### Enforcement dry run

Use when you want to see who would be reviewed without changing the server ban list.

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Expected result:

```text
Reports and scores are written.
Admin.ini is untouched.
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
- identity mapping works
- reports look correct
- `Admin.ini` backup behavior works
- the server owner accepts automatic ban writing

---

## Configuration Index

| Goal | Config area | Key options |
|---|---|---|
| Find the right server files | `saved` | `root_candidates`, `direct_known_files`, `scan_world_saves`, `scan_player_data`, `scan_backups` |
| Track joins/leaves/crashes | `log_tail`, `join_leave`, `crash_correlation` | `enabled`, `start_at_end_on_first_run`, `join_wave_window_minutes`, `repeated_failure_review_count` |
| Keep the loop responsive | `runtime`, `log_tail`, `scanning` | `poll_interval_ms`, `max_bytes_per_poll`, `startup_scan_files_per_tick` |
| Build world context | `scanning`, `object_registry`, `world_state` | `full_scan_on_start`, `scan_patterns`, `write_current_state` |
| Avoid rescanning everything | `scanning` | `reuse_completed_baseline`, `resume_incomplete_scan`, `incremental_refresh_after_baseline` |
| Control file growth | `retention`, `logging` | `detailed_retention_days`, `rotate_jsonl_when_bytes_exceed`, `low_importance_mode` |
| Review suspicious behavior | `warning_bursts`, `raid_detection`, `accumulation` | warning thresholds, raid case thresholds, delta thresholds |
| Write bans | `enforcement`, `admin_ini` | `auto_ban`, `write_admin_ini`, `require_clean_ban_id`, `atomic_write` |
| Request AMP restart | `amp` | `request_restart_after_ban`, `restart_marker_file`, `max_restarts_per_hour` |

---

## Health Checks

### Good poll status

```json
{
  "scheduler_status": "running",
  "poll_scheduled": true,
  "poll_in_flight": false
}
```

Good signs:

```text
poll_id increases
poll_in_flight returns to false
log_backlog_pending becomes false when unread bytes are zero
scan_progress.json appears after scan starts
```

### Good scan status

```json
{
  "active": true,
  "phase": "scanning",
  "files_done": 141,
  "total_files": 1767,
  "entries_seen": 2888
}
```

Meaning:

```text
The scan is running.
The baseline is not finished yet.
Live defense can still operate.
```

### Good completed baseline

```json
{
  "scan_complete": true,
  "baseline_loaded": true
}
```

Meaning:

```text
World/object baseline exists.
Future boots should load it before scanning changed files.
```

---

## Output File Index

| File | First question it answers |
|---|---|
| `runtime/runtime_version.json` | Which version actually loaded? |
| `runtime/startup_status.json` | Did startup reach the expected phase? |
| `runtime/current/poll_status.json` | Is the watchdog loop alive? |
| `runtime/current/live_defense_state.json` | What does the live guard currently know? |
| `runtime/current/session_state.json` | Who is active or recently active? |
| `runtime/evidence/session_events.jsonl` | What login/join/leave events happened? |
| `runtime/evidence/live_defense_events.jsonl` | What churn or review events were recorded? |
| `runtime/evidence/crash_reconnect_events.jsonl` | Who overlapped crashes or returned after restart? |
| `runtime/scan_progress.json` | Where is the baseline scan right now? |
| `runtime/scan_checkpoint.json` | Where should an interrupted scan resume? |
| `runtime/object_registry_partial.json` | What classes/objects are known so far? |
| `runtime/object_registry.json` | What classes/objects were found after completion? |
| `runtime/world_state/current/world_state_latest.json` | What world context is currently available? |
| `runtime/baselines/file_manifest.tsv` | Which files were scanned and how are changes detected? |
| `runtime/enforced_bans.jsonl` | What bans did the guard write, if enforcement is enabled? |

---

## How Decisions Are Built

RandomDayGuard does not jump from one event to a ban. It builds a chain.

```text
log line
-> identity mapping
-> session event
-> live-defense counters
-> baseline/world context if available
-> review score
-> enforcement gates
-> Admin.ini write only if enabled
```

### Normal session

```text
Player logs in.
Player enters.
Player leaves cleanly.
```

Result:

```text
Evidence stored.
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

Safety:

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

Safety:

```lua
single_crash_never_bans = true
```

### World actor save touch

```text
Server evidence references UpdateActorToWorldSave and a deployed container class.
```

Result:

```text
Stored as world context.
Useful when correlated with sessions, crashes, warnings, or baseline deltas.
Not direct proof by itself.
```

---

## The First Baseline Scan

The first scan builds the world/object context used for better review.

It reads:

```text
Saved/SaveGames/Server/Worlds/**/*.sav
Saved/SaveGames/Server/Worlds/**/PlayerData/*.sav
Saved/SaveGames/Server/Backups/**
Saved/SaveGames/Server/Admin.ini
Saved/Logs/*.log
```

It looks for visible strings such as:

```text
/Game/...
/Script/...
*_C
Deployed_...
Container_...
Item_...
PowerSocket...
LootSpillBag...
```

The first scan may be slow. That is acceptable when:

```text
polling continues
live defense continues
scan_progress.json updates
scan_checkpoint.json updates
partial world_state_latest.json appears
```

---

## Checkpoint And Resume

A crash during scan should not waste the work already done.

Example:

```text
Before crash:
files_done = 141
total_files = 1767

After restart:
resume near file 141 or reuse cached file entries
```

If a checkpoint is stale because the world changed, the old partial evidence should be preserved and a new baseline generation should start.

---

## Changed-File Refresh

After a completed baseline exists, the guard should avoid reading every file again.

A file is rescanned when:

- it is new
- it was removed
- size changed
- modified time changed
- quick fingerprint changed

A file can be reused when:

```text
size unchanged
mtime unchanged where available
fingerprint unchanged
```

Result:

```text
First scan builds the expensive baseline.
Later scans focus on changed files.
```

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

Correct setup:

```text
SavedRoot.txt -> AbioticFactor/Saved
```

Do not set:

```text
SavedRoot.txt -> Saved/SaveGames/Server/Worlds/<WorldName>
```

The guard discovers world folders under the Saved root.

---

## World Folder Changes

### Same world, renamed folder

Expected behavior:

```text
reuse cached evidence where fingerprints match
rescan files whose paths no longer match
preserve previous evidence
```

### Restored backup or different world

Expected behavior:

```text
preserve old completed baseline
start a new baseline generation
replace final baseline only after the new scan completes
```

### Partial scan existed before the change

Expected behavior:

```text
mark the old checkpoint stale
preserve partial evidence
start a new baseline for the new world
```

### Completed baseline existed before the change

Expected behavior:

```text
load the old baseline for visibility
mark it as previous-world context
build the new baseline safely
```

---

## Ban ID Mapping

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

Never write:

```ini
BannedPlayer=ExamplePlayer
BannedPlayer=2535422284688820_+_|0002d07b...
```

Use only the clean numeric prefix.

---

## Enforcement Path

Admin.ini writing requires all gates to pass.

```text
auto_ban == true
write_admin_ini == true
review_only_mode == false
ban_id is clean numeric
account identity is mapped
threshold is met
account is not trusted
account is not a moderator
account-specific evidence exists
```

When enforcement writes to `Admin.ini`, it writes only:

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

If a fact is direct, the output should record the source.

If a fact is indirect, the output should store it as context.

Context can support review. Context is not the same as direct proof.

Examples:

| Evidence | How to treat it |
|---|---|
| Login request with `ConnectID` | Strong identity source. |
| Join line matched to recent login | Good session mapping. |
| PlayerData file only | Confirms an ID exists; may not prove display name. |
| World actor save touch | World context. Not direct player action by itself. |
| One crash overlap | Context. Not enough by itself. |
| Repeated same-account crash return | Stronger review signal. |

---

## First-Run Checklist

- [ ] Server stopped before install.
- [ ] ZIP extracted into `ue4ss/Mods/RandomDayGuard`.
- [ ] `mods.txt` contains `RandomDayGuard : 1`.
- [ ] `SavedRoot.txt` points to `Saved/` or is blank for auto-detection.
- [ ] `review_only_mode=true`.
- [ ] `auto_ban=false`.
- [ ] `write_admin_ini=false`.
- [ ] Trusted IDs are configured before enforcement testing.
- [ ] `runtime/runtime_version.json` exists.
- [ ] `runtime/current/poll_status.json` shows `scheduler_status="running"`.
- [ ] `poll_id` increases.
- [ ] `poll_in_flight` returns to `false`.
- [ ] `runtime/current/live_defense_state.json` exists.
- [ ] `runtime/scan_progress.json` appears after scan starts.
- [ ] `runtime/world_state/current/world_state_latest.json` appears.
- [ ] Enforcement remains disabled until reports are verified.

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
