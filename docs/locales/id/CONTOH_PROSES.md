<a id="worked-operation-examples"></a>
# Contoh operasi yang berhasil

> **Sumber kanonis bahasa Inggris:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Contoh ini menggunakan nilai yang ditemukan untuk menjelaskan transisi keadaan yang diharapkan; ini bukan kompatibilitas langsung atau bukti pemain.

<a id="successful-current-cycle"></a>
## Siklus saat ini yang berhasil

Masukan: log aktif yang dapat dibaca, version/boot/epoch, `poll_id=41`, menyelesaikan jajak pendapat saat ini, accounting/history/report akar yang dapat ditulis, tidak ada kebijakan pemindaian lambat yang memblokir.

Diharapkan:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Setiap rute yang diaktifkan memiliki JSON/TXT keluaran dan garis keturunan yang sama di `route_proof.json`. Status rute bergantung pada subjeknya sendiri, bukan pada pesan sukses umum.

<a id="expected-empty-player-and-case-routes"></a>
## Rute pemain dan kasus yang diharapkan kosong

Masukan: pembuktian siklus saat ini selesai; tidak ada baris pemain saat ini atau yang dipertahankan; tidak ada kasus yang ditahan dan tidak ada akun REVIEW/BAN-ELIGIBLE saat ini.

Diharapkan:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

Laporan yang diterjemahkan menyatakan bahwa tidak ada subjek terikat yang memenuhi syarat yang diamati. Mereka juga mengatakan hal ini tidak membuktikan tidak ada orang yang pernah terhubung atau tidak ada konteks yang hilang. Tidak ada placeholder player/case yang dibuat.

<a id="partial-bounded-scan"></a>
## Pemindaian berbatas parsial

Input: ada log/poll; `scan_checkpoint.json` atau `scan_progress.json` terkini; pemindaian tidak lengkap; default `slow_world_scan_blocks_current_reports=false`.

Diharapkan:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Setel `slow_world_scan_blocks_current_reports=true` hanya bila operator menginginkan sumber lambat opsional tersebut memblokir laporan saat ini. Pemulihan adalah untuk memungkinkan pekerja pemindaian melanjutkan, bukan menghapus pos pemeriksaan.

<a id="missing-current-cycle-proof"></a>
## Bukti siklus saat ini tidak ada

Masukan: log aktif tidak tersedia, `poll_id=0`, atau boot/epoch/last-poll silsilah hilang.

Diharapkan:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

Amplop yang disembunyikan adalah catatan audit, bukan pengiriman dalam antrean. Catatan akhir yang lama hanya tinggal sejarah. Perbaiki kolom lineage/source pertama yang hilang dan buat siklus yang lebih baru.

<a id="malformed-optional-adminini-source"></a>
## Format opsional Admin.ini sumber

Masukan salah: `Admin.ini` ada tetapi gagal dalam validasi struktural yang bersih.

Diharapkan:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Simpan file dan memulihkan format bersih yang telah ditinjau. Simpan teks penjelasan dalam bukti runtime; setiap `Admin.ini` entri larangan hanya tersisa `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## Kesalahan pemeriksaan log aktif yang diperlukan

Input: pemeriksaan log aktif yang diperlukan dan dibatasi gagal dengan kesalahan pembacaan yang telah disanitasi.

Diharapkan:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` tetap berada di baris sumber dengan detail yang dibatasi. Laporan tingkat atas menggunakan `unavailable`, dan bukti rute tetap `missing` hingga siklus terbaru saat ini membuktikan sumber yang diperlukan.

<a id="incompatible-or-stale-baseline"></a>
## Data dasar tidak kompatibel atau basi

Input: mengubah package/source identitas atau stale/incompatible data dasar manifes.

Diharapkan: validasi atau status runtime mencatat ketidakcocokan; status pemindaian tidak mengklaim penggunaan kembali telah selesai. Pertahankan bukti-bukti sebelumnya, mulai pembangunan kembali garis dasar yang eksplisit, dan tunggu bukti akhir yang baru. Pembuatan ulang yang dipaksakan tanpa alasan yang tercatat bukanlah pemulihan default.

<a id="paired-report-write-failure"></a>
## Kegagalan penulisan laporan berpasangan

Masukan salah: JSON penulisan berhasil tetapi TXT penulisan gagal, atau sebaliknya.

Diharapkan:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

Upaya terbaik penulis menulis ulang kedua saudara kandung untuk menyatu pada kegagalan. Satu saudara kandung yang sukses tidak bisa tetap menjadi klaim sukses. Detail penulisan yang dibatasi tidak menghasilkan nilai cakupan tingkat atas kelima.

<a id="route-proof-write-failure"></a>
## Kegagalan penulisan tahan rute

Masukan: pasangan rute telah ditulis tetapi `route_proof.json` tidak dapat diganti.

Diharapkan: semua laporan ditulis ulang `missing`, semua hasil notifikasi adalah `route_proof_write_failed`, dan tidak ada amplop yang diterima. Rute yang dikonfigurasi mungkin memiliki amplop audit `suppressed_current_cycle` dengan tanda pengiriman salah. Perbaiki akar keluaran dan buat ulang siklus yang sama saat ini.

<a id="review-only-enforcement-example"></a>
## Contoh penerapan hanya tinjauan

Konfigurasi:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Diharapkan: skor, kasus, dan rekomendasi dapat ditulis; `Admin.ini` tetap tidak berubah. Ini adalah default publik.

<a id="approved-write-success-example"></a>
## Contoh keberhasilan penulisan yang disetujui

Hanya pengujian yang disetujui secara terpisah yang dapat menyetel ketiga tombol tulis. Ini juga harus membuktikan identitas numerik yang bersih, trust/moderator pengecualian, kelayakan ambang batas, Admin.ini path/parse yang valid, keberhasilan pencadangan, keberhasilan penulisan, kesetaraan baca balik, dan bukti khusus akun.

Diharapkan:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

Contoh yang berhasil tidak mengaktifkan penerapan otomatis untuk akun lain.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback kegagalan dengan rollback

Masukan: setiap gerbang pra-tulis dilewati; penggantian tulis atau baca kembali gagal; `rollback_on_readback_failure=true` dan cadangan terverifikasi tersedia.

Diharapkan: bukti kegagalan mencatat tahapan dan `rollback_success`; byte Admin.ini asli dipulihkan dan akun tidak dilaporkan berhasil diterapkan. Jika rollback juga gagal, hentikan penulisan, pertahankan files/evidence, dan pulihkan secara manual dari cadangan.

<a id="local-outbox-example"></a>
## Contoh kotak keluar lokal

Masukan: notifikasi diaktifkan dalam mode `local_file_outbox`, rute diaktifkan, pembuktian rute selesai, dan `full` atau diizinkan secara eksplisit diharapkan-kosong.

Amplop yang diharapkan:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

Untuk missing/ineligible keluaran, jalur yang sama mungkin berisi `status=suppressed_current_cycle`, `completed_output=false`, dan `delivery_eligible=false`. File mana pun hanya membuktikan penulisan lokal. Tidak ada penyedia, transportasi, pengiriman, atau tanda terima telah dibaca yang dibundel atau disimpulkan.

Lihat [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md), [`CONFIG_FIELD_CATALOG.md`](KATALOG_BIDANG_KONFIGURASI.md), dan [`TROUBLESHOOTING.md`](PEMECAHAN_MASALAH.md).
