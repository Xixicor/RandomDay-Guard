<a id="player-review-workflow"></a>
# Alur kerja peninjauan pemain

> **Sumber kanonis bahasa Inggris:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Gunakan halaman ini untuk satu pemain, akun, atau kasus. Tujuannya adalah keputusan peninjauan yang dapat direproduksi, bukan tuduhan otomatis.

<a id="quick-path"></a>
## Jalur cepat

1. Buka `runtime/final_logs/player_activity_latest.json`.
2. Konfirmasi status rute di `runtime/final_logs/route_proof.json`.
3. Identifikasi pengamatan mana yang terkini dan mana yang historis.
4. Periksa identitas yang dikutip dan referensi sumber sesi.
5. Tinjau `case_review_latest.json` ketika ada kasus yang berkorelasi.
6. Catat hal yang tidak diketahui dan `does_not_prove` sebelum memilih tindakan.
7. Biarkan penerapan dinonaktifkan kecuali gerbang penegakan hukum yang terpisah terbukti.

<a id="1-confirm-route-proof"></a>
## 1. Konfirmasi bukti rute

Interpretasikan rute pemutar sebagai:

| Status | Aksi |
|---|---|
| `full` | Lanjutkan, sambil tetap meninjau batas sumber. |
| `limited_expected_empty` | Lanjutkan hanya dengan subjek yang benar-benar ada; jangan menemukan pemain atau kasus yang hilang. |
| `missing` | Hentikan keputusan pemain dan pecahkan masalah rute. |

Penjadwal yang sehat tidak menggantikan bukti rute.

<a id="2-establish-identity"></a>
## 2. Tetapkan identitas

Pilih pengidentifikasi akun bersih yang dikuatkan oleh bukti identitas yang terekspos di server dan, jika tersedia, PlayerData nama file. Simpan referensi sumber mentah.

Jangan memaksakan dari:

- nama tampilan saja;
- nama yang terlihat di panel notifikasi atau hosting;
- kesamaan waktu;
- identitas yang belum dipetakan atau berkeyakinan lemah;
- laporan historis tanpa pembuktian terkini.

<a id="3-separate-current-from-historical"></a>
## 3. Pisahkan bukti terkini dari historis

Bukti terkini menjelaskan jendela pelaporan aktif atau zaman server. Bukti sejarah dapat menjelaskan suatu pola, namun tidak dapat secara diam-diam mengisi kekosongan dalam jendela saat ini.

Rekam kedua cakupan secara terpisah:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Tinjau observasi dan interpretasi

Baca bagian laporan ini dengan jelas:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Buka kembali bukti terstruktur yang dikutip untuk setiap keputusan material. Terjemahan adalah navigasi dan penjelasan, bukan bukti baru.

<a id="5-calibrate-the-decision"></a>
## 5. Kalibrasi keputusan

| Keputusan | Gunakan ketika |
|---|---|
| `INFO` | Pengamatan normal atau konteks rendah. |
| `WATCH` | Sinyal lemah atau tidak lengkap layak untuk dipantau. |
| `REVIEW` | Bukti yang berkorelasi memerlukan penilaian administrator. |
| `BAN-ELIGIBLE` | Identitas yang bersih dan ambang batas bukti yang dikonfigurasikan bertemu; gerbang tulis masih berlaku. |
| `AUTO-BANNED` | Penerapan diaktifkan secara eksplisit dan pencadangan, penulisan, pembacaan kembali, dan audit semuanya berhasil. |

Tidak ada label keputusan yang membuktikan kesalahan atau niat.

<a id="6-apply-the-evidence-boundary"></a>
## 6. Menerapkan batasan bukti

Kerusakan, penyambungan kembali, peringatan, token object/class, dan pengelompokan kasus dapat mendukung peninjauan. Dokumentasi tersebut tidak membuktikan adanya kecurangan, pencurian, duplikasi, kepemilikan, kerusakan langsung, atau penyebab insiden.

Jika identitas, penguraian, pencadangan, penulisan, pembacaan kembali, atau rollback lemah atau gagal, penegakan hukum harus gagal ditutup.

<a id="review-note-template"></a>
## Tinjau templat catatan

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

<a id="related-docs"></a>
## Dokumen terkait

- [`EVIDENCE_BOUNDARY.md`](BATAS_BUKTI.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENSI_SKEMA_OUTPUT.md)
- [`ADMIN_INI_ENFORCEMENT.md`](PENEGAKAN_ADMIN_INI.md)
- [`DETECTION_SIGNALS.md`](SINYAL_DETEKSI.md)
