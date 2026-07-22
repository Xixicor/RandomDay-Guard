<a id="source-module-reference"></a>
# Referensi modul sumber

> **Sumber kanonis bahasa Inggris:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Halaman ini memetakan setiap sumber, konfigurasi, data, pemuat kompatibilitas, dan kelas runtime-placeholder yang diterima berdasarkan daftar rilis yang diizinkan. Indeks mesinnya adalah [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json); halaman ini adalah penjelasan kanonik yang dapat dibaca. Setiap baris mesin yang dihasilkan memberi nama path/class yang berbeda, tujuan, blok sumber kepemilikan, setelan publik, efek samping, status yang terlihat oleh operator, kegagalan, pemulihan, dan dokumen kanonik.

<a id="packaged-file-map"></a>
## Peta file terpaket

| Jalur | Tanggung jawab | Titik masuk atau pemanggil | Input | Output dan efek samping | Perilaku kegagalan | Dapat diedit pengguna |
|---|---|---|---|---|---|---|
| `LICENSE` | Lisensi proyek dikirimkan di root arsip. | Penginstal, distributor ulang, dan operator. | Lisensi repositori yang telah ditinjau teks. | Menyatakan ketentuan yang berlaku pada paket; tidak ada mutasi runtime. | Penghilangan membuat paket rilis tidak lengkap secara hukum dan memblokir daftar yang diizinkan. | Tidak. |
| `NOTICE.md` | Pemberitahuan proyek dikirimkan di root arsip. | Pemasang dan operator. | Pemberitahuan proyek telah ditinjau. | Mempertahankan atribusi yang diperlukan dan konteks proyek; tidak ada mutasi waktu proses. | Penghilangan membuat paket rilis tidak lengkap dan memblokir daftar yang diizinkan. | Tidak. |
| `THIRD_PARTY_NOTICES.md` | Pemberitahuan pihak ketiga dikirimkan di root arsip. | Penginstal dan distributor ulang. | Teks atribusi pihak ketiga telah ditinjau. | Mempertahankan ketergantungan atribusi; tidak ada mutasi runtime. | Penghilangan membuat paket rilis tidak lengkap dan memblokir daftar yang diizinkan. | Tidak. |
| `RandomDayGuard/enabled.txt` | UE4SS tanda pengaktifan mod. | UE4SS pemuat mod. | `1` atau `0` didukung oleh UE4SS. | Mengaktifkan atau menonaktifkan pemuatan; tidak menulis bukti waktu proses. | Bendera yang dinonaktifkan atau formatnya salah mencegah bukti permulaan yang normal. | Ya, selama pemasangan. |
| `RandomDayGuard/config.lua` | Lengkapi tabel setelan publik. | `Scripts/main.lua` saat permulaan. | Field berbeda yang dikatalogkan dalam [`CONFIG_FIELD_CATALOG.md`](KATALOG_BIDANG_KONFIGURASI.md). | Mengontrol penemuan, anggaran, laporan, gerbang peninjauan, dan penanda lokal opsional. | Lua/load/default penyimpangan memblokir validasi atau membuat startup gagal ditutup. | Ya; simpan cadangan. |
| `RandomDayGuard/SavedRoot.txt` | Penggantian root tersimpan eksplisit opsional. | Resolver root tersimpan di `main.lua`. | Satu jalur sistem file generik ke `AbioticFactor/Saved`. | Memilih root yang digunakan untuk log, penyimpanan, PlayerData nama file, dan `Admin.ini`. | Tidak ada yang diperbolehkan; jalur yang tidak aman, salah, atau tidak terbaca masih belum terbukti. | Ya; jangan pernah menempatkan kredensial di sini. |
| `RandomDayGuard/BUILD_MARKER.txt` | Identitas paket yang dapat dibaca manusia. | Penginstal, validator, dan operator. | Versi rilis yang dirender oleh pembuat. | Tidak ada mutasi runtime. | Ketidakcocokan versi memblokir pengemasan. | Tidak. |
| `RandomDayGuard/MANIFEST.json` | Identitas paket dan metadata tata letak yang dapat dibaca mesin. | Validator, pembuat, dan alat dukungan. | Versi rilis yang dirender oleh pembuat. | Tidak ada mutasi runtime. | JSON atau ketidakcocokan versi memblokir pengemasan. | Tidak. |
| `RandomDayGuard/README.txt` | Referensi cepat bahasa Inggris yang diinstal. | Operator. | Jalur yang dikemas dan default yang aman. | Tidak ada mutasi runtime. | Jalur basi atau kata-kata keamanan gagal dalam paritas dokumentasi. | Tidak. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS entri, pengumpulan bukti, kepemilikan negara, penjadwalan terbatas, penegakan opsional, dan penulis keluaran. | UE4SS. | Konfigurasi, Sumber root tersimpan, terkini status runtime, kamus, dan modul pelaporan. | Menulis kelas runtime dalam [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md); jalur penegakan yang disetujui dapat dicadangkan dan diperbarui `Admin.ini`. | Startup/poll/write kegagalan menghasilkan status kesalahan yang jelas dan tidak pernah membuktikan penyelesaian rute. | Tidak. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Akuntansi sumber, silsilah siklus saat ini, terjemahan laporan, bukti rute, riwayat publik yang tahan lama, dan kotak keluar lokal opsional. | `main.lua` pekerja laporan. | Callback state/context hanya baca dan menyimpan bukti lokal. | Menulis laporan JSON/TXT berpasangan, source/history akuntansi, bukti rute, riwayat akun yang tahan lama, dan pemberitahuan status/envelopes. | Silsilah tidak ada, sumber yang diperlukan, penulisan berpasangan, atau gaya penulisan tahan rute `missing` dan memblokir antrean. | Tidak. |
| `RandomDayGuard/data/detection_events.json` | Kosakata dan penjelasan acara publik. | `main.lua` acara normalization/reporting. | Valid JSON kamus. | Beri label bukti; tidak membuat observasi. | Missing/malformed validasi repositori blok data. | Tidak. |
| `RandomDayGuard/data/warning_types.json` | Kosakata jenis peringatan dan makna ulasan. | Peringatan normalization/reporting. | Valid JSON kamus. | Memberi label bukti peringatan. | Missing/malformed validasi repositori blok data. | Tidak. |
| `RandomDayGuard/data/object_categories.json` | Object/class kosakata kategori. | Pemindaian dan registrasi objek pelaporan. | Valid JSON kamus. | Label mengekstraksi konteks kelas. | Missing/malformed validasi repositori blok data. | Tidak. |
| `RandomDayGuard/runtime/**/.gitkeep` | Kosongkan hanya placeholder tata letak pemasangan. | Ekstraksi paket. | Byte kosong. | Membuat struktur direktori yang dapat ditulis; tidak ada bukti yang dibundel. | Anggota runtime non-placeholder mana pun memblokir daftar yang diizinkan secara tepat. | Tidak. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS pemuat dan pengawas

`Scripts/main.lua` memiliki startup pengawas independen, penemuan akar tersimpan, ekor log saat ini, periode dan sesi server, pemungutan suara dan pemindaian terbatas, object/world konteks, penilaian ulasan, `Admin.ini` gerbang keselamatan, keluaran operasional lama, dan serah terima pekerja laporan yang terpisah. Pemerintah harus membatasi pemungutan suara secara langsung, sementara pekerjaan sejarah yang lambat dilanjutkan secara independen. Detak jantung, penanda permulaan, atau peningkatan `poll_id` hanya membuktikan komponen itu; penyelesaian rute memerlukan boot, epoch, polling, kesegaran sumber, pasangan laporan, dan bukti rute saat ini yang sama.

Sumber dan paket memiliki satu otoritas: `RandomDayGuard/Scripts/main.lua`. Salinan huruf kecil `scripts/` bukan bagian dari pohon sumber atau rilis. Mempertahankan satu ejaan kanonik akan mencegah kegagalan tabrakan kasus ketika paket diekstraksi di Windows atau Linux.

<a id="public-reporting-module"></a>
## Modul pelaporan publik

`Scripts/public_pipeline.lua` menerima callback, bukan kredensial host atau adaptor penyedia. Ia menginventarisasi delapan kelas sumber, mencatat status terminal dan status tidak lengkap, memisahkan pemain saat ini dari riwayat yang disimpan, menerjemahkan setiap rute dalam urutan `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action`, dan `Source references`, lalu menulis bukti rute. Mode notifikasi opsional hanya menulis amplop JSON lokal; ia tidak pernah mengklaim pengiriman atau memaketkan pengiriman endpoint/bridge.

Perlengkapan yang dapat dieksekusi di `tests/lua/public_pipeline_runtime_test.lua` memuat modul yang dikirim ini dengan Lua, membuktikan rute penuh dan diharapkan kosong, membuktikan siklus sumber arus yang hilang gagal ditutup, dan membuktikan rute yang tidak lengkap tidak masuk ke kotak keluar.

<a id="configuration-and-data"></a>
## Konfigurasi dan data

[`CONFIG_FIELD_CATALOG.md`](KATALOG_BIDANG_KONFIGURASI.md) dan [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) dihasilkan oleh `tools/generate_documentation_audit.py` dari penguraian struktural `config.lua`, daftar paket yang diizinkan, dan kelas keluaran yang ditemukan sumber. Konten yang dihasilkan secara tepat dan cakupan satu lawan satu divalidasi. Ketiga kamus JSON tersebut merupakan label dan pemetaan, bukan sumber bukti. Operator dapat mengedit konfigurasi, pemilihan root tersimpan, dan pengaktifan; sumber, kamus, manifes, dan paket readme adalah milik rilis.

<a id="package-layout"></a>
## Tata letak paket

Pembuat hanya mengizinkan tiga file root legal, `RandomDayGuard/` jalur di atas, dan placeholder waktu proses kosong. Ini memerintahkan anggota secara byte, memperbaiki ZIP metadata, mengemas pemuat kanonik satu kali, memindai materi pribadi setiap anggota, mencatat SHA-256 untuk setiap anggota, mengikat nama dan byte ke dalam satu intisari konten, dan membuat dua kali. Pengujian menolak setiap tabrakan case-fold dan membuktikan ekstraksi normal menghasilkan tepat satu file fisik per entri arsip.

Repositori publik hanya menyimpan folder rilis saat ini. Pembuatnya memeriksa apakah ZIP, checksum, catatan, penanda versi, dan pohon sumbernya sesuai.

<a id="code-comment-contract"></a>
## Kontrak komentar kode

Komentar runtime adalah kontrak pengelola yang ringkas, bukan manual kedua. Setiap modul runtime yang dikirim harus menempatkan satu tautan kanonis di blok komentar pembukanya:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Blok status, penjadwalan, write/readback/rollback, penemuan sumber, terjemahan, bukti, skema keluaran, irama rute, dan redaksi yang tidak jelas menggunakan komentar terfokus dengan label berikut jika berlaku:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

Pemuat utama juga memiliki satu komentar pemilik terfokus untuk pemuatan konfigurasi, Tersimpan penemuan, penggantian atom, penegakan, dan penjadwalan. Komentar-komentar ini menyatakan batas-batas aliran kendali dan kegagalan; mereka tidak mengubah perilaku waktu proses.

Validator memerlukan tautan `Documentation:` tingkat modul untuk setiap modul waktu proses, menyelesaikan setiap jalur komentar dan jangkar, memerlukan kontrak terfokus dan komentar kegagalan di kedua modul waktu proses, dan membandingkan tautan kanonis yang sama dengan `TRACEABILITY_INDEX.json`. Komentar bersifat ketertelusuran, bukan bukti runtime.

<a id="contributor-change-checklist"></a>
## Daftar periksa perubahan kontributor

1. Perbarui satu modul pemilik dan perlengkapan fokusnya.
2. Perbarui bagian konfigurasi kanonik, skema, keluaran, bukti, atau siklus hidup.
3. Jalankan `python -B tools/generate_documentation_audit.py --write` setelah a konfigurasi, jalur paket, kelas keluaran yang dihasilkan, pemilik, atau perubahan kontrak pemulihan.
4. Jalankan `python -B tools/generate_documentation_audit.py --check`, pengujian unit terfokus, perlengkapan Lua sebenarnya di mana Lua tersedia, validator lengkap, dua build deterministik independen, dan `git diff --check`.
5. Tinjau daftar anggota ZIP yang dihasilkan, checksum, dan pemindaian materi pribadi sebelum membuat rilis.
