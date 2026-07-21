# Operations playbook

This is the normal reading order for RandomDayGuard. You do not need to know
JSON, Git, checksums, or command-line tools to review a healthy server.

## Daily operator flow

1. Open `runtime/final_logs/server_status_latest.txt`. It tells you whether
   Guard is monitoring the current server run, when its last cycle completed,
   how many players are connected, and whether a source or scan is incomplete.
2. Open `runtime/final_logs/daily_rollup_latest.txt` once per day. It summarizes
   same-day sessions, exits, named case work, identity inventory, and source
   coverage without repeating every individual record.
3. Open `runtime/final_logs/player_activity_latest.txt` only when the server had
   a join, leave, or active session during the day.
4. Open `runtime/final_logs/case_review_latest.txt` only when it names a current
   subject. The report gives the account, review state, score, identity source,
   and the records to open next.
5. Open `runtime/final_logs/critical_guard_latest.txt` only when Guard reports a
   failure in its own startup, monitoring cycle, or report writes.

If a route has nothing to report, Guard records an expected-empty result. That
is a completed check, not a missing report.

## What to read inside a report

Read these sections in order:

1. **Summary** - what this report covers.
2. **What Guard observed** - actual timestamps, counts, accounts, sessions, or
   status values collected for this route.
3. **What it means** - the plain-language interpretation of those records.
4. **What remains unknown** - a source or scan limit that affects the result.
5. **Recommended next step** - whether to monitor, review a named subject, or
   repair Guard.
6. **Evidence boundary** - the limit of the report's scope.

The technical record and source references appear at the end for readers who
need to inspect the exact structured evidence.

## When a report is missing

Open `runtime/final_logs/route_proof.json` only when a readable report is absent
or says its current proof is missing. Each route has one of these results:

| Result | Meaning |
|---|---|
| `full` | Guard completed the route with current route-owned evidence. |
| `limited_expected_empty` | Guard completed the route and found no qualifying event, or recorded a named maturity limit. |
| `missing` | A required source, lineage check, or paired report write did not complete. |

For a missing route, follow the named source or write error in the report. Do
not change unrelated routes or notification settings first.

## After a crash or restart

1. Read Server Status for the new server-run timestamp and latest completed
   monitoring cycle.
2. Read Critical Guard for a current startup or poll failure.
3. Read Player Activity only if a same-day session joined, left, or returned
   after the lifecycle change.
4. Preserve the cited source record before changing configuration.

## Before enabling optional Admin.ini writes

The default package watches and reports without changing `Admin.ini`. Advanced
operators can enable the optional enforcement path after testing it against a
copy of the file. Guard then requires a clean numeric account ID, protects
trusted accounts, creates and verifies a backup, rejects concurrent changes,
reads the saved file back, and restores the backup if verification fails. See
[`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md) for the complete setup
and test procedure.

## Related guides

- [`START_HERE.md`](START_HERE.md)
- [`REPORT_EXAMPLES.md`](REPORT_EXAMPLES.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
- [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)