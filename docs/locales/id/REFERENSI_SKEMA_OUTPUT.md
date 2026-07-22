<a id="output-and-state-schema-reference"></a>
# Referensi skema keluaran dan status

> **Sumber kanonis bahasa Inggris:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Ini adalah kontrak kanonik untuk file yang dihasilkan oleh operator. Ia sendiri yang memiliki jalur keluaran yang tepat, nama bidang, nilai yang diizinkan, persyaratan garis keturunan, dan skema rute. Panduan prosedural ditautkan di sini alih-alih mendefinisikan ulang fakta tersebut.

Bukti runtime bersifat resmi; nama file, detak jantung penjadwal, laporan yang diterjemahkan, atau objek kotak keluar lokal tidak membuktikan lebih dari bidang dan garis keturunannya sendiri.

<a id="public-report-routes"></a>
## Rute laporan publik

Pekerja laporan memiliki lima rute berdasarkan persyaratan `runtime/final_logs/`:

| Rute | Kontrak | `full` | Makna kosong yang diharapkan |
|---|---|---|---|
| `server_status` | Penjadwal saat ini, log aktif, status pemindaian tertunda, dan cakupan sumber. | Peristiwa boot/epoch/poll silsilah, log aktif baru, accounting/history penulisan, dan JSON/TXT pasangan. | Tidak digunakan untuk siklus saat ini yang sehat; garis keturunan yang hilang adalah `missing`. |
| `daily_rollup` | Peristiwa day/window kesinambungan di seluruh server, pemutar, kasus, pemindaian, dan cakupan. | Terminal penghitungan riwayat cukup untuk melengkapi pembuktian rute dan siklus saat ini. | Tidak ada pemain yang dipertahankan dan tidak ada kasus peninjauan. |
| `player_activity` | Pisahkan pengamatan player/account terkini dan historis. | Bukti siklus saat ini ditambah satu atau lebih current/historical baris. | Tidak ada baris pemain yang memenuhi syarat dalam input terbatas; tidak ada subjek sintetis. |
| `case_review` | Kasus yang dipertahankan dan kandidat review/BAN-ELIGIBLE saat ini telah disebutkan. | Bukti siklus saat ini ditambah satu atau lebih kasus yang disebutkan dengan referensi sumber. | Tidak ada kasus bernama yang memenuhi kriteria peninjauan; tidak ada kasus sintetis. |
| `critical_guard` | Penjadwal booting saat ini, startup, jajak pendapat, atau kegagalan integritas bukti. | Bukti siklus saat ini ditambah kegagalan kritis saat ini. | Tidak ada kegagalan kritis saat ini; kesalahan teks lama tidak memiliki rute ini. |

Setiap rute yang diaktifkan menulis `<route>_latest.json` dan `<route>_latest.txt`. Pasangan ini tidak akan selesai sampai `runtime/final_logs/route_proof.json` mencatat versi, boot, epoch, polling, dan kesegaran sumber yang sama.

<a id="report-json-schema"></a>
## Laporkan JSON skema

Semua jalur rute JSON menggunakan `schema="randomdayguard.report/v1"`.

| Kolom | Ketik | Arti dan invarian |
|---|---|---|
| `schema` | string | Tepat `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | string | Stempel waktu pembuatan dan tanggal pelaporan. |
| `version` | string | Runtime/package identitas untuk siklus ini. |
| `boot_id`, `epoch_id` | string | Proses booting saat ini dan masa kontinuitas server. Keduanya diperlukan untuk penyelesaian. |
| `poll_id` | integer | Pengidentifikasi jajak pendapat positif saat ini. Zero/missing tidak dapat menyelesaikan rute. |
| `source_freshness` | objek | `status`, `checked_ts`, status log aktif, stempel waktu jajak pendapat terakhir, dan stempel waktu jajak pendapat terakhir yang diselesaikan. |
| `current_cycle_proof_complete` | boolean | Benar hanya jika silsilah dan active-log/current-poll bukti baru setuju. |
| `route` | enum | Salah satu dari lima rute di atas. |
| `route_proof_status` | enum | `full`, `limited_expected_empty`, atau `missing`. |
| `coverage_status` | enum | Tepat `complete`, `complete_with_gaps`, `partial`, atau `unavailable`. |
| `completed`, `expected_empty` | boolean | `completed` salah hanya untuk `missing`; `expected_empty` benar hanya untuk `limited_expected_empty`. |
| `observed` | rangkaian string | Beton dipertahankan facts/counts/statuses. |
| `interpretation` | rangkaian string | Makna hati-hati dikalibrasi ke bukti. |
| `unknown` | rangkaian string | Identitas, riwayat, tidak ada sumber, atau konteks. |
| `does_not_prove` | rangkaian string | Kesimpulan yang tidak dapat didukung oleh bukti. |
| `next_action` | string | Tindakan operator terikat yang paling aman. |
| `source_references` | rangkaian string | Referensi runtime/Saved yang diurutkan unik. |
| `enforcement_authority` | boolean | Selalu salah. Laporan tidak pernah mengotorisasi penulisan. |
| `output_paths` | dua string | JSON dan TXT ditambahkan sebelum penulisan berpasangan. |

`coverage_status` hanya merupakan akuntansi tingkat atas. Catatan sumber dimiliki secara terpisah `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, dan `error`. Bukti rute secara terpisah memiliki `full`, `limited_expected_empty`, dan `missing`; nilai tidak pernah melewati batas ini.

Ekstensi rute:

- `server_status`: `scheduler_status`, `active_log_status`, dan `server_metrics`. Metrik ini mencatat permulaan periode saat ini, stempel waktu dan ID jajak pendapat terakhir yang diselesaikan, jumlah pemain aktif, jumlah active/backup-log, nilai pemindaian pending/progress, dan configured/usable/unavailable penghitungan grup sumber. Mereka tidak menciptakan waktu aktif, jumlah restart, stempel waktu cadangan, atau durasi pemadaman ketika tidak ada sumber yang mengungkap fakta tersebut.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players`, dan rangkaian kompatibilitas `players`. Setiap sesi di hari yang sama menyimpan ID sesi, ID akun, nama tampilan saat diketahui, stempel waktu join/leave stempel waktu, tanda keluar bersih dan siklus hidup, serta referensi sumber. Identitas yang dipertahankan dan PlayerData kehadiran tetap menjadi konteks, bukan bukti aktivitas saat ini.
- `case_review`: `cases`, `review_subjects`, `current_case_count`, dan `retained_case_count`. Subjek ulasan saat ini mencatat case/account ID-nya, nama tampilan saat diketahui, status, skor, keyakinan identitas, first/last observasi, jumlah peringatan, alasan, tanda siaran langsung saat ini, dan referensi sumber. Kasus yang disimpan tidak membuat subjek saat ini dengan sendirinya.
- `critical_guard`: `critical_failure_present` dan `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window`, dan `daily_metrics`. Metrik ini mencatat tanggal laporan, pemain aktif, akun dengan aktivitas di hari yang sama, bergabung, keluar, keluar bersih dan tidak bersih, pengembalian siklus hidup, subjek ulasan yang disebutkan saat ini, kasus yang ditahan, current/retained jumlah identitas, dan cakupan grup sumber.

<a id="translated-txt-schema"></a>
## Diterjemahkan TXT skema

File teks yang dipasangkan mengarah dengan hasil yang dapat dibaca operator dan memindahkan detail silsilah ke akhir. Ini mempertahankan urutan bagian yang persis seperti ini:

```text
RandomDayGuard <route title>
Generated: <timestamp>

Summary
<one plain-language route summary>

What Guard observed
- ...

What it means
- ...

What remains unknown
- ...

Recommended next step
...

Evidence boundary
- ...

Rating explanation
- ...

Technical record
- Route: <route>
- Version: <version>
- Cycle: boot=<boot> epoch=<epoch> poll=<poll>
- Source freshness: <status>
- Route result: <full|limited_expected_empty|missing>
- Coverage: <status>

Translation notes
- ...

Source references
- ...
```

Terjemahan hanya menggunakan bidang laporan terstruktur dan pemetaan kamus yang disetujui. Laporan terstruktur tidak dapat menambahkan pemain, kasus, penyampaian, sebab akibat, kepemilikan, niat, atau kelayakan penegakan hukum. Detail teknis tetap tersedia tanpa menggantikan hasil yang dapat dibaca.

<a id="source-accounting-schema"></a>
## Skema akuntansi sumber

`runtime/final_logs/source_accounting_latest.json` menggunakan `randomdayguard.source-accounting/v1` dengan pembuatan reason/status, enablement/disabled alasan, current/historical pembedaan, manifes file yang diubah, catatan sumber, kelas usable/unavailable daftar, dan batas klaim.

Setiap catatan sumber berisi:

| Kolom | Ketik | Arti |
|---|---|---|
| `source_class` | string | Salah satu dari delapan kelas di bawah. |
| `scope` | `current` atau `historical` | Kepemilikan waktu; cakupan tidak pernah digabungkan secara diam-diam. |
| `required` | boolean | Hanya `active_log` yang diperlukan untuk kesegaran rute siklus saat ini. |
| `status` | enum | Sumber hasil tercantum di bawah. |
| `terminal` | boolean | Salah hanya untuk `partial` dan `deferred`. |
| `available`, `readable` | boolean | Benar hanya untuk `available` dan `expected_empty`. |
| `file_count` | integer | Terbatas diperhitungkan file/reference count. |
| `source_references` | array | Sumber unik yang diurutkan paths/references. |
| `detail` | string | Hasil yang dibatasi atau detail kesalahan. |
| `does_not_prove` | string | Ketersediaan bukanlah niat, kepemilikan, kerusakan, duplikasi, atau bukti penegakan hukum. |

Kelas sumber:

| Kelas sumber | Cakupan | Apa yang dikontribusikannya | Apa yang tidak dapat dibuktikan |
|---|---|---|---|
| `active_log` | saat ini, wajib | Log server aktif yang dapat dibaca dan silsilah jajak pendapat baru. | Riwayat lengkap atau kesalahan pemain. |
| `admin_ini` | saat ini, opsional | Status moderator/ban saat ini valid secara struktural, atau perkiraan ketidakhadiran. | Metadata perilaku pemain atau alasan yang valid. |
| `recent_backup_logs` | historis | Referensi log rotated/backup yang dapat dibaca. | Keberadaan saat ini atau status booting saat ini. |
| `playerdata_filenames` | konteks saat ini | Referensi nama file yang dapat dibaca dan dibatasi pada akar Tersimpan yang dipilih. | Kepemilikan file, kehadiran langsung, konten identitas, atau pelanggaran. |
| `existing_cases` | historis | Catatan kasus bernama files/index yang disimpan diambil sebelum keluaran saat ini. | Aktivitas saat ini atau kebenaran kesimpulan lama. |
| `existing_reports` | historis | Laporan final/forensic/warning yang disimpan referensi. | Penggantian sumber resmi. |
| `existing_evidence` | historis | Referensi bukti yang disimpan. | Kelengkapan peristiwa yang tidak pernah diungkapkan oleh server. |
| `world_save_scan` | historis | Status scan/checkpoint yang lengkap, sebagian, ditangguhkan, atau tidak tersedia. | Tindakan atau kepemilikan pemain tertentu. |

Nilai status sumber:

| Status | Terminal | Makna dan tindakan operator |
|---|---:|---|
| `available` | ya | Sangat berguna untuk dibaca sumber ada; tinjau referensinya. |
| `expected_empty` | ya | Sumber opsional telah diperiksa dan sah absent/empty. Jangan menciptakan data. |
| `partial` | tidak | Batas pekerjaan atau inventaris yang dibatasi tidak lengkap; izinkan melanjutkan. |
| `deferred` | tidak | Pekerjaan sengaja ditunda; menunggu pekerja pemilik. |
| `unavailable` | ya | Source/path/tool tidak ada atau tidak dapat digunakan; perbaikan hanya jika diperlukan oleh rute. |
| `malformed` | ya | Konten gagal validasi struktural; melestarikannya dan memperbaiki format. |
| `permission_denied` | ya | Akses secara eksplisit ditolak; memulihkan akses baca dengan hak istimewa paling rendah. |
| `error` | ya | Batas tingkat sumber probe/read tiba-tiba gagal; periksa `detail` tanpa mengungkap rahasia. |

Tingkat teratas `coverage_status` persis `complete`, `complete_with_gaps`, `partial`, atau `unavailable`. `error`, `malformed`, atau `permission_denied` tingkat sumber yang diperlukan digabungkan hingga `unavailable` tingkat atas; tingkat sumber `deferred` tingkat sumber yang diperlukan digabungkan hingga `partial`. Menonaktifkan akuntansi sumber masih menulis status tidak tersedia dan memaksa setiap rute ke `missing`.

<a id="historical-status-schema"></a>
## Skema status historis

`runtime/final_logs/historical_backfill_latest.json` menggunakan `randomdayguard.history/v1`: `generated_ts`, akuntansi `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, array akuntansi sumber, kelas yang tidak tersedia, dan `next_action`.

`runtime/history/public_accounts.tsv` yang dibatasi adalah riwayat publik yang tahan lama dengan header ini:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

Baris diurutkan berdasarkan ID akun, kolomnya adalah single-line/tab-safe, dan referensinya adalah sorted/unique. File ini mempertahankan konteks historis saat restart secara diam-diam; itu tidak pernah mengubah sejarah menjadi kehadiran saat ini.

<a id="route-proof-schema"></a>
## Skema pembuktian rute

`runtime/final_logs/route_proof.json` menggunakan `randomdayguard.route-proof/v1` dan mencatat stempel waktu pembuatan tingkat atas, versi, boot, masa, jajak pendapat, kesegaran sumber, kelengkapan siklus saat ini, status yang diizinkan, dan larik `routes`.

Setiap entri rute berisi route/status, version/boot/epoch/poll, objek kesegaran sumber, siklus saat ini kelengkapan, jalur keluaran, dan referensi sumber. Catatan rute yang dinonaktifkan `status="missing"` dan `reason="route_disabled"`. Jika penulisan tahan rute gagal, setiap rute ditulis ulang sebagai incomplete/missing sebelum kandidat notifikasi diterima.

<a id="notification-schemas"></a>
## Skema notifikasi

Mode publik opsional hanya berupa kotak keluar file lokal.

`runtime/notifications/pending/<route>_latest.json` menggunakan `randomdayguard.notification/v1` dengan stempel waktu yang dihasilkan, version/boot/epoch/ poll/source kesegaran, rute, `completed_output`, status tahan rute, jalur laporan terstruktur dan diterjemahkan, referensi sumber, `delivery_backend="none"`, dan `delivery_attempted=false`. Output yang memenuhi syarat menggunakan `status="ready_for_local_consumer"`, `delivery_eligible=true`, dan `delivery_allowed=true`. Rute yang dikonfigurasi tetapi missing/ineligible masih menulis amplop audit dengan `status="suppressed_current_cycle"`, kedua tanda pengiriman salah, dan `suppression_reason="route_or_completion_policy_blocked"`. Oleh karena itu, keberadaan file di bawah `pending/` tidak dengan sendirinya berarti masuk dalam antrean atau memenuhi syarat.

`runtime/notifications/notification_status.json` menggunakan `randomdayguard.notification-status/v1` dengan baris silsilah, `generic_local_outbox_only=true`, `delivery_attempted=false`, dan per rute `queued`/`outcome` yang sama. `full` memenuhi syarat; Expected-empty hanya memenuhi syarat jika `include_expected_empty=true`; `missing` tidak pernah memenuhi syarat. Pada kegagalan penulisan tahan rute, hasil statusnya adalah `route_proof_write_failed`; amplop audit yang disembunyikan mungkin masih ditulis, tetapi bukan keluaran yang diterima.

<a id="runtime-output-inventory"></a>
## Inventaris keluaran runtime

Indeks ketertelusuran memiliki satu baris mesin untuk setiap jalur atau kelas file dinamis. Inventaris yang dapat dibaca ini mengelompokkan file berdasarkan tujuan operator.

| Jalur atau pola | Producer/trigger | Kebijakan dan status berguna | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Entri pemuat. | Startup yang ditimpa identity/probe. | Hilang tidak membuktikan muatan; periksa UE4SS log dan pengaktifannya. |
| `runtime/config_load_error.txt` | Kegagalan pemuatan konfigurasi. | Hanya kesalahan, pertahankan alasan terbatas. | Pulihkan konfigurasi publik yang valid dan mulai ulang. |
| `runtime/saved_path_probe.json` | Resolusi root tersimpan. | Candidate/readability terbatas. | Setel `SavedRoot.txt` atau perbaiki kandidat generik. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Siklus hidup startup. | Kesalahan startup dan boot terbaru saat ini. | Hanya boot yang cocok yang memiliki status kritis saat ini. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report integrasi. | version/capability/handoff yang lengkap, sebagian, ditangguhkan, atau tidak tersedia. | Versi atau penyimpangan kemampuan memblokir klaim penyelesaian. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Poll finalizer/error. | poll/scheduler/in-flight status dan kesalahan booting saat ini. | Perbaiki callback yang dibatasi dan minta polling lengkap yang lebih baru. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Event logger. | Bounded append/rotation. | Pertahankan byte sebelumnya; perbaikan disk/retention sebelum mengandalkan celah. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Log tail/registry. | Offset terbaru dan identitas log kanonik. | Buat ulang dengan hati-hati; log cadangan tetap historis. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle normalizer. | Konteks hanya tambahkan. | Konteks yang hilang tidak dapat membuktikan graceful/crash yang lengkap, sebagian, ditangguhkan, atau tidak tersedia. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Pemilik zaman. | Waktu saat ini ditambah server yang dipertahankan. | Mulailah zaman baru setelahnya perbaikan; jangan menulis ulang riwayat lama. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Pemilik sesi. | Current/historical peristiwa dan cuplikan sesi. | Baris yang belum dipetakan tetap tidak diketahui; tidak ada penemuan identitas. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session modul agregasi dan pelaporan. | Snapshot saat ini ditambah riwayat yang tahan lama. | Pisahkan cakupan dan pulihkan dari bukti, bukan tebakan. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state penulis. | Snapshot saat ini ditimpa. | Stale/missing tidak diketahui, tidak diharapkan kosong. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly agregasi. | Indeks yang dapat dibangun kembali. | Buat kembali dari peristiwa resmi. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Pemindaian pekerja. | Dimulai, partial/deferred, pos pemeriksaan, selesai, atau kesalahan. | Melanjutkan pos pemeriksaan; membangun kembali hanya dengan alasan yang tercatat. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Pekerja dasar. | scan/baseline dan pengikatan file yang diubah. | Stale/incompatible manifes memerlukan pembangunan kembali secara eksplisit. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Pemindaian objek. | Partial/final konteks kelas. | Penghitungan bukan merupakan bukti tindakan pemain; melanjutkan atau membangun kembali pemindaian. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | Perbandingan objek. | Tambahkan saja new/delta parsial dan final. | Tinjau mapping/baseline sebelum inferensi. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Indeks root yang disimpan. | Filename/admin konteks struktur. | Nama file lemah; status admin yang salah menutup penulisan. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | Penulis negara dunia. | Boot/current/session cuplikan dan perbedaan. | Hanya konteks; dibuat ulang setelah scan/source perbaikan. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence penulis. | Penambahan yang dibatasi dan per-player/session file ulasan. | Laporan yang hilang bukan bukti peristiwa yang hilang; memeriksa bukti sumber. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review agregasi. | Menyebutkan materi ulasan dan mengantri kandidat. | Kasus membership/threshold tidak pernah melewati gerbang khusus akun. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Opsional Admin.initransaksi. | Cadangan, buku besar sukses, atau eksplisit failure/rollback yang dikutip. | Apa saja backup/write/readback/rollback kegagalan menutup penegakan; memulihkan cadangan. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Penulis penanda opsional. | Hanya permintaan lokal. | Tidak membuktikan konsumsi atau memulai ulang. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Pembatalan forensik. | Indeks tinjauan terkini dan tertanggal yang dapat dibangun kembali. | Membangun kembali dari sumber bukti; jangan pernah memperlakukan ringkasan sebagai otoritas. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Pekerja laporan publik. | Skema dan aturan penyelesaian di atas. | Perbaiki dulu ketidaksesuaian lineage/source/write; hilang tetap hilang. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Kotak keluar lokal opsional. | Amplop lokal plus status yang memenuhi syarat atau secara eksplisit disembunyikan. | Missing/ineligible rute mungkin menyembunyikan file tetapi tidak pernah dimasukkan dalam antrean; periksa tanda pengiriman dan simpulkan tidak ada pengiriman eksternal. |

Overwrite/append/retention perilaku dikontrol oleh bagian produksi di [`CONFIG_FIELD_CATALOG.md`](KATALOG_BIDANG_KONFIGURASI.md). Paket ZIP hanya berisi `.gitkeep` placeholder di bawah `runtime/`; apapun evidence/output byte dalam paket rilis gagal validasi.

<a id="failure-and-recovery-matrix"></a>
## Matriks kegagalan dan pemulihan

| Kegagalan | Keadaan yang diperlukan | Pemulihan aman | Inferensi tidak valid |
|---|---|---|---|
| Silsilah saat ini absent/stale | Semua rute `missing`. | Pulihkan active-log/current-poll buktikan dan buat ulang. | File rute lama belum selesai saat ini. |
| Sumber opsional diharapkan kosong | Sumber `expected_empty`; rute yang memenuhi syarat mungkin `limited_expected_empty`. | Tidak ada perbaikan kecuali sumbernya ada. | Kosong bukan berarti tidak tersedia dan tidak membuktikan riwayat tidak ada. |
| Pemindaian tidak lengkap | Sumber `partial` atau `deferred`. | Izinkan resume yang dibatasi; menjaga kebijakan rute saat ini tetap eksplisit. | Sebagian tidak rusak. |
| Sumber yang diperlukan tidak tersedia | `coverage_status=unavailable`; rute dependen `missing`. | Perbaiki akses Saved/log yang dipilih. | Sumber sehat lainnya tidak menggantikan sumber yang diperlukan. |
| Kesalahan pemeriksaan sumber yang diperlukan | Status sumber `error` dengan `detail`; `coverage_status=unavailable`; rute dependen `missing`. | Perbaiki source/probe yang diberi nama dan buat siklus yang lebih baru. | Kesalahan sumber bukan nilai cakupan tingkat atas kelima. |
| Penulisan laporan berpasangan gagal | `coverage_status=unavailable`; rute menyatu menjadi `missing`. | Perbaiki sistem file dan tulis ulang kedua anggota pasangan ditambah bukti. | Satu file saudara belum selesai, dan kegagalan penulisan bukan tingkat atas `error`. |
| Penulisan tahan rute gagal | Setiap rute yang ditulis ulang hilang; tidak ada kotak keluar yang memenuhi syarat; rute yang dikonfigurasi mungkin menerima amplop audit yang disembunyikan. | Perbaiki penulisan yang tahan rute dan buat ulang keluaran siklus yang sama. | Laporan yang tampak valid JSON atau amplop yang disembunyikan bukanlah bukti rute. |
| Penulisan notifikasi gagal | Hasil `local_outbox_write_failed`. | Perbaikan lokal akar keluaran; membuat ulang dari laporan yang telah selesai. | Tidak ada pengiriman eksternal yang terjadi. |
| Admin.ini transaksi gagal | Penerapan diblokir dengan backup/write/readback/rollback yang dikutip. | Pulihkan cadangan terverifikasi; tetap hanya untuk peninjauan. | Ambang batas atau laporan tidak dapat dijadikan alasan untuk mengabaikan pemulihan. |

Lihat [`EVIDENCE_BOUNDARY.md`](BATAS_BUKTI.md), [`ARCHITECTURE.md`](ARSITEKTUR.md), dan [`SOURCE_MODULE_REFERENCE.md`](REFERENSI_MODUL_SUMBER.md).
