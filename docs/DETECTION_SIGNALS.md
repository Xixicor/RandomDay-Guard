# Detection signals

Signals are review inputs, not automatic accusations.

## Signal table

| Signal | Meaning | Stronger when... | Not enough by itself |
|---|---|---|---|
| Login identity | Maps name to account ID | ConnectID is present | Ban |
| Clean leave | Normal session closure | Join and leave match | Suspicion |
| Rapid reconnect | Churn/probing context | Repeats quickly | Ban |
| Unclean disconnect | Session did not close cleanly | Repeats or overlaps crashes | Ban |
| Crash overlap | Account active near crash | Same account repeats | Ban |
| Post-crash return | Account returns after restart | Repeats across epochs | Ban by one event |
| Warning burst | Server warning window | Overlaps mapped sessions | Ban by one burst |
| Actor save touch | World-save context | Correlates with sessions | Proof of use/theft |
| Object delta | World/class change | Correlates with sessions | Ban from count alone |
| Raid case | Multi-account cluster | Central account repeats | Mass-ban all accounts |

## Login identity

Best source:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Use it to map:

```text
display/log name -> account_id -> ban_id
```

## Rapid reconnect

Pattern:

```text
join -> leave -> join -> leave -> join
```

Use for review when repeated.

Safety:

```text
churn_alone_never_bans = true
```

## Crash overlap and post-crash return

Pattern:

```text
account active before crash
server restarts
same account returns quickly
```

Use for review when repeated across epochs.

Safety:

```text
single_crash_never_bans = true
```

## Warning bursts

Examples:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Use as context until linked to mapped sessions and thresholds.

## Actor save touch

Meaning:

```text
The server evidence referenced a class or actor.
```

Not meaning:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

## Raid cases

A raid case groups accounts by timing and shared windows.

Rule:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

## Related docs

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](BAD_ACTOR_PATTERNS_AND_RESILIENCE.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
