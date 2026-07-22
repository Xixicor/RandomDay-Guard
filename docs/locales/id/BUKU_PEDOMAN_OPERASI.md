<a id="operations-playbook"></a>
# Buku pedoman pengoperasian

> **Sumber kanonis bahasa Inggris:** [OPERATIONS_PLAYBOOK.md](../../OPERATIONS_PLAYBOOK.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Ini adalah urutan pembacaan normal untuk RandomDayGuard. Anda tidak perlu mengetahui JSON, Git, checksum, atau alat baris perintah untuk meninjau server yang sehat.

<a id="daily-operator-flow"></a>
## Alur operator harian

1. Buka `runtime/final_logs/server_status_latest.txt`. Ini memberi tahu Anda apakah Guard memantau server yang berjalan saat ini, kapan siklus terakhirnya selesai, berapa banyak pemain yang terhubung, dan apakah sumber atau pemindaian belum selesai.
2. Buka `runtime/final_logs/daily_rollup_latest.txt` sekali sehari. Ini merangkum sesi pada hari yang sama, keluar, pekerjaan kasus yang disebutkan, inventaris identitas, dan cakupan sumber tanpa mengulangi setiap catatan individual.
3. Buka `runtime/final_logs/player_activity_latest.txt` hanya ketika server memiliki sesi bergabung, keluar, atau aktif pada siang hari.
4. Buka `runtime/final_logs/case_review_latest.txt` hanya ketika server menyebutkan subjek saat ini. Laporan ini memberikan akun, status peninjauan, skor, sumber identitas, dan catatan yang akan dibuka berikutnya.
5. Buka `runtime/final_logs/critical_guard_latest.txt` hanya jika Guard melaporkan kegagalan dalam startup, siklus pemantauan, atau penulisan laporannya sendiri.

Jika rute tidak memiliki apa pun untuk dilaporkan, Guard mencatat hasil kosong yang diharapkan. Itu adalah pemeriksaan yang telah selesai, bukan laporan yang hilang.

<a id="what-to-read-inside-a-report"></a>
## Apa yang harus dibaca di dalam laporan

Baca bagian ini secara berurutan:

1. **Ringkasan** - apa yang tercakup dalam laporan ini.
2. **Apa yang diamati Penjaga** - stempel waktu, jumlah, akun, sesi, atau nilai status aktual yang dikumpulkan untuk rute ini.
3. **Apa artinya** - interpretasi bahasa sederhana dari catatan tersebut.
4. **Apa yang masih belum diketahui** - sumber atau batas pemindaian yang memengaruhi hasil.
5. **Langkah berikutnya yang disarankan** - apakah akan memantau, meninjau subjek bernama, atau memperbaiki Penjaga.
6. **Batas bukti** - batas laporan cakupannya.

Catatan teknis dan referensi sumber muncul di bagian akhir bagi pembaca yang perlu memeriksa bukti terstruktur yang tepat.

<a id="when-a-report-is-missing"></a>
## Jika laporan hilang

Buka `runtime/final_logs/route_proof.json` hanya jika laporan yang dapat dibaca tidak ada atau menyatakan bukti terkininya hilang. Setiap rute memiliki salah satu hasil berikut:

| Hasil | Arti |
|---|---|
| `full` | Penjaga menyelesaikan rute dengan bukti milik rute saat ini. |
| `limited_expected_empty` | Penjaga menyelesaikan rute dan tidak menemukan peristiwa yang memenuhi syarat, atau mencatat batas jatuh tempo yang ditentukan. |
| `missing` | Sumber yang diperlukan, pemeriksaan silsilah, atau penulisan laporan berpasangan tidak selesai. |

Untuk rute yang hilang, ikuti sumber yang disebutkan atau tulis kesalahan dalam laporan. Jangan ubah rute atau setelan notifikasi yang tidak terkait terlebih dahulu.

<a id="after-a-crash-or-restart"></a>
## Setelah mogok atau dimulai ulang

1. Baca Status Server untuk stempel waktu pengoperasian server yang baru dan siklus pemantauan terbaru yang diselesaikan.
2. Baca Critical Guard untuk kegagalan startup atau polling saat ini.
3. Baca Aktivitas Pemain hanya jika sesi pada hari yang sama bergabung, keluar, atau kembali setelah siklus hidup ubah.
4. Pertahankan catatan sumber yang dikutip sebelum mengubah konfigurasi.

<a id="before-enabling-optional-adminini-writes"></a>
## Sebelum mengaktifkan opsional Admin.ini tulis

Paket default mengawasi dan melaporkan tanpa mengubah `Admin.ini`. Operator tingkat lanjut dapat mengaktifkan jalur penerapan opsional setelah mengujinya terhadap salinan file. Guard kemudian memerlukan ID akun numerik yang bersih, melindungi akun tepercaya, membuat dan memverifikasi cadangan, menolak perubahan bersamaan, membaca kembali file yang disimpan, dan memulihkan cadangan jika verifikasi gagal. Lihat [`ADMIN_INI_ENFORCEMENT.md`](PENEGAKAN_ADMIN_INI.md) untuk pengaturan lengkap dan prosedur pengujian.

<a id="related-guides"></a>
## Panduan terkait

- [`START_HERE.md`](MULAI_DI_SINI.md)
- [`REPORT_EXAMPLES.md`](CONTOH_LAPORAN.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](ALUR_KERJA_TINJAUAN_PEMAIN.md)
- [`TROUBLESHOOTING.md`](PEMECAHAN_MASALAH.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md)
