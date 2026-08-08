# Panduan RandomDayGuard Bahasa Indonesia

> [!IMPORTANT]
> ## Status proyek — pengujian RandomDay selesai
>
> Operasi pengujian RandomDay telah selesai dan server uji publik akan segera ditutup.
>
> Selama operasi ini, RandomDay dan RandomDayGuard dijalankan bersama melalui rotasi profil berulang, pemulaian ulang server yang normal maupun terputus, pemeriksaan pemulihan dan rollback, integrasi mod tambahan, pengumpulan bukti server, serta peninjauan laporan operator.
>
> Hal ini memberi kami pengetahuan yang ingin kami peroleh: bagaimana profil sandbox yang berotasi berperilaku sepanjang siklus hidup nyata server khusus; bagaimana RandomDay berinteraksi dengan mod tambahan yang didukung; dan sejauh mana RandomDayGuard dapat mengubah bukti yang ditulis server menjadi pemantauan yang berguna dan berhati-hati tanpa menyajikan celah atau dugaan sebagai fakta.
>
> **Stack server uji yang digunakan:**
>
> - RandomDay build pengembangan privat `v0.41.76`
> - RandomDayGuard build pengembangan privat `v0.46.130`
> - Chaotic Spawn Engine / DynamicSpawns `0.8.5 Hotfix 1`
> - Lethal Lasers `1.0 UE4SS`
> - ANTE Up `0.26`
> - Encounter Director integration — ekstensi DynamicSpawns milik RandomDay, bukan mod yang didistribusikan secara terpisah
> - UE4SS `v3.0.1 Beta #0` (Git `01e0a584`; Nexus `v3.0.1-940-g01e0a584`)
> - server khusus Abiotic Factor `1.4.0.27939`
>
> Paket yang saat ini diterbitkan tetap RandomDay `v0.3.16-alpha` dan RandomDayGuard `v0.4.12-alpha`.
>
> Pengembangan kedua proyek kini dijeda. Rilis dan dokumentasi yang ada akan tetap tersedia, dan kami mungkin kembali ketika kembali ingin melanjutkan pekerjaan ini.
>
> Stack ini mendokumentasikan apa yang digunakan selama operasi; ini bukan persyaratan versi minimum ataupun jaminan kompatibilitas dengan versi game, loader, atau mod yang lebih baru. Siklus terakhir yang dicatat secara resmi menggunakan Abiotic Factor `1.4.0.27939`.

**v0.4.12-alpha**

RandomDayGuard mengubah bukti terbatas dari dedicated server Abiotic Factor
menjadi laporan operator yang mudah dibaca. Status server, rangkuman harian,
aktivitas pemain, peninjauan kasus, dan kegagalan kritis tetap terpisah.

## Instalasi

Ikuti [panduan instalasi](PEMASANGAN.md). Lokasi mod harus
`ue4ss/Mods/RandomDayGuard` dan `mods.txt` harus memuat `RandomDayGuard : 1`.
Hindari instalasi bertingkat dan folder `Scripts` ganda.

## Buktikan laporan pertama

Periksa `runtime/current/startup_status.json`, lalu
`runtime/final_logs/latest_dossier.json` dan
`runtime/final_logs/route_proof.json`. Setiap rute melaporkan `full`,
`limited_expected_empty`, atau `missing`. Ringkasan dan sumber yang dirujuk harus
berasal dari siklus yang sama.

## Konfigurasi dan operasi

Nilai publik awal adalah `review_only_mode = true`, `auto_ban = false`, dan
`write_admin_ini = false`. Gunakan [Mulai](MULAI_DI_SINI.md),
[Operasi](BUKU_PEDOMAN_OPERASI.md), [Konfigurasi](PROFIL_KONFIGURASI.md),
dan [Pemecahan masalah](PEMECAHAN_MASALAH.md). Bukti terstruktur adalah
catatan teknis; terjemahan membuatnya lebih mudah dibaca.

Perintah, path, key, dan status tetap berbahasa Inggris agar cocok dengan file.

## Rilis alfa dan dua jalur bukti

Ini adalah rilis alfa. Jalur pengumpulan, pelaporan, dan pemulihan yang didokumentasikan telah diuji; kompatibilitas, cakupan sejarah, dan mutu laporan terus ditingkatkan.

Jalur saat ini memakai log aktif, keadaan awal dan penjadwal saat ini, serta sesi yang sedang berjalan sehingga dapat menulis laporan terkini segera. Jalur sejarah memeriksa log tersimpan, nama PlayerData, bukti, dan kasus lama dalam langkah terbatas.

`runtime/current/report_worker_status.json`

Bandingkan `scan_cursor` dan `last_progress_ts` di `runtime/current/report_worker_status.json` selama beberapa siklus. Jika bergerak, pemindaian bekerja. Jika tetap sama saat laporan terkini maju, pemindaian sejarah macet; fakta terkini tetap berguna, tetapi kesimpulan yang membutuhkan sejarah lama terbatas.

[Troubleshooting](PEMECAHAN_MASALAH.md)

## Perpustakaan dokumentasi lengkap

Setiap dokumen Penurunan Harga publik tersedia dalam bahasa ini dengan nama file yang dilokalkan.

- [Buka indeks dokumentasi yang dilokalkan](DOKUMENTASI.md)
