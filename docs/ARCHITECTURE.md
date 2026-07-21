# Architecture and lifecycle

RandomDayGuard is one UE4SS watchdog plus one isolated reporting module. It
reads server-owned files, maintains bounded local state, and writes local
evidence and review outputs. It has no provider, control-panel, notification
service, RandomDay, or network dependency.

## End-to-end data flow

1. UE4SS loads the single canonical entrypoint
   `RandomDayGuard/Scripts/main.lua`. Current packages do not ship a lowercase
   case-variant duplicate.
2. The loader reads `config.lua`, the three data dictionaries, and optional
   `SavedRoot.txt`. Version identity must agree with `VERSION`, `MANIFEST.json`,
   and `BUILD_MARKER.txt`.
3. Saved-root discovery checks bounded known candidates and direct known files.
   It records what was readable in `runtime/saved_path_probe.json`; finding a
   directory alone is not evidence coverage.
4. The immediate layer tails the active server log from a safe offset. It
   normalizes lifecycle, session, account, warning, reconnect, and other
   observed events into append-only evidence plus current snapshots.
5. The slow layer inventories Saved files in bounded chunks. It writes progress
   and checkpoints, resumes incomplete work, compares a changed-file manifest,
   and produces partial then final object/world context.
6. Review logic correlates only the evidence available to it. Weak filenames,
   timing, class counts, relative coordinates, churn, a single crash, or ping
   remain context and cannot authorize enforcement alone.
7. A separate report worker calls `Scripts/public_pipeline.lua`. It inventories
   source classes, records current versus historical scope, binds the cycle to
   version/boot/epoch/poll/source freshness, writes five route-specific JSON/TXT
   pairs, and then writes `route_proof.json`.
8. When explicitly enabled, the local outbox copies references from a completed
   report after route proof exists. It records `delivery_backend="none"` and
   `delivery_attempted=false`; transport is outside this product.

## Ownership and asynchronous boundaries

| Owner | Bounded work | Must not block or imply |
|---|---|---|
| Startup | Config, Saved-root, active-log, epoch, indexes, initial status. | A successful loader marker does not prove evidence or routes. |
| Poll callback | New log bytes, state updates, event/session/account outputs, scheduling. | Slow recursive discovery or report draining. |
| Scan worker | Manifest discovery, file parsing, checkpoint, partial/final baseline. | Current log progress; partial is not failure. |
| Report worker | Source accounting, translation, report pairs, route proof, local outbox. | Enforcement or external delivery. |
| Optional enforcement | Confirm the account and score, protect trusted accounts and duplicates, verify a backup, reject outside file changes, then verify the saved result. | A report score, route status, or case membership bypassing any required safety check. |

The poll loop stays healthy only while `poll_id` advances, `poll_in_flight`
returns false, and scheduling remains active. That proves the poll component,
not the report pipeline. Slow scans may be `partial` or `deferred`; the default
`slow_world_scan_blocks_current_reports=false` lets fresh current routes proceed
while naming the historical limitation.

## State and lifecycle

| State | Entry | Terminal or next state | Error and recovery |
|---|---|---|---|
| Startup | UE4SS invokes the loader. | Running poll/scan/report workers with a boot ID and epoch. | `startup_error` is current-boot critical evidence; repair config/path/source and restart. |
| Current poll | Scheduled bounded callback begins. | Completed poll records timestamp and reschedules. | `poll_error` is current-boot critical evidence; restore bounded work and confirm a newer poll. |
| Scan pending | Baseline required or incomplete checkpoint found. | `partial`/`deferred`, then `scan_complete`. | Resume checkpoint; rebuild only when stale/incompatible evidence is recorded. |
| Source accounting | Report worker inventories eight source classes. | `complete`, `complete_with_gaps`, `partial`, or `unavailable`. | Disabled/failed accounting forces all routes to `missing`. |
| Route generation | Current-cycle lineage and source accounting are available. | `full`, `limited_expected_empty`, or `missing`. | Paired JSON/TXT or route-proof write failure converges the route to `missing`. |
| Local outbox | A route is enabled, completed, and eligible. | Pending local envelope and notification-status outcome. | No write or incomplete proof means no envelope; no delivery is inferred. |
| Enforcement review | Account-specific evidence reaches the configured score for automatic action. | Review-only recommendation or an explicitly enabled `Admin.ini` update. | A failed or unavailable safety check stops the update; a failed final comparison restores the verified backup when recovery is enabled. |

## Current and historical evidence

Current evidence belongs to the active boot/poll and is never reconstructed
from retained filenames alone. Historical evidence includes rotated logs,
durable account/session history, retained cases/reports/evidence, and bounded
world-save scanning. Reports expose separate current and historical arrays and
counts. A quiet restart must not erase durable context, and a historical record
must not be presented as current presence.

## Completion and recovery boundary

Completion for one route requires matching current-cycle version, boot ID,
epoch ID, positive poll ID, fresh active-log status, both route outputs, and its
entry in `route_proof.json`. Notification claims additionally require the
same-cycle local envelope; external delivery is never part of the public proof.

If final reports are missing or older than current poll/source state, continue
from the first mismatched lineage or failed write. Do not change unrelated
routes, wording, or enforcement settings. See
[`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md),
[`TROUBLESHOOTING.md`](TROUBLESHOOTING.md), and
[`SOURCE_MODULE_REFERENCE.md`](SOURCE_MODULE_REFERENCE.md).
