<a id="world-save-folder-changes"></a>
# Perubahan folder penyimpanan dunia

> **Sumber kanonis bahasa Inggris:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Gunakan halaman ini ketika folder dunia aktif berubah.

<a id="normal-layout"></a>
## Tata letak normal

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` harus tetap mengarah ke:

```text
AbioticFactor/Saved
```

bukan dunia folder.

<a id="case-1-same-world-renamed"></a>
## Kasus 1: dunia yang sama diganti namanya

Contoh:

```text
Worlds/OldName/
Worlds/NewName/
```

Perilaku yang diharapkan:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Kasus 2: dunia berbeda atau cadangan dipulihkan

Perilaku yang diharapkan:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Kasus 3: pemindaian sebagian sudah ada sebelum perubahan

Perilaku yang diharapkan:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Kasus 4: garis dasar yang sudah selesai sudah ada sebelum perubahan

Perilaku yang diharapkan:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Apa yang harus diperiksa

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Dokumen terkait

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](EKONOMI_MEMORI_DAN_OUTPUT.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](POLA_DAN_KETAHANAN_PELAKU_BURUK.md)
