<a id="world-save-folder-changes"></a>
# Änderungen des Weltspeicherordners

> **Kanonisch-englische Quelle:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Verwenden Sie diese Seite, wenn sich der aktive Weltordner ändert.

<a id="normal-layout"></a>
## Normales Layout

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` sollte weiterhin auf Folgendes verweisen:

```text
AbioticFactor/Saved
```

nicht auf den Weltordner.

<a id="case-1-same-world-renamed"></a>
## Fall 1: Dieselbe Welt umbenannt

Beispiel:

```text
Worlds/OldName/
Worlds/NewName/
```

Erwartetes Verhalten:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Fall 2: andere Welt oder wiederhergestelltes Backup

Erwartetes Verhalten:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Fall 3: Teilscan existierte vor der Änderung

Erwartetes Verhalten:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Fall 4: abgeschlossene Baseline existierte vor der Änderung

Erwartetes Verhalten:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Was zu überprüfen ist

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Verwandte Dokumente

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](SPEICHER%C3%96KONOMIE_UND_AUSGABEN.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](BAD_ACTOR_PATTERNS_AND_RESILIENCE.md)
