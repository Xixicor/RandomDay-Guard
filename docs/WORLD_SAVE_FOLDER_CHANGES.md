# World save folder changes

Use this page when the active world folder changes.

## Normal layout

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` should still point to:

```text
AbioticFactor/Saved
```

not the world folder.

## Case 1: same world renamed

Example:

```text
Worlds/OldName/
Worlds/NewName/
```

Expected behavior:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

## Case 2: different world or restored backup

Expected behavior:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

## Case 3: partial scan existed before the change

Expected behavior:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

## Case 4: completed baseline existed before the change

Expected behavior:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

## What to check

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

## Related docs

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](MEMORY_ECONOMY_AND_OUTPUTS.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](BAD_ACTOR_PATTERNS_AND_RESILIENCE.md)
