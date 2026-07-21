# Troubleshooting

Use this page when Guard does not load, a source cannot be collected, a report
does not appear, or route proof contradicts what you expected. Start with the
decision tree and follow one branch. Use the dedicated
[status and error reference](STATUS_AND_ERROR_REFERENCE.md) only after the
failed layer is known.

Preserve current runtime files before changing configuration or reinstalling.
A stale or missing artifact identifies a failed stage; repeated restarts can
erase that evidence.

## Choose the failure path

### 1. Decide whether Guard loaded

- **No `runtime/` files exist:** follow [Restore missing runtime
  files](#restore-missing-runtime-files). Verify install path, canonical loader,
  `enabled.txt`, and `mods.txt` before investigating reports.
- **Current status files exist:** Guard loaded far enough to write state.
  Continue to step 2; reinstalling is not the first response.

### 2. Decide whether the scheduler is advancing

Open:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Counters and timestamps advance:** continue to step 3.
- **`poll_id` is static, `poll_in_flight` stays true, or scheduler status is not
  running:** follow [Recover a stuck poll loop](#recover-a-stuck-poll-loop).
- **Baseline scan is pending while scheduler progress continues:** this is a
  caution, not automatically a failed startup. Investigate only if backlog or
  scan progress stops.

### 3. Classify route proof

Open `runtime/final_logs/route_proof.json` and inspect every route separately.

- **`full`:** compare unexpected wording with current `source_references` and
  lineage. Do not change delivery because wording alone looks wrong.
- **`limited_expected_empty`:** confirm source accounting supports a legitimate
  empty result. Do not create a synthetic player or case.
- **`missing`:** follow [Diagnose a missing route](#diagnose-a-missing-route).

### 4. Classify source coverage

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, or
  `error`:** follow [Interpret incomplete source
  coverage](#interpret-incomplete-source-coverage), then look up the exact code
  in [Status and error reference](STATUS_AND_ERROR_REFERENCE.md).
- **Structured source is current but translated or pending output is older:**
  diagnose completion handoff, not the delivery endpoint. Preserve both timestamps and
  inspect report and dispatch status before changing delivery configuration.

### 5. Follow the matching branch

- Incomplete identity: [Map an unmapped player](#map-an-unmapped-player).
- Missing daily continuity: [Restore a missing daily
  rollup](#restore-a-missing-daily-rollup).
- Explicitly approved enforcement test did not write: [Diagnose a blocked
  Admin.ini write](#diagnose-a-blocked-adminini-write).
- ZIP extraction failed: [Resolve a Windows extraction case
  collision](#resolve-a-windows-extraction-folder-collision).
- Fixture, package, or repository check failed: [Validation and release
  review](VALIDATION_AND_RELEASE.md#avoid-validation-environment-pitfalls).

### 6. Stop with one proved outcome

A troubleshooting pass ends when:

- the route is current and `full`;
- the route is current and `limited_expected_empty` for a named reason;
- one exact blocker, evidence path, and next action are recorded; or
- rollback restored the previous known state and preserved failed evidence.

“The server is running,” an increasing heartbeat, or HTTP success alone does
not prove a report route completed.

## Diagnose a missing route

Open `runtime/final_logs/route_proof.json` and compare `server_status`,
`daily_rollup`, `player_activity`, `case_review`, and `critical_guard`.

1. Read the route's reason, lineage, generation time, and source references.
2. Confirm the named structured source exists and belongs to the same cycle.
3. Compare its mtime with the translated output and pending envelope.
4. If final logs are newer than translated or pending output, record stale
   completion dispatch and repair that handoff first.
5. If all local output is current but delivery is absent, then inspect route
   configuration and sender status.

Do not promote scheduler health or one successful notification to five-route
proof.

## Interpret incomplete source coverage

| State | What to do |
|---|---|
| `partial` | Use only collected evidence and avoid complete-coverage claims. |
| `deferred` | Confirm later bounded work advances before changing configuration. |
| `unavailable` | Record the environment limit; correct only a proven path or permission issue. |
| `malformed` | Preserve the source and parse error; do not guess missing values. |
| `permission_denied` | Grant only the narrow read permission required. |
| `error` | Preserve details and diagnose the named stage before relying on the route. |

## Restore missing runtime files

Confirm:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

The correct install root is:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Reject this nested layout:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

If the files are correct but UE4SS did not start Guard, preserve `UE4SS.log`
and compare its startup timestamp with the actual game-process start.

## Resolve a Windows extraction folder collision

An older release used program directories whose names differed only by
capitalization. Some Windows extractors merge those names when a ZIP is placed
over an existing folder.

1. Delete only the unsuccessful temporary extraction, not the installed mod or
   its evidence.
2. Create a new empty temporary directory.
3. Extract the current release there.
4. Confirm it produces one RandomDayGuard folder and one program directory.
5. If Windows still reports a collision, download the release again and report
   the release version and extractor used.

Never extract a new release over the installed folder. Follow the clean-folder
update procedure in [`../INSTALL.md`](../INSTALL.md).

## Load the expected version

Check the source marker and build marker:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

If they disagree:

1. Stop the server.
2. Back up the installed folder, reviewed configuration, and runtime evidence.
3. Stage and inspect the intended package.
4. Replace only package-managed program and data files.
5. Confirm the canonical loader exists and no lowercase duplicate was added.
6. Start once and read back the current markers before judging runtime output.

## Correct a missing Saved root

Open `runtime/saved_path_probe.json`. Put the verified absolute path to the
complete Abiotic Factor `Saved/` directory in `SavedRoot.txt`; do not point only
to a world directory. A path outside the bounded root must remain rejected.

## Recover a stalled historical scan

Current monitoring and historical discovery are separate. A large archive may
need many bounded cycles, so one unchanged observation is not enough to call it
stalled.

1. Open `runtime/current/report_worker_status.json`.
2. Record `scan_cursor`, files discovered, files completed, and
   `last_progress_ts`.
3. Wait for at least two normal report-worker opportunities and compare the
   same fields again.
4. If the cursor, completed count, or progress time advances, the scan is still
   working. Leave it bounded.
5. If all progress fields remain unchanged while poll IDs and current reports
   continue advancing, preserve the status file and check the source class named
   by the worker phase. Repair that source path or read failure before retrying.

A stalled historical scan limits conclusions that need older records. It does
not invalidate a current report whose active-log and current-cycle proof are
fresh.

## Recover a stuck poll loop

Open:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Record `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`,
`scheduler_status`, and timestamps twice at a bounded interval.

- If counters advance, the loop is not stuck; diagnose the later worker stage.
- If `poll_in_flight=true` remains unchanged, preserve the last progress stage
  and error before restarting.
- If the scheduler stopped, inspect the preceding error and startup handoff.

Do not add a second loop owner to compensate for one stalled lifecycle.

## Start the scan after log backlog

In `runtime/current/poll_status.json`, compare:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

Historical scan should wait while the active log has unread bytes. Confirm
later polls reduce the backlog. A fixed unread count with advancing polls is a
source-tail problem; a fixed poll is a scheduler problem.

## Preserve scan progress after a crash

Preserve and compare:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Check whether the checkpoint or manifest is missing, the Saved root or world
changed, or the checkpoint was marked stale. Do not delete a valid baseline to
make progress appear newer.

## Map an unmapped player

Compare session evidence with the authoritative log:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Look for a complete `Login request` relationship among display name,
`ConnectID`, and `UniqueId`. If no accepted connection identity exists, keep
the row review-only. A display name or PlayerData filename alone is not an
enforceable identity.

## Diagnose a blocked Admin.ini write

Run an enforcement test only with explicit approval and a disposable test file,
never with a live server file. First confirm that the test configuration asks
Guard to write:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Then read the recorded failure reason. Guard must identify one account, protect
moderators and trusted accounts, find enough account-specific evidence, create
and verify a new backup, confirm that no other program changed the file, save
the intended update, and compare the complete saved file with that intended
result. If any step fails or cannot be checked, leave the ban list unchanged.
See [Admin.ini enforcement](ADMIN_INI_ENFORCEMENT.md).

## Restore a missing daily rollup

Confirm `forensic_rollup.enabled = true`, then inspect:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

If these are missing, check startup, poll, report-worker, and source-accounting
status in that order. Daily rollup is one continuity record per day, not a
repeating server-status notification.

## Look up an exact status or error

Use [Status and error reference](STATUS_AND_ERROR_REFERENCE.md) for complete
route, source, PlayerData, enforcement, startup, scheduler, report, and
notification code tables. Keeping lookup tables separate prevents this repair
page from becoming a second schema manual.

## Related docs

- [Start here](START_HERE.md)
- [Operations playbook](OPERATIONS_PLAYBOOK.md)
- [Status and error reference](STATUS_AND_ERROR_REFERENCE.md)
- [Validation and release review](VALIDATION_AND_RELEASE.md)
