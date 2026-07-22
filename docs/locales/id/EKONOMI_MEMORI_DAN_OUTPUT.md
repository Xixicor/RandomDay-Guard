<a id="memory-economy-and-output-files"></a>
# Ekonomi memori dan file keluaran

> **Sumber kanonis bahasa Inggris:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Halaman ini menjelaskan file mana yang berkembang, file mana yang ditimpa, dan apa yang harus diunggah untuk ditinjau dengan cepat.

<a id="fast-answer"></a>
## Jawaban cepat

| Pertanyaan | Buka |
|---|---|
| Apakah penjaganya masih hidup? | `runtime/current/poll_status.json` |
| Siapa yang terlihat? | `runtime/account_evidence.json` |
| Apa yang terjadi dengan sesi? | `runtime/evidence/session_events.jsonl` |
| Apa yang terjadi hari ini? | `runtime/forensic_days/YYYY-MM-DD/` |
| Apa yang dimaksud dengan ringkasan bahasa sederhana? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| Apa yang dimaksud dengan kemajuan pemindaian? | `runtime/scan_progress.json` |
| Apa konteks dunianya? | `runtime/world_state/current/world_state_latest.json` |
| Larangan apa yang ditulis? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Model keluaran

| Ketik | Perilaku | Contoh |
|---|---|---|
| Saat ini snapshots | Ditimpa | `runtime/current/*.json` |
| Log peristiwa | Hanya tambahan | `runtime/evidence/*.jsonl` |
| Tabel | Diperbarui atau ditambahkan | `*.tsv` |
| Garis dasar | Digunakan kembali setelahnya penyelesaian | `runtime/baselines/*` |
| Pembatalan harian | Diperbarui pada tempatnya | `runtime/forensic_days/YYYY-MM-DD/*` |
| Log akhir | Ringkasan harian dengan bahasa sederhana | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Saat ini snapshots

Ini tetap kecil dan menjawab “apa yang benar sekarang.”

```text
runtime/current/poll_status.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

<a id="player-summaries"></a>
## Ringkasan pemain

Ini adalah file pertama yang diperiksa untuk peninjauan akun.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Ringkasannya:

```text
account_id
ban_id
name
identity_confidence
first_seen
last_seen
join_count
leave_count
status
score
```

<a id="event-logs"></a>
## Log peristiwa

Ini menjaga garis waktu.

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/warning_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
```

<a id="daily-forensic-rollups"></a>
## Pembatalan forensik harian

Ini adalah paket unggahan cepat.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Unggah salah satu folder tersebut bila Anda menginginkan analisis periode cepat.

<a id="scan-and-baseline-files"></a>
## Pindai dan file dasar

Gunakan ini untuk memahami apakah konteks dunia bersifat parsial atau lengkap.

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

<a id="enforcement-files"></a>
## File penegakan

Gunakan ini hanya ketika penegakan diaktifkan.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` hanya akan menerima:

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## Pembaruan apa saat pemain bergabung

Pembaruan yang diharapkan:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/current/session_state.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-server-crashes-or-restarts"></a>
## Pembaruan apa saat server mogok atau dimulai ulang

Pembaruan yang diharapkan:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## Apa yang diperbarui saat pemindaian berlangsung

Pembaruan yang diharapkan:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## Apa yang harus diunggah untuk analisis cepat

Paket terbaik:

```text
runtime/final_logs/YYYY-MM-DD/
```

Paket lebih lengkap:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Paket bukti lengkap:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## Dokumen terkait

* [`FORENSIC_DAILY_ROLLUPS.md`](ROLLUP_HARIAN_FORENSIK.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](ALUR_KERJA_TINJAUAN_PEMAIN.md)
