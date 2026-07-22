<a id="configuration-concepts"></a>
# Konsep konfigurasi

> **Sumber kanonis bahasa Inggris:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Penjelasan ini menjelaskan apa yang dikontrol oleh setiap area konfigurasi utama, kapan area tersebut dijalankan, dan bagaimana area tersebut berinteraksi dengan bukti dan gerbang keselamatan. Ia tidak memiliki katalog bidang atau prosedur profil yang tepat.

Untuk preset berorientasi tugas dan langkah perubahan yang aman, gunakan [`CONFIG_PROFILES.md`](PROFIL_KONFIGURASI.md). Untuk setiap kolom sumber, default, tipe, invarian, efek keluaran, dan aturan pemulihan yang tepat, gunakan [`CONFIG_FIELD_CATALOG.md`](KATALOG_BIDANG_KONFIGURASI.md); validator memerlukan satu baris di sana untuk setiap pengiriman `config.lua` yang dikirimkan.

<a id="reading-this-page"></a>
## Membaca halaman ini

Setiap area konfigurasi menjawab:

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## Keamanan tingkat atas

| Opsi | Default | Arti |
|---|---:|---|
| `enabled` | `true` | Saklar utama untuk penjaga |
| `enforcement.review_only_mode` | `true` | Record/recommend saja |
| `enforcement.auto_ban` | `false` | Jangan dicekal secara otomatis secara default |
| `enforcement.write_admin_ini` | `false` | Jangan menulis Admin.ini secara default |

Simpan ini dengan aman sampai pemilik server meninjau hasilnya.

<a id="saved"></a>
## `saved`

Mengontrol bagaimana penjaga menemukan folder `Saved/` server dan jenis file mana itu dapat memindai.

Gunakan ketika:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Periksa:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Aturan:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Mengontrol pembacaan log langsung.

Opsi yang berguna:

| Opsi | Nilai aman | Mengapa |
|---|---|---|
| `enabled` | `true` | Diperlukan untuk pertahanan langsung |
| `start_at_end_on_first_run` | `true` | Hindari log lama sebagai acara langsung |
| `tail_backup_logs` | `false` | Log cadangan adalah riwayat, bukan siaran langsung |
| `max_lines_per_poll` | terbatas | Menjaga loop jajak pendapat tetap responsif |

Periksa:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Mengontrol jajak pendapat dan anggaran.

Aturan kesehatan utama:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Periksa:

```text
runtime/current/poll_status.json
```

Jika `poll_id` berhenti, ada sesuatu yang menghalangi perulangan.

<a id="source_accounting"></a>
## `source_accounting`

Mengontrol cakupan dan cakupan sumber bukti yang eksplisit.

| Kunci | Default | Arti |
|---|---:|---|
| `enabled` | `true` | Menulis penghitungan sumber untuk laporan rute publik. |
| `require_terminal_status` | `true` | Memerlukan setiap sumber untuk mengekspos terminal yang eksplisit atau tidak lengkap negara bagian. |
| `distinguish_current_from_historical` | `true` | Memisahkan bukti terkini dan bukti historis. |
| `slow_world_scan_blocks_current_reports` | `false` | Memungkinkan laporan saat ini menyatakan bahwa pemindaian dunia terbatas ditangguhkan atau sebagian. |
| `changed_file_manifest` | jalur manifes dasar | Referensi yang digunakan untuk akuntansi historical/world terbatas. |

Status sumber `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, atau `error`.

Pengaturan `source_accounting.enabled = false` tidak menghapus keluaran status secara diam-diam. Pipeline masih menulis `runtime/final_logs/source_accounting_latest.json` dengan `enabled=false`, `status="unavailable"`, dan `disabled_reason="source_accounting_disabled"`. Ia juga menulis catatan status historis dengan akuntansi yang tidak tersedia. Karena penghitungan sumber adalah bagian dari kontrak laporan, setiap rute gagal ditutup ke `missing`; tidak ada rute yang dianggap selesai saat akuntansi dinonaktifkan.

<a id="reports"></a>
## `reports`

Mengontrol alur pelaporan lokal umum.

Default mengaktifkan kelima rute dan menulis di bawah `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Setiap rute harus menulis keluaran terstruktur dan diterjemahkan ditambah bukti dalam `route_proof.json`. Menonaktifkan rute akan menghasilkan `missing` bukti daripada berpura-pura bahwa rute telah selesai.

<a id="notification"></a>
## `notification`

Kotak keluar file lokal generik opsional. Ini dinonaktifkan secara default dan tidak mengirimkan apa pun ke penyedia eksternal.

Default:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Setiap rute notifikasi dinonaktifkan secara default. Bila sengaja diaktifkan, kotak keluar hanya dapat menggunakan laporan terjemahan lengkap setelah `route_proof.json` ditulis. Bukti dan laporan lokal tetap sahih. Pengiriman khusus penyedia, titik akhir pengiriman, kredensial, dan jembatan bukan bagian dari kontrak pengawas independen publik.

<a id="scanning"></a>
## `scanning`

Mengontrol pemindaian dasar, pos pemeriksaan, dan penyegaran file yang diubah.

Gunakan ketika:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Periksa:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Setelan penting:

```lua
scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
},
```

<a id="forensic_rollup"></a>
## `forensic_rollup`

Mengontrol paket unggahan harian cepat dan log bahasa sederhana akhir.

Output:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Gunakan ketika:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Periksa:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Aturan:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Mengontrol volume peristiwa dan agregasi yang tidak terlalu penting.

Gunakan ketika:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Pola aman:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Mengontrol berapa lama file disimpan dan kapan JSONL log diputar.

Gunakan ketika:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Opsi penting:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

Mengontrol deteksi jendela peringatan.

Contoh:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Aturan:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

Mengontrol peninjauan crash/reconnect yang berulang.

Default aman:

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Penghitung yang berguna:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Mengontrol pelacakan churn dan join-wave.

Aman default:

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Digunakan untuk:

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

Akun grup yang aktif di jendela terkait.

Aturan:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Setiap akun yang diterapkan masih memerlukan bukti khusus akun.

<a id="object_registry"></a>
## `object_registry`

Mengontrol object/class ekstraksi token dari bukti tersimpan yang dapat dibaca.

Output:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Aturan:

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Mengontrol boot/current/session cuplikan keadaan dunia.

Output:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Digunakan untuk tinjauan sesi dan konteks dunia.

<a id="enforcement"></a>
## `enforcement`

Mengontrol rekomendasi dan penulisan Admin.ini aktual.

Sebelum Guard dapat menambahkan larangan, setiap pernyataan di bawah ini harus benar:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
account identity is mapped
not trusted
not moderator
threshold is met
```

Jika satu pernyataan salah atau tidak dapat diperiksa, Guard keluar `Admin.ini` tidak berubah dan mencatat alasannya.

<a id="admin_ini"></a>
## `admin_ini`

Mengontrol penulisan file yang aman.

Aturan:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Mengontrol file penanda lokal opsional yang mungkin diperiksa oleh proses milik operator lain. Ini tidak memulai ulang atau mematikan server.

Default:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Output:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

Tidak ada panel hosting, jembatan penyedia, atau otomatisasi mulai ulang yang disertakan. Mengaktifkan pembuatan penanda tidak membuktikan bahwa proses eksternal menggunakan permintaan atau memulai ulang server.

<a id="related-docs"></a>
## Dokumen terkait

* [`CONFIG_PROFILES.md`](PROFIL_KONFIGURASI.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md)
* [`ADMIN_INI_ENFORCEMENT.md`](PENEGAKAN_ADMIN_INI.md)
