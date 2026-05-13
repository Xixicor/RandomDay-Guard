# Memory economy and output files

This page explains which files grow, which files are overwritten, and what to upload for quick review.

## Fast answer

| Question | Open |
|---|---|
| Is the guard alive? | `runtime/current/poll_status.json` |
| Who was seen? | `runtime/account_evidence.json` |
| What happened to sessions? | `runtime/evidence/session_events.jsonl` |
| What happened today? | `runtime/forensic_days/YYYY-MM-DD/` |
| What is the plain-language summary? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| What is scan progress? | `runtime/scan_progress.json` |
| What is the world context? | `runtime/world_state/current/world_state_latest.json` |
| What bans were written? | `runtime/enforced_bans.jsonl` |

## Output model

| Type | Behavior | Examples |
|---|---|---|
| Current snapshots | Overwritten | `runtime/current/*.json` |
| Event logs | Append-only | `runtime/evidence/*.jsonl` |
| Tables | Updated or appended | `*.tsv` |
| Baselines | Reused after completion | `runtime/baselines/*` |
| Daily rollups | Updated in place | `runtime/forensic_days/YYYY-MM-DD/*` |
| Final logs | Plain-language daily summary | `runtime/final_logs/YYYY-MM-DD/*` |

## Current snapshots

These stay small and answer “what is true now.”

```text
runtime/current/poll_status.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

## Player summaries

These are the first files to check for account review.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

They summarize:

```text
account_id
ban_id
name
identity_confidence
first_seen
last_seen
join_count
leave_count
status
score
```

## Event logs

These preserve the timeline.

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/warning_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
```

## Daily forensic rollups

These are the quick upload packages.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Upload one of those folders when you want a quick period analysis.

## Scan and baseline files

Use these to understand whether the world context is partial or complete.

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

## Enforcement files

Use these only when enforcement is enabled.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` should receive only:

```ini
BannedPlayer=<ID>
```

## What updates when a player joins

Expected updates:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/current/session_state.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

## What updates when the server crashes or restarts

Expected updates:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

## What updates when the scan progresses

Expected updates:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

## What to upload for quick analysis

Best package:

```text
runtime/final_logs/YYYY-MM-DD/
```

More complete package:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Full evidence package:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

## Related docs

* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
