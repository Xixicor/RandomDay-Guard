# Detection Signals

This document explains RandomDayGuard signals and what they mean.

Signals are not automatically accusations. They are evidence pieces used for review.

---

## Signal Strength Summary

| Signal | Meaning | Stronger when... |
|---|---|---|
| Login identity | Maps name to account/ban ID. | Login request includes ConnectID. |
| Clean leave | Normal session closure. | Join and leave match same mapped account. |
| Rapid reconnect | Possible churn/probing. | Repeats in short windows. |
| Unclean disconnect | Session ended without clean leave. | Repeats or overlaps crashes. |
| Crash overlap | Account active near crash/restart. | Repeats across epochs. |
| Post-crash return | Account reconnects after restart. | Same account repeats quickly after crashes. |
| Warning burst | Server warning/anomaly window. | Tied to mapped session and repeated. |
| Actor save touch | World save/class context. | Correlated with sessions, warnings, deltas. |
| Object delta | World/class count changed. | Correlated with account sessions. |
| Raid case | Multi-account timing cluster. | Central account has repeated specific evidence. |

---

## Login Identity

Source:

```text
Saved/Logs/AbioticFactor.log
Login request
Name=
ConnectID=
UniqueId=
```

Purpose:

```text
Map display/log name to account_id and ban_id.
```

Strong evidence for:

```text
identity mapping
Admin.ini clean ID extraction
session attribution
```

Not enough for:

```text
ban by itself
```

---

## Join / Leave

Source:

```text
has entered the facility
has exited the facility
```

Purpose:

```text
Create session timeline.
```

Files:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/current/session_state.json
```

Meaning:

```text
Normal join/leave with clean leave is INFO.
```

---

## Rapid Reconnect

Pattern:

```text
join -> leave -> join -> leave -> join
```

Purpose:

```text
Detect churn or probing.
```

Stronger when:

```text
repeated in a short window
same account repeats
overlaps warning/failure windows
```

Safety:

```text
Churn alone should not auto-ban by default.
```

---

## Crash Overlap

Pattern:

```text
account active
server crash/restart/unknown gap
session closes uncleanly or epoch changes
```

Purpose:

```text
Identify accounts active near crash windows.
```

Stronger when:

```text
same account overlaps multiple crashes
same account reconnects quickly after restart
```

Safety:

```text
One crash is not enough for auto-ban.
```

---

## Post-Crash Return

Pattern:

```text
server restarts
same account joins within grace window
```

Purpose:

```text
Detect repeated return-after-crash patterns.
```

Files:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/session_events.jsonl
runtime/account_evidence.json
```

---

## Warning Bursts

Examples:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove timestamp warnings
```

Purpose:

```text
Group repeated server warnings by time/session/context.
```

Stronger when:

```text
repeated
mapped to same session window
same account appears in multiple warning windows
warning window overlaps crash/reconnect behavior
```

Safety:

```text
One warning burst is not enough for auto-ban.
```

---

## Actor Save Touch

Pattern:

```text
UpdateActorToWorldSave
Deployed_...
Container_...
PowerSocket...
```

Purpose:

```text
Record world-save class/context evidence.
```

Meaning:

```text
The server evidence referenced that actor/class.
```

Not meaning:

```text
A specific player opened it.
A specific player stole from it.
A specific player duplicated through it.
A specific player damaged it.
```

---

## Object / Class Deltas

Source:

```text
object_registry.json
object_registry_counts.tsv
class_deltas.jsonl
baseline manifest
```

Purpose:

```text
Compare world/class tokens over time.
```

Stronger when:

```text
large or repeated deltas
high-risk classes involved
deltas overlap mapped sessions
deltas overlap warning/crash windows
```

Safety:

```text
Object count alone is not a ban reason.
```

---

## Raid / Cluster Context

Source:

```text
runtime/raid_cases/index.jsonl
runtime/raid_cases/RAID-*.json
```

Purpose:

```text
Group accounts that appear around same join wave, warning window, failure window, or reconnect pattern.
```

Safety:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

---

## Score Interpretation

Common statuses:

| Status | Meaning |
|---|---|
| INFO | Normal or low-context evidence. |
| WATCH | Worth watching, not enough for review. |
| REVIEW | Admin should inspect. |
| BAN-ELIGIBLE | Thresholds met, but write gates still apply. |
| AUTO-BANNED | Enforcement enabled and Admin.ini was written. |

Do not treat score as proof. Score is a routing mechanism for review and enforcement gates.
