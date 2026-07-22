<a id="world-save-folder-changes"></a>
# Dünya kaydetme klasörü değişiklikleri

> **Kanonik İngilizce kaynağı:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Etkin dünya klasörü değiştiğinde bu sayfayı kullanın.

<a id="normal-layout"></a>
## Normal düzen

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` yine de şunu göstermelidir:

```text
AbioticFactor/Saved
```

dünyayı değil folder.

<a id="case-1-same-world-renamed"></a>
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

<a id="case-2-different-world-or-restored-backup"></a>
## Durum 2: farklı dünya veya geri yüklenen yedekleme

Expected behavior:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Durum 3: değişiklikten önce kısmi tarama mevcuttu

Expected behavior:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Durum 4: değişiklikten önce tamamlanmış temel mevcuttu

Expected behavior:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Kontrol edilmesi gerekenler

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## İlgili belgeler

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](BELLEK_EKONOMISI_VE_%C3%87IKI%C5%9ELAR.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](K%C3%96T%C3%9C_AKT%C3%96R_KALIPLARI_VE_DAYANIKLILIK.md)
