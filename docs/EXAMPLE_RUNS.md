# Worked operation examples

These examples use invented values to explain expected
state transitions; they are not live compatibility or player evidence.

## Successful current cycle

Inputs: readable active log, version/boot/epoch, `poll_id=41`, completed current
poll, writable accounting/history/report roots, no blocking slow-scan policy.

Expected:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Every enabled route has JSON/TXT output and the same lineage in
`route_proof.json`. The route status depends on its own subjects, not on a
generic success message.

## Expected-empty player and case routes

Inputs: current-cycle proof is complete; no current or retained player rows;
no retained case and no current REVIEW/BAN-ELIGIBLE account.

Expected:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

The translated reports say that no eligible bounded subject was observed. They
also say this does not prove nobody ever connected or that no context is
missing. No placeholder player/case is created.

## Partial bounded scan

Inputs: fresh current log/poll; `scan_checkpoint.json` or `scan_progress.json`
exists; scan is incomplete; default
`slow_world_scan_blocks_current_reports=false`.

Expected:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Set `slow_world_scan_blocks_current_reports=true` only when the operator wants
that optional slow source to block current reports. Recovery is to allow the
scan worker to resume, not to delete the checkpoint.

## Missing current-cycle proof

Inputs: active log unavailable, `poll_id=0`, or boot/epoch/last-poll lineage
missing.

Expected:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

The suppressed envelope is an audit record, not a queued delivery. Old final
logs remain historical only. Repair the first missing lineage/source field and
generate a newer cycle.

## Malformed optional Admin.ini source

Inputs: `Admin.ini` exists but fails clean structural validation.

Expected:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Preserve the file and restore a reviewed clean format. Keep explanatory text in
runtime evidence; each `Admin.ini` ban entry remains only
`BannedPlayer=<ID>`.

## Required active-log probe error

Inputs: the bounded required active-log probe fails with a sanitized read error.

Expected:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` remains on the source row with its bounded detail. The top-level report
uses `unavailable`, and route proof remains `missing` until a newer current
cycle proves the required source.

## Incompatible or stale baseline

Inputs: changed package/source identity or stale/incompatible baseline manifest.

Expected: validation or runtime status records the incompatibility; scan state
does not claim completed reuse. Preserve prior evidence, start an explicit
baseline rebuild, and wait for new terminal proof. A forced rebuild without a
recorded reason is not the default recovery.

## Paired report write failure

Inputs: JSON write succeeds but TXT write fails, or the reverse.

Expected:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

The writer best-effort rewrites both siblings to converge on failure. One
successful sibling cannot remain as a success claim. The bounded write detail
does not create a fifth top-level coverage value.

## Route-proof write failure

Inputs: route pairs were written but `route_proof.json` cannot be replaced.

Expected: all reports are rewritten `missing`, all notification outcomes are
`route_proof_write_failed`, and no envelope is accepted. A configured route
may have a `suppressed_current_cycle` audit envelope with delivery flags false.
Repair the output root and regenerate the same current cycle.

## Review-only enforcement example

Config:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Expected: scores, cases, and recommendations may be written; `Admin.ini`
remains unchanged. This is the public default.

## Approved write success example

Only a separately approved test may set all three write switches. It must also
prove clean numeric identity, trust/moderator exclusion, threshold eligibility,
valid Admin.ini path/parse, backup success, write success, readback equality,
and account-specific evidence.

Expected:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

The successful example does not enable automatic enforcement for other accounts.

## Write/readback failure with rollback

Inputs: every pre-write gate passed; replacement write or readback fails;
`rollback_on_readback_failure=true` and the verified backup is available.

Expected: failure evidence records the stage and `rollback_success`; the
original Admin.ini bytes are restored and the account is not reported as
successfully enforced. If rollback also fails, stop writes, preserve both
files/evidence, and recover manually from the backup.

## Local outbox example

Inputs: notification enabled in `local_file_outbox` mode, route enabled,
completed route proof, and either `full` or explicitly allowed expected-empty.

Expected envelope:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

For missing/ineligible output, the same path may instead contain
`status=suppressed_current_cycle`, `completed_output=false`, and
`delivery_eligible=false`. Either file proves a local write only. No provider,
transport, delivery, or read receipt is bundled or inferred.

See [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md),
[`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md), and
[`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).
