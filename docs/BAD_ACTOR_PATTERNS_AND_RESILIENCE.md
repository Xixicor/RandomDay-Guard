# Bad-actor patterns and resilience

Use this page to understand how the guard helps review crash abuse, exploit-adjacent behavior, and recovery planning.

## What the guard can help with

| Pattern | What to check |
|---|---|
| Crash-correlated returns | Same account active before crashes and returning after restart |
| Rapid reconnect probing | Repeated join/leave or timeout/reconnect loops |
| Multi-account clusters | Join waves, shared warning windows, shared failure windows |
| Warning burst stress | Repeated ActorChannelFailure or save-warning windows |
| Out-of-bounds context | PlayerData/map/world context when readable |
| Save-touch overlap | World-save context overlapping mapped sessions |
| Identity confusion | Names that need ConnectID mapping |

## Why it avoids memory access

RandomDayGuard works from server-owned files:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

That makes it less dependent on client-side memory state and less fragile across game updates.

Tradeoff:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

## Crash-correlated returners

Pattern:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Useful files:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

## Rapid reconnect probers

Pattern:

```text
join -> leave -> join -> leave -> join
```

Useful files:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

## Multi-account clusters

Pattern:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Useful files:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Rule:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

## Sticky backup recommendation

Create a sticky backup after:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Back up:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

## Recovery model

```text
Clean install
-> verify live defense
-> complete first baseline
-> create sticky backup
-> run server normally
-> use daily rollups for review
-> restore sticky backup if needed
```

## Related docs

* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](WORLD_SAVE_FOLDER_CHANGES.md)
