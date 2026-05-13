# Evidence boundary

Use this page to understand what RandomDayGuard can and cannot claim.

## Core rule

RandomDayGuard records what the server exposes through logs and Saved files.

If a fact does not appear in readable server evidence, the guard should not present it as proof.

## Strong evidence

| Evidence | Usually supports |
|---|---|
| Login request with ConnectID | Identity mapping |
| Join/leave lines | Session timeline |
| Crash/restart markers | Lifecycle context |
| Repeated same-account crash returns | Review signal |
| PlayerData ID file | ID existence |
| World/class tokens | World context |
| Clean Admin.ini write audit | Enforcement history |

## Context evidence

These can support review but are not direct proof by themselves:

```text
ActorChannelFailure
UpdateActorToWorldSave
object/class counts
map/path strings
raid case membership
one crash
one warning burst
rapid reconnect churn
```

## Claims that require direct evidence

Do not claim these unless logs or Saved files directly expose them:

```text
exact live coordinates
direct item duplication
direct object damage
direct container use
item theft
inventory actions
object ownership
live ping
memory-level behavior
```

## Practical wording

Use:

```text
The account overlapped a crash window.
The evidence references a deployed container class.
The session had repeated reconnects.
The baseline was partial.
```

Avoid:

```text
The player stole from the container.
The player duplicated items.
The player damaged the object.
The player used cheat memory.
```

unless direct evidence exists.

## Related docs

* [`DETECTION_SIGNALS.md`](DETECTION_SIGNALS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
