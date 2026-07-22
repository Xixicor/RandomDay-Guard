<a id="troubleshooting"></a>
# Pemecahan Masalah

> **Sumber kanonis bahasa Inggris:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Gunakan halaman ini ketika Penjaga tidak dimuat, sumber tidak dapat dikumpulkan, laporan tidak muncul, atau bukti rute bertentangan dengan yang Anda harapkan. Mulailah dengan pohon keputusan dan ikuti satu cabang. Gunakan [referensi status dan kesalahan](REFERENSI_STATUS_DAN_KESALAHAN.md) hanya setelah lapisan yang gagal diketahui.

Pertahankan file runtime saat ini sebelum mengubah konfigurasi atau menginstal ulang. Artefak yang basi atau hilang mengidentifikasi tahapan yang gagal; memulai ulang berulang kali dapat menghapus bukti tersebut.

<a id="choose-the-failure-path"></a>
## Pilih jalur kegagalan

<a id="1-decide-whether-guard-loaded"></a>
### 1. Putuskan apakah Guard memuat

- **Tidak ada `runtime/` file yang ada:** ikuti [Pulihkan file runtime yang hilang](#restore-missing-runtime-files). Verifikasi jalur pemasangan, pemuat kanonik, `enabled.txt`, dan `mods.txt` sebelum menyelidiki laporan.
- **Ada file status saat ini:** Penjaga dimuat cukup jauh untuk menulis status. Lanjutkan ke langkah 2; menginstal ulang bukanlah respons pertama.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. Putuskan apakah penjadwal maju

Terbuka:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Penghitung dan stempel waktu maju:** lanjutkan ke langkah 3.
- **`poll_id` bersifat statis, `poll_in_flight` tetap benar, atau status penjadwal tidak berjalan:** ikuti [Memulihkan loop jajak pendapat yang terhenti](#recover-a-stuck-poll-loop).
- **Pemindaian dasar tertunda sementara kemajuan penjadwal berlanjut:** ini adalah peringatan, tidak otomatis startup gagal. Selidiki hanya jika simpanan atau kemajuan pemindaian berhenti.

<a id="3-classify-route-proof"></a>
### 3. Klasifikasikan bukti rute

Buka `runtime/final_logs/route_proof.json` dan periksa setiap rute secara terpisah.

- **`full`:** bandingkan kata-kata yang tidak terduga dengan `source_references` dan garis keturunan. Jangan mengubah penyampaiannya karena kata-katanya saja sudah terlihat salah.
- **`limited_expected_empty`:** saat ini untuk mengonfirmasi bahwa penghitungan sumber mendukung hasil kosong yang sah. Jangan membuat pemutar atau casing sintetis.
- **`missing`:** ikuti [Diagnosis rute yang hilang](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. Klasifikasikan cakupan sumber

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, atau `error`:** ikuti [Tafsirkan cakupan sumber yang tidak lengkap](#interpret-incomplete-source-coverage), lalu cari kode persisnya di [Referensi status dan kesalahan](REFERENSI_STATUS_DAN_KESALAHAN.md).
- **Sumber terstruktur adalah yang terbaru, namun keluaran yang diterjemahkan atau tertunda lebih lama:** mendiagnosis handoff penyelesaian, bukan titik akhir pengiriman. Pertahankan stempel waktu dan periksa status laporan dan pengiriman sebelum mengubah konfigurasi pengiriman.

<a id="5-follow-the-matching-branch"></a>
### 5. Ikuti cabang yang cocok

- Identitas tidak lengkap: [Petakan pemain yang belum dipetakan](#map-an-unmapped-player).
- Kontinuitas harian tidak ada: [Memulihkan rollup harian yang hilang](#restore-a-missing-daily-rollup).
- Uji penegakan yang disetujui secara eksplisit tidak menulis: [Diagnosis Admin.ini write](#diagnose-a-blocked-adminini-write).
- ZIP ekstraksi gagal: [Menyelesaikan kasus ekstraksi Windows tabrakan](#resolve-a-windows-extraction-folder-collision).
- Pemeriksaan perlengkapan, paket, atau repositori gagal: [Tinjauan validasi dan rilis](VALIDASI_DAN_RILIS.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Berhenti dengan satu hasil yang terbukti

Kartu pemecahan masalah berakhir ketika:

- rute terkini dan `full`;
- rute terkini dan `limited_expected_empty` untuk alasan yang disebutkan;
- satu pemblokir yang tepat, jalur bukti, dan tindakan selanjutnya dicatat; atau
- rollback memulihkan keadaan yang diketahui sebelumnya dan menyimpan bukti yang gagal.

"Server sedang berjalan", detak jantung yang meningkat, atau HTTP keberhasilan saja tidak membuktikan bahwa rute laporan telah selesai.

<a id="diagnose-a-missing-route"></a>
## Diagnosis rute yang hilang

Buka `runtime/final_logs/route_proof.json` dan bandingkan `server_status`, `daily_rollup`, `player_activity`, `case_review`, dan `critical_guard`.

1. Baca alasan, garis keturunan, waktu pembuatan, dan sumber rute referensi.
2. Konfirmasi bahwa sumber terstruktur yang disebutkan ada dan termasuk dalam siklus yang sama.
3. Bandingkan waktu dengan keluaran yang diterjemahkan dan amplop yang tertunda.
4. Jika log akhir lebih baru daripada keluaran yang diterjemahkan atau tertunda, catat pengiriman penyelesaian yang sudah basi dan perbaiki handoff tersebut terlebih dahulu.
5. Jika semua keluaran lokal adalah yang terbaru tetapi tidak ada pengiriman, maka periksa konfigurasi rute dan status pengirim.

Jangan promosikan kesehatan penjadwal atau satu notifikasi berhasil menjadi bukti lima rute.

<a id="interpret-incomplete-source-coverage"></a>
## Tafsirkan cakupan sumber yang tidak lengkap

| Status | Apa yang harus dilakukan |
|---|---|
| `partial` | Gunakan hanya bukti yang dikumpulkan dan hindari klaim cakupan lengkap. |
| `deferred` | Konfirmasikan pekerjaan yang dibatasi nanti. maju sebelum mengubah konfigurasi. |
| `unavailable` | Catat batas lingkungan; hanya memperbaiki jalur yang terbukti atau masalah izin. |
| `malformed` | Pertahankan sumber dan kesalahan penguraian; jangan menebak nilai yang hilang. |
| `permission_denied` | Berikan hanya izin baca sempit yang diperlukan. |
| `error` | Pertahankan detail dan diagnosis tahap bernama sebelum mengandalkan rute. |

<a id="restore-missing-runtime-files"></a>
## Pulihkan file runtime yang hilang

Konfirmasi:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

Root instalasi yang benar adalah:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Tolak tata letak bersarang ini:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Jika file sudah benar tetapi UE4SS tidak memulai Penjaga, pertahankan `UE4SS.log` dan bandingkan stempel waktu permulaannya dengan permulaan proses permainan yang sebenarnya.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## Menyelesaikan tabrakan folder ekstraksi Windows

Rilis lama menggunakan direktori program yang namanya hanya berbeda berdasarkan kapitalisasi. Beberapa ekstraktor Windows menggabungkan nama-nama tersebut ketika ZIP ditempatkan di atas folder yang ada.

1. Hapus hanya ekstraksi sementara yang gagal, bukan mod yang diinstal atau buktinya.
2. Buat direktori sementara baru yang kosong.
3. Ekstrak rilis saat ini di sana.
4. Konfirmasi bahwa folder tersebut menghasilkan satu folder RandomDayGuard dan satu direktori program.
5. Jika Windows masih melaporkan tabrakan, unduh lagi rilis tersebut dan laporkan versi rilis serta ekstraktor yang digunakan.

Jangan pernah mengekstrak rilis baru melalui folder yang diinstal. Ikuti prosedur pembaruan folder bersih di [`../INSTALL.md`](PEMASANGAN.md).

<a id="load-the-expected-version"></a>
## Muat versi yang diharapkan

Periksa penanda sumber dan penanda build:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Jika tidak setuju:

1. Hentikan server.
2. Cadangkan folder yang diinstal, tinjau konfigurasi, dan bukti runtime.
3. Tahap dan periksa paket yang dimaksud.
4. Ganti hanya program dan file data yang dikelola paket.
5. Konfirmasi keberadaan pemuat kanonik dan tidak ada duplikat huruf kecil yang ditambahkan.
6. Mulai sekali dan baca kembali penanda saat ini sebelum menilai keluaran waktu proses.

<a id="correct-a-missing-saved-root"></a>
## Perbaiki root Tersimpan yang hilang

Buka `runtime/saved_path_probe.json`. Letakkan jalur absolut terverifikasi ke Faktor Abiotik lengkap `Saved/` tersebut di `SavedRoot.txt`; jangan hanya menunjuk ke direktori dunia. Jalur di luar akar yang dibatasi harus tetap ditolak.

<a id="recover-a-stalled-historical-scan"></a>
## Memulihkan pemindaian riwayat yang terhenti

Pemantauan saat ini dan penemuan riwayat bersifat terpisah. Arsip yang besar mungkin memerlukan banyak siklus yang dibatasi, jadi satu pengamatan yang tidak diubah tidak cukup untuk menghentikannya.

1. Buka `runtime/current/report_worker_status.json`.
2. Rekam `scan_cursor`, file ditemukan, file selesai, dan `last_progress_ts`.
3. Tunggu setidaknya dua peluang pekerja laporan normal dan bandingkan lagi bidang yang sama.
4. Jika kursor, hitungan selesai, atau waktu kemajuan maju, pemindaian masih berfungsi. Biarkan tetap terikat.
5. Jika semua bidang kemajuan tetap tidak berubah sementara ID jajak pendapat dan laporan saat ini terus maju, pertahankan file status dan periksa kelas sumber yang diberi nama oleh fase pekerja. Perbaiki jalur sumber atau kegagalan baca tersebut sebelum mencoba lagi.

Pemindaian riwayat yang terhenti membatasi kesimpulan yang memerlukan catatan lama. Hal ini tidak membatalkan laporan saat ini yang log aktif dan bukti siklus saat ini masih baru.

<a id="recover-a-stuck-poll-loop"></a>
## Memulihkan loop jajak pendapat yang terhenti

Terbuka:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Rekam `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status`, dan stempel waktu dua kali pada interval yang dibatasi.

- Jika penghitung maju, loop tidak terhenti; mendiagnosis tahap pekerja selanjutnya.
- Jika `poll_in_flight=true` tetap tidak berubah, pertahankan tahap kemajuan terakhir dan kesalahan sebelum memulai ulang.
- Jika penjadwal berhenti, periksa kesalahan sebelumnya dan handoff startup.

Jangan tambahkan pemilik loop kedua untuk mengkompensasi satu siklus hidup yang terhenti.

<a id="start-the-scan-after-log-backlog"></a>
## Mulai pemindaian setelah log backlog

Dalam `runtime/current/poll_status.json`, bandingkan:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

Pemindaian riwayat harus menunggu sementara log aktif memiliki byte yang belum dibaca. Konfirmasikan jajak pendapat nanti untuk mengurangi backlog. Jumlah tetap yang belum dibaca dengan jajak pendapat yang maju adalah masalah sumber; jajak pendapat yang diperbaiki adalah masalah penjadwal.

<a id="preserve-scan-progress-after-a-crash"></a>
## Pertahankan kemajuan pemindaian setelah kerusakan

Pertahankan dan bandingkan:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Periksa apakah pos pemeriksaan atau manifes hilang, akar atau dunia yang disimpan berubah, atau pos pemeriksaan ditandai basi. Jangan hapus garis dasar yang valid untuk membuat kemajuan tampak lebih baru.

<a id="map-an-unmapped-player"></a>
## Petakan pemain yang belum dipetakan

Bandingkan bukti sesi dengan log resmi:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Cari hubungan `Login request` yang lengkap di antara nama tampilan, `ConnectID`, dan `UniqueId`. Jika tidak ada identitas koneksi yang diterima, pertahankan peninjauan baris saja. Nama tampilan atau PlayerData nama file saja bukan merupakan identitas yang dapat diterapkan.

<a id="diagnose-a-blocked-adminini-write"></a>
## Diagnosis Admin.ini write

Jalankan pengujian penerapan hanya dengan persetujuan eksplisit dan file pengujian sekali pakai, jangan pernah dengan file server aktif. Pertama-tama konfirmasikan bahwa konfigurasi pengujian meminta Guard untuk menulis:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Kemudian baca catatan alasan kegagalan. Penjaga harus mengidentifikasi satu akun, melindungi moderator dan akun tepercaya, menemukan bukti spesifik akun yang cukup, membuat dan memverifikasi cadangan baru, mengonfirmasi bahwa tidak ada program lain yang mengubah file, menyimpan pembaruan yang dimaksudkan, dan membandingkan seluruh file tersimpan dengan hasil yang diinginkan. Jika ada langkah yang gagal atau tidak dapat diperiksa, biarkan daftar larangan tidak berubah. Lihat [Admin.ini penegakan](PENEGAKAN_ADMIN_INI.md).

<a id="restore-a-missing-daily-rollup"></a>
## Memulihkan rollup harian yang hilang

Konfirmasi `forensic_rollup.enabled = true`, lalu periksa:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Jika tidak ada, periksa status startup, polling, pekerja laporan, dan akuntansi sumber secara berurutan. Rollup harian adalah satu catatan kontinuitas per hari, bukan pemberitahuan status server yang berulang.

<a id="look-up-an-exact-status-or-error"></a>
## Cari status atau kesalahan yang tepat

Gunakan [Referensi status dan kesalahan](REFERENSI_STATUS_DAN_KESALAHAN.md) untuk rute lengkap, sumber, PlayerData, penegakan, permulaan, penjadwal, laporan, dan kode notifikasi. Memisahkan tabel pencarian akan mencegah halaman perbaikan ini menjadi manual skema kedua.

<a id="related-docs"></a>
## Dokumen terkait

- [Mulai di sini](MULAI_DI_SINI.md)
- [Buku pedoman pengoperasian](BUKU_PEDOMAN_OPERASI.md)
- [Referensi status dan kesalahan](REFERENSI_STATUS_DAN_KESALAHAN.md)
- [Tinjauan validasi dan rilis](VALIDASI_DAN_RILIS.md)
