# Output and state schema reference

This is the canonical contract for generated operator-facing files. It alone
owns exact output paths, field names, allowed values, lineage requirements, and
route schemas. Procedural guides link here instead of redefining those facts.

Runtime evidence is authoritative; a filename, scheduler heartbeat, translated
report, or local outbox object does not prove more than its own fields and
lineage.

## Public report routes

The report worker owns five routes under `runtime/final_logs/`:

| Route | Contract | `full` requirement | Expected-empty meaning |
|---|---|---|---|
| `server_status` | Current scheduler, active-log, scan-pending, and source-coverage state. | Current boot/epoch/poll lineage, fresh active log, accounting/history writes, and the JSON/TXT pair. | Not used for an otherwise healthy current cycle; missing lineage is `missing`. |
| `daily_rollup` | Current day/window continuity across server, players, cases, scan, and coverage. | Historical accounting terminal enough for the route and current-cycle proof complete. | No retained players and no review cases. |
| `player_activity` | Separate current and historical player/account observations. | Current-cycle proof plus one or more current/historical rows. | No eligible player rows in bounded inputs; no synthetic subject. |
| `case_review` | Named retained cases and current review/BAN-ELIGIBLE candidates. | Current-cycle proof plus one or more named cases with source references. | No named case met review criteria; no synthetic case. |
| `critical_guard` | Current-boot scheduler, startup, poll, or evidence-integrity failure. | Current-cycle proof plus a current critical failure. | No current critical failure; old text errors do not own this route. |

Every enabled route writes `<route>_latest.json` and
`<route>_latest.txt`. The pair is not completed until
`runtime/final_logs/route_proof.json` records the same version, boot, epoch,
poll, and source freshness.

## Report JSON schema

All route JSON uses `schema="randomdayguard.report/v1"`.

| Field | Type | Meaning and invariant |
|---|---|---|
| `schema` | string | Exactly `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | string | Generation timestamp and reporting date. |
| `version` | string | Runtime/package identity for this cycle. |
| `boot_id`, `epoch_id` | string | Current process boot and server continuity epoch. Both are required for completion. |
| `poll_id` | integer | Positive current poll identifier. Zero/missing cannot complete a route. |
| `source_freshness` | object | `status`, `checked_ts`, active-log status, last poll timestamp, and last completed poll timestamp. |
| `current_cycle_proof_complete` | boolean | True only when lineage and fresh active-log/current-poll evidence agree. |
| `route` | enum | One of the five routes above. |
| `route_proof_status` | enum | `full`, `limited_expected_empty`, or `missing`. |
| `coverage_status` | enum | Exactly `complete`, `complete_with_gaps`, `partial`, or `unavailable`. |
| `completed`, `expected_empty` | boolean | `completed` is false only for `missing`; `expected_empty` is true only for `limited_expected_empty`. |
| `observed` | array of strings | Concrete retained facts/counts/statuses. |
| `interpretation` | array of strings | Cautious meaning calibrated to the evidence. |
| `unknown` | array of strings | Missing identity, history, source, or context. |
| `does_not_prove` | array of strings | Conclusions the evidence cannot support. |
| `next_action` | string | Safest bounded operator action. |
| `source_references` | array of strings | Sorted unique runtime/Saved references. |
| `enforcement_authority` | boolean | Always false. A report never authorizes a write. |
| `output_paths` | two strings | JSON and TXT paths added before paired writes. |

`coverage_status` is top-level accounting only. Source records separately own
`available`, `expected_empty`, `partial`, `deferred`, `unavailable`,
`malformed`, `permission_denied`, and `error`. Route proof separately owns
`full`, `limited_expected_empty`, and `missing`; values never cross these
boundaries.

Route extensions:

- `server_status`: `scheduler_status`, `active_log_status`, and
  `server_metrics`. The metrics record the current epoch start, latest
  completed poll timestamp and ID, active-player count, active/backup-log
  counts, scan pending/progress values, and configured/usable/unavailable
  source-group accounting. They do not invent uptime, restart counts, backup
  timestamps, or outage duration when no source exposes those facts.
- `player_activity`: `player_activity_present`, `movement`,
  `same_day_sessions`, `current_player_count`,
  `current_evidence_player_count`, `historical_player_count`,
  `historical_session_count`, `current_players`, `historical_players`, and
  compatibility array `players`. Each same-day session keeps its session ID,
  account ID, display name when known, join/leave timestamps, clean-exit and
  lifecycle flags, and source references. Retained identity and PlayerData
  presence remain context, not proof of activity today.
- `case_review`: `cases`, `review_subjects`, `current_case_count`, and
  `retained_case_count`. A current review subject records its case/account ID,
  display name when known, status, score, identity confidence, first/last
  observation, warning counts, reasons, current-live flag, and source
  references. Retained cases do not create a current subject by themselves.
- `critical_guard`: `critical_failure_present` and
  `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`,
  `dedupe_window`, and `daily_metrics`. The metrics record the report date,
  active players, accounts with same-day activity, joins, leaves, clean and
  unclean exits, lifecycle returns, current named review subjects, retained
  cases, current/retained identity counts, and source-group coverage.

## Translated TXT schema

The paired text file leads with the operator-readable result and moves lineage
details to the end. It preserves this exact section order:

```text
RandomDayGuard <route title>
Generated: <timestamp>

Summary
<one plain-language route summary>

What Guard observed
- ...

What it means
- ...

What remains unknown
- ...

Recommended next step
...

Evidence boundary
- ...

Rating explanation
- ...

Technical record
- Route: <route>
- Version: <version>
- Cycle: boot=<boot> epoch=<epoch> poll=<poll>
- Source freshness: <status>
- Route result: <full|limited_expected_empty|missing>
- Coverage: <status>

Translation notes
- ...

Source references
- ...
```

Translation uses only the structured report fields and approved dictionary
mappings. It cannot add players, cases, delivery, causation, ownership, intent,
or enforcement eligibility absent from the structured report. Technical
details remain available without displacing the readable result.

## Source accounting schema

`runtime/final_logs/source_accounting_latest.json` uses
`randomdayguard.source-accounting/v1` with generation reason/status,
enablement/disabled reason, current/historical distinction, changed-file
manifest, source records, usable/unavailable class lists, and a claim limit.

Each source record contains:

| Field | Type | Meaning |
|---|---|---|
| `source_class` | string | One of the eight classes below. |
| `scope` | `current` or `historical` | Time ownership; scopes are never merged silently. |
| `required` | boolean | Only `active_log` is required for current-cycle route freshness. |
| `status` | enum | Source result listed below. |
| `terminal` | boolean | False only for `partial` and `deferred`. |
| `available`, `readable` | boolean | True only for `available` and `expected_empty`. |
| `file_count` | integer | Bounded accounted file/reference count. |
| `source_references` | array | Sorted unique source paths/references. |
| `detail` | string | Bounded result or error detail. |
| `does_not_prove` | string | Availability is not intent, ownership, damage, duplication, or enforcement proof. |

Source classes:

| Source class | Scope | What it contributes | What it cannot prove |
|---|---|---|---|
| `active_log` | current, required | Readable active server log and fresh poll lineage. | Complete history or player culpability. |
| `admin_ini` | current, optional | Structurally valid current moderator/ban state, or expected absence. | Player behavior or valid reason metadata. |
| `recent_backup_logs` | historical | Readable rotated/backup log references. | Current presence or current boot state. |
| `playerdata_filenames` | current context | Bounded readable filename references under the selected Saved root. | File ownership, live presence, identity content, or misconduct. |
| `existing_cases` | historical | Retained named case files/index records captured before current outputs. | Current activity or correctness of old conclusions. |
| `existing_reports` | historical | Retained final/forensic/warning report references. | Authoritative source replacement. |
| `existing_evidence` | historical | Retained evidence references. | Completeness of events the server never exposed. |
| `world_save_scan` | historical | Complete, partial, deferred, or unavailable bounded scan/checkpoint state. | A specific player's action or ownership. |

Source status values:

| Status | Terminal | Operator meaning and action |
|---|---:|---|
| `available` | yes | Readable useful source exists; review its references. |
| `expected_empty` | yes | Optional source was checked and legitimately absent/empty. Do not invent data. |
| `partial` | no | Bounded work or inventory limit is incomplete; allow resume. |
| `deferred` | no | Work is intentionally pending; wait for the owning worker. |
| `unavailable` | yes | Source/path/tool is absent or unusable; repair only if needed by the route. |
| `malformed` | yes | Content failed structural validation; preserve it and repair format. |
| `permission_denied` | yes | Access was explicitly denied; restore least-privilege read access. |
| `error` | yes | Source-level bounded probe/read failed unexpectedly; inspect `detail` without exposing secrets. |

Top-level `coverage_status` is exactly `complete`, `complete_with_gaps`,
`partial`, or `unavailable`. A required source-level `error`, `malformed`, or
`permission_denied` rolls up to top-level `unavailable`; source-level
`deferred` rolls up to top-level `partial`. Disabling source accounting still
writes an unavailable status and forces every route to `missing`.

## Historical status schema

`runtime/final_logs/historical_backfill_latest.json` uses
`randomdayguard.history/v1`: `generated_ts`, accounting `status`,
`resumable=true`, `changed_file_refresh=true`,
`current_evidence_is_not_history=true`, the source-accounting array,
unavailable classes, and a bounded `next_action`.

`runtime/history/public_accounts.tsv` is durable public history with this
header:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

Rows are sorted by account ID, fields are single-line/tab-safe, and references
are sorted/unique. This file preserves historical context across quiet
restarts; it never converts history into current presence.

## Route proof schema

`runtime/final_logs/route_proof.json` uses
`randomdayguard.route-proof/v1` and records top-level generation timestamp,
version, boot, epoch, poll, source freshness, current-cycle completeness,
allowed statuses, and a `routes` array.

Each route entry contains route/status, version/boot/epoch/poll,
source-freshness object, current-cycle completeness, output paths, and source
references. A disabled route records `status="missing"` and
`reason="route_disabled"`. If route-proof writing fails, every route is
rewritten as incomplete/missing before any notification candidate is accepted.

## Notification schemas

The optional public mode is local-file outbox only.

`runtime/notifications/pending/<route>_latest.json` uses
`randomdayguard.notification/v1` with generated timestamp, version/boot/epoch/
poll/source freshness, route, `completed_output`, route-proof status, structured
and translated report paths, source references, `delivery_backend="none"`, and
`delivery_attempted=false`. Eligible output uses
`status="ready_for_local_consumer"`, `delivery_eligible=true`, and
`delivery_allowed=true`. A configured but missing/ineligible route still writes
an audit envelope with `status="suppressed_current_cycle"`, both delivery flags
false, and `suppression_reason="route_or_completion_policy_blocked"`. Therefore
the presence of a file under `pending/` does not by itself mean queued or
eligible.

`runtime/notifications/notification_status.json` uses
`randomdayguard.notification-status/v1` with the same lineage,
`generic_local_outbox_only=true`, `delivery_attempted=false`, and per-route
`queued`/`outcome` rows. `full` is eligible; expected-empty is eligible only
when `include_expected_empty=true`; `missing` is never eligible. On a
route-proof write failure the status outcome is `route_proof_write_failed`; a
suppressed audit envelope may still be written, but it is not accepted output.

## Runtime output inventory

The traceability index has one machine row for each path or dynamic file class.
This readable inventory groups files by operator purpose.

| Path or pattern | Producer/trigger | Policy and useful states | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Loader entry. | Overwritten startup identity/probe. | Missing does not prove load; inspect UE4SS logs and enablement. |
| `runtime/config_load_error.txt` | Config load failure. | Error-only, preserves bounded reason. | Restore valid public config and restart. |
| `runtime/saved_path_probe.json` | Saved-root resolution. | Candidate/readability accounting. | Set `SavedRoot.txt` or repair a generic candidate. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Startup lifecycle. | Latest startup and current-boot error. | Only matching boot owns current critical status. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report integration. | Latest version/capability/handoff state. | Version or capability drift blocks completion claims. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Poll finalizer/error. | Latest poll/scheduler/in-flight state and current-boot error. | Repair bounded callback and require a newer completed poll. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Event logger. | Bounded append/rotation. | Preserve prior bytes; repair disk/retention before relying on gaps. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Log tail/registry. | Latest offsets and canonical log identities. | Rebuild carefully; backup logs remain historical. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle normalizer. | Append-only context. | Missing context cannot prove graceful/crash state. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Epoch owner. | Current plus retained server epochs. | Start a new epoch after repair; do not rewrite old history. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Session owner. | Current/historical session events and snapshots. | Unmapped rows stay unknown; no identity invention. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session aggregation and reporting module. | Current snapshot plus durable history. | Keep scopes separate and restore from evidence, not guesses. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state writers. | Overwritten current snapshots. | Stale/missing is unknown, not expected empty. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly aggregation. | Rebuildable indexes. | Rebuild from authoritative events. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Scan worker. | Started, partial/deferred, checkpoint, complete, or error. | Resume checkpoint; rebuild only with recorded reason. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Baseline worker. | Latest scan/baseline and changed-file binding. | Stale/incompatible manifests require an explicit rebuild. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Object scan. | Partial/final class context. | Counts are not player-action proof; resume or rebuild scan. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | Object comparison. | Append-only new/delta context. | Review mapping/baseline before inference. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Saved-root indexes. | Filename/admin structure context. | Filenames are weak; malformed admin state closes writes. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | World-state writer. | Boot/current/session snapshots and diffs. | Context only; regenerate after scan/source repair. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence writers. | Bounded append and per-player/session review files. | Missing report is not missing event proof; inspect source evidence. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review aggregation. | Named review material and queue candidates. | Case membership/threshold never bypasses account-specific gates. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Optional Admin.ini transaction. | Backup, success ledger, or explicit failure/rollback evidence. | Any backup/write/readback/rollback failure closes enforcement; restore backup. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Optional marker writer. | Local request only. | Does not prove consumption or restart. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Forensic rollup. | Current and dated rebuildable review indexes. | Rebuild from source evidence; never treat summary as authority. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Public report worker. | Schemas and completion rules above. | Repair first mismatched lineage/source/write; missing stays missing. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Optional local outbox. | Eligible or explicitly suppressed local envelope plus status. | Missing/ineligible routes may have suppressed files but are never queued; inspect delivery flags and infer no external delivery. |

Overwrite/append/retention behavior is controlled by the producing section in
[`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md). Package ZIPs contain only
empty `.gitkeep` placeholders under `runtime/`; any evidence/output byte in a
release package fails validation.

## Failure and recovery matrix

| Failure | Required state | Safe recovery | Invalid inference |
|---|---|---|---|
| Current lineage absent/stale | All routes `missing`. | Restore active-log/current-poll proof and regenerate. | Old route files are not current completion. |
| Optional source expected empty | Source `expected_empty`; eligible route may be `limited_expected_empty`. | No repair unless the source should exist. | Empty is not unavailable and does not prove historical absence. |
| Scan incomplete | Source `partial` or `deferred`. | Allow bounded resume; keep current route policy explicit. | Partial is not corruption. |
| Required source unavailable | `coverage_status=unavailable`; dependent routes `missing`. | Repair selected Saved/log access. | Other healthy sources do not replace the required source. |
| Required source probe errors | Source status `error` with bounded `detail`; `coverage_status=unavailable`; dependent routes `missing`. | Repair the named source/probe and generate a newer cycle. | A source error is not a fifth top-level coverage value. |
| Paired report write fails | `coverage_status=unavailable`; route converges to `missing`. | Repair filesystem and rewrite both pair members plus proof. | One sibling file is not completion, and write failure is not top-level `error`. |
| Route-proof write fails | Every route rewritten missing; no eligible outbox; configured routes may receive suppressed audit envelopes. | Repair route-proof write and regenerate same-cycle outputs. | Valid-looking report JSON or a suppressed envelope is not route proof. |
| Notification write fails | Outcome `local_outbox_write_failed`. | Repair local output root; regenerate from completed report. | No external delivery occurred. |
| Admin.ini transaction fails | Enforcement blocked with backup/write/readback/rollback evidence. | Restore verified backup; remain review-only. | A threshold or report cannot justify bypassing recovery. |

See [`EVIDENCE_BOUNDARY.md`](EVIDENCE_BOUNDARY.md),
[`ARCHITECTURE.md`](ARCHITECTURE.md), and
[`SOURCE_MODULE_REFERENCE.md`](SOURCE_MODULE_REFERENCE.md).
