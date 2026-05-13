# Output schema reference

Use this page when you need to know what a field means.

## Quick field groups

| File | Main question |
|---|---|
| `poll_status.json` | Is the watchdog alive? |
| `account_evidence.json` | Who is this account? |
| `session_events.jsonl` | What happened in session order? |
| `scan_progress.json` | What is the scan doing? |
| `world_state_latest.json` | Is world context partial or complete? |
| `players.tsv` | Who should be reviewed today? |
| `ban_recommendations.tsv` | Which clean ban lines are candidates? |
| `final_forensic_log.txt` | What happened in plain language? |

## `runtime/current/poll_status.json`

Important fields:

| Field | Meaning |
|---|---|
| `version` | Loaded guard version |
| `boot_id` | Current boot ID |
| `epoch_id` | Current server epoch |
| `scheduler_status` | Should be `running` |
| `poll_id` | Increases as the loop completes |
| `poll_in_flight` | Should return `false` between polls |
| `poll_scheduled` | Should be `true` between polls |
| `active_log_caught_up` | Active log has no unread backlog |
| `active_log_unread_bytes` | Bytes still unread |
| `log_backlog_pending` | Whether scan should wait |
| `scan_job_active` | Whether scan is active |
| `scan_phase` | Current scan phase |

Healthy:

```json
{
  "scheduler_status": "running",
  "poll_scheduled": true,
  "poll_in_flight": false
}
```

## `runtime/account_evidence.json`

Important fields:

| Field | Meaning |
|---|---|
| `account_id` | Clean account ID used by the guard |
| `ban_id` | Clean ID candidate for Admin.ini |
| `name` | Display/log name when known |
| `connect_id_raw` | Raw server identity value |
| `unique_id` | Platform/network identity if visible |
| `identity_source` | Source used for mapping |
| `identity_confidence` | Strength of mapping |
| `playerdata_verified` | Matching PlayerData found |
| `first_seen` | First recorded time |
| `last_seen` | Last recorded time |
| `status` | INFO, WATCH, REVIEW, BAN-ELIGIBLE, AUTO-BANNED |
| `score` | Review/enforcement score if implemented |

## `runtime/evidence/session_events.jsonl`

One JSON object per event.

Common fields:

| Field | Meaning |
|---|---|
| `ts` | Event timestamp |
| `type` | Event type |
| `account_id` | Mapped account or placeholder |
| `ban_id` | Clean ban ID when known |
| `name` | Name in evidence |
| `session_id` | Session identifier |
| `epoch_id` | Server epoch |
| `leave_reason` | Why session ended |
| `clean_leave` | Whether leave was clean |

Common event types:

```text
PLAYER_LOGIN_IDENTITY
PLAYER_JOIN_STATE
PLAYER_LEAVE_STATE
SESSION_JOIN
SESSION_LEAVE
SESSION_LIFECYCLE_CLOSE
```

## `runtime/scan_progress.json`

Important fields:

| Field | Meaning |
|---|---|
| `scan_generation_id` | Current scan generation |
| `active` | Scan running |
| `complete` | Scan complete |
| `phase` | Discovery, scanning, complete, failed |
| `files_done` | Files processed |
| `total_files` | Files known |
| `entries_seen` | Tokens/entries found |
| `current_file` | File currently being processed |
| `budget_exhausted` | Scan paused due to budget |

## `runtime/world_state/current/world_state_latest.json`

Important fields:

| Field | Meaning |
|---|---|
| `scan_complete` | Completed baseline or not |
| `generated_from_partial_scan` | Partial context |
| `files_done` | Files scanned when written |
| `total_files` | Total known files |
| `entries_seen` | Extracted token count |
| `object_registry_summary` | Registry summary |
| `active_sessions_summary` | Active session context |
| `scan_generation_id` | Source scan generation |

Partial:

```json
{
  "scan_complete": false,
  "generated_from_partial_scan": true
}
```

Complete:

```json
{
  "scan_complete": true,
  "baseline_loaded": true
}
```

## Daily rollup files

### `players.tsv`

Use for quick daily account review.

Key columns:

```text
account_id
ban_id
name
identity_confidence
join_count
leave_count
unclean_disconnect_count
rapid_rejoin_count
crash_overlap_count
post_crash_reconnect_count
warning_overlap_count
status
recommended_action
admin_ini_line
```

### `ban_recommendations.tsv`

Use for clean candidate ban lines.

Key columns:

```text
account_id
ban_id
name
status
reason
admin_ini_line
gates_passed
blocked_by
evidence_files
```

### `final_forensic_log.txt`

Use for plain-language review.

It should include:

```text
Server health
Scan state
Players to review
Ban candidates
Do-not-ban / insufficient evidence
Crash/reconnect timeline
Warning bursts
Raid/cluster context
World/baseline context
Files used
Limits
```

## Status values

| Status | Meaning |
|---|---|
| `INFO` | Normal or low-context evidence |
| `WATCH` | Worth watching |
| `REVIEW` | Admin should inspect |
| `BAN-ELIGIBLE` | Thresholds reached; write gates still apply |
| `AUTO-BANNED` | Enforcement was enabled and write succeeded |

## Related docs

* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
