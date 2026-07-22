<a id="install-randomdayguard"></a>
# Instal RandomDayGuard

> **Sumber kanonis bahasa Inggris:** [INSTALL.md](../../../INSTALL.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Panduan ini menginstal `v0.4.12-alpha` pada server khusus Abiotic Factor yang sudah menggunakan UE4SS. Mod tidak terikat pada satu perusahaan hosting atau panel kontrol.

<a id="before-you-begin"></a>
## Sebelum memulai

Anda memerlukan:

- akses untuk menghentikan dan memulai server khusus;
- server UE4SS `Mods` server;
- salinan dari RandomDayGuard jika Anda memperbarui;
- cadangan data server yang biasanya Anda lindungi sebelum mengubah mod.

**Folder mods** adalah `ue4ss/Mods/` direktori di dalam instalasi server khusus. RandomDayGuard langsung berada di dalam folder itu.

<a id="new-installation"></a>
## Instalasi baru

1. Hentikan server khusus.
2. Ekstrak RandomDayGuard ZIP ke dalam folder kosong baru.
3. Salin folder `RandomDayGuard` ke dalam UE4SS `Mods` folder. Hasilnya harus berupa satu folder `Mods/RandomDayGuard/`, bukan sedetik RandomDayGuard bersarang di dalamnya.
4. Buka UE4SS `mods.txt` dan aktifkan:

   ```text
   RandomDayGuard : 1
   ```

5. Mulai server secara normal.
6. Tunggu UE4SS dan server game untuk menyelesaikan permulaan, lalu ikuti [Baca laporan pertama](MULAI_DI_SINI.md).

Jangan menyalin rilis baru dari instalasi yang sedang berjalan. Simpan cadangan hingga instalasi yang diperbarui menghasilkan laporan status server saat ini.

<a id="update-an-existing-installation"></a>
## Perbarui instalasi yang ada

1. Hentikan server.
2. Salin seluruh instalasi RandomDayGuard folder ke lokasi pencadangan yang aman.
3. Keluarkan folder program lama dari UE4SS `Mods` alih-alih melapisi rilis baru di atasnya.
4. Salin yang baru RandomDayGuard folder ke dalam `Mods`.
5. Pulihkan hanya lokal yang telah ditinjau konfigurasi dan bukti yang disimpan. Jika panduan konfigurasi mencantumkan kolom baru, gabungkan kolom tersebut ke dalam salinan yang telah ditinjau alih-alih mengganti semua setelan secara membabi buta.
6. Konfirmasi `RandomDayGuard : 1` tetap diaktifkan.
7. Mulai server dan baca laporan status server saat ini.

Pembaruan folder bersih ini juga menghapus file usang dari rilis lama tanpa meminta operator untuk memeriksa program nama file.

<a id="help-guard-find-the-server-records"></a>
## Bantu Penjaga menemukan catatan server

Penjaga biasanya menemukan direktori Faktor Abiotik `Saved` secara otomatis. Jika tidak bisa, masukkan path lengkap ke direktori `Saved` tersebut di `SavedRoot.txt` di dalam RandomDayGuardfolder. Arahkan ke `Saved`, bukan satu dunia di bawahnya.

Laporan status server pertama menyatakan apakah lokasi rekaman ditemukan dan grup sumber mana yang tersedia. Gunakan [Pemecahan Masalah](PEMECAHAN_MASALAH.md) jika tidak dapat membaca lokasi.

<a id="first-run-behavior"></a>
## Perilaku yang dijalankan pertama kali

Instalasi default mengawasi catatan yang tersedia dan menulis laporan. Itu tidak mengubah `Admin.ini` atau menambahkan larangan. Hal ini memungkinkan Anda mengonfirmasi pengumpulan, terjemahan, dan kualitas laporan sebelum memutuskan apakah akan mengaktifkan tindakan opsional apa pun.

[Baca laporan pertama](MULAI_DI_SINI.md)

<a id="disable-or-remove-randomdayguard"></a>
## Menonaktifkan atau menghapus RandomDayGuard

1. Hentikan server.
2. Salin folder RandomDayGuard lengkap ke arsip yang aman.
3. Untuk menonaktifkan mod, setel `RandomDayGuard : 0` di UE4SS `mods.txt`.
4. Untuk menghapusnya, pindahkan folder RandomDayGuard lengkap dari `Mods` setelah mengonfirmasi bahwa arsip dapat dibuka.
5. Mulai server dan konfirmasikan Guard tidak lagi dimulai.

Menonaktifkan atau menghapus Guard akan menghentikan pengumpulan di masa mendatang. Itu tidak menghapus data game, menghapus laporan yang diarsipkan, atau membalikkan tindakan operator terpisah.

<a id="roll-back-an-update"></a>
## Membatalkan pembaruan

Jika instalasi baru tidak dimuat atau tidak dapat menghasilkan laporan saat ini:

1. Hentikan server.
2. Singkirkan instalasi yang gagal tanpa menghapus catatannya.
3. Pulihkan folder RandomDayGuard pra-pembaruan lengkap.
4. Pulihkan konfigurasi yang telah ditinjau dan simpan bukti dari cadangan yang sama.
5. Konfirmasi bahwa mod telah diaktifkan dan mulai server.
6. Baca laporan status server yang dipulihkan sebelum melakukan perubahan lainnya.

<a id="more-help"></a>
## Bantuan lebih lanjut

- [Baca laporan pertama](MULAI_DI_SINI.md)
- [Buku pedoman pengoperasian](BUKU_PEDOMAN_OPERASI.md)
- [Pemecahan Masalah](PEMECAHAN_MASALAH.md)
- [Profil konfigurasi](PROFIL_KONFIGURASI.md)
- [Admin.ini penegakan](PENEGAKAN_ADMIN_INI.md)

Pemelihara rilis dapat menemukan sumber, paket, dan pemeriksaan privasi di [Validasi dan rilis](VALIDASI_DAN_RILIS.md). Mereka tidak diperlukan untuk instalasi biasa.
