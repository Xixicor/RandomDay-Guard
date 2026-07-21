# Glossary

| Term | Plain meaning | Exact technical meaning |
|---|---|---|
| Active log | The current server log used for fresh evidence. | Required `active_log` source; readability plus current lineage is needed for route completion. |
| Boot ID | One watchdog process start. | Current runtime identifier used to reject prior-boot errors/reports. |
| Epoch ID | One server continuity interval. | Identifier spanning normal runtime until continuity logic starts another epoch. |
| Poll ID | One bounded poll opportunity. | Positive monotonic cycle field; zero/missing cannot complete a route. |
| Source freshness | Whether current source and poll lineage agree. | `fresh_current_poll` or `stale_or_unproven` with timestamps and active-log status. |
| Source accounting | Inventory of evidence availability and limits. | `randomdayguard.source-accounting/v1` with eight source classes and current/historical scope. |
| `available` | A source was found and read. | Terminal source status with `available=true`, `readable=true`. |
| `expected_empty` | An optional source was checked and legitimately absent/empty. | Terminal readable source status; never manufactures a subject. |
| `partial` | Bounded work has useful but incomplete results. | Nonterminal source/accounting status; resume the owning worker. |
| `deferred` | Work is intentionally pending. | Nonterminal source status; not an error or completion. |
| `unavailable` | The source cannot currently be used. | Terminal gap; a required-source gap makes accounting unavailable. |
| `malformed` | A source exists but is structurally invalid. | Terminal gap preserving validation detail and closing dependent writes. |
| `permission_denied` | The OS explicitly rejected access. | Terminal gap distinct from missing/unavailable. |
| `error` | A bounded operation failed unexpectedly. | Terminal failure requiring the named recovery; no secret detail belongs in public reports. |
| `complete` | All accounted sources are terminal with no gap. | Top-level source accounting status. |
| `complete_with_gaps` | Required current evidence works; optional terminal gaps remain. | Top-level accounting status; routes still apply their own requirements. |
| `full` | A route completed with its required non-empty contract. | Route proof enum with completed current-cycle outputs. |
| `limited_expected_empty` | A route completed and found no eligible subject/failure. | Route proof enum with `completed=true`, `expected_empty=true`. |
| `missing` | Route completion proof is absent or failed. | Route proof enum with `completed=false`; never eligible for outbox. |
| Structured report | Machine-readable route output. | `<route>_latest.json` using `randomdayguard.report/v1`. |
| Translated report | Human-readable rendering of the same route. | `<route>_latest.txt` with fixed Observed-to-Source-references order. |
| Route proof | Cross-route completion ledger. | `route_proof.json` binding version/boot/epoch/poll/freshness/output paths. |
| Current evidence | Observation owned by the active cycle. | Scope `current`; not reconstructed from old filenames/reports. |
| Historical evidence | Retained context from earlier cycles or slow scan. | Scope `historical`; may inform review but cannot claim current presence. |
| Review-only | Produce review evidence without Admin.ini writes. | Default `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| Ban-list safety check | One question Guard must answer before it may change `Admin.ini`. | It must confirm the account and score, exclude trusted accounts and duplicates, verify a backup, detect outside changes, save the intended update, and verify or safely restore the complete file. |
| Local outbox | Optional provider-neutral notification handoff. | JSON files with `delivery_backend="none"` and `delivery_attempted=false`. |
| Baseline | Completed bounded Saved-file context snapshot. | Manifest/object/world state reused only when compatible and fresh enough. |
| Checkpoint | Resume position for incomplete scan work. | `scan_checkpoint.json`; deletion is not the default recovery. |
| Rebuildable index | Summary that can be regenerated. | Daily/weekly/forensic/final review output; source evidence remains authoritative. |
| Evidence boundary | Limit on what a source can support. | Explicit `does_not_prove`, unknowns, identity strength, and scope rules. |

Canonical definitions for schemas are in
[`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md); configuration terms
are in [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md).
