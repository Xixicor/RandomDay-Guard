<a id="evidence-boundary"></a>
# Batas bukti

> **Sumber kanonis bahasa Inggris:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Gunakan laman ini untuk memutuskan RandomDayGuard dapat melaporkan dan apa yang masih memerlukan peninjauan manusia.

<a id="core-rule"></a>
## Aturan inti

RandomDayGuard mencatat observasi terbatas dari file milik server. Ia harus mengidentifikasi sumber, ruang lingkup, status pengumpulan, dan batasan untuk setiap kesimpulan material.

Bukti terstruktur bersifat otoritatif. Laporan yang diterjemahkan menjelaskan buktinya; ia tidak dapat menambahkan fakta yang tidak ada dalam catatan terstruktur.

<a id="evidence-source-classes"></a>
## Kelas sumber bukti

| Kelas sumber | Penggunaan umum | Tidak membuktikan dengan sendirinya |
|---|---|---|
| `admin_ini` | Status administrasi yang ada dan diaudit write/readback konteks | Siapa yang menyebabkan sebuah insiden |
| `active_log` | Peristiwa server/session terkini yang terlihat di log aktif | Niat, kepemilikan, atau kerusakan langsung |
| `recent_backup_logs` | Konteks log historis | Peristiwa terkini terjadi |
| `playerdata_filenames` | Pembuktian bahwa pengenal akun bersih ada | Perilaku, rasa bersalah, atau kepemilikan identitas di luar pengidentifikasi yang terungkap |
| `existing_cases` | Konteks peninjauan sebelumnya | Bahwa interpretasi sebelumnya tetap benar |
| `existing_reports` | Ringkasan dan keputusan sebelumnya | Kebenaran saat ini tanpa bukti yang menguatkan saat ini |
| `existing_evidence` | Bukti terstruktur sejarah | Aktivitas saat ini |
| pemindaian penyimpanan dunia terbatas | Lambat world/class konteks | Tindakan pemain, kepemilikan, pencurian, duplikasi, atau kerusakan |

Setiap sumber mencatat availability/readability, jumlah file, referensi sumber, cakupan terkini atau historis, dan `does_not_prove` eksplisit pernyataan.

<a id="source-states"></a>
## Sumber menyatakan

| Status | Arti operator |
|---|---|
| `available` | Sumber dapat dibaca dan bukti telah dikumpulkan. |
| `expected_empty` | Sumber dapat dibaca dan secara sah tidak memiliki catatan yang cocok. |
| `partial` | Beberapa bukti telah dikumpulkan; cakupannya tidak lengkap. |
| `deferred` | Pekerjaan yang dibatasi sengaja ditunda. |
| `unavailable` | Sumber tidak ada di lingkungan ini. |
| `malformed` | Sumber ada tetapi tidak dapat diuraikan dengan aman. |
| `permission_denied` | Pengawas tidak memiliki izin membaca. |
| `error` | Pengumpulan gagal untuk rekaman lain alasan. |

Yang diharapkan kosong adalah pengamatan yang valid. Bukti tersebut tidak boleh diubah menjadi pemain, kasus, insiden, atau tuduhan yang dibuat-buat.

<a id="current-versus-historical-evidence"></a>
## Bukti terkini versus bukti sejarah

Bukti terkini termasuk dalam periode pengumpulan atau periode server yang aktif. Bukti sejarah berasal dari catatan, kasus, laporan, catatan bukti, cadangan, atau data dasar sebelumnya.

Bukti sejarah dapat memberikan konteks. Hal ini tidak dapat secara diam-diam mengisi kesenjangan bukti yang ada saat ini. Laporan harus memberi label pada kedua cakupan dan mengutip sumbernya secara terpisah.

<a id="corroboration-rule"></a>
## Aturan pembuktian

Ini adalah konteks yang berguna tetapi bukan merupakan bukti langsung:

- nama tampilan atau kesamaan nama;
- kebetulan waktu;
- memutuskan atau menghubungkan kembali churn;
- satu error atau peringatan meledak;
- kelas, jalur, aktor, peta, atau token jumlah objek;
- keanggotaan dalam kasus yang dikelompokkan secara otomatis;
- laporan sebelumnya tanpa konfirmasi sumber saat ini.

Jangan mengklaim kesalahan, niat, kecurangan, kepemilikan, pencurian, duplikasi, kerusakan langsung, penggunaan kontainer langsung, tindakan inventaris langsung, koordinat langsung yang tepat, ping langsung, atau perilaku tingkat memori tanpa bukti yang secara langsung mengungkap fakta.

<a id="truthful-report-language"></a>
## Bahasa laporan yang benar

Gunakan:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Hindari:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Urutan pembacaan laporan

Setiap laporan yang dapat diakses oleh publik harus menjelaskan:

1. Makna yang jelas.
2. Mengapa hal ini penting.
3. Bukti teknis dan referensi sumber.
4. Tindakan selanjutnya.
5. Batas, hal yang tidak diketahui, dan klaim tidak terbukti.

<a id="related-docs"></a>
## Dokumen terkait

- [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](ALUR_KERJA_TINJAUAN_PEMAIN.md)
- [`BAN_ID_MAPPING.md`](PEMETAAN_ID_LARANGAN.md)
- [`DETECTION_SIGNALS.md`](SINYAL_DETEKSI.md)
