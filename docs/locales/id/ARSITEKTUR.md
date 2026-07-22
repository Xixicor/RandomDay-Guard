<a id="architecture-and-lifecycle"></a>
# Arsitektur dan siklus hidup

> **Sumber kanonis bahasa Inggris:** [ARCHITECTURE.md](../../ARCHITECTURE.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


RandomDayGuard adalah satu UE4SS pengawas ditambah satu modul pelaporan terisolasi. Ia membaca file milik server, mempertahankan keadaan lokal yang dibatasi, dan menulis bukti lokal dan meninjau keluaran. panel kontrol, layanan notifikasi, RandomDay, atau ketergantungan jaringan.

<a id="end-to-end-data-flow"></a>
## Aliran data ujung ke ujung

1. UE4SS memuat titik masuk kanonis tunggal `RandomDayGuard/Scripts/main.lua`. Paket saat ini tidak mengirimkan duplikat varian huruf kecil.
2. Pemuat membaca `config.lua`, tiga kamus data, dan `SavedRoot.txt` opsional. Identitas versi harus sesuai dengan `VERSION`, `MANIFEST.json`, dan `BUILD_MARKER.txt`.
3. Pemeriksaan penemuan root yang disimpan membatasi kandidat yang diketahui dan mengarahkan file yang diketahui. Ia mencatat apa yang dapat dibaca di `runtime/saved_path_probe.json`; menemukan direktori saja bukanlah cakupan bukti.
4. Lapisan terdekat mengekor log server aktif dari offset yang aman. Ini menormalkan siklus hidup, sesi, akun, peringatan, penyambungan kembali, dan kejadian lain yang diamati menjadi bukti tambahan saja ditambah snapshot terkini.
5. Inventaris lapisan lambat File yang disimpan dalam potongan terbatas. Ia menulis kemajuan dan pos pemeriksaan, melanjutkan pekerjaan yang belum selesai, membandingkan manifes file yang diubah, dan menghasilkan konteks object/world parsial dan final.
6. Logika tinjauan hanya menghubungkan bukti yang tersedia padanya. Nama file yang lemah, waktu, jumlah kelas, koordinat relatif, churn, satu error, atau ping tetap menjadi konteks dan tidak dapat mengotorisasi penerapan saja.
7. Pekerja laporan terpisah akan memanggil `Scripts/public_pipeline.lua`. Ini menginventarisasi kelas sumber, mencatat cakupan saat ini versus cakupan historis, mengikat siklus ke version/boot/epoch/poll/source kesegaran, menulis lima pasangan JSON/TXT khusus rute, dan kemudian menulis `route_proof.json`.
8. Bila diaktifkan secara eksplisit, kotak keluar lokal menyalin referensi dari laporan lengkap setelah bukti rute ada. Ini mencatat `delivery_backend="none"` dan `delivery_attempted=false`; transport berada di luar produk ini.

<a id="ownership-and-asynchronous-boundaries"></a>
## Kepemilikan dan batasan asinkron

| Pemilik | Pekerjaan yang dibatasi | Tidak boleh memblokir atau menyiratkan |
|---|---|---|
| Startup | Config, Saved-root, log aktif, masa, indeks, status awal. | Penanda pemuat yang berhasil tidak membuktikan bukti atau rute. |
| Panggilan balik jajak pendapat | Byte log baru, pembaruan status, event/session/account keluaran, penjadwalan. | Penemuan atau laporan rekursif lambat menguras tenaga. |
| Pemindaian pekerja | Penemuan manifes, penguraian file, pos pemeriksaan, partial/final garis dasar. | Kemajuan log saat ini; parsial bukanlah kegagalan. |
| Pekerja laporan | Akuntansi sumber, terjemahan, pasangan laporan, bukti rute, kotak keluar lokal. | Penerapan atau pengiriman eksternal. |
| Penerapan opsional | Konfirmasi akun dan skor, lindungi akun tepercaya dan duplikat, verifikasi cadangan, tolak perubahan file luar, lalu verifikasi hasil yang disimpan. | Skor laporan, status rute, atau keanggotaan kasus melewati pemeriksaan keamanan yang diperlukan. |

Perulangan jajak pendapat tetap sehat hanya ketika `poll_id` maju, `poll_in_flight` menghasilkan false, dan penjadwalan tetap aktif. Hal ini membuktikan komponen jajak pendapat, bukan saluran laporan. Pemindaian yang lambat mungkin `partial` atau `deferred`; `slow_world_scan_blocks_current_reports=false` default memungkinkan rute baru dilanjutkan sambil menyebutkan batasan historis.

<a id="state-and-lifecycle"></a>
## Status dan siklus hidup

| Status | Entri | Terminal atau status berikutnya | Kesalahan dan pemulihan |
|---|---|---|---|
| Startup | UE4SS memanggil pemuat. | Menjalankan poll/scan/report pekerja dengan ID boot dan epoch. | `startup_error` adalah bukti penting booting saat ini; perbaiki config/path/source dan mulai ulang. |
| Jajak pendapat saat ini | Panggilan balik terjadwal yang dijadwalkan dimulai. | Jajak pendapat yang telah selesai mencatat stempel waktu dan penjadwalan ulang. | `poll_error` adalah bukti penting booting saat ini; pulihkan pekerjaan yang dibatasi dan konfirmasi jajak pendapat yang lebih baru. |
| Pemindaian tertunda | Pos pemeriksaan dasar diperlukan atau tidak lengkap ditemukan. | `partial`/`deferred`, lalu `scan_complete`. | Lanjutkan pos pemeriksaan; membangun kembali hanya ketika stale/incompatible bukti dicatat. |
| Akuntansi sumber | Laporkan inventaris pekerja delapan kelas sumber. | `complete`, `complete_with_gaps`, `partial`, atau `unavailable`. | Disabled/failed akuntansi memaksa semua rute ke `missing`. |
| Pembuatan rute | Penghitungan silsilah dan sumber siklus saat ini tersedia. | `full`, `limited_expected_empty`, atau `missing`. | Kegagalan penulisan JSON/TXT yang berpasangan atau tahan rute menyatukan rute ke `missing`. |
| Kotak keluar lokal | Rute diaktifkan, diselesaikan, dan memenuhi syarat. | Tertunda amplop lokal dan hasil status pemberitahuan. | Tidak ada bukti tertulis atau tidak lengkap berarti tidak ada amplop; tidak ada pengiriman yang disimpulkan. |
| Peninjauan penegakan | Bukti khusus akun mencapai skor yang dikonfigurasi untuk tindakan otomatis. | Rekomendasi hanya peninjauan atau pembaruan `Admin.ini` yang diaktifkan secara eksplisit. | Pemeriksaan keamanan yang gagal atau tidak tersedia akan menghentikan pembaruan; perbandingan akhir yang gagal akan memulihkan cadangan terverifikasi ketika pemulihan diaktifkan. |

<a id="current-and-historical-evidence"></a>
## Bukti terkini dan historis

Bukti terkini adalah milik boot/poll yang aktif dan tidak pernah direkonstruksi hanya dari nama file yang disimpan. Bukti sejarah termasuk kayu gelondongan yang diputar, tahan lama account/session riwayat, dipertahankan cases/reports/evidence, dan pemindaian penyimpanan dunia terbatas. Laporan memaparkan susunan dan jumlah terkini dan historis yang terpisah. Memulai ulang secara diam-diam tidak boleh menghapus konteks yang tahan lama, dan catatan riwayat tidak boleh disajikan sebagai keberadaan saat ini.

<a id="completion-and-recovery-boundary"></a>
## Batas penyelesaian dan pemulihan

Penyelesaian untuk satu rute memerlukan pencocokan versi siklus saat ini, ID boot, ID zaman, ID jajak pendapat positif, status log aktif baru, kedua keluaran rute, dan entri di `route_proof.json`. Klaim pemberitahuan juga memerlukan amplop lokal dengan siklus yang sama; pengiriman eksternal tidak pernah menjadi bagian dari bukti publik.

Jika laporan akhir tidak ada atau lebih lama dari status poll/source, melanjutkan dari silsilah pertama yang tidak cocok atau gagal menulis. Jangan mengubah pengaturan rute, kata-kata, atau penerapan yang tidak terkait. Lihat baris [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md), [`TROUBLESHOOTING.md`](PEMECAHAN_MASALAH.md), dan [`SOURCE_MODULE_REFERENCE.md`](REFERENSI_MODUL_SUMBER.md).
