# Panduan RandomDayGuard Bahasa Indonesia

**v0.4.12-alpha**

RandomDayGuard mengubah bukti terbatas dari dedicated server Abiotic Factor
menjadi laporan operator yang mudah dibaca. Status server, rangkuman harian,
aktivitas pemain, peninjauan kasus, dan kegagalan kritis tetap terpisah.

## Instalasi

Ikuti [panduan instalasi](../../../INSTALL.md). Lokasi mod harus
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
`write_admin_ini = false`. Gunakan [Mulai](../../START_HERE.md),
[Operasi](../../OPERATIONS_PLAYBOOK.md), [Konfigurasi](../../CONFIG_PROFILES.md),
dan [Pemecahan masalah](../../TROUBLESHOOTING.md). Bukti terstruktur adalah
catatan teknis; terjemahan membuatnya lebih mudah dibaca.

Perintah, path, key, dan status tetap berbahasa Inggris agar cocok dengan file.

## Rilis alfa dan dua jalur bukti

Ini adalah rilis alfa. Jalur pengumpulan, pelaporan, dan pemulihan yang didokumentasikan telah diuji; kompatibilitas, cakupan sejarah, dan mutu laporan terus ditingkatkan.

Jalur saat ini memakai log aktif, keadaan awal dan penjadwal saat ini, serta sesi yang sedang berjalan sehingga dapat menulis laporan terkini segera. Jalur sejarah memeriksa log tersimpan, nama PlayerData, bukti, dan kasus lama dalam langkah terbatas.

`runtime/current/report_worker_status.json`

Bandingkan `scan_cursor` dan `last_progress_ts` di `runtime/current/report_worker_status.json` selama beberapa siklus. Jika bergerak, pemindaian bekerja. Jika tetap sama saat laporan terkini maju, pemindaian sejarah macet; fakta terkini tetap berguna, tetapi kesimpulan yang membutuhkan sejarah lama terbatas.

[Troubleshooting](../../TROUBLESHOOTING.md)
