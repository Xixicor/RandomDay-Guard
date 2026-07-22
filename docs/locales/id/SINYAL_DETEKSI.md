<a id="detection-signals"></a>
# Sinyal deteksi

> **Sumber kanonis bahasa Inggris:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Sinyal adalah masukan tinjauan, bukan tuduhan otomatis.

<a id="signal-table"></a>
## Tabel sinyal

| Sinyal | Arti | Lebih kuat ketika... | Tidak cukup dengan sendirinya |
|---|---|---|---|
| Identitas login | Memetakan nama ke ID akun | ConnectID ada | Larangan |
| Keluar bersih | Penutupan sesi normal | Bergabung dan keluar dari pertandingan | Kecurigaan |
| Hubungan kembali dengan cepat | Churn/probing konteks | Berulang dengan cepat | Larangan |
| Pemutusan sambungan tidak bersih | Sesi tidak ditutup dengan rapi | Pengulangan atau crash yang tumpang tindih | Larangan |
| Error yang tumpang tindih | Akun aktif hampir error | Akun yang sama berulang | Larangan |
| Pengembalian pasca-crash | Akun kembali setelah dimulai ulang | Berulang dalam beberapa periode | Blok per satu peristiwa |
| Peringatan burst | Jendela peringatan server | Sesi yang dipetakan tumpang tindih | Ban per satu burst |
| Aktor menyimpan sentuhan | Konteks penyelamatan dunia | Berkorelasi dengan session | Bukti use/theft |
| Objek delta | World/class perubahan | Berkorelasi dengan session | Larangan dari penghitungan saja |
| Kasus serangan | Kluster multi-akun | Pengulangan akun pusat | Larangan massal semua akun |

<a id="login-identity"></a>
## Identitas login

Sumber terbaik:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Gunakan untuk memetakan:

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Hubungan kembali dengan cepat

Pola:

```text
join -> leave -> join -> leave -> join
```

Gunakan untuk peninjauan saat diulang.

Keamanan:

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Kerusakan yang tumpang tindih dan pengembalian pasca kerusakan

Pola:

```text
account active before crash
server restarts
same account returns quickly
```

Gunakan untuk peninjauan saat diulangi epochs.

Keamanan:

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Lonjakan peringatan

Contoh:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Gunakan sebagai konteks hingga ditautkan ke sesi dan ambang batas yang dipetakan.

<a id="actor-save-touch"></a>
## Aktor menyimpan sentuhan

Arti:

```text
The server evidence referenced a class or actor.
```

Tidak berarti:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## Kasus serangan

Kasus penggerebekan mengelompokkan akun berdasarkan waktu dan jendela bersama.

Aturan:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## Dokumen terkait

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](POLA_DAN_KETAHANAN_PELAKU_BURUK.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](ALUR_KERJA_TINJAUAN_PEMAIN.md)
