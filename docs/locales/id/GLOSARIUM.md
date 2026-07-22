<a id="glossary"></a>
# Glosarium

> **Sumber kanonis bahasa Inggris:** [GLOSSARY.md](../../GLOSSARY.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


| Istilah | Arti yang jelas | Arti teknis yang tepat |
|---|---|---|
| Log aktif | Log server saat ini digunakan untuk bukti baru. | Sumber `active_log` diperlukan; keterbacaan ditambah garis keturunan saat ini diperlukan untuk penyelesaian rute. |
| ID Booting | Satu proses pengawas dimulai. | Pengidentifikasi waktu proses saat ini digunakan untuk menolak booting sebelumnya errors/reports. |
| ID Epoch | Satu interval kontinuitas server. | Pengidentifikasi yang mencakup waktu proses normal hingga logika kontinuitas memulai periode berikutnya. |
| ID Jajak Pendapat | Satu peluang jajak pendapat terbatas. | Bidang siklus monotonik positif; zero/missing tidak dapat menyelesaikan rute. |
| Kebaruan sumber | Apakah sumber saat ini dan silsilah jajak pendapat sesuai. | `fresh_current_poll` atau `stale_or_unproven` dengan stempel waktu dan status log aktif. |
| Akuntansi sumber | Inventarisasi ketersediaan dan batasan bukti. | `randomdayguard.source-accounting/v1` dengan delapan kelas sumber dan cakupan current/historical. |
| `available` | Sumber ditemukan dan dibaca. | Status sumber terminal dengan `available=true`, `readable=true`. |
| `expected_empty` | Sumber opsional telah diperiksa dan sah absent/empty. | Status sumber yang dapat dibaca terminal; tidak pernah membuat subjek. |
| `partial` | Pekerjaan yang dibatasi memiliki hasil yang berguna tetapi tidak lengkap. | Status nonterminal source/accounting; melanjutkan pekerja pemilik. |
| `deferred` | Pekerjaan sengaja ditunda. | Status sumber nonterminal; bukan kesalahan atau penyelesaian. |
| `unavailable` | Sumber saat ini tidak dapat digunakan. | Kesenjangan terminal; kesenjangan sumber yang diperlukan membuat akuntansi tidak tersedia. |
| `malformed` | Sumber ada tetapi secara struktural tidak valid. | Kesenjangan terminal menjaga detail validasi dan menutup penulisan dependen. |
| `permission_denied` | OS secara eksplisit menolak akses. | Kesenjangan terminal berbeda dari missing/unavailable. |
| `error` | Operasi terbatas gagal secara tak terduga. | Kegagalan terminal yang memerlukan pemulihan bernama; tidak ada rincian rahasia yang termasuk dalam laporan publik. |
| `complete` | Semua sumber yang tercatat adalah terminal tanpa celah. | Status akuntansi sumber tingkat atas. |
| `complete_with_gaps` | Bukti terkini yang diperlukan berfungsi; kesenjangan terminal opsional masih ada. | Status akuntansi tingkat atas; rute masih menerapkan persyaratannya sendiri. |
| `full` | Rute yang diselesaikan dengan kontrak kosong yang disyaratkan. | Rute bukti enum dengan keluaran siklus saat ini yang telah selesai. |
| `limited_expected_empty` | Rute telah diselesaikan dan tidak ditemukan subject/failure. | Rute bukti enum dengan `completed=true`, `expected_empty=true`. |
| `missing` | Bukti penyelesaian rute tidak ada atau gagal. | Rute bukti enum dengan `completed=false`; tidak pernah memenuhi syarat untuk kotak keluar. |
| Laporan terstruktur | Output rute yang dapat dibaca mesin. | `<route>_latest.json` menggunakan `randomdayguard.report/v1`. |
| Laporan yang diterjemahkan | Render rute yang sama yang dapat dibaca manusia. | `<route>_latest.txt` dengan perbaikan Urutan observasi-ke-Sumber-referensi. |
| Pembuktian rute | Buku besar penyelesaian lintas rute. | `route_proof.json` jalur version/boot/epoch/poll/freshness/output yang mengikat. |
| Bukti terkini | Pengamatan dimiliki berdasarkan siklus aktif. | Cakupan `current`; tidak direkonstruksi dari filenames/reports. |
| Bukti sejarah | Konteks yang dipertahankan dari siklus sebelumnya atau pemindaian lambat. | Cakupan `historical`; dapat menginformasikan ulasan tetapi tidak dapat mengklaim keberadaan saat ini. |
| Hanya ulasan | Membuat bukti peninjauan tanpa Admin.ini aktual. | Default `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| Pemeriksaan keamanan daftar larangan | Satu pertanyaan yang harus dijawab oleh Penjaga sebelum dapat berubah `Admin.ini`. | Itu harus mengonfirmasi akun dan menilai, mengecualikan akun tepercaya dan duplikat, memverifikasi cadangan, mendeteksi perubahan luar, menyimpan pembaruan yang dimaksudkan, dan memverifikasi atau dengan aman memulihkan file lengkap. |
| Kotak keluar lokal | Handoff notifikasi netral penyedia opsional. | JSON file dengan `delivery_backend="none"` dan `delivery_attempted=false`. |
| Baseline | Menyelesaikan snapshot konteks File Tersimpan terikat. | Manifest/object/world status hanya digunakan kembali jika kompatibel dan cukup segar. |
| Pos pemeriksaan | Melanjutkan posisi untuk pekerjaan pemindaian yang belum selesai. | `scan_checkpoint.json`; penghapusan bukanlah pemulihan default. |
| Indeks yang dapat dibangun kembali | Ringkasan yang dapat dibuat ulang. | Daily/weekly/forensic/final keluaran tinjauan; bukti sumber tetap otoritatif. |
| Batas bukti | Batasan pada apa yang dapat didukung oleh sumber. | Eksplisit `does_not_prove`, aturan yang tidak diketahui, kekuatan identitas, dan cakupan. |

Definisi kanonik untuk skema ada di [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md); istilah konfigurasi ada di [`CONFIG_FIELD_CATALOG.md`](KATALOG_BIDANG_KONFIGURASI.md).
