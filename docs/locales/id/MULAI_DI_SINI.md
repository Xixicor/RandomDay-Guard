<a id="start-here-read-the-first-guard-report"></a>
# Mulai dari sini: baca Penjaga pertama laporan

> **Sumber kanonis bahasa Inggris:** [START_HERE.md](../../START_HERE.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Panduan ini dimulai setelah RandomDayGuard diinstal dan diaktifkan. Ini membuktikan satu hasil yang berguna tanpa meminta operator baru untuk memeriksa kode sumber, internal paket, atau file status khusus mesin.

<a id="what-happens-after-the-server-starts"></a>
## Apa yang terjadi setelah server dimulai

Guard menunggu server game dan UE4SS memuat, menemukan data server yang tersedia, dan memulai pemindaian latar belakang terbatas. Ia dapat melaporkan kesehatan server saat ini sementara riwayat lama masih diindeks.

Laporan pertama seharusnya **Status server**. Laporan ini menjawab apakah Guard sedang menyelesaikan siklus pemantauan sekarang, kapan server saat ini berjalan dimulai, apakah stempel waktu tersebut tersedia, berapa banyak active/rotated cakupan log dan pemindaian yang ada, berapa banyak pemain yang terhubung, grup sumber mana yang hilang, dan apakah tindakan operator diperlukan.

Pemindaian latar belakang yang masih berlangsung merupakan batasan pada cakupan historis, bukan kegagalan startup secara otomatis. Penjaga mencatat kursor pemindaian, file selesai, file ditemukan, dan waktu kemajuan terakhir. Jika nilai tersebut berhenti berubah selama siklus pemantauan berulang, perlakukan jalur historis sebagai terhenti dan ikuti cabang pemindaian di Pemecahan Masalah. Jangan membuang hasil log dan sesi saat ini hanya karena riwayat lama tidak lengkap.

<a id="read-the-first-server-status-report"></a>
## Baca laporan status server pertama

1. Mulai server khusus secara normal.
2. Tunggu hingga server game dan UE4SS selesai memulai.
3. Buka RandomDayGuard's folder laporan akhir dan pilih laporan status server terbaru yang dapat dibaca.
4. Konfirmasi bahwa laporan berisi:
   - **Ringkasan**
   - **Apa yang diamati Penjaga**
   - **Apa artinya**
   - **Apa yang masih belum diketahui**
   - **Langkah berikutnya yang disarankan**
   - **Catatan teknis**
5. Dalam **Apa yang diamati Penjaga**, konfirmasikan kemajuan siklus pemantauan terbaru dan nama laporan yang tersedia log, pemindaian, pemutar, dan cakupan sumber.
6. Jika langkah berikutnya menyatakan tidak diperlukan intervensi, pertahankan laporan sebagai hasil pertama yang berhasil. Jika ia menyebutkan sumber yang hilang atau proses terhenti, ikuti gejala yang sama di [Pemecahan Masalah](PEMECAHAN_MASALAH.md).

Laporan ini mungkin ditautkan ke bukti teknis untuk tinjauan lebih mendalam. Operator normal dapat membaca laporan terlebih dahulu dan membuka referensi tersebut hanya ketika hasil biasa perlu diperiksa.

<a id="understand-quiet-reports"></a>
## Memahami laporan senyap

Aktivitas pemain, tinjauan kasus, dan Penjaga Kritis didorong oleh peristiwa. Server yang tenang tidak boleh menghasilkan pemain fiksi, kasus, atau kegagalan hanya untuk mengisi saluran. Hasil yang dapat dibaca mungkin menyatakan bahwa sumber telah diperiksa dan tidak ada yang termasuk dalam laporan itu.

Rollup harian berbeda: ia menyediakan satu tinjauan per tanggal laporan menggunakan sesi pada hari yang sama, subjek tinjauan saat ini, dipertahankan identity/case konteks, kemajuan pemindaian, dan celah sumber yang sebenarnya dapat dibaca oleh Guard. Fakta yang tidak ada dalam catatan server yang tersedia tetap tidak diketahui dan tidak diperkirakan.

<a id="test-one-ordinary-player-session"></a>
## Uji satu sesi pemain biasa

Setelah laporan status server pertama adalah terkini:

1. Biarkan satu pemain yang dikenal bergabung dan keluar secara normal.
2. Tunggu siklus laporan berikutnya.
3. Buka aktivitas Pemain.
4. Konfirmasi bahwa ini mengidentifikasi akun atau nama tampilan yang tersedia untuk Penjaga, waktu bergabung dan keluar, hasil sesi yang bersih atau tidak lengkap, riwayat sebelumnya jika tersedia, dan satu tindakan berikutnya.

Laporan sesi harus berisi data yang diamati. Catatan tersebut tidak boleh diganti dengan daftar nama file atau pernyataan umum bahwa catatan itu ada.

<a id="continue"></a>
## Lanjutkan

- [Lima contoh laporan](CONTOH_LAPORAN.md)
- [Buku pedoman pengoperasian](BUKU_PEDOMAN_OPERASI.md)
- [Alur kerja peninjauan pemain](ALUR_KERJA_TINJAUAN_PEMAIN.md)
- [Pemecahan Masalah](PEMECAHAN_MASALAH.md)
- [Indeks dokumentasi lengkap](DOKUMENTASI.md)
