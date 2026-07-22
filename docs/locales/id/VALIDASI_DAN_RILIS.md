<a id="validation-and-release"></a>
# Validasi dan rilis

> **Sumber kanonis bahasa Inggris:** [VALIDATION_AND_RELEASE.md](../../VALIDATION_AND_RELEASE.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Halaman ini ditujukan untuk kontributor dan pengelola rilis. Operator server tidak perlu menjalankan perintah ini untuk menginstal RandomDayGuard.

<a id="user-visible-proof"></a>
## Bukti yang terlihat oleh pengguna

Rilis dapat dimengerti ketika operator baru dapat menginstalnya, menemukan laporan status server pertama, membedakan lima rute laporan, dan mengikuti satu tindakan yang jelas dari contoh yang berhasil. Tugas pembaca tidak boleh memerlukan pengetahuan Git, PowerShell, Python, atau checksum.

<a id="contributor-checks"></a>
## Pemeriksaan kontributor

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

Kapan `luac` tersedia:

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

Pengujian perlengkapan Lua mencakup loader, penjadwal, rute laporan, dan transaksi tulis Admin.ini opsional. Perlengkapan penerapan hanya menggunakan file sementara dan memverifikasi identitas, penolakan akun tepercaya, ambang batas, pencadangan, penolakan perubahan bersamaan, pembacaan kembali, dan pengembalian.

<a id="package-proof"></a>
## Bukti paket

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- Semua penanda versi cocok `VERSION`.
- Hanya versi saat ini yang ada di bawah `releases/`.
- ZIP berisi `RandomDayGuard/Scripts/main.lua` dan tidak ada pemuat varian huruf kecil.
- Output runtime, konfigurasi pribadi, kredensial, jalur lokal, cache, dan artefak pengujian tidak termasuk.
- Konfigurasi publik tetap hanya untuk peninjauan dengan penegakan dinonaktifkan.
- Lima contoh laporan yang dikerjakan tetap konsisten dengan kepemilikan rute dan perlengkapan pengujian rilis.
- ZIP byte kanonik yang bersifat deterministik dan cocok `CHECKSUMS.sha256`.
- Semua link dokumentasi lokal dan 27 halaman entri lokal divalidasi.

<a id="avoid-validation-environment-pitfalls"></a>
## Hindari kesalahan lingkungan validasi

- Jalankan pemeriksaan penulisan repositori secara serial untuk menghindari pertikaian file sementara.
- Di Windows, periksa nama anggota yang diarsipkan atau ejaan jalur yang dihitung daripada pencarian file yang tidak membedakan huruf besar dan kecil saat memeriksa duplikat loader.
- Perintah `luac` yang hilang atau runtime Lua adalah kemampuan yang tidak tersedia, bukan pengujian sintaksis atau runtime yang lewat.
- Fixture hanya membuktikan input yang dimodelkan. Hal ini tidak membuktikan bahwa server aktif menghasilkan laporan terkini.
- Rekam batas waktu perintah dan keluaran sebagian alih-alih berasumsi selesai.

<a id="repair-failed-repository-validation"></a>
## Perbaiki validasi repositori yang gagal

Mulai dengan jalur atau kontrak pertama yang dilaporkan. Perbaiki item tersebut, jalankan kembali pengujian sempit, lalu jalankan kembali matriks lengkap. Jangan sembunyikan kemampuan yang hilang dengan menghapus pengujian yang memerlukannya.

<a id="known-limits-and-release-decision"></a>
## Batas yang diketahui dan keputusan rilis

Pemeriksaan lokal membuktikan kontrak sumber, perlengkapan, paket, dan dokumentasi. Instalasi server tertentu, jendela stabilitas yang berjalan lama, atau tampilan klien memerlukan hasil integrasi terpisah. Catat hasil tersebut dengan build, konfigurasi, durasi, dan keluaran yang diamati sebelum membuat klaim yang cocok.
