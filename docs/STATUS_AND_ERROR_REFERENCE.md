# Status and error reference

Use this reference after a symptom has been classified in
[Troubleshooting](TROUBLESHOOTING.md). Read the structured status file named by
the error. Distinct codes represent distinct safety and lifecycle states; do
not collapse them into a generic "Guard failed" result.

## Route and source states

| Value | Meaning | Operator response |
|---|---|---|
| `full` | The route contract completed with current-cycle source proof. | Read the route's evidence boundary; no repair is implied. |
| `limited_expected_empty` | The route completed and the missing activity is legitimate for this cycle. | No synthetic player/case event should be created. |
| `missing` | A required output, lineage field, or source proof is absent. | Inspect the route reason and named source status. |
| `available` | The named source was readable and usable. | No action. |
| `expected_empty` | The source was checked and legitimately had no rows. | No action unless activity was independently expected. |
| `partial` / `complete_with_gaps` | Usable evidence exists, but named source classes are incomplete. | Limit conclusions to collected evidence. |
| `deferred` | Bounded work is scheduled for a later worker opportunity. | Confirm progress advances before changing configuration. |
| `unavailable` | The environment did not provide the source. | Record the limit; correct only a proven path or permission issue. |
| `malformed` | The source was readable but failed structural validation. | Preserve it and fix the source; do not guess. |
| `permission_denied` | The source exists but could not be read. | Grant only the narrow required read permission. |
| `error` | Collection failed for the recorded reason. | Preserve the error and diagnose that stage. |

## PlayerData and inventory codes

| Code | Meaning | Safe response |
|---|---|---|
| `saved_root_unavailable` | No verified Saved root was available to the public pipeline. | Correct `SavedRoot.txt` and recheck the path probe. |
| `unsafe_playerdata_root` | PlayerData discovery resolved outside the bounded Saved root. | Correct the path; never weaken the boundary. |
| `playerdata_discovery_not_run` | The bounded discovery worker has not run yet. | Check scheduler and worker progress. |
| `playerdata_discovery_read_failed:*` | Discovery output could not be read. | Preserve the suffix detail and verify the bounded inventory command. |
| `inventory_command_open_failed` | The inventory process could not be started. | Verify the runtime provides the configured command bridge. |
| `inventory_command_read_failed` | Inventory output failed during read. | Preserve partial output and rerun only after the underlying error is fixed. |
| `inventory_command_close_failed` | Inventory completed without a trustworthy close result. | Treat the source as incomplete. |
| `identity_ledger_row_limit_exceeded` | Durable identity input exceeded its public safety bound. | Archive and review the ledger; do not silently truncate it into full proof. |

## Admin.ini enforcement codes

All codes in this section are fail-closed. They do not authorize a manual ban
by themselves.

| Code | Meaning | Safe response |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | Public-safe write gates are off. | Expected in review-only operation. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | Required backup policy is not active. | Keep writes disabled. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | One explicit enforcement gate is off. | Expected in public review-only defaults; do not reinterpret it as a write failure. |
| `review_only_mode_enabled` | Review-only mode intentionally blocks mutation. | Review evidence only. |
| `duplicate_prevention_disabled` | Duplicate protection was disabled. | Keep writes disabled until the safety gate is restored. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | Post-write verification or rollback protection was disabled. | Keep writes disabled; never bypass these gates. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | Clean identity or account-specific evidence enforcement was disabled. | Restore the gate before any enforcement test. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | Protected-account or existing-ban preservation was disabled. | Keep writes disabled. |
| `clean_numeric_identity_required` | The proposed ID is not the complete accepted connection form or clean numeric ID. | Obtain a verified mapping; never truncate an arbitrary prefix. |
| `identity_strength_below_minimum` | Identity evidence is weaker than the configured threshold. | Review evidence only. |
| `playerdata_verification_required` | Configuration requires PlayerData confirmation and the account does not have it. | Keep the candidate review-only; do not infer ownership from a filename. |
| `trusted_or_moderator_identity` | The account is protected by trusted or moderator state. | No write is allowed. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | The target path is invalid or escapes the Saved root. | Correct configuration; never bypass the path guard. |
| `admin_ini_unavailable` | No readable configured Admin.ini was found inside the Saved root. | Correct the bounded path or keep enforcement disabled. |
| `admin_ini_read_failed` | Authoritative bytes could not be read. | Stop before mutation. |
| `admin_ini_parse_failed` | Admin.ini validation failed without a more specific structural code. | Preserve the file and inspect its section and line structure. |
| `admin_ini_contains_nul` | The file contains NUL bytes and is not accepted as text. | Preserve the file and repair it outside Guard. |
| `admin_ini_duplicate_banned_players_section` | More than one `[BannedPlayers]` section exists. | Merge sections manually while stopped. |
| `admin_ini_banned_player_outside_section` | A ban row appears outside `[BannedPlayers]`. | Correct the layout manually. |
| `admin_ini_invalid_banned_player_line` | A ban line is not exactly a clean supported ID row. | Correct the malformed line. |
| `admin_ini_backup_failed` | The unique backup did not write and read back byte-identically. | No mutation is allowed. |
| `admin_ini_external_change_detected` | Another writer changed the file after Guard's snapshot. | Preserve the external bytes and retry only after coordinating writers. |
| `atomic_rename_unavailable` | Atomic replacement was requested but Lua did not provide `os.rename`. | No write is trusted; use a supported runtime or keep enforcement disabled. |
| `admin_ini_write_failed` | Controlled replacement did not complete. | Inspect the recorded replacement error and backup. |
| `post_write_verification_failed` | Production bytes did not equal the candidate. | Check `rollback_success` and `rollback_refused_external_change` before any action. |

## Startup, scheduler, and backlog states

These values are lifecycle evidence, not route proof. Read them with current
poll, report-worker, and route-proof files.

| Value | Meaning | Safe response |
|---|---|---|
| `not_started` | The named startup or scheduler stage has not begun. | During launch, wait for the documented interval; afterward inspect the first unchanged phase. |
| `main_lua_loaded` / `starting` | The canonical loader ran and Guard entered startup. | Continue to later phases; this alone is not readiness. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Core source and continuity initialization advanced. | No action unless the next phase stops advancing. |
| `admin_state_written` / `playerdata_index_written` | Initial bounded indexes were exported. | No action; scheduler handoff must still follow. |
| `watchdog_started` | The report and poll watchdog was registered. | Confirm scheduler and poll progress next. |
| `ready_degraded` / `scan_running` | Guard is running while bounded historical scan remains pending. | Caution, not failure; verify progress counters advance. |
| `ready` | Startup and the current bounded scan reached ready state. | Check route proof separately. |
| `scan_failed` / `error` | Startup or scan terminated with a recorded error. | Preserve the named error or status file and diagnose that stage. |
| `running` | The scheduler owns future poll opportunities. | Confirm `poll_id` and `poll_completed_count` advance. |
| `manual_only` | Loop scheduling was unavailable; only explicit work can run. | Treat unattended operation as unavailable. |
| `stopped` | Scheduler operation ended. | Inspect preceding stop and error evidence before restart. |
| `active_log_caught_up` | No unread active-log backlog remains. | Historical scan may proceed. |
| `active_log_unavailable_nonblocking` | The active log was absent, but startup remained non-blocking. | Record the source limit and verify other sources. |
| `active_log_read_failed` | The active log existed but could not be read. | Preserve the error and correct only the proven path or permission issue. |
| `budget_exhausted` / `active_log_has_unread_bytes` | The bounded tail pass stopped with backlog remaining. | Confirm later polls reduce the unread count. |
| `offset_commit_failed_after_events_applied` | Events were processed but durable log offset persistence failed. | Enforcement is deferred; repair offset storage before relying on another cycle. |

## Scheduler, report, and notification codes

| Code or status | Meaning | Safe response |
|---|---|---|
| `poll already in flight` | A second callback arrived while the current poll owned the lifecycle. | Confirm the existing poll advances; do not add another loop owner. |
| `no_log_files_found` | No configured active or backup log was discovered. | Verify Saved root and source configuration. |
| `current_poll_error` | The current cycle recorded a poll-source failure. | Read `runtime/current/poll_error.json`. |
| `cadence_deferred` | The completion dispatcher is not due yet. | Expected until the next bounded opportunity. |
| `reports_disabled` | Public report generation is disabled. | Enable only if reports are intended. |
| `local_outbox_write_failed` | A translated local envelope could not be written. | Repair the runtime output directory; this is not a notification transport error. |
| `source_accounting_disabled` | Route proof cannot claim complete source coverage. | Enable source accounting or accept missing proof explicitly. |
| `route_disabled` | The route is intentionally disabled. | No delivery is expected for that route. |
| `poll_owner_between_polls` | The report worker is queued for the scheduler-owned gap between polls. | Expected only while timestamps and cursors continue advancing. |
| `unsafe_shell_path` | A bounded inventory or shell path failed platform-safe validation. | Correct the path; never weaken quoting or path validation. |

## Related procedures

- [Troubleshooting](TROUBLESHOOTING.md) for symptom classification and repair.
- [Validation and release review](VALIDATION_AND_RELEASE.md) for fixture and
  package failures.
- [Output schema reference](OUTPUT_SCHEMA_REFERENCE.md) for complete field
  contracts.
