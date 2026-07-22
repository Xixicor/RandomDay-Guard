<a id="bad-actor-patterns-and-resilience"></a>
# Pola dan ketahanan pelaku buruk

> **Sumber kanonis bahasa Inggris:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Gunakan halaman ini untuk memahami bagaimana penjaga membantu meninjau penyalahgunaan error, perilaku yang berhubungan dengan eksploitasi, dan perencanaan pemulihan.

<a id="what-the-guard-can-help-with"></a>
## Apa yang dapat dibantu oleh penjaga

| Pola | Apa yang harus diperiksa |
|---|---|
| Pengembalian yang berkorelasi dengan error | Akun yang sama aktif sebelum error dan kembali setelah restart |
| Pemeriksaan koneksi ulang secara cepat | Perulangan join/leave atau timeout/reconnect berulang |
| Kluster multi-akun | Gelombang gabungan, jendela peringatan bersama, jendela kegagalan bersama |
| Peringatan stres yang meledak | Perulangan ActorChannelFailure atau jendela peringatan penyimpanan |
| Konteks di luar batas | PlayerData/map/world konteks saat dapat dibaca |
| Save-touch overlap | Konteks penyelamatan dunia tumpang tindih dengan sesi yang dipetakan |
| Kebingungan identitas | Nama yang memerlukan pemetaan ConnectID |

<a id="why-it-avoids-memory-access"></a>
## Mengapa ia menghindari akses memori

RandomDayGuard berfungsi dari file milik server:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Hal ini membuatnya tidak terlalu bergantung pada status memori sisi klien dan tidak terlalu rapuh di seluruh update game.

Tradeoff:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Pengembalian yang berkorelasi dengan error

Pola:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

File yang berguna:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Rapid sambungkan kembali probe

Pola:

```text
join -> leave -> join -> leave -> join
```

File yang berguna:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Kluster multi-akun

Pola:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

File yang berguna:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Aturan:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Rekomendasi pencadangan tempel

Buat cadangan tempel setelah:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Pencadangan:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Model pemulihan

```text
Clean install
-> verify live defense
-> complete first baseline
-> create sticky backup
-> run server normally
-> use daily rollups for review
-> restore sticky backup if needed
```

<a id="related-docs"></a>
## Dokumen terkait

* [`FORENSIC_DAILY_ROLLUPS.md`](ROLLUP_HARIAN_FORENSIK.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](ALUR_KERJA_TINJAUAN_PEMAIN.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](PERUBAHAN_FOLDER_PENYIMPANAN_DUNIA.md)
