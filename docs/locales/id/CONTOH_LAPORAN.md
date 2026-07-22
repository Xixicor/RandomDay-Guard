<a id="examples-of-the-five-guard-reports"></a>
# Contoh lima laporan Penjaga

> **Sumber kanonis bahasa Inggris:** [REPORT_EXAMPLES.md](../../REPORT_EXAMPLES.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Contoh-contoh ini dihasilkan dari data sampel yang disertakan dengan rilis; nama dan nomor rekening ditemukan. Mereka menunjukkan bidang laporan yang diuji, perhitungan, dan batas rute. Laporan nyata menggantikannya dengan informasi yang dikumpulkan dari server tersebut dan menyatakan ketika fakta tidak tersedia.

Setiap laporan memiliki satu tugas. Kesehatan server tidak mengulangi riwayat pemain, tinjauan harian tidak dikirim setiap beberapa menit, dan rute pemain atau kasus yang tenang tidak menerima pesan pengisi. Laporan terkini mungkin sudah siap sementara pemindaian historis terbatas masih berlangsung; dalam hal ini, laporan akan menyebutkan celah tersebut alih-alih menyajikan riwayat lama sebagai selesai.

<a id="server-status"></a>
## Status server

> **Status Server: Online Setelah Mulai Ulang**  **Status saat ini:** Online **Tersedia sejak:** 14:07  **Mulai ulang selesai:** 14:06  **Waktu henti:** 3 menit, 12 detik **Alasan memulai ulang:** Pembaruan game terjadwal **Pemantauan:** Aktif. Pemeriksaan terakhir yang berhasil: 14:09 **Log permainan:** Tersedia dan diperbarui **Pemindaian riwayat:** 312 dari 355 file telah ditinjau **Cadangan:** Terakhir diverifikasi: 13:00. Perkiraan berikutnya: 15:00. Kegagalan hari ini: 0 **Tindakan:** Tidak ada. Server pulih secara normal.

Status server adalah untuk operasi server saat ini: permulaan, mulai ulang pemulihan, waktu henti, pencadangan, penjadwal, dan kesehatan Penjaga. Itu tidak berisi sesi pemain atau detail kasus.

<a id="daily-rollup"></a>
## Rollup harian

> **Ulasan Harian: 19 Juli 2026**  **Ketersediaan server:** Online selama 23 jam, 47 menit. Offline selama 13 menit.  **Mulai ulang:** Total 2: 1 terjadwal dan 1 tidak terduga.  **Cadangan:** 23 berhasil. 1 hilang atau gagal. Pencadangan terakhir yang berhasil: 23:00.  **Aktivitas pemain:** 3 pemain unik. 7 sesi: 6 selesai secara normal dan 1 terputus.  **Aktivitas kasus:** 1 kasus baru, 2 kasus yang diperbarui, 1 kasus memerlukan perhatian, dan 0 kasus kritis.  **Cakupan bukti:** 6 dari 7 kelompok sumber yang diharapkan tersedia. Log cadangan pukul 04:00 tidak tersedia.  **Ringkasan hari:** Server tetap tersedia hampir sepanjang hari. Satu gangguan tak terduga mengakhiri sesi pemain lebih awal. Pemantauan dilanjutkan setelah pemulihan, dan satu kasus siap untuk ditinjau.  **Tindakan:** Tinjau kasus `RDG-20260719-004`. Tidak ada tindakan segera lainnya yang diperlukan.

Rollup harian ditulis satu kali untuk tanggal kalendernya. Ini menggabungkan hari selama periode tenang dan memulai ulang tanpa menjadi ping status server lainnya.

<a id="player-activity"></a>
## Aktivitas pemain

> **Aktivitas Pemain: Alex**  **Akun:** `76561198000000400`  **Pertama kali diamati:** 12 Juli 2026 **Sesi terakhir:** Bergabung pada 10:02, keluar pada 11:18, berlangsung 1 jam 16 menit, dan berakhir secara normal.  **Hari ini:** 3 koneksi, 2 sesi selesai, 1 sesi terputus, dan 2 koneksi ulang cepat dalam 10 menit.  **7 hari sebelumnya:** 9 sesi, rekaman pemutaran 6 jam 18 menit, dan 0 kasus sebelumnya.  **Diamati:** Alex kembali dua kali tak lama setelah sesi terputus. Aktivitas yang tercatat cukup lengkap untuk dilestarikan sebagai sejarah, namun tidak dengan sendirinya menjelaskan mengapa penyambungan kembali terjadi.  **Tindakan:** Lanjutkan pemantauan. Tidak diperlukan tindakan segera.

Aktivitas pemain dikirim hanya ketika informasi pemain atau sesi yang didukung berubah. Masa tenang tidak membuat pesan pemain.

<a id="case-review"></a>
## Tinjauan kasus

> **Tinjauan Kasus: RDG-20260719-004**  **Subjek:** Alex **Akun:** `76561198000000400`  **Status:** Peninjauan administrator diminta **Peringkat ulasan:** 90 - Prioritas tinggi **Mengapa kasus dibuka:** Akun melakukan upaya koneksi berulang kali setelah sesi terputus, dan server mencatat permintaan login secara langsung.  **Pengamatan yang dikonfirmasi:** - Permintaan login dicatat pada 18:42. - Empat percobaan dicatat dalam waktu 6 menit. - Dua sesi berakhir tanpa catatan keberangkatan normal. - Akun yang sama diamati pada 12 Juli dan 17 Juli.  **Riwayat yang relevan:** Tidak ada kasus sebelumnya yang dicatat untuk akun ini.  **Tidak diketahui:** Catatan yang tersedia tidak menentukan alasan penyambungan kembali, niat pemain, atau apakah keadaan dunia berubah.  **Tindakan yang disarankan:** Bandingkan waktu sesi dengan log server dan aktivitas dunia yang direkam sebelum memutuskan apakah tindakan apa pun diperlukan.

Tinjauan kasus berisi materi ulasan yang disebutkan, observasi yang dikonfirmasi, batasannya, dan langkah peninjauan spesifik. Kehadiran historis saja tidak menciptakan kasus baru.

<a id="critical-guard"></a>
## Penjaga Kritis

> **Penjaga Kritis: Penulisan Laporan Dihentikan**  **Dimulai:** 21:14  **Fungsi yang terpengaruh:** Penulis laporan pemain **Dampak:** Ringkasan pemain baru tidak dapat diselesaikan.  **Server:** Tetap online.  **Pemantauan:** Pengumpulan bukti terus berlanjut, namun laporan yang dapat dibaca tertunda.  **Laporan terakhir berhasil:** 21:09  **Gagal:** Output laporan tidak dapat disimpan.  **Kemungkinan alasan:** Tujuan tidak tersedia atau penulisan ditolak.  **Tindakan:** Periksa lokasi keluaran waktu proses Guard. Jangan memulai ulang server game kecuali pemantauan juga berhenti.

Saat masalah teratasi, rute yang sama mencatat pemulihan:

> **Penjagaan Kritis Terselesaikan: Penulisan Laporan Dipulihkan**  **Dilanjutkan:** 21:22  **Gangguan:** 8 menit **Hasil:** Bukti yang dikumpulkan selama interupsi disimpan dan laporan yang tertunda diselesaikan.

Critical Guard hanya bersifat kegagalan. Status rutin, riwayat harian, aktivitas pemain, dan hasil biasa yang diharapkan kosong tetap ada di laporannya sendiri.

<a id="when-a-route-is-quiet"></a>
## Saat rute sepi

Rute sepi mencatat hasil langsung tanpa mengirimkan pengisi ke Discord:

> **Diperiksa; tidak ada apa pun untuk laporan ini.** Catatan yang diperlukan tersedia dan tidak ada aktivitas pemain, kasus, atau kegagalan Penjaga yang cocok yang terjadi selama jendela laporan ini.

Itu adalah hasil yang benar-benar kosong. Hal ini berbeda dengan laporan yang hilang, yang mana sumber yang diperlukan tidak dapat diperiksa atau keluaran yang dapat dibaca tidak dapat dibuat.

Setiap laporan yang dapat dibaca mengikuti jalur yang sama:

```text
collected evidence -> normalized values -> dictionary mapping -> route calculations -> readable report -> Discord notification
```

Gunakan [buku pedoman operasi](BUKU_PEDOMAN_OPERASI.md) untuk meninjau laporan terkini dan [skema keluaran](REFERENSI_SKEMA_OUTPUT.md) untuk referensi bidang teknis.
