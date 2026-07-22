<a id="world-save-folder-changes"></a>
# Համաշխարհային պահումների թղթապանակի փոփոխություններ

> **Կանոնական անգլերեն աղբյուր:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Այս տեղայնացված փաստաթուղթը պահպանում է ճշգրիտ հրամաններ, ուղիներ, բանալիներ, կարգավիճակի արժեքներ, հեշեր և ֆայլերի անուններ: Եթե ​​տեխնիկական ձևակերպումը տարբերվում է, օգտագործեք անգլերեն աղբյուրը:


Օգտագործեք այս էջը, երբ աշխարհի ակտիվ պանակը փոխվի:

<a id="normal-layout"></a>
## Նորմալ դասավորություն

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` դեռևս պետք է մատնանշի`

```text
AbioticFactor/Saved
```

համաշխարհային թղթապանակը չէ:

<a id="case-1-same-world-renamed"></a>
## Դեպք 1. նույն աշխարհը վերանվանվել է

Օրինակ՝

```text
Worlds/OldName/
Worlds/NewName/
```

Սպասվող վարքագիծ.

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Դեպք 2. տարբեր աշխարհ կամ վերականգնված պահուստավորում

Սպասվող վարքագիծ.

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Դեպք 3. մասնակի սկան գոյություն է ունեցել նախքան փոփոխությունը

Սպասվող վարքագիծ.

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Դեպք 4. լրացված բազային գիծը եղել է մինչև փոփոխությունը

Սպասվող վարքագիծ.

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Ինչ ստուգել

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Առնչվող փաստաթղթեր

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](%D5%80%D4%BB%D5%87%D5%88%D5%82%D5%88%D5%92%D4%B9%D5%85%D4%B1%D5%86_%D5%8F%D5%86%D5%8F%D4%B5%D5%8D%D5%88%D5%92%D4%B9%D5%85%D5%88%D5%92%D5%86_%D4%B5%D5%92_%D4%B1%D5%90%D4%B4%D5%85%D5%88%D5%92%D5%86%D5%94%D5%86%D4%B5%D5%90.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](%D4%B4%D4%B5%D5%90%D4%B1%D5%8D%D4%B1%D5%86%D4%BB_%D5%8E%D4%B1%D5%8F_%D5%95%D5%90%D4%BB%D5%86%D4%B1%D5%89%D4%B1%D5%93%D5%88%D5%92%D4%B9%D5%85%D5%88%D5%92%D5%86%D5%86%D4%B5%D5%90_%D4%B5%D5%92_%D5%83%D4%BF%D5%88%D5%92%D5%86%D5%88%D5%92%D4%B9%D5%85%D5%88%D5%92%D5%86.md)
