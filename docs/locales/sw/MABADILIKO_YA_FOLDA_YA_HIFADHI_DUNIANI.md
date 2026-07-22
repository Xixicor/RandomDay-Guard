<a id="world-save-folder-changes"></a>
# Mabadiliko ya folda ya hifadhi ya dunia

> **Chanzo cha Kiingereza cha Canonical:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Tumia ukurasa huu folda inayotumika ya ulimwengu inapobadilika.

<a id="normal-layout"></a>
## Mpangilio wa kawaida

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` bado inapaswa kuelekeza kwenye:

```text
AbioticFactor/Saved
```

si folda ya ulimwengu.

<a id="case-1-same-world-renamed"></a>
## Kesi ya 1: ulimwengu sawa umebadilishwa jina

Mfano:

```text
Worlds/OldName/
Worlds/NewName/
```

Tabia inayotarajiwa:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Kesi ya 2: ulimwengu tofauti au hifadhi rudufu iliyorejeshwa

Tabia inayotarajiwa:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Kesi ya 3: uchunguzi wa sehemu ulikuwepo kabla ya mabadiliko

Tabia inayotarajiwa:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Kesi ya 4: msingi uliokamilika ulikuwepo kabla ya mabadiliko

Tabia inayotarajiwa:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Cha kuangalia

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Nyaraka zinazohusiana

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](UCHUMI_WA_KUMBUKUMBU_NA_MATOKEO.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](MIUNDO_NA_USTAHIMILIVU_MBAYA_WA_WAIGIZAJI.md)
