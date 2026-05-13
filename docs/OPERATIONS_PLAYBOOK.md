# Operations playbook

Use this page for routine server administration.

## Daily check

Open:

```text
runtime/current/poll_status.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
```

Confirm:

```text
poll_id is increasing
poll_in_flight returns false
final log exists
no unexpected enforcement happened
```

## After a crash

Open:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Check:

```text
who was active before crash
who reconnected after restart
whether pattern repeats
```

## After a long scan

Open:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Then create a sticky backup.

## Before enabling enforcement

Confirm:

```text
trusted IDs are configured
Admin.ini backups work
ban_recommendations.tsv is understandable
final_forensic_log.txt explains gate status
```

## Quick upload for analysis

Zip:

```text
runtime/final_logs/YYYY-MM-DD/
```

Better:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Full:

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
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
