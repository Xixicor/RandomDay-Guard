<a id="world-save-folder-changes"></a>
# Modifications du dossier de sauvegarde du monde

> **Source canonique en anglais:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Utilisez cette page lorsque le dossier du monde actif change.

<a id="normal-layout"></a>
## La présentation normale

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` doit toujours pointer vers :

```text
AbioticFactor/Saved
```

pas le dossier du monde.

<a id="case-1-same-world-renamed"></a>
## Cas 1 : même monde renommé

Exemple :

```text
Worlds/OldName/
Worlds/NewName/
```

Comportement attendu :

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Cas 2 : monde différent ou sauvegarde restaurée

Comportement attendu :

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Cas 3 : une analyse partielle existait avant le changement

Comportement attendu :

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Cas 4 : une ligne de base terminée existait avant le changement

Comportement attendu :

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Que vérifier

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Documents associés

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](%C3%89CONOMIE_DE_M%C3%89MOIRE_ET_SORTIES.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](MOD%C3%88LES_D_ACTEURS_MALVEILLANTS_ET_R%C3%89SILIENCE.md)
