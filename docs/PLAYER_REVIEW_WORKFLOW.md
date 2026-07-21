# Player review workflow

Use this page for one player, account, or case. The purpose is a reproducible review decision, not an automated accusation.

## Quick path

1. Open `runtime/final_logs/player_activity_latest.json`.
2. Confirm the route status in `runtime/final_logs/route_proof.json`.
3. Identify which observations are current and which are historical.
4. Check the cited identity and session source references.
5. Review `case_review_latest.json` when a correlated case exists.
6. Record unknowns and `does_not_prove` before choosing an action.
7. Leave enforcement disabled unless the separate enforcement gates are proven.

## 1. Confirm route proof

Interpret the player route as:

| Status | Action |
|---|---|
| `full` | Continue, while still reviewing source limits. |
| `limited_expected_empty` | Continue only with the subjects actually present; do not invent a missing player or case. |
| `missing` | Stop the player decision and troubleshoot the route. |

A healthy scheduler does not replace route proof.

## 2. Establish identity

Prefer a clean account identifier corroborated by server-exposed identity evidence and, where available, PlayerData filenames. Keep the raw source reference.

Do not enforce from:

- a display name alone;
- a name seen in a notification or hosting panel;
- timing similarity;
- an unmapped or weak-confidence identity;
- a historical report without current corroboration.

## 3. Separate current from historical

Current evidence describes the active reporting window or server epoch. Historical evidence may explain a pattern, but it cannot silently fill gaps in the current window.

Record both scopes independently:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

## 4. Review observations and interpretation

Read these report sections distinctly:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Re-open the cited structured evidence for any material decision. A translation is navigation and explanation, not new evidence.

## 5. Calibrate the decision

| Decision | Use when |
|---|---|
| `INFO` | Normal or low-context observation. |
| `WATCH` | Weak or incomplete signal worth monitoring. |
| `REVIEW` | Correlated evidence needs administrator judgment. |
| `BAN-ELIGIBLE` | Clean identity and configured evidence thresholds are met; write gates still apply. |
| `AUTO-BANNED` | Enforcement was explicitly enabled and backup, write, readback, and audit all succeeded. |

No decision label proves guilt or intent.

## 6. Apply the evidence boundary

Crashes, reconnects, warnings, object/class tokens, and case grouping can support review. Alone, they do not prove cheating, theft, duplication, ownership, direct damage, or incident causation.

If identity, parsing, backup, write, readback, or rollback is weak or fails, enforcement must fail closed.

## Review note template

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

## Related docs

- [`EVIDENCE_BOUNDARY.md`](EVIDENCE_BOUNDARY.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)
- [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
- [`DETECTION_SIGNALS.md`](DETECTION_SIGNALS.md)
