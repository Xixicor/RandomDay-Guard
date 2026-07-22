<a id="faq"></a>
# FAQ

> **Sumber kanonis bahasa Inggris:** [FAQ.md](../../FAQ.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


<a id="is-randomdayguard-the-randomday-mod"></a>
## Apakah RandomDayGuard RandomDay Mod?

Tidak. RandomDay Mod mengubah pengalaman server. RandomDayGuard mengawasi lapisan bukti server.

<a id="does-live-defense-work-before-the-scan-completes"></a>
## Apakah pertahanan langsung berfungsi sebelum pemindaian selesai?

Ya. Pertahanan langsung menggunakan log dan peristiwa sesi. Pemindaian dasar akan menyempurnakan konteksnya nanti.

<a id="why-can-the-first-scan-take-a-long-time"></a>
## Mengapa pemindaian pertama bisa memakan waktu lama?

Pemindaian pertama membangun world/object konteks, manifes file, dan data dasar yang dapat digunakan kembali.

<a id="what-do-i-check-first-after-startup"></a>
## Apa yang pertama kali saya periksa setelah memulai?

```text
runtime/current/poll_status.json
```

Cari:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

<a id="where-are-player-summaries"></a>
## Di mana pemain ringkasan?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

<a id="where-is-the-daily-quick-review-package"></a>
## Di mana paket tinjauan cepat harian?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="which-file-should-i-upload-for-fastest-review"></a>
## File mana yang harus saya unggah untuk peninjauan tercepat?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="can-it-write-bans-automatically"></a>
## Dapatkah ia menulis larangan secara otomatis?

Hanya jika diaktifkan secara eksplisit.

Default:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

<a id="what-does-adminini-receive"></a>
## Apa artinya Admin.ini diterima?

Hanya:

```ini
BannedPlayer=<ID>
```

Tidak ada nama, komentar, alasan, atau akhiran.

<a id="is-a-display-name-enough-to-ban"></a>
## Apakah nama tampilan cukup untuk diblokir?

Tidak. Gunakan log server `Login request` dengan `ConnectID` atau bukti server yang setara.

<a id="can-one-crash-ban-someone"></a>
## Dapatkah satu crash mencekal seseorang?

Tidak secara default.

<a id="can-object-count-alone-ban-someone"></a>
## Dapatkah jumlah objek saja mencekal seseorang?

Tidak secara default.

<a id="should-savedroottxt-point-to-the-world-folder"></a>
## Haruskah SavedRoot.txt menunjuk ke dunia folder?

Tidak. Arahkan ke `AbioticFactor/Saved`.

<a id="what-if-the-world-folder-changes"></a>
## Bagaimana jika folder dunia berubah?

Perlakukan ini sebagai perubahan identitas dasar. Pertahankan garis dasar lama dan buat yang baru.

<a id="related-docs"></a>
## Dokumen terkait

* [`START_HERE.md`](MULAI_DI_SINI.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](ROLLUP_HARIAN_FORENSIK.md)
* [`TROUBLESHOOTING.md`](PEMECAHAN_MASALAH.md)
