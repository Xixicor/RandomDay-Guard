# Player review workflow

Use this page when reviewing one player or account.

## Quick path

```text
1. Open account_evidence.json
2. Check identity confidence and ban_id
3. Open session_events.jsonl
4. Check joins/leaves/unclean closes
5. Open lifecycle events
6. Check crash/reconnect overlap
7. Open warning events
8. Check warning overlap
9. Open world/session context if needed
10. Decide INFO / WATCH / REVIEW / BAN-ELIGIBLE
```

## 1. Start with the account

Open:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Check:

```text
account_id
ban_id
name
identity_source
identity_confidence
playerdata_verified
status
score
first_seen
last_seen
```

Do not enforce from a display name only.

## 2. Check the session timeline

Open:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
```

Look for:

```text
SESSION_JOIN
SESSION_LEAVE
SESSION_LIFECYCLE_CLOSE
clean_leave
leave_reason
session_id
epoch_id
```

Questions:

```text
Did the player leave cleanly?
Did sessions close during crash/restart?
Did the account reconnect quickly?
```

## 3. Check crash context

Open:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
```

Questions:

```text
Was the account active before a crash?
Did it return after restart?
Does that repeat?
```

One crash is context. Repeated same-account patterns matter more.

## 4. Check warnings

Open:

```text
runtime/warning_events.jsonl
runtime/evidence/high_events.jsonl
runtime/evidence/critical_events.jsonl
runtime/warnings/
```

Questions:

```text
Did warnings happen during the session?
Were warnings repeated?
Were they tied to the same mapped account?
```

## 5. Check world context

Open:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Use this for context, not unsupported accusations.

## 6. Check daily rollup

Open:

```text
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

These files give the quick daily view.

## 7. Make a decision

| Decision | Use when |
|---|---|
| INFO | Normal session, no meaningful pattern |
| WATCH | Weak signal, one-off issue, or incomplete mapping |
| REVIEW | Repeated suspicious pattern or correlated context |
| BAN-ELIGIBLE | Thresholds and account-specific evidence are met |
| AUTO-BANNED | Enforcement enabled and Admin.ini write succeeded |

## Review note template

```text
Account:
Ban ID:
Name:
Identity confidence:
Sessions reviewed:
Crash/reconnect pattern:
Warning context:
World context:
Raid/cluster context:
Decision:
Reason:
Limits:
Files used:
```

## Related docs

* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`DETECTION_SIGNALS.md`](DETECTION_SIGNALS.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
