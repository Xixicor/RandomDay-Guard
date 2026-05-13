# World Save Folder Changes

RandomDayGuard supports one active world folder under:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` should point to `Saved/`, not to `<WorldName>`.

When the active world folder changes:

- Same world renamed: reuse baseline data where file fingerprints match.
- Different/restored world: create a new baseline generation.
- Incomplete checkpoint plus changed world: mark the checkpoint stale and preserve the old partial evidence.
- Completed baseline plus changed world: load the previous completed baseline for visibility and safely build a new baseline.

Partial `world_state_latest.json` files must say `scan_complete=false`. Final outputs become authoritative only after `scan_complete.json` and `last_completed_baseline.json` are written.
