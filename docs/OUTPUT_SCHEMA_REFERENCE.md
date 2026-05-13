# Output Schema Reference

This document explains the most important RandomDayGuard runtime files and fields.

Field availability may vary by version and by what evidence the server exposes.

---

## `runtime/current/poll_status.json`

Purpose:

```text
Shows whether the watchdog loop is alive and what phase it is in.
```

Important fields:

| Field | Meaning |
|---|---|
| `version` | Loaded RandomDayGuard version. |
| `boot_id` | Current boot identifier. |
| `epoch_id` | Current server epoch identifier. |
| `scheduler_status` | Should be `running` when the loop is active. |
| `poll_id` | Increases every completed poll. |
| `poll_in_flight` | Should return to `false` between polls. |
| `poll_scheduled` | Should be `true` between polls. |
| `active_log_caught_up` | Whether the active log tail has no unread backlog. |
| `active_log_unread_bytes` | Unread bytes remaining in the active log. |
| `log_backlog_pending` | Whether startup scan should wait for log backlog. |
| `scan_job_active` | Whether a scan job is currently running. |
| `scan_phase` | Current scan phase, such as discovery or scanning. |
| `scan_files_done` | Number of files processed by the scan. |
| `scan_total_files` | Total files currently known to the scan. |

Healthy example:

```json
{
  "scheduler_status": "running",
  "poll_id": 25,
  "poll_in_flight": false,
  "poll_scheduled": true,
  "active_log_caught_up": true,
  "active_log_unread_bytes": 0,
  "log_backlog_pending": false
}
```

Problem signs:

| Symptom | Meaning |
|---|---|
| `poll_id` does not increase | Poll loop may be blocked. |
| `poll_in_flight` stays `true` | A callback may not have returned. |
| `log_backlog_pending=true` with unread bytes 0 | Backlog gate bug or stale state. |
| `scan_job_active=false` forever | Scan gate did not open or scan disabled. |

---

## `runtime/runtime_version.json`

Purpose:

```text
Confirms what version loaded on the server.
```

Important fields:

| Field | Meaning |
|---|---|
| `version` | Expected `v0.4.11-alpha`. |
| `boot_id` | Runtime boot identity. |
| `loaded_at` or `ts` | When the mod wrote the file. |

Use it to verify the server actually loaded the new build after replacing files.

---

## `runtime/account_evidence.json`

Purpose:

```text
Current account/player profile summary.
```

Important fields:

| Field | Meaning |
|---|---|
| `account_id` | Clean mapped account ID used internally. |
| `ban_id` | Clean numeric ID used for Admin.ini when enforcement is enabled. |
| `name` / `log_name` | Name observed in readable server evidence. |
| `connect_id_raw` | Raw ConnectID before suffix cleanup. |
| `unique_id` | Platform/network identity string if visible. |
| `identity_source` | Source used for mapping, such as Login request. |
| `identity_confidence` | Confidence in the mapping. |
| `playerdata_verified` | Whether matching `Player_<ID>.sav` was found. |
| `playerdata_file` | Matching PlayerData path if found. |
| `first_seen` | First time account was seen by the guard. |
| `last_seen` | Last time account was seen by the guard. |
| `join_count` | Number of joined sessions recorded. |
| `leave_count` | Number of clean/observed leaves recorded. |
| `status` | Review status, such as INFO or REVIEW. |
| `score` | Current review/enforcement score if implemented. |

Use this file first when reviewing one player.

---

## `runtime/account_evidence.tsv`

Purpose:

```text
Spreadsheet-friendly account profile table.
```

Use it for:

```text
quick filtering
counting REVIEW accounts
comparing account IDs
exporting to a spreadsheet
```

Common columns should mirror `account_evidence.json`.

---

## `runtime/evidence/session_events.jsonl`

Purpose:

```text
Structured session timeline.
```

JSONL means one JSON object per line.

Common event types:

```text
PLAYER_LOGIN_IDENTITY
PLAYER_JOIN_STATE
PLAYER_LEAVE_STATE
SESSION_JOIN
SESSION_LEAVE
SESSION_LIFECYCLE_CLOSE
```

Common fields:

| Field | Meaning |
|---|---|
| `ts` | Event timestamp. |
| `type` | Event type. |
| `account_id` | Mapped account ID or unmapped placeholder. |
| `ban_id` | Clean ban ID if known. |
| `name` | Display/log name. |
| `session_id` | Session identifier. |
| `epoch_id` | Server epoch. |
| `leave_reason` | Why a session ended, if applicable. |
| `clean_leave` | Whether leave was clean. |

Use this for timeline reconstruction.

---

## `runtime/session_events.tsv`

Purpose:

```text
Human-readable session timeline.
```

Use it for quick review with grep, Excel, LibreOffice, or Google Sheets.

Expected rows may include:

```text
JOIN
LEAVE
LIFECYCLE_CLOSE
```

---

## `runtime/scan_progress.json`

Purpose:

```text
Shows current baseline scan progress.
```

Important fields:

| Field | Meaning |
|---|---|
| `scan_generation_id` | Current scan generation. |
| `active` | Whether scan job is active. |
| `complete` | Whether scan is complete. |
| `phase` | Current phase. |
| `files_done` | Files completed. |
| `total_files` | Total files known. |
| `entries_seen` | Tokens/entries extracted. |
| `readable_files_seen` | Files readable during discovery/scan. |
| `current_file` | File currently being processed. |
| `budget_exhausted` | Whether the scan paused due to per-tick budget. |

Common phases:

```text
discover_direct_known
discover_recursive
scanning
complete
failed
```

---

## `runtime/scan_checkpoint.json`

Purpose:

```text
Resume point for interrupted scans.
```

Important fields:

| Field | Meaning |
|---|---|
| `scan_generation_id` | Scan generation to resume. |
| `phase` | Phase to continue. |
| `file_index` | Where to resume in the manifest. |
| `files_done` | Completed file count. |
| `total_files` | Known total file count. |
| `manifest_path` | File list used by the scan. |
| `counts_path` | Sidecar counts file if used. |
| `map_paths_path` | Sidecar map paths file if used. |
| `complete` | Should be false during an incomplete scan. |

Use this after crashes/restarts to verify the scan did not restart from zero.

---

## `runtime/world_state/current/world_state_latest.json`

Purpose:

```text
Latest world-state summary.
```

Important fields:

| Field | Meaning |
|---|---|
| `scan_complete` | Whether world state comes from completed baseline. |
| `generated_from_partial_scan` | Whether output is partial. |
| `files_done` | Files scanned when this was written. |
| `total_files` | Files expected. |
| `entries_seen` | Extracted entries/tokens. |
| `object_registry_summary` | High-level object registry summary. |
| `active_sessions_summary` | Current session context if included. |
| `scan_generation_id` | Scan generation used. |

Partial example:

```json
{
  "scan_complete": false,
  "generated_from_partial_scan": true,
  "files_done": 141,
  "total_files": 1767
}
```

Complete example:

```json
{
  "scan_complete": true,
  "baseline_loaded": true
}
```

---

## `runtime/object_registry_partial.json`

Purpose:

```text
Object/class registry built so far during an incomplete scan.
```

Use it when:

```text
full scan is still running
admin needs partial world context
scan_complete.json does not exist yet
```

---

## `runtime/object_registry.json`

Purpose:

```text
Final object/class registry after completed baseline scan.
```

It may include tokens such as:

```text
/Game/...
/Script/...
*_C
Deployed_...
Container_...
PowerSocket...
LootSpillBag...
```

The object registry is context. It is not a ban reason by itself.

---

## `runtime/object_registry_counts.tsv`

Purpose:

```text
Spreadsheet-friendly object/class token counts.
```

Use it to compare class counts across runs or identify new categories.

---

## `runtime/baselines/file_manifest.tsv`

Purpose:

```text
Tracks files included in the completed baseline and supports changed-file refresh.
```

Important columns:

| Column | Meaning |
|---|---|
| `path` | Full or relative path. |
| `relpath` | Path relative to Saved root. |
| `size` | File size. |
| `mtime_or_unknown` | Modified time if available. |
| `fingerprint` | Quick fingerprint. |
| `scan_priority` | Scan bucket. |
| `file_type` | World save, PlayerData, log, backup, etc. |
| `entries_cache_path` | Per-file cached entries. |
| `included_in_registry` | Whether file contributed to registry. |
| `entries_found` | Number of tokens found. |
| `error` | Read/scan error if any. |

---

## `runtime/baselines/last_completed_baseline.json`

Purpose:

```text
Summary of the last completed full baseline.
```

Important fields:

| Field | Meaning |
|---|---|
| `scan_generation_id` | Completed scan ID. |
| `completed_ts` | Completion time. |
| `saved_root` | Saved root used. |
| `total_files` | Files discovered. |
| `scanned_files` | Files scanned. |
| `entries_seen` | Entries/tokens extracted. |
| `object_registry_path` | Final registry path. |
| `world_state_latest_path` | World state path. |
| `file_manifest_path` | Manifest path. |

Use this to verify later boots can load the previous baseline.

---

## `runtime/warning_events.jsonl`

Purpose:

```text
Structured warning/failure/anomaly events.
```

Common event classes:

```text
DeployableSaveWarning
ActorChannelFailure
UpdateActorToWorldSave
ServerMove timestamp warnings
high-risk class references
map/path references
```

A warning event is context unless correlated with account/session evidence and thresholds.

---

## `runtime/warnings/warning_<period>.txt`

Purpose:

```text
Admin-readable warning report.
```

Should group information by:

```text
player
session
warning/failure window
decision status
world-state paths
evidence explanation
```

Use this for manual review.

---

## `runtime/raid_cases/index.jsonl` and `runtime/raid_cases/RAID-*.json`

Purpose:

```text
Multi-account case grouping.
```

A raid case may link accounts by:

```text
same join wave
same warning burst
same failure window
same post-crash reconnect window
account rotation pattern
```

Important rule:

```text
A raid case does not automatically make every account guilty.
```

Each enforced account still needs account-specific evidence.

---

## `runtime/enforced_bans.jsonl`

Purpose:

```text
Audit trail for bans written by RandomDayGuard.
```

Common fields:

| Field | Meaning |
|---|---|
| `ts` | Enforcement time. |
| `account_id` | Account ID. |
| `ban_id` | Clean Admin.ini ID. |
| `reason` | Reason summary. |
| `confidence` | Confidence or decision level. |
| `admin_ini_written` | Whether write succeeded. |

---

## `runtime/enforced.txt`

Purpose:

```text
Human-readable enforcement summary.
```

Use with `enforced_bans.jsonl`.

---

## `runtime/ban_queue.json`

Purpose:

```text
Pending bans that should survive interruption.
```

Used only when enforcement is enabled.

---

## `runtime/request_restart.flag` and `runtime/restart_reason.json`

Purpose:

```text
AMP restart marker files.
```

RandomDayGuard should not kill the server process. It can write marker files for an external AMP/operator workflow.

---

## Status Values

Common status meanings:

| Status | Meaning |
|---|---|
| `INFO` | Normal evidence, no review threshold. |
| `WATCH` | Worth watching, below review threshold. |
| `REVIEW` | Admin should inspect evidence. |
| `BAN-ELIGIBLE` | Thresholds met, but enforcement gates may still block writing. |
| `AUTO-BANNED` | Enforcement was enabled and a ban was written. |

---

## Identity Confidence Values

Common examples:

| Confidence | Meaning |
|---|---|
| `direct_login_request` | Strong login identity source. |
| `mapped_presence_after_login` | Join/leave resolved through recent login. |
| `mapped_known_name` | Name mapped from known identity cache. |
| `playerdata_only` | ID exists in PlayerData, display name may be unknown. |
| `unmapped_presence_only` | Display name or presence without usable account ID. |

Only clean mapped IDs should be eligible for Admin.ini writing by default.
