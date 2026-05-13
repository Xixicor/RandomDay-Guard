# Example runs

Use these examples to understand what the output means.

## Normal session

Timeline:

```text
Login request
Player enters
Player exits cleanly
```

Expected:

```text
SESSION_JOIN
SESSION_LEAVE
status = INFO
```

No warning. No ban.

## Rapid reconnect loop

Timeline:

```text
join -> leave -> join -> leave -> join
```

Expected:

```text
rapid_rejoin_count increases
session_churn_score increases
status may become WATCH or REVIEW
```

Default safety:

```text
Churn alone does not ban.
```

## Crash-correlated return

Timeline:

```text
Player active
Server crashes
Same player reconnects quickly
Pattern repeats
```

Expected:

```text
crash_overlap_count increases
post_crash_reconnect_count increases
status may become REVIEW or BAN-ELIGIBLE
```

One crash alone is not enough.

## First scan still running

Expected:

```text
scan_progress.json exists
scan_checkpoint.json exists
object_registry_partial.json may exist
world_state_latest.json says scan_complete=false
```

This is normal.

## Restart during scan

Expected:

```text
scan_checkpoint.json is loaded
scan resumes near prior index
or cached entries are reused
```

Problem:

```text
files_done returns to 0 every restart without stale-world reason
```

## Completed baseline

Expected:

```text
scan_complete.json
object_registry.json
object_registry_counts.tsv
baselines/last_completed_baseline.json
baselines/file_manifest.tsv
```

Future boots should load the baseline and refresh changed files.

## Enforcement test mode

Config:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Expected:

```text
recommendations may appear
Admin.ini remains unchanged
```

## Enforcement enabled

Config:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Expected if gates pass:

```text
runtime/backups/Admin_<timestamp>.ini
runtime/enforced_bans.jsonl
runtime/enforced.txt
Admin.ini contains BannedPlayer=<ID>
```

## Daily forensic upload

After a day of activity, zip:

```text
runtime/final_logs/YYYY-MM-DD/
```

or:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Expected result:

```text
final_forensic_log.txt explains the day in plain language.
players.tsv lists account status.
ban_recommendations.tsv lists candidate BannedPlayer lines.
```

## Related docs

* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
