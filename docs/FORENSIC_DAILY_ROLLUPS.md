# Forensic daily rollups

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

Use this page when you want one folder to upload for quick analysis.

## What it is

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

The daily rollup is a rebuildable summary of the raw evidence for one day.

It does not replace raw evidence.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

## Where it writes

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

Current day:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Daily package:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Final plain-language package:

```text
runtime/final_logs/YYYY-MM-DD/
```

## What to upload here for quick analysis

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

Upload one of:

```text
runtime/final_logs/YYYY-MM-DD/
runtime/forensic_days/YYYY-MM-DD/
```

The fastest file for me to read is:

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

## Daily folder contents

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

```text
runtime/forensic_days/YYYY-MM-DD/
â”œâ”€ forensic_day_summary.json
â”œâ”€ forensic_day_summary.md
â”œâ”€ forensic_day_summary.txt
â”œâ”€ players.tsv
â”œâ”€ sessions.tsv
â”œâ”€ crash_reconnects.tsv
â”œâ”€ warning_bursts.tsv
â”œâ”€ raid_cases.tsv
â”œâ”€ world_context.tsv
â”œâ”€ ban_recommendations.tsv
â”œâ”€ enforcement_audit.tsv
â””â”€ evidence_index.json
```

## Final log contents

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

```text
runtime/final_logs/YYYY-MM-DD/
â”œâ”€ final_forensic_log.txt
â”œâ”€ final_forensic_log.md
â””â”€ final_forensic_log.json
```

The TXT is written in plain language for fast operator review.

## What the final TXT should answer

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

```text
Did the guard run?
Was the scan partial or complete?
Who joined?
Who left cleanly?
Who did not leave cleanly?
Who rapidly reconnected?
Who overlapped crashes?
Who returned after crashes?
Who had warning overlap?
Who appears in a cluster?
Who is REVIEW?
Who is BAN-ELIGIBLE?
Which BannedPlayer=<ID> lines are candidates?
Which gates blocked enforcement?
What evidence files support each recommendation?
```

## Source files used

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

The rollup can read these when present:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
runtime/warning_events.jsonl
runtime/raid_cases/
runtime/world_state/current/world_state_latest.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry.json
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

Missing files should be marked as missing, not treated as fatal.

## Update behavior

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

For the same day, the guard updates the same files.

Correct:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Wrong:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

## Crash-safety

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

The guard should write temp files first, then rename:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

This protects the last good summary if the server crashes mid-write.

## `players.tsv` columns

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

```text
date
account_id
ban_id
name
identity_confidence
playerdata_verified
first_seen
last_seen
join_count
leave_count
clean_leave_count
unclean_disconnect_count
rapid_rejoin_count
crash_overlap_count
post_crash_reconnect_count
warning_overlap_count
raid_case_count
world_context_count
score
status
recommended_action
ban_eligible
already_enforced
admin_ini_line
```

## `ban_recommendations.tsv` columns

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

```text
date
account_id
ban_id
name
status
recommended_action
reason
admin_ini_line
gates_passed
blocked_by
evidence_files
```

## Review rule

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

A daily rollup can make review fast, but it should not be the only evidence.

When a recommendation matters, verify with:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

## Related docs

The daily rollup is a rebuildable index. Source evidence remains authoritative; the daily folder and final log are fast review packages generated from runtime evidence.

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](MEMORY_ECONOMY_AND_OUTPUTS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)

