<a id="status-and-error-reference"></a>
# Referensi status dan kesalahan

> **Sumber kanonis bahasa Inggris:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Gunakan referensi ini setelah gejala diklasifikasikan di [Pemecahan Masalah](PEMECAHAN_MASALAH.md). Baca file status terstruktur yang diberi nama kesalahan. Kode yang berbeda mewakili status keselamatan dan siklus hidup yang berbeda; jangan menciutkannya menjadi hasil umum "Penjaga gagal".

<a id="route-and-source-states"></a>
## Status rute dan sumber

| Nilai | Arti | Respon operator |
|---|---|---|
| `full` | Kontrak rute dilengkapi dengan bukti sumber siklus saat ini. | Baca batas bukti rute; tidak ada perbaikan yang tersirat. |
| `limited_expected_empty` | Rute yang diselesaikan dan aktivitas yang hilang sah untuk siklus ini. | Tidak boleh ada peristiwa player/case sintetis yang dibuat. |
| `missing` | Tidak ada keluaran, bidang silsilah, atau bukti sumber yang diperlukan. | Periksa alasan rute dan status sumber yang diberi nama. |
| `available` | Sumber yang disebutkan dapat dibaca dan digunakan. | Tidak tindakan. |
| `expected_empty` | Sumber telah diperiksa dan secara sah tidak ada baris. | Tidak ada tindakan kecuali aktivitas diharapkan secara independen. |
| `partial` / `complete_with_gaps` | Bukti yang dapat digunakan ada, tetapi kelas sumber yang disebutkan tidak lengkap. | Batasi kesimpulan pada bukti yang dikumpulkan. |
| `deferred` | Pekerjaan yang dibatasi dijadwalkan untuk peluang pekerja berikutnya. | Konfirmasi kemajuan kemajuan sebelum mengubah konfigurasi. |
| `unavailable` | Lingkungan tidak menyediakan sumbernya. | Catat batasnya; hanya memperbaiki jalur yang terbukti atau masalah izin. |
| `malformed` | Sumber dapat dibaca tetapi gagal dalam validasi struktural. | Pertahankan dan perbaiki sumbernya; jangan menebak-nebak. |
| `permission_denied` | Sumber ada tetapi tidak dapat dibaca. | Berikan hanya izin baca yang diperlukan saja. |
| `error` | Pengumpulan gagal karena alasan yang tercatat. | Pertahankan kesalahan dan diagnosis tahap tersebut. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData dan penemuan kode inventaris

| Kode | Arti | Respon aman |
|---|---|---|
| `saved_root_unavailable` | Tidak ada Root tersimpan terverifikasi yang tersedia untuk pipeline publik. | Perbaiki `SavedRoot.txt` dan periksa kembali pemeriksaan jalur. |
| `unsafe_playerdata_root` | PlayerData diselesaikan di luar batas Root tersimpan. | Perbaiki jalur; jangan pernah melemahkan batas. |
| `playerdata_discovery_not_run` | Pekerja penemuan yang dibatasi belum berjalan. | Periksa penjadwal dan kemajuan pekerja. |
| `playerdata_discovery_read_failed:*` | Output penemuan tidak dapat dibaca. | Pertahankan detail akhiran dan verifikasi perintah inventaris yang dibatasi. |
| `inventory_command_open_failed` | Proses inventaris tidak dapat dilakukan dimulai. | Verifikasi bahwa waktu proses menyediakan jembatan perintah yang dikonfigurasi. |
| `inventory_command_read_failed` | Output inventaris gagal selama membaca. | Pertahankan sebagian output dan jalankan kembali hanya setelah kesalahan mendasar telah diperbaiki. |
| `inventory_command_close_failed` | Inventaris selesai tanpa hasil penutupan yang dapat dipercaya. | Perlakukan sumber sebagai tidak lengkap. |
| `identity_ledger_row_limit_exceeded` | Input identitas yang tahan lama melampaui batas keamanan publik. | Arsipkan dan tinjau buku besar; jangan diam-diam memotongnya menjadi bukti penuh. |

<a id="adminini-enforcement-codes"></a>
## Admin.ini kode penegakan

Semua kode di bagian ini ditutup secara gagal. Mereka sendiri tidak mengizinkan pelarangan manual.

| Kode | Arti | Respon aman |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | Gerbang tulis yang aman untuk publik tidak aktif. | Diharapkan dalam operasi peninjauan saja. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | Kebijakan pencadangan yang diperlukan tidak aktif. | Tetap menonaktifkan penulisan. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Salah satu gerbang penerapan yang eksplisit adalah nonaktif. | Diharapkan dalam setelan default khusus tinjauan publik; jangan menafsirkannya kembali sebagai kegagalan penulisan. |
| `review_only_mode_enabled` | Mode hanya tinjauan dengan sengaja memblokir mutasi. | Tinjau bukti saja. |
| `duplicate_prevention_disabled` | Perlindungan duplikat dinonaktifkan. | Tetap nonaktifkan penulisan hingga gerbang keamanan dipulihkan. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | Verifikasi pasca-tulis atau perlindungan rollback dinonaktifkan. | Simpan menulis dinonaktifkan; jangan pernah melewati gerbang ini. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | Pemberlakuan identitas bersih atau bukti khusus akun telah dinonaktifkan. | Pulihkan gerbang sebelum uji penegakan apa pun. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | Pemeliharaan akun yang dilindungi atau pemblokiran yang ada telah dinonaktifkan. | Tetap menonaktifkan penulisan. |
| `clean_numeric_identity_required` | ID yang diusulkan bukanlah formulir koneksi lengkap yang diterima atau ID numerik bersih. | Dapatkan pemetaan terverifikasi; jangan pernah memotong awalan sembarangan. |
| `identity_strength_below_minimum` | Bukti identitas lebih lemah dari ambang batas yang dikonfigurasi. | Tinjau bukti saja. |
| `playerdata_verification_required` | Konfigurasi memerlukan PlayerData konfirmasi dan akun tidak memilikinya. | Simpan hanya peninjauan kandidat; jangan menyimpulkan kepemilikan dari nama file. |
| `trusted_or_moderator_identity` | Akun dilindungi oleh status tepercaya atau moderator. | Penulisan tidak diperbolehkan. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | Jalur target tidak valid atau lolos dari root Tersimpan. | Konfigurasi benar; jangan pernah melewati penjaga jalur. |
| `admin_ini_unavailable` | Tidak ditemukan Admin.ini terkonfigurasi yang dapat dibaca di dalam root Tersimpan. | Perbaiki jalur yang dibatasi atau tetap nonaktifkan penerapannya. |
| `admin_ini_read_failed` | Byte resmi tidak dapat dibaca. | Hentikan sebelum mutasi. |
| `admin_ini_parse_failed` | Admin.ini validasi gagal tanpa kode struktural yang lebih spesifik. | Simpan file dan periksa bagian serta struktur barisnya. |
| `admin_ini_contains_nul` | File berisi NUL byte dan tidak diterima sebagai teks. | Simpan file dan perbaiki di luar Guard. |
| `admin_ini_duplicate_banned_players_section` | Ada lebih dari satu `[BannedPlayers]` bagian. | Gabungkan bagian secara manual saat dihentikan. |
| `admin_ini_banned_player_outside_section` | Baris larangan muncul di luar `[BannedPlayers]`. | Perbaiki tata letak secara manual. |
| `admin_ini_invalid_banned_player_line` | Baris larangan bukanlah baris ID yang didukung dengan jelas. | Perbaiki baris yang salah format. |
| `admin_ini_backup_failed` | Cadangan unik tidak menulis dan membaca kembali byte secara identik. | Mutasi tidak diperbolehkan. |
| `admin_ini_external_change_detected` | Penulis lain mengubah file setelah snapshot Guard. | Pertahankan byte eksternal dan coba lagi hanya setelah mengoordinasikan penulis. |
| `atomic_rename_unavailable` | Penggantian atom diminta tetapi Lua tidak menyediakan `os.rename`. | Tidak ada penulisan yang dapat dipercaya; gunakan runtime yang didukung atau nonaktifkan penerapannya. |
| `admin_ini_write_failed` | Penggantian terkontrol tidak selesai. | Periksa kesalahan penggantian yang tercatat dan cadangan. |
| `post_write_verification_failed` | Byte produksi tidak sama dengan kandidat. | Periksa `rollback_success` dan `rollback_refused_external_change` sebelum melakukan tindakan apa pun. |

<a id="startup-scheduler-and-backlog-states"></a>
## Status startup, penjadwal, dan backlog

Nilai-nilai ini adalah bukti siklus hidup, bukan bukti rute. Bacalah dengan file polling, pekerja laporan, dan bukti rute saat ini.

| Nilai | Arti | Respon aman |
|---|---|---|
| `not_started` | Tahap startup atau penjadwal yang disebutkan belum dimulai. | Selama peluncuran, tunggu interval yang terdokumentasi; setelah itu periksa fase pertama yang tidak diubah. |
| `main_lua_loaded` / `starting` | Pemuat kanonik berjalan dan Guard memasuki startup. | Lanjutkan ke fase selanjutnya; ini saja belum siap. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Inisialisasi sumber inti dan kontinuitas tingkat lanjut. | Tidak ada tindakan kecuali fase berikutnya berhenti maju. |
| `admin_state_written` / `playerdata_index_written` | Indeks batas awal diekspor. | Tidak ada tindakan; serah terima penjadwal harus tetap mengikuti. |
| `watchdog_started` | Pengawas laporan dan jajak pendapat telah terdaftar. | Konfirmasi kemajuan penjadwal dan jajak pendapat berikutnya. |
| `ready_degraded` / `scan_running` | Penjaga berjalan sementara pemindaian riwayat terbatas masih tertunda. | Perhatian, bukan kegagalan; verifikasi penghitung kemajuan terlebih dahulu. |
| `ready` | Startup dan pemindaian terbatas saat ini mencapai status siap. | Periksa bukti rute secara terpisah. |
| `scan_failed` / `error` | Startup atau pemindaian diakhiri dengan kesalahan yang tercatat. | Pertahankan kesalahan bernama atau file status dan diagnosis tahap tersebut. |
| `running` |  penjadwal memiliki peluang jajak pendapat di masa mendatang. | Konfirmasi `poll_id` dan `poll_completed_count` terlebih dahulu. |
| `manual_only` | Penjadwalan loop tidak tersedia; hanya pekerjaan eksplisit yang dapat berjalan. | Perlakukan operasi tanpa pengawasan sebagai tidak tersedia. |
| `stopped` | Operasi penjadwal berakhir. | Periksa bukti penghentian dan kesalahan sebelumnya sebelum memulai ulang. |
| `active_log_caught_up` | Tidak ada simpanan log aktif yang belum dibaca yang tersisa. | Pemindaian riwayat mungkin lanjutkan. |
| `active_log_unavailable_nonblocking` | Log aktif tidak ada, namun startup tetap tidak memblokir. | Catat batas sumber dan verifikasi sumber lain. |
| `active_log_read_failed` | Log aktif ada tetapi tidak dapat dibaca. | Pertahankan kesalahan dan perbaiki hanya jalur yang terbukti atau masalah izin. |
| `budget_exhausted` / `active_log_has_unread_bytes` | Pass ekor yang dibatasi dihentikan dengan sisa simpanan. | Konfirmasi jajak pendapat nanti mengurangi jajak pendapat yang belum dibaca count. |
| `offset_commit_failed_after_events_applied` | Peristiwa telah diproses tetapi persistensi log offset yang tahan lama gagal. | Penerapan ditunda; perbaiki penyimpanan offset sebelum mengandalkan siklus lain. |

<a id="scheduler-report-and-notification-codes"></a>
## Kode penjadwal, laporan, dan notifikasi

| Kode atau status | Arti | Respon aman |
|---|---|---|
| `poll already in flight` | Panggilan balik kedua tiba saat jajak pendapat saat ini memiliki siklus hidup. | Konfirmasi kemajuan jajak pendapat yang ada; jangan tambahkan pemilik loop lain. |
| `no_log_files_found` | Tidak ditemukan log aktif atau cadangan yang dikonfigurasi. | Verifikasi konfigurasi root dan sumber yang tersimpan. |
| `current_poll_error` | Siklus saat ini mencatat kegagalan sumber jajak pendapat. | Baca `runtime/current/poll_error.json`. |
| `cadence_deferred` | Pengirim penyelesaian belum selesai. | Diharapkan hingga peluang terbatas berikutnya. |
| `reports_disabled` | Pembuatan laporan publik dinonaktifkan. | Aktifkan hanya jika laporan memang dimaksudkan. |
| `local_outbox_write_failed` | Amplop lokal yang diterjemahkan tidak dapat ditulis. | Perbaiki direktori keluaran runtime; ini bukan kesalahan pengangkutan notifikasi. |
| `source_accounting_disabled` | Pembuktian rute tidak dapat mengklaim cakupan sumber yang lengkap. | Aktifkan penghitungan sumber atau terima bukti yang hilang secara eksplisit. |
| `route_disabled` | Rute sengaja dinonaktifkan. | Tidak ada pengiriman yang diharapkan untuk rute tersebut. |
| `poll_owner_between_polls` | Pekerja laporan mengantri untuk jeda yang dimiliki penjadwal antar jajak pendapat. | Diharapkan hanya ketika stempel waktu dan kursor terus bergerak maju. |
| `unsafe_shell_path` | Inventaris yang dibatasi atau jalur shell gagal dalam validasi yang aman untuk platform. | Perbaiki jalan; jangan pernah melemahkan kutipan atau validasi jalur. |

<a id="related-procedures"></a>
## Prosedur terkait

- [Pemecahan Masalah](PEMECAHAN_MASALAH.md) untuk klasifikasi gejala dan perbaikan.
- [Tinjauan validasi dan rilis](VALIDASI_DAN_RILIS.md) untuk kegagalan perlengkapan dan paket.
- [Referensi skema keluaran](REFERENSI_SKEMA_OUTPUT.md) untuk kontrak lapangan lengkap.
