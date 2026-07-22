<a id="forensic-daily-rollups"></a>
# Batal harian forensik

> **Sumber kanonis bahasa Inggris:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Batal harian adalah indeks yang dapat dibangun kembali. Sumber bukti tetap sah; folder harian dan log akhir adalah paket peninjauan cepat yang dihasilkan dari bukti waktu proses.

Gunakan laman ini bila Anda ingin satu folder diunggah untuk analisis cepat.

<a id="what-it-is"></a>
## Apa itu
Batal harian adalah ringkasan bukti mentah yang dapat dibuat ulang untuk satu hari.

Ini tidak menggantikan bukti mentah.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## Tempat penulisannya
Hari ini:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Paket harian:

```text
runtime/forensic_days/YYYY-MM-DD/
- forensic_day_summary.json
- forensic_day_summary.md
- forensic_day_summary.txt
- players.tsv
- sessions.tsv
- crash_reconnects.tsv
- warning_bursts.tsv
- raid_cases.tsv
- world_context.tsv
- ban_recommendations.tsv
- enforcement_audit.tsv
- evidence_index.json

## Final log contents
```text
runtime/final_logs/YYYY-MM-DD/
- final_forensic_log.txt
- final_forensic_log.md
- final_forensic_log.json

TXT ditulis dalam bahasa yang sederhana untuk tinjauan operator yang cepat.

<a id="what-the-final-txt-should-answer"></a>
## Apa yang harus dijawab oleh TXT final
```text
Did the guard run?
Was the scan partial or complete?
Who joined?
Who left cleanly?
Who did not leave cleanly?
Who rapidly reconnected?
Who overlapped crashes?
Who returned after crashes?
Who had warning overlap?
Who appears in a cluster?
Who is REVIEW?
Who is BAN-ELIGIBLE?
Which BannedPlayer=<ID> lines are candidates?
Which gates blocked enforcement?
What evidence files support each recommendation?
```

<a id="source-files-used"></a>
## File sumber yang digunakan
Rollup dapat membaca ini ketika ada:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
runtime/warning_events.jsonl
runtime/raid_cases/
runtime/world_state/current/world_state_latest.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry.json
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

File yang hilang harus ditandai sebagai hilang, tidak dianggap fatal.

<a id="update-behavior"></a>
## Perilaku pembaruan
Pada hari yang sama, penjaga memperbarui file yang sama.

Benar:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Salah:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## Keselamatan dari kerusakan
Penjaga harus menulis file sementara terlebih dahulu, lalu mengganti namanya:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

Ini melindungi ringkasan bagus terakhir jika server mogok saat sedang menulis.

<a id="playerstsv-columns"></a>
## `players.tsv` kolom
```text
date
account_id
ban_id
name
identity_confidence
playerdata_verified
first_seen
last_seen
join_count
leave_count
clean_leave_count
unclean_disconnect_count
rapid_rejoin_count
crash_overlap_count
post_crash_reconnect_count
warning_overlap_count
raid_case_count
world_context_count
score
status
recommended_action
ban_eligible
already_enforced
admin_ini_line
```

<a id="ban_recommendationstsv-columns"></a>
## `ban_recommendations.tsv` kolom
```text
date
account_id
ban_id
name
status
recommended_action
reason
admin_ini_line
gates_passed
blocked_by
evidence_files
```

<a id="review-rule"></a>
## Aturan peninjauan
Rollup harian dapat mempercepat peninjauan, namun hal tersebut tidak boleh menjadi satu-satunya bukti.

Jika sebuah rekomendasi penting, verifikasi dengan:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## Dokumen terkait
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](EKONOMI_MEMORI_DAN_OUTPUT.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](ALUR_KERJA_TINJAUAN_PEMAIN.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md)
