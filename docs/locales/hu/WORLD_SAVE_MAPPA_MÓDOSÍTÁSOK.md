<a id="world-save-folder-changes"></a>
# Változások a világszintű mentési mappákban

> **Kanonikus angol forrás:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Használja ezt az oldalt, ha megváltozik az aktív világ mappa.

<a id="normal-layout"></a>
## Normál elrendezés

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` továbbra is a következőre kell mutatnia:

```text
AbioticFactor/Saved
```

nem a világmappa.

<a id="case-1-same-world-renamed"></a>
## 1. eset: ugyanaz a világ átnevezve

Példa:

```text
Worlds/OldName/
Worlds/NewName/
```

Várható viselkedés:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## 2. eset: más világ vagy visszaállított biztonsági másolat

Várható viselkedés:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## 3. eset: részleges vizsgálat létezett a változás előtt

Várható viselkedés:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## 4. eset: A befejezett alapvonal a változás előtt létezett

Várható viselkedés:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Mit kell ellenőrizni

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](MEM%C3%93RIATAKAR%C3%89KOSS%C3%81G_%C3%89S_KIMENETEK.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](ROSSZ_SZ%C3%8DN%C3%89SZI_MINT%C3%81K_%C3%89S_RUGALMASS%C3%81G.md)
