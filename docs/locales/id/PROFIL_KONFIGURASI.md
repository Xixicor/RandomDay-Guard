<a id="configuration-profiles"></a>
# Profil konfigurasi

> **Sumber kanonis bahasa Inggris:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Gunakan panduan cara ini untuk memilih dan menerapkan profil konfigurasi praktis. Untuk penjelasan tentang bagaimana grup setting berinteraksi, baca [`CONFIG_REFERENCE.md`](REFERENSI_KONFIGURASI.md). Untuk kolom eksak, default, tipe, dan invarian, gunakan [`CONFIG_FIELD_CATALOG.md`](KATALOG_BIDANG_KONFIGURASI.md).

Setiap blok Lua di bawah ini adalah sekumpulan entri tingkat atas yang dapat menggantikan entri yang cocok di dalam `return { ... }` yang dikirimkan.

<a id="profile-chooser"></a>
## Pemilih profil

| Situasi | Gunakan profil ini |
|---|---|
| Pemasangan pertama | Pemasangan pertama yang aman |
| Server tidak stabil dan sering error | Bukti terkini tanpa pemindaian lambat |
| Anda ingin object/world konteks | Dasar lengkap |
| Anda ingin meninjau log lama | Pengisian ulang forensik |
| Anda menginginkan rekomendasi tetapi tidak perlu menulis | Pengujian penerapan |
| Anda siap membiarkan penjaga menulis larangan | Penerapan diaktifkan |
| Disk terbatas | Pertumbuhan disk rendah |
| Anda menyelesaikan baseline yang bersih | Penyiapan pencadangan yang rumit |

<a id="safe-first-install"></a>
## Pemasangan pertama yang aman

Gunakan ini terlebih dahulu di server langsung.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
},

scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Apa fungsinya:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Bukti terkini tanpa pemindaian lambat

Gunakan ini jika server tidak stabil dan Anda memerlukan crash/reconnect bukti sebelum pemindaian berat.

```lua
log_tail = {
    enabled = true,
},

scanning = {
    full_scan_on_start = false,
},

enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Apa fungsinya:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Dasar lengkap

Gunakan ini setelah server dapat bertahan cukup lama untuk memindai.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

Apa fungsinya:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Pengisian ulang forensik

Gunakan ini hanya ketika dengan sengaja meninjau log historis.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Sebelum menggunakannya:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Pengujian penerapan

Gunakan ini sebelum Admin.ini penulisan.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

Apa yang harus diperiksa:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Penerapan diaktifkan

Gunakan ini hanya setelah keluaran tinjauan benar.

```lua
enforcement = {
    review_only_mode = false,
    auto_ban = true,
    write_admin_ini = true,
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
},
```

Sebelum mengaktifkan:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
## Pertumbuhan disk rendah

Gunakan ini ketika file runtime berkembang terlalu cepat.

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},

retention = {
    detailed_retention_days = 7,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    compact_json_outputs = true,
},
```

<a id="sticky-backup-setup"></a>
## Penyiapan pencadangan yang rumit

Gunakan setelah baseline pertama yang diselesaikan.

Periksa apakah ini ada:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Kemudian buat cadangannya dengan `config.lua`, `SavedRoot.txt`, dan `Admin.ini`.

<a id="related-docs"></a>
## Dokumen terkait

* [`CONFIG_REFERENCE.md`](REFERENSI_KONFIGURASI.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](ROLLUP_HARIAN_FORENSIK.md)
* [`ADMIN_INI_ENFORCEMENT.md`](PENEGAKAN_ADMIN_INI.md)
