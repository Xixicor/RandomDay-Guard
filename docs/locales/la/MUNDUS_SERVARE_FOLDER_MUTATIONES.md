<a id="world-save-folder-changes"></a>
# Mundus nisi folder mutationes

> **Canonicum Anglicum fontem:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


 Hac pagina utere cum mutationibus folder mundi activae.

<a id="normal-layout"></a>
## Northalis layout

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` adhuc designare debet:

```text
AbioticFactor/Saved
```

non mundi folder.

<a id="case-1-same-world-renamed"></a>
## Case 1: idem mundus appellatus est

Exemple:

```text
Worlds/OldName/
Worlds/NewName/
```

Moribus Expectatur:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Casus 2: mundus diversus vel restitutus tergum

Moribus Expectatur:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Casus 3: scan partialis ante mutationem

Moribus Expectatur:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Case 4: peracta basilinea ante mutationem

Moribus Expectatur:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Quae reprimendam

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Related docs

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](MEMORIA_OECONOMIA_ET_OUTPUTS.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](MALA_ACTOR_PATTERNS_ET_RESILIENTIAE.md)
