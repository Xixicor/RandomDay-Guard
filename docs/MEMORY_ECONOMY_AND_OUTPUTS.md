# Memory Economy and Output Files

This guide explains **where RandomDayGuard writes information**, **which files grow**, **which files are overwritten**, and **where player profiles are summarized when something changes**.

It is written for server operators who need to know what to open first after a run, a crash, a long scan, or a suspected abuse pattern.

---

## Fast Answer

If you only need the important files, start here.

| Question | Open this file |
|---|---|
| Is the watchdog alive? | `runtime/current/poll_status.json` |
| What version actually loaded? | `runtime/runtime_version.json` |
| Which accounts/sessions are active now? | `runtime/current/session_state.json` and `runtime/current/active_accounts.json` |
| What changed for player profiles? | `runtime/account_evidence.json` and `runtime/account_evidence.tsv` |
| What is the player/session event history? | `runtime/evidence/session_events.jsonl` and `runtime/session_events.tsv` |
| What lifecycle/crash/restart context exists? | `runtime/server_lifecycle_events.jsonl`, `runtime/server_epochs.jsonl`, and `runtime/evidence/lifecycle_events.jsonl` |
| What is the scan doing right now? | `runtime/scan_progress.json` |
| Can the scan resume after restart? | `runtime/scan_checkpoint.json` |
| What world/object data exists so far? | `runtime/object_registry_partial.json` and `runtime/world_state/current/world_state_latest.json` |
| What is the completed world/object baseline? | `runtime/object_registry.json`, `runtime/object_registry_counts.tsv`, and `runtime/baselines/last_completed_baseline.json` |
| What files were included in the completed baseline? | `runtime/baselines/file_manifest.tsv` |
| What enforcement happened? | `runtime/enforced_bans.jsonl`, `runtime/enforced.txt`, and `runtime/evidence/enforced_bans.jsonl` |

The main **player profile summary** files are:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

The main **event trail** files are:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/raw_events.jsonl
runtime/warning_events.jsonl
```

---

## What “Memory Economy” Means Here

RandomDayGuard has to run on real servers without filling disk or rebuilding everything after every restart.

It uses four kinds of output.

| Output type | Behavior | Why it exists |
|---|---|---|
| Current snapshots | Overwritten repeatedly | Gives the latest state without creating endless files. |
| Append-only evidence | Adds one line per event | Preserves event history for review. |
| Rollups and summaries | Rewritten or rotated | Gives readable admin summaries without raw-event bloat. |
| Baseline and manifest files | Written after scan progress or completion | Lets the guard resume scans and avoid rescanning unchanged files. |

This is the core economy:

```text
Current files answer “what is true now.”
Evidence logs answer “what happened over time.”
Baselines answer “what did the world look like when scanned.”
Manifests answer “what files changed since the last baseline.”
```

---

## Output Categories

### 1. Current snapshot files

These files are normally **overwritten**. They should stay small.

```text
runtime/current/poll_status.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/current/spatial_context.json
runtime/current/actor_touch_rollup.json
runtime/poll_status.json
runtime/startup_status.json
runtime/runtime_version.json
runtime/runtime_capabilities.json
runtime/admin_state.json
runtime/playerdata_index.json
runtime/log_registry.json
runtime/current_server_epoch.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
runtime/object_registry_partial.json
```

Use these for dashboards, quick checks, and “what is happening now?”

### 2. Append-only event files

These files normally **grow** because they preserve history.

```text
runtime/logs/current.jsonl
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/raw_events.jsonl
runtime/warning_events.jsonl
runtime/log_continuity_events.jsonl
runtime/evidence/log_continuity_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/evidence/lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/critical_events.jsonl
runtime/evidence/high_events.jsonl
runtime/evidence/medium_events.jsonl
runtime/enforced_bans.jsonl
runtime/evidence/enforced_bans.jsonl
runtime/new_classes_detected.jsonl
runtime/class_deltas.jsonl
runtime/raid_cases/index.jsonl
```

Use these when you need a timeline.

### 3. Player/account summary files

These are the main player profile rollups.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

They summarize known accounts with fields such as:

```text
account_id
ban_id
log_name
name
connect_id_raw
raw_id
unique_id
identity_source
identity_confidence
playerdata_verified
playerdata_file
first_seen
last_seen
status
score
```

These files are rewritten as a compact current profile table. They are not one file per player in the current baseline. The event trail remains in `session_events`, `raw_events`, warning files, lifecycle files, and enforcement files.

### 4. Session world-state folders

Each mapped session can have its own technical review folder.

Pattern:

```text
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Typical files:

```text
world_state_join.json
world_state_latest.json
world_state_leave.json
world_state_diff.json
```

Use this when you want the world/context snapshot around one session.

### 5. Baseline and scan files

These track the large world scan.

```text
runtime/scan_started.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/scan_error.txt
runtime/object_registry_partial.json
runtime/object_registry_counts_partial.tsv
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_scan.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

Use these to answer:

```text
Did the scan start?
Is the scan stuck?
How many files were scanned?
Can the scan resume?
Is the world baseline partial or complete?
What files are included in the completed baseline?
```

### 6. Enforcement files

These exist only when enforcement paths are reached.

```text
runtime/ban_queue.json
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/evidence/enforced_bans.jsonl
runtime/evidence/enforcement_failed_<timestamp>.json
runtime/request_restart.flag
runtime/restart_reason.json
```

`Admin.ini` should only receive clean lines:

```ini
BannedPlayer=<ID>
```

Reasons stay in runtime evidence files.

---

## What Updates When a Player Changes State?

### Player joins

Expected updates:

```text
runtime/session_events.tsv
runtime/evidence/session_events.jsonl
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/world_state/sessions/<date>/<session_id>_<account_id>/world_state_join.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/world_state_latest.json
```

What the files say:

| File | Meaning |
|---|---|
| `session_events.tsv` | Human-readable session row with JOIN/LEAVE. |
| `evidence/session_events.jsonl` | Structured event record for tools. |
| `current/session_state.json` | Current active session list. |
| `current/active_accounts.json` | Current active accounts only. |
| `account_evidence.json` | Updated account profile summary. |
| `world_state_join.json` | Session-start context. |

Example `session_events.tsv` row:

```text
2026-05-13T01:10:22Z    JOIN    S-20260513_011022-0001    123456789    123456789    ExamplePlayer    ExamplePlayer    mapped_presence_after_login
```

Example `session_events.jsonl` line:

```json
{"ts":"2026-05-13T01:10:22Z","type":"SESSION_JOIN","importance":"medium","session_id":"S-20260513_011022-0001","account_id":"123456789","epoch_id":"E-20260513_010000"}
```

### Player leaves cleanly

Expected updates:

```text
runtime/session_events.tsv
runtime/evidence/session_events.jsonl
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/world_state/sessions/<date>/<session_id>_<account_id>/world_state_leave.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/world_state_diff.json
```

What changes:

```text
leave_count increases
clean_leave_count increases
active session closes
current active account disappears
account last_seen updates
```

Example event:

```json
{"ts":"2026-05-13T01:15:40Z","type":"SESSION_LEAVE","importance":"medium","session_id":"S-20260513_011022-0001","account_id":"123456789","epoch_id":"E-20260513_010000","leave_reason":"normal_leave"}
```

### Player disconnects without clean leave

Expected updates:

```text
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/evidence/lifecycle_events.jsonl
runtime/current/session_state.json
runtime/account_evidence.json
runtime/account_evidence.tsv
```

What changes:

```text
unclean disconnect context may increase
session may be closed by lifecycle handler
account status may move toward REVIEW if repeated
```

### Player repeats rapid join/leave

Expected updates:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/warning_events.jsonl
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/warnings/warning_<period>.txt
```

What changes:

```text
rapid_rejoin_count or churn score increases
status may become REVIEW
churn alone should not auto-ban by default
```

### Server crashes or restarts while a player is active

Expected updates:

```text
runtime/server_lifecycle_events.jsonl
runtime/evidence/lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/current_server_epoch.json
runtime/evidence/session_events.jsonl
runtime/account_evidence.json
runtime/account_evidence.tsv
```

What changes:

```text
current epoch closes
new epoch opens
open sessions may close as crash/restart context
active-before-failure evidence may be recorded
post-crash reconnects can be correlated if the same account returns quickly
```

---

## What Updates During the Scan?

### Scan starts

Expected files:

```text
runtime/scan_started.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
```

`scan_progress.json` should show:

```json
{
  "active": true,
  "phase": "discover_recursive",
  "files_done": 0,
  "total_files": 0,
  "scan_generation_id": "20260513_011000"
}
```

### Scan is running

Expected files:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/object_registry_counts_partial.tsv
runtime/world_state/current/world_state_latest.json
```

Partial world-state example:

```json
{
  "scan_complete": false,
  "scan_phase": "scanning",
  "files_done": 141,
  "total_files": 1767,
  "entries_seen": 2888,
  "generated_from_partial_scan": true
}
```

Meaning:

```text
The scan has useful partial data.
The baseline is not final yet.
Live defense should still be active.
```

### Scan completes

Expected files:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_scan.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Completed world-state should say:

```json
{
  "scan_complete": true,
  "baseline_loaded": true
}
```

---

## Time-Based Examples

### Example A: First 30 seconds after boot

Expected writes:

```text
runtime/loader_probe.txt
runtime/loader_probe.json
runtime/runtime_version.json
runtime/startup_status.json
runtime/saved_path_probe.json
runtime/current/poll_status.json
runtime/log_offsets.tsv
runtime/log_registry.json
runtime/runtime_capabilities.json
```

What to check:

```text
runtime/current/poll_status.json
```

Healthy:

```json
{
  "scheduler_status": "running",
  "poll_scheduled": true,
  "poll_in_flight": false
}
```

If this is healthy, the watchdog loop is alive.

### Example B: First player joins after 2 minutes

Expected writes:

```text
runtime/session_events.tsv
runtime/evidence/session_events.jsonl
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

What to open first:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
```

### Example C: First scan is still running after 10 minutes

Expected writes:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/object_registry_counts_partial.tsv
runtime/world_state/current/world_state_latest.json
```

Example status:

```json
{
  "phase": "scanning",
  "active": true,
  "complete": false,
  "files_done": 141,
  "total_files": 1767,
  "entries_seen": 2888
}
```

Interpretation:

```text
The scan is working.
The registry is partial.
If the server restarts, checkpoint data should prevent starting from zero.
```

### Example D: First scan completes after a long run

Expected writes:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

What to open first:

```text
runtime/scan_complete.json
runtime/baselines/last_completed_baseline.json
runtime/object_registry_counts.tsv
```

### Example E: Next boot after completed baseline

Expected behavior:

```text
load completed baseline
write current world-state quickly
scan only changed/new/removed files where supported
```

Files to check:

```text
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/scan_progress.json
```

### Example F: Enforcement enabled and a ban is written

Expected writes:

```text
runtime/backups/Admin_<timestamp>.ini
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/evidence/enforced_bans.jsonl
runtime/evidence/<timestamp>_<ban_id>_<reason>.json
runtime/request_restart.flag
runtime/restart_reason.json
```

Admin.ini line:

```ini
BannedPlayer=123456789
```

No names. No comments. No suffixes.

---

## How Files Are Marked

### JSON snapshots

Most snapshot files include some of:

```text
ts
version
boot_id
epoch_id
saved_root
scan_generation_id
scan_complete
scan_phase
```

Use these to identify which boot, epoch, or scan produced the file.

### JSONL evidence

JSONL files contain one JSON object per line.

Common fields:

```text
ts
type
importance
account_id
session_id
epoch_id
reason
leave_reason
clean_leave
```

Use these for timeline reconstruction.

### TSV files

TSV files are table-style outputs for quick grep/spreadsheet use.

Common TSV files:

```text
runtime/session_events.tsv
runtime/account_evidence.tsv
runtime/object_registry_counts.tsv
runtime/baselines/file_manifest.tsv
```

Use these for quick filtering and comparison.

---

## What Files Grow and What Files Stay Bounded?

### Usually overwritten

These should remain bounded because they are snapshots:

```text
runtime/current/*.json
runtime/poll_status.json
runtime/startup_status.json
runtime/runtime_version.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/admin_state.json
runtime/playerdata_index.json
runtime/log_registry.json
runtime/current_server_epoch.json
```

### Usually append-only

These grow until retention/rotation handles them:

```text
runtime/logs/current.jsonl
runtime/raw_events.jsonl
runtime/warning_events.jsonl
runtime/session_events.tsv
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/enforced_bans.jsonl
runtime/new_classes_detected.jsonl
runtime/class_deltas.jsonl
```

### Large but useful baseline files

These may be larger, but they replace repeated rescans:

```text
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/file_manifest.tsv
runtime/baselines/last_completed_baseline.json
```

The baseline is the memory economy tradeoff:

```text
Spend time once.
Save enough state to avoid repeating the same full scan.
Use changed-file refresh later.
```

---

## Retention and Bloat Controls

Relevant config areas:

```lua
retention = {
    detailed_retention_days = 7,
    daily_summary_retention_days = 90,
    weekly_summary_retention_weeks = 12,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    max_low_importance_events_per_day = 5000,
    max_actor_touch_rollups_per_day = 10000,
    max_recent_event_keys = 5000,
    max_warning_reports = 30,
    max_raid_cases = 200,
    compact_json_outputs = true,
}
```

Meaning:

| Option | What it controls |
|---|---|
| `detailed_retention_days` | How long detailed runtime files stay active. |
| `rotate_jsonl_when_bytes_exceed` | Size limit before JSONL rotation. |
| `max_raw_events_lines` | Raw event line cap. |
| `max_low_importance_events_per_day` | Prevents low-value spam. |
| `max_actor_touch_rollups_per_day` | Prevents actor-touch bloat. |
| `keep_enforced_forever` | Keeps enforcement audit records. |
| `keep_evidence_forever` | Keeps evidence files unless changed. |

Use low-importance aggregation when world touch events are frequent:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
}
```

This means repeated context events are summarized instead of written as endless raw lines.

---

## Operator Reading Order

When reviewing a run, use this order.

### 1. Check the guard is alive

```text
runtime/current/poll_status.json
```

Look for:

```text
scheduler_status = running
poll_id increasing
poll_in_flight = false between polls
```

### 2. Check player profile summary

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Look for:

```text
account_id
ban_id
identity_confidence
playerdata_verified
status
score
first_seen
last_seen
```

### 3. Check session timeline

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
```

Look for:

```text
SESSION_JOIN
SESSION_LEAVE
SESSION_LIFECYCLE_CLOSE
leave_reason
clean_leave
```

### 4. Check lifecycle context

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/lifecycle_events.jsonl
```

Look for:

```text
restart
shutdown
suspected_crash
unknown_gap
epoch_id
```

### 5. Check scan/world context

```text
runtime/scan_progress.json
runtime/world_state/current/world_state_latest.json
runtime/object_registry_partial.json
runtime/object_registry.json
```

Look for:

```text
scan_complete
files_done
total_files
entries_seen
scan_phase
```

### 6. Check enforcement only if enabled

```text
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/evidence/enforced_bans.jsonl
runtime/ban_queue.json
```

Confirm:

```text
ban_id is numeric
Admin.ini was backed up
trusted/moderator IDs were preserved
reason is in evidence, not Admin.ini
```

---

## Current Baseline Note

In the current v0.4.11-alpha baseline, the primary player profile rollups are:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Some public docs may describe `live_defense_state.json` as the live-defense summary target. If your installed build writes that file, use it as the first live-defense dashboard. If it does not exist in your installed build, use:

```text
runtime/account_evidence.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
```

Those are the current reliable live/session profile files.

---

## Short Summary

RandomDayGuard avoids runtime bloat by separating outputs:

```text
current/*.json = latest state
*.jsonl = event history
*.tsv = spreadsheet-friendly summaries
baselines/* = reusable scan data
world_state/* = session/world context
warnings/* = admin-readable review output
enforced* = audit trail for actual actions
```

When a player changes state, read:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/current/session_state.json
```

When the world scan changes state, read:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

When enforcement changes state, read:

```text
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/evidence/
```
## Forensic Daily Rollups

Forensic rollups keep quick-review files bounded by updating the same current-day files:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

They are rebuildable indexes over source evidence, not replacements for raw JSON/JSONL/TSV evidence.
