# Player Review Workflow

This guide explains how to review one player or account using RandomDayGuard output.

Goal:

```text
Start from a name/account.
Trace identity.
Trace sessions.
Check crash/reconnect behavior.
Check warnings.
Check world context.
Decide INFO, WATCH, REVIEW, BAN-ELIGIBLE, or no action.
```

---

## 1. Start With Account Evidence

Open:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Look for:

```text
account_id
ban_id
name
log_name
connect_id_raw
unique_id
identity_source
identity_confidence
playerdata_verified
status
score
first_seen
last_seen
```

Questions:

```text
Is the account mapped?
Is ban_id clean numeric?
Was PlayerData found?
Is identity_confidence high enough?
Is status INFO, WATCH, REVIEW, BAN-ELIGIBLE, or AUTO-BANNED?
```

If the account is only a display name with no `ConnectID`, do not treat it as enforceable.

---

## 2. Open the Session Timeline

Open:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
```

Filter by:

```text
account_id
ban_id
name
session_id
```

Look for:

```text
SESSION_JOIN
SESSION_LEAVE
SESSION_LIFECYCLE_CLOSE
PLAYER_LOGIN_IDENTITY
PLAYER_JOIN_STATE
PLAYER_LEAVE_STATE
```

Questions:

```text
How many joins?
How many leaves?
Did the player leave cleanly?
Did sessions close because of crash/restart?
Did the account rapidly reconnect?
```

---

## 3. Check Crash / Restart Context

Open:

```text
runtime/server_lifecycle_events.jsonl
runtime/evidence/lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/current_server_epoch.json
```

Look for:

```text
suspected_crash
restart_or_boot
graceful_shutdown
unknown_gap
epoch_id
```

Questions:

```text
Was the account active before a crash?
Did the account return quickly after restart?
Does this repeat across epochs?
Were other accounts active too?
```

One crash overlap is context. Repeated same-account overlap is stronger.

---

## 4. Check Warning Events

Open:

```text
runtime/warning_events.jsonl
runtime/evidence/medium_events.jsonl
runtime/evidence/high_events.jsonl
runtime/evidence/critical_events.jsonl
runtime/warnings/warning_<period>.txt
```

Look for:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove timestamp warnings
high-risk class references
map/path references
```

Questions:

```text
Did warnings happen during this account's session?
Are warnings isolated or repeated?
Are warnings tied to one account or many accounts?
Did warnings overlap crash/reconnect windows?
```

Warning bursts are context until correlated.

---

## 5. Check World / Baseline Context

Open:

```text
runtime/world_state/current/world_state_latest.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/file_manifest.tsv
```

If reviewing one session, open:

```text
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Look for:

```text
world_state_join.json
world_state_latest.json
world_state_leave.json
world_state_diff.json
```

Questions:

```text
Was the world baseline partial or complete?
What object/class context existed?
Did PlayerData or world evidence expose map/path context?
Did class/object deltas overlap the session?
```

Remember:

```text
World context supports review.
It is not automatically direct proof of player action.
```

---

## 6. Check Raid / Multi-Account Context

Open:

```text
runtime/raid_cases/index.jsonl
runtime/raid_cases/RAID-*.json
```

Questions:

```text
Was this account part of a join wave?
Was it active during the same warning/failure window as other accounts?
Is it a central account or only nearby in time?
Does it have account-specific evidence?
```

Do not ban all accounts in a raid case by default.

---

## 7. Check Enforcement Gates

Before any Admin.ini write, confirm:

```text
auto_ban == true
write_admin_ini == true
review_only_mode == false
ban_id is clean numeric
account identity is mapped
trusted/moderator IDs are preserved
account-specific threshold is met
```

If any gate fails, record recommendation only.

---

## 8. Decision Template

Use this format for review notes.

```text
Account:
  <account_id>

Ban ID:
  <ban_id>

Identity source:
  <Login request / PlayerData / mapped presence / unknown>

Identity confidence:
  <confidence>

Sessions reviewed:
  <session IDs>

Crash/restart overlap:
  <none / one-time / repeated>

Reconnect pattern:
  <none / rapid / post-crash / repeated>

Warning context:
  <none / isolated / repeated / session-correlated>

World context:
  <none / partial baseline / completed baseline / PlayerData / object registry>

Raid context:
  <none / case ID / central account / supporting account>

Decision:
  INFO / WATCH / REVIEW / BAN-ELIGIBLE / AUTO-BANNED

Reason:
  <short evidence-based reason>

Limits:
  <what this does not prove>
```

---

## 9. Common Review Outcomes

### INFO

Use when:

```text
normal join/leave
clean session
no repeated warning/crash context
```

### WATCH

Use when:

```text
minor reconnects
unclean disconnect once
weak warning context
identity still being built
```

### REVIEW

Use when:

```text
repeated reconnects
repeated crash overlap
warning bursts overlap mapped sessions
world context needs manual inspection
```

### BAN-ELIGIBLE

Use when:

```text
account-specific thresholds are met
ban_id is clean
trusted/moderator checks pass
evidence is repeated and correlated
```

### AUTO-BANNED

Only when enforcement is explicitly enabled and Admin.ini write succeeded.

---

## 10. Files To Attach To A Review Bundle

Use sanitized copies.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/warnings/warning_<period>.txt
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
runtime/enforced_bans.jsonl if enforcement happened
```

Do not publish raw PlayerData, Admin.ini, server logs, or private account IDs without sanitization.
