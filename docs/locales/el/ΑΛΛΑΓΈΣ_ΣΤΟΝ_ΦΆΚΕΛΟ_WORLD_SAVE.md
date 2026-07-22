<a id="world-save-folder-changes"></a>
# Αλλαγές φακέλων παγκόσμιας αποθήκευσης

> **Κανονική αγγλική πηγή:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Αυτή η τοπική τεκμηρίωση διατηρεί ακριβείς εντολές, διαδρομές, κλειδιά, τιμές κατάστασης, κατακερματισμούς και ονόματα αρχείων. Εάν η τεχνική διατύπωση διαφέρει, χρησιμοποιήστε την αγγλική πηγή.


Χρησιμοποιήστε αυτήν τη σελίδα όταν αλλάζει ο φάκελος του ενεργού κόσμου.

<a id="normal-layout"></a>
## Κανονική διάταξη

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` θα πρέπει να δείχνει ακόμα:

```text
AbioticFactor/Saved
```

όχι ο παγκόσμιος φάκελος.

<a id="case-1-same-world-renamed"></a>
## Περίπτωση 1: μετονομάστηκε ο ίδιος κόσμος

Παράδειγμα:

```text
Worlds/OldName/
Worlds/NewName/
```

Αναμενόμενη συμπεριφορά:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Περίπτωση 2: διαφορετικός κόσμος ή επαναφορά αντιγράφου ασφαλείας

Αναμενόμενη συμπεριφορά:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Περίπτωση 3: υπήρχε μερική σάρωση πριν από την αλλαγή

Αναμενόμενη συμπεριφορά:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Περίπτωση 4: η ολοκληρωμένη γραμμή βάσης υπήρχε πριν από την αλλαγή

Αναμενόμενη συμπεριφορά:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Τι να ελέγξετε

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Σχετικά έγγραφα

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](%CE%9F%CE%99%CE%9A%CE%9F%CE%9D%CE%9F%CE%9C%CE%8A%CE%91_%CE%9C%CE%9D%CE%89%CE%9C%CE%97%CE%A3_%CE%9A%CE%91%CE%99_%CE%88%CE%9E%CE%9F%CE%94%CE%9F%CE%99.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](%CE%9A%CE%91%CE%9A%CE%86_%CE%A0%CE%A1%CE%8C%CE%A4%CE%A5%CE%A0%CE%91_%CE%97%CE%98%CE%9F%CE%A0%CE%9F%CE%99%CE%8F%CE%9D_%CE%9A%CE%91%CE%99_%CE%91%CE%9D%CE%98%CE%95%CE%9A%CE%A4%CE%99%CE%9A%CE%8C%CE%A4%CE%97%CE%A4%CE%91.md)
