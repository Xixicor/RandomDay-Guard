<a id="adminini-enforcement"></a>
# Admin.ini penegakan

> **Sumber kanonis bahasa Inggris:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


RandomDayGuard tidak mengubah daftar larangan server dalam pengaturan defaultnya. Ini hanya membuat laporan untuk ditinjau oleh admin. Halaman ini menjelaskan pembaruan daftar larangan otomatis untuk admin yang sengaja mengaktifkannya.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## Apa yang diperiksa Penjaga sebelum mengubah daftar larangan

Penjaga menambahkan larangan hanya jika setiap jawaban di bawah ini adalah **ya**:

1. Apakah bukti saat ini mengidentifikasi satu akun tertentu dengan keyakinan yang cukup?
2. Apakah akun tersebut bukan moderator atau akun yang admin ditandai sebagai tepercaya?
3. Apakah akun tersebut belum ada dalam daftar larangan?
4. Apakah akun mencapai skor tindakan otomatis yang dikonfigurasi?
5. Dapatkah Guard membaca `Admin.ini` dan menyimpan cadangan yang sama?
6. Apakah `Admin.ini` tetap tidak berubah saat Guard menyiapkan pembaruan?
7. Setelah menyimpan, apakah seluruh file sama persis dengan hasil yang diharapkan?

Jika ada jawaban yang **tidak**, atau tidak dapat dicentang, Penjaga meninggalkan status `Admin.ini` tidak berubah dan mencatat alasannya dalam laporannya. Jika penyimpanan dimulai tetapi pemeriksaan terakhir gagal, Guard memulihkan cadangan terverifikasi.

<a id="file-format"></a>
## Format file

`Admin.ini` harus menerima baris larangan bersih saja:

```ini
BannedPlayer=<ID>
```

- Tidak ada nama.
- Tidak ada komentar.
- Tidak ada alasan.
- Tidak sufiks.

<a id="safe-defaults"></a>
## Default aman

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Sumber ID pelarangan

Sumber terbaik:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

Waktu proses menerima ID numerik penuh atau formulir koneksi `<digits>_+_|<non-space token>` yang terdokumentasi lengkap dan mendapatkan ID larangan numerik darinya. Awalan numerik sembarang dengan akhiran yang tidak diketahui ditolak; pengaturan tersebut tidak terpotong menjadi ID larangan.

Benar:

```ini
BannedPlayer=2535422284688820
```

Salah:

```ini
BannedPlayer=ExamplePlayer
```

Juga salah:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Pengaturan yang tepat Pemeriksaan penjaga

Pengaturan ini menerapkan pemeriksaan yang dijelaskan di atas. Setiap kondisi yang tercantum harus benar:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

Jika ada kondisi yang salah atau tidak dapat diperiksa, Guard membiarkan daftar larangan tidak berubah dan mencatat apa yang menghentikannya.

<a id="transaction-safety"></a>
## Keamanan transaksi

Satu-satunya jalur mutasi `Admin.ini` melakukan langkah-langkah berikut secara berurutan:

1. Membaca dan memvalidasi byte otoritatif secara struktural.
2. Mendapatkan status moderator, tepercaya, dan larangan yang ada dari snapshot yang sama.
3. Tulis cadangan unik di bawah `runtime/backups/` dan verifikasi byte demi byte.
4. Baca ulang `Admin.ini` segera sebelum penggantian dan tolak perubahan eksternal apa pun.
5. Tulis kandidat melalui jalur penggantian terkontrol yang dikonfigurasi.
6. Wajibkan byte readback lengkap untuk sama dengan byte kandidat lengkap.
7. Saat readback kegagalan, pulihkan cadangan terverifikasi hanya ketika file saat ini masih merupakan kandidat persis yang ditulis oleh Guard. Jika penulis lain mengubahnya, Guard menolak melakukan rollback daripada menimpa byte eksternal yang tidak diketahui.

ID duplikat bersifat idempoten: tidak ada baris kedua dan cadangan kedua yang ditulis. Nama cadangan mencakup stempel waktu, sidik jari byte sumber, dan ID bersih sehingga upaya terpisah tidak dapat berbagi nama file satu detik yang lama.

<a id="local-regression-proof"></a>
## Bukti regresi lokal

`tests/lua/enforcement_runtime_test.lua` mem-boot loader yang dikirim satu kali dan kemudian mengeksekusi penutupan `append_ban()` lokal aslinya terhadap file sintetis terisolasi di bawah direktori `.tmp/` repositori. Ini mencakup penyisipan, idempotensi duplikat, penolakan moderator/trusted, penolakan identitas yang lemah dan salah format, verifikasi cadangan persis byte, penolakan modifikasi bersamaan, rollback yang berhasil setelah pembacaan kembali yang gagal, dan penolakan untuk menimpa perubahan eksternal pasca-tulis. Pembungkus sistem filenya menolak mutasi apa pun di luar root perlengkapan; tidak ada jalur server nyata atau `Admin.ini` asli yang digunakan.

Jalankan melalui `python tools/test_public_pipeline.py`. Tiket perlengkapan membuktikan perilaku transaksi lokal saja. Itu tidak mengaktifkan penegakan, mengotorisasi penulisan produksi, atau membuktikan izin khusus host.

<a id="files-to-check"></a>
## File yang harus diperiksa

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Kembalikan

1. Hentikan server.
2. Pulihkan cadangan Admin.ini terbaru dari `runtime/backups/`.
3. Hapus baris `BannedPlayer=<ID>` yang salah jika diperlukan.
4. Mulai server.
5. Buka kembali Admin.ini dan konfirmasikan baris tersebut tetap ada atau telah dihapus.
6. Simpan `enforced_bans.jsonl` untuk audit.

<a id="related-docs"></a>
## Dokumen terkait

* [`BAN_ID_MAPPING.md`](PEMETAAN_ID_LARANGAN.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](ALUR_KERJA_TINJAUAN_PEMAIN.md)
