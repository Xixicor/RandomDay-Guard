<a id="contributing"></a>
# Kontribusi

> **Sumber kanonis bahasa Inggris:** [CONTRIBUTING.md](../../../CONTRIBUTING.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


RandomDayGuard menerima peningkatan yang terfokus dan dapat direproduksi pada parser, dokumentasi, pengujian, dan validasi keamanan publik. Jaga agar setiap perubahan tetap terikat pada kontrak proyek publik dan pertahankan perilaku peninjauan terlebih dahulu: Penjaga harus keluar `Admin.ini` tidak berubah ketika pemeriksaan keamanan yang diperlukan tidak dapat dikonfirmasi.

<a id="prepare-a-safe-workspace"></a>
## Siapkan ruang kerja yang aman

1. Buat atau klon repositori dan buat cabang terfokus.
2. Instal penerjemah Python 3 yang didukung. Instal kompiler Lua ketika Anda mengubah Lua sehingga `luac -p` dapat memeriksa sintaksis.
3. Baca [beranda dokumentasi](DOKUMENTASI.md), [arsitektur](ARSITEKTUR.md), dan [batas bukti](BATAS_BUKTI.md) untuk area yang akan Anda ubah.
4. Periksa `git status` sebelum mengedit dan simpan pekerjaan yang tidak terkait.
5. Gunakan hanya perlengkapan sintetis atau sanitasi.

Jangan pernah mengirimkan log server pribadi, Folder tersimpan, pengidentifikasi pemain, `Admin.ini`, titik akhir notifikasi pribadi, kredensial, jalur pribadi, keluaran waktu proses, atau salinan bukti langsung.

<a id="make-a-focused-change"></a>
## Lakukan perubahan terfokus

- Ikuti penamaan, pemformatan, pemeriksaan keamanan, dan kepemilikan modul yang ada.
- Pertahankan satu pemilik dokumentasi kanonik untuk setiap prosedur atau fakta sebenarnya.
- Perbarui dokumentasi pengguna dan contoh ketika perilaku atau keluaran publik berubah.
- Tambahkan uji regresi untuk perbaikan bug bila memungkinkan.
- Jangan melemahkan konfirmasi akun, perlindungan akun tepercaya, verifikasi cadangan, deteksi perubahan luar, perbandingan file tersimpan, pemulihan, atau default hanya tinjauan untuk membuat lulus pengujian.

<a id="run-the-relevant-checks"></a>
## Jalankan pemeriksaan yang relevan

Untuk perubahan hanya dokumentasi, jalankan:

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

Untuk perubahan sumber, konfigurasi, pengemasan, atau pengujian, jalankan juga pemeriksaan yang berlaku dari [Tinjauan validasi dan rilis](VALIDASI_DAN_RILIS.md), termasuk pemeriksaan sintaksis Lua, validasi repositori, pengujian saluran publik, dan rangkaian pengujian unit lengkap. Laporkan setiap cek yang dilewati atau tidak tersedia; jangan menggambarkannya sebagai telah dilewati.

<a id="submit-the-change-for-review"></a>
## Kirimkan perubahan untuk ditinjau

Buka permintaan penarikan terfokus hanya setelah meninjau perbedaan lengkap. Mencakup:

- masalah dan perilaku yang diinginkan;
- file persis dan kontrak publik diubah;
- perintah dijalankan dan hasilnya;
- dampak privasi, kompatibilitas, dan penegakan hukum; dan
- batasan yang tersisa atau pekerjaan tindak lanjut.

Jangan sertakan bukti runtime atau arsip rilis yang dihasilkan kecuali perubahan tersebut secara eksplisit mengharuskan dan memvalidasinya. Kontribusi tidak mengizinkan rilis, penerapan, pengujian server langsung, tindakan penegakan hukum, atau publikasi di situs pihak ketiga.

Laporkan kerentanan melalui [rute keamanan pribadi](KEAMANAN.md), bukan masalah publik atau permintaan penarikan biasa.
