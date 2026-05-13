# Bad Actor Patterns, Crash Resilience, and Recovery Strategy

This document explains how RandomDayGuard helps administrators review server-crash abuse, reconnect patterns, exploit-adjacent behavior, suspicious world-state context, and recovery planning.

It is not a promise that every exploit or crash source can be detected. RandomDayGuard is a server-evidence tool. It works from logs, Saved files, Admin.ini, PlayerData, backups, session timelines, and scan baselines.

---

## What This Document Is For

Use this guide when you want to answer:

```text
Who was active before the server crashed?
Did the same account reconnect right after the restart?
Is this a one-off instability event or a repeated pattern?
Are several accounts rotating around the same crash or warning window?
Did suspicious activity overlap world-save context?
Are there out-of-bounds or unusual map/context traces in readable evidence?
Do we have enough evidence for review, ban recommendation, or backup restore?
```

RandomDayGuard is useful because it combines two layers:

| Layer | What it gives you |
|---|---|
| Live defense | Immediate session, crash, reconnect, and churn evidence from logs. |
| Baseline/world assessment | Slower but deeper object, class, map, PlayerData, backup, and changed-file context. |

Live defense should work from minute one. The baseline improves precision after enough files are scanned.

---

## Important Evidence Rule

RandomDayGuard does not need to access process memory, client memory, or cheat-client internals.

It works from server-owned evidence:

```text
Saved/Logs/*.log
Saved/SaveGames/Server/Admin.ini
Saved/SaveGames/Server/Worlds/**/*.sav
Saved/SaveGames/Server/Worlds/**/PlayerData/*.sav
Saved/SaveGames/Server/Backups/**
runtime/*.json / *.jsonl / *.tsv
```

This is deliberate.

A memory-based cheat or client-side tool can affect the client or gameplay attempt, but RandomDayGuard is watching what the dedicated server persisted: log lines, session timing, crashes, server epochs, save references, PlayerData traces, object/class tokens, and file changes.

That does not make the guard magic. It means its evidence is grounded in server artifacts rather than client claims.

---

## What Types of Bad Actors It Helps Review

### 1. Crash-correlated returners

Pattern:

```text
Account joins.
Server crashes, restarts, or enters an unknown gap.
Same account reconnects quickly after restart.
Pattern repeats across epochs.
```

Useful files:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/lifecycle_events.jsonl
runtime/evidence/session_events.jsonl
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/current/poll_status.json
```

Useful counters / concepts:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
crash_abuse_score
epoch_id
session_id
```

Interpretation:

```text
One crash is context.
Repeated same-account crash overlap is stronger.
Repeated same-account crash overlap plus immediate reconnect is stronger still.
```

Default safety:

```lua
single_crash_never_bans = true
require_account_specific_evidence = true
```

### 2. Rapid reconnect probers

Pattern:

```text
join -> leave -> join -> leave -> join
```

or:

```text
join -> timeout -> reconnect -> timeout -> reconnect
```

Useful files:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/warning_events.jsonl
runtime/warnings/warning_<period>.txt
```

Useful counters:

```text
join_count
leave_count
rapid_rejoin_count
session_churn_score
clean_leave_count
unclean_disconnect_count
```

Interpretation:

```text
Churn can show probing, instability, connection trouble, or deliberate stress.
Churn alone should not ban by default.
Repeated churn plus warning/crash correlation becomes stronger review evidence.
```

Default safety:

```lua
churn_alone_never_bans = true
```

### 3. Multi-account crash or raid clusters

Pattern:

```text
Several accounts join in the same window.
Warnings or failures occur.
Some accounts leave.
Some reconnect after restart.
The same group or central account appears in repeated windows.
```

Useful files:

```text
runtime/raid_cases/index.jsonl
runtime/raid_cases/RAID-*.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/account_evidence.json
runtime/warnings/warning_<period>.txt
```

Useful concepts:

```text
join_wave_window_minutes
join_wave_min_accounts
link_by_same_warning_burst
link_by_same_failure_window
link_by_rejoin_after_failure
central_account_review_score
central_account_auto_ban_score
```

Interpretation:

```text
A raid case groups related accounts.
It does not mean every account in the case is guilty.
Each enforced account still needs account-specific evidence.
```

Default safety:

```lua
ban_all_accounts_in_case = false
require_account_specific_evidence = true
```

### 4. Warning-burst stressors

Pattern:

```text
ActorChannelFailure bursts
ServerMove timestamp warnings
DeployableSaveWarning bursts
UpdateActorToWorldSave bursts
```

Useful files:

```text
runtime/warning_events.jsonl
runtime/evidence/medium_events.jsonl
runtime/evidence/high_events.jsonl
runtime/evidence/critical_events.jsonl
runtime/warnings/warning_<period>.txt
runtime/account_evidence.json
```

Useful config areas:

```lua
warning_bursts.actor_channel_failure
warning_bursts.deployable_save_warning
warning_bursts.update_actor_to_worldsave
crash_correlation
join_leave
```

Interpretation:

```text
A warning burst is not automatically proof of abuse.
A repeated warning burst tied to the same mapped account/session is stronger.
A warning burst plus crash/reconnect repetition is stronger still.
```

Default safety:

```lua
ban_from_single_warning_burst = false
```

### 5. Out-of-bounds or protected-area context

Pattern:

```text
Readable PlayerData, map paths, save strings, or world-state evidence reference unusual map/area context.
The same account/session overlaps that context.
The behavior also overlaps crash/reconnect/warning patterns.
```

Useful files:

```text
runtime/playerdata_index.json
runtime/account_evidence.json
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/file_manifest.tsv
```

Useful evidence:

```text
map paths
PlayerData file presence
readable position/string traces if exposed
world_state_join.json
world_state_latest.json
world_state_leave.json
world_state_diff.json
```

Interpretation:

```text
Readable world/save context can support review.
It should be labeled as context unless the server evidence directly proves location, action, or interaction.
```

Important distinction:

```text
PlayerData or map context can support access-control decisions.
It does not automatically prove how the player got there.
```

### 6. Save-touch overlap accounts

Pattern:

```text
A mapped session is active.
Server evidence references world-save activity or deployed classes.
The same account also has churn, warning, crash, or baseline-delta context.
```

Useful files:

```text
runtime/current/actor_touch_rollup.json
runtime/evidence/session_events.jsonl
runtime/warning_events.jsonl
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
runtime/object_registry_partial.json
runtime/object_registry.json
```

Interpretation:

```text
World actor save touch is context.
It can help decide where to look.
It is not direct proof of opening, stealing, duplicating, or damaging.
```

### 7. Identity/name confusion patterns

Pattern:

```text
Display names change.
Presence lines appear before identity lines.
Names contain separators or log prefixes.
A join event is parsed in the same poll batch as its login identity.
```

Useful files:

```text
runtime/evidence/session_events.jsonl
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/playerdata_index.json
runtime/logs/current.jsonl
```

Useful identity fields:

```text
log_name
name
account_id
ban_id
connect_id_raw
unique_id
identity_source
identity_confidence
playerdata_verified
```

Interpretation:

```text
Display name is not enough for enforcement.
Login request with ConnectID is the strongest mapping source.
PlayerData can confirm an ID exists but may not prove display name by itself.
```

---

## How To Count What Was Detected

Do not publish invented numbers. Count from runtime evidence.

### Count enforced bans

Linux / SSH:

```sh
test -f runtime/enforced_bans.jsonl && wc -l runtime/enforced_bans.jsonl
```

PowerShell:

```powershell
if (Test-Path runtime/enforced_bans.jsonl) {
    (Get-Content runtime/enforced_bans.jsonl).Count
}
```

### Count unique accounts seen

PowerShell:

```powershell
Select-String -Path runtime/account_evidence.tsv -Pattern "^[0-9]" | Measure-Object
```

Linux:

```sh
awk 'NR>1 && $1 != "" {print $1}' runtime/account_evidence.tsv | sort -u | wc -l
```

### Count review or ban-eligible accounts

PowerShell:

```powershell
Select-String -Path runtime/account_evidence.tsv -Pattern "REVIEW|BAN-ELIGIBLE|AUTO-BANNED" | Measure-Object
```

Linux:

```sh
grep -E "REVIEW|BAN-ELIGIBLE|AUTO-BANNED" runtime/account_evidence.tsv | wc -l
```

### Count crash/reconnect events

PowerShell:

```powershell
if (Test-Path runtime/evidence/crash_reconnect_events.jsonl) {
    (Get-Content runtime/evidence/crash_reconnect_events.jsonl).Count
}
```

Linux:

```sh
test -f runtime/evidence/crash_reconnect_events.jsonl && wc -l runtime/evidence/crash_reconnect_events.jsonl
```

### Count raid cases

PowerShell:

```powershell
Get-ChildItem runtime/raid_cases -Filter "RAID-*.json" -ErrorAction SilentlyContinue | Measure-Object
```

Linux:

```sh
find runtime/raid_cases -name "RAID-*.json" 2>/dev/null | wc -l
```

---

## Operator Case Summary Template

Use this when reporting what the guard helped detect.

```text
Review window:
  <start time> to <end time>

Accounts seen:
  <count from account_evidence.tsv>

Accounts moved to REVIEW:
  <count from account_evidence.tsv>

Accounts BAN-ELIGIBLE:
  <count from account_evidence.tsv>

Bans actually written:
  <count from enforced_bans.jsonl>

Crash/reconnect events:
  <count from crash_reconnect_events.jsonl>

Raid cases:
  <count from runtime/raid_cases/RAID-*.json>

World baseline:
  partial / complete

Baseline files scanned:
  <files_done>/<total_files>

Useful context found:
  <object registry / world-state / PlayerData / warning burst / lifecycle notes>

Evidence limitations:
  <what was context only and what was direct>
```

This keeps public reports grounded in files, not memory, guesses, or display-name-only claims.

---

## Why Avoiding Memory Access Helps

RandomDayGuard avoids direct process memory access by design.

Advantages:

```text
Less fragile across game updates.
Less likely to crash the server process.
Less likely to be influenced by client-side memory tooling directly.
Evidence is based on what the server persisted.
Works as an admin review layer instead of a client anti-cheat.
Can be restored with backups if runtime files or baselines are damaged.
```

Tradeoffs:

```text
It cannot see everything live.
It cannot prove hidden actions unless the server writes them.
It may see context later through logs, saves, PlayerData, backups, or changed files.
```

Practical meaning:

```text
Use RandomDayGuard as a server evidence and recovery system.
Do not market it as a memory anti-cheat.
```

---

## Sticky Backup Recommendation

A “sticky backup” is a known-good backup taken after the server is installed, configured, and baseline-scanned.

Use it as a recovery anchor.

### When to create it

Create a sticky backup after:

```text
RandomDayGuard is installed.
SavedRoot.txt is correct.
mods.txt enables RandomDayGuard.
review_only_mode is confirmed.
trusted IDs are configured.
first full baseline scan completed.
world_state_latest.json shows scan_complete=true.
object_registry.json exists.
file_manifest.tsv exists.
server is stable.
```

### What to include

Backup these:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/BUILD_MARKER.txt
RandomDayGuard/MANIFEST.json
RandomDayGuard/Scripts/main.lua
RandomDayGuard/scripts/main.lua
RandomDayGuard/data/
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/object_registry_counts.tsv
RandomDayGuard/runtime/world_state/current/world_state_latest.json
RandomDayGuard/runtime/scan_complete.json
RandomDayGuard/runtime/admin_state.json
AbioticFactor/Saved/SaveGames/Server/Admin.ini
```

Optional but useful:

```text
RandomDayGuard/runtime/account_evidence.json
RandomDayGuard/runtime/account_evidence.tsv
RandomDayGuard/runtime/playerdata_index.json
RandomDayGuard/runtime/log_registry.json
RandomDayGuard/runtime/server_epochs.jsonl
```

### What not to rely on as the only backup

Do not rely only on:

```text
the browser file manager view
one open browser tab
a runtime folder copied during a running scan
a partial scan with no checkpoint
an Admin.ini edited while the server is running without verification
```

### Recommended sticky backup naming

```text
sticky_baseline_<server_label>_<world_label>_<version>_<date>.zip
```

Example with placeholders:

```text
sticky_baseline_server01_world01_v0.4.11-alpha_2026-05-13.zip
```

### Restore strategy

If a crash/exploit window corrupts runtime evidence or world state:

```text
1. Stop the server.
2. Copy current runtime/evidence out for investigation if still readable.
3. Restore the sticky backup.
4. Restore or verify Admin.ini.
5. Start the server.
6. Confirm poll_status.json is healthy.
7. Confirm world_state_latest.json loads.
8. Let changed-file refresh run.
```

Do not overwrite an old completed baseline with a new partial baseline until the replacement scan finishes.

---

## Baseline + Backup Operating Model

Recommended model:

```text
Clean install
-> verify live defense
-> complete first baseline
-> create sticky backup
-> run server normally
-> use changed-file refresh
-> preserve evidence when incidents happen
-> restore sticky backup if needed
```

This model makes crash/restart abuse less damaging because attackers cannot easily force the guard to lose all progress if checkpoints and sticky backups exist.

---

## What RandomDayGuard Can Help Prove vs Support

| Evidence question | Stronger support when... |
|---|---|
| Was the account present? | Login request, join/leave, session evidence. |
| Did the account overlap a crash? | Session open near crash epoch or no clean leave. |
| Did the account return after crash? | Same account joins inside post-crash window. |
| Is this repeated? | Counts repeat across epochs or sessions. |
| Was there warning context? | Warning bursts overlap mapped session windows. |
| Was there world/save context? | Object registry, world_state, PlayerData, or save-touch evidence overlaps session. |
| Was there a cluster? | Multiple accounts linked by same warning/failure window. |
| Is there enough for Admin.ini? | Clean ban ID, threshold met, not trusted/moderator, account-specific evidence, enforcement enabled. |

---

## Suggested Related Config

```lua
crash_correlation = {
    enabled = true,
    single_crash_never_bans = true,
    active_before_failure_minutes = 5,
    repeated_failure_review_count = 2,
    repeated_failure_ban_count = 3,
    require_same_account = true,
    require_non_whitelist = true,
}

join_leave = {
    enabled = true,
    churn_alone_never_bans = true,
    rolling_history_days = 7,
    join_wave_window_minutes = 10,
    join_wave_min_accounts = 3,
}

raid_detection = {
    enabled = true,
    create_case_min_accounts = 2,
    critical_case_min_accounts = 3,
    ban_all_accounts_in_case = false,
    require_account_specific_evidence = true,
}

scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
}
```

---

## Short Summary

RandomDayGuard helps with bad-actor review by preserving server-side facts:

```text
who joined
who left
who did not leave cleanly
who overlapped crashes
who returned after crashes
which accounts cluster together
which warnings happened during sessions
what world/save context existed
what changed between baselines
what was actually enforced
```

It avoids memory access and client-side claims. It stays useful by combining:

```text
live defense
checkpointed scans
completed baselines
changed-file refresh
evidence logs
sticky backups
```

This does not guarantee every exploit will be caught. It gives administrators a stronger, recoverable evidence workflow when crashes, reconnect patterns, suspicious clusters, and world-state anomalies need to be reviewed.
