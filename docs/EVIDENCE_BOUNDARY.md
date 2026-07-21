# Evidence boundary

Use this page to decide what RandomDayGuard can report and what still requires human review.

## Core rule

RandomDayGuard records bounded observations from server-owned files. It must identify the source, scope, collection state, and limits for every material conclusion.

Structured evidence is authoritative. A translated report explains the evidence; it cannot add facts that are absent from the structured record.

## Evidence source classes

| Source class | Typical use | Does not prove by itself |
|---|---|---|
| `admin_ini` | Existing administration state and audited write/readback context | Who caused an incident |
| `active_log` | Current server/session events visible in the active log | Intent, ownership, or direct damage |
| `recent_backup_logs` | Historical log context | A current event occurred |
| `playerdata_filenames` | Corroboration that a clean account identifier exists | Behavior, guilt, or identity ownership beyond the exposed identifier |
| `existing_cases` | Prior review context | That a prior interpretation remains correct |
| `existing_reports` | Earlier summaries and decisions | Current truth without current corroboration |
| `existing_evidence` | Historical structured evidence | Current activity |
| bounded world-save scan | Slow world/class context | Player action, ownership, theft, duplication, or damage |

Each source records availability/readability, file count, source references, current or historical scope, and an explicit `does_not_prove` statement.

## Source states

| State | Operator meaning |
|---|---|
| `available` | The source was readable and evidence was collected. |
| `expected_empty` | The source was readable and legitimately had no matching record. |
| `partial` | Some evidence was collected; coverage is incomplete. |
| `deferred` | Bounded work was intentionally postponed. |
| `unavailable` | The source is not present in this environment. |
| `malformed` | The source exists but cannot be parsed safely. |
| `permission_denied` | The watchdog lacks read permission. |
| `error` | Collection failed for another recorded reason. |

Expected empty is a valid observation. It must never be converted into a fabricated player, case, incident, or accusation.

## Current versus historical evidence

Current evidence belongs to the active collection window or server epoch. Historical evidence comes from prior logs, cases, reports, evidence records, backups, or baselines.

Historical evidence can provide context. It cannot silently fill a current-evidence gap. Reports must label both scopes and cite their sources separately.

## Corroboration rule

These are useful context but are not direct proof by themselves:

- display names or name similarity;
- timing coincidence;
- disconnect or reconnect churn;
- one crash or warning burst;
- class, path, actor, map, or object-count tokens;
- membership in an automatically grouped case;
- prior reports without current source confirmation.

Do not claim guilt, intent, cheating, ownership, theft, duplication, direct damage, direct container use, direct inventory action, exact live coordinates, live ping, or memory-level behavior without evidence that directly exposes the fact.

## Truthful report language

Use:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Avoid:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

## Report reading order

Every public-facing report should explain:

1. Plain meaning.
2. Why it matters.
3. Technical proof and source references.
4. Next action.
5. Limits, unknowns, and claims not proved.

## Related docs

- [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
- [`BAN_ID_MAPPING.md`](BAN_ID_MAPPING.md)
- [`DETECTION_SIGNALS.md`](DETECTION_SIGNALS.md)
