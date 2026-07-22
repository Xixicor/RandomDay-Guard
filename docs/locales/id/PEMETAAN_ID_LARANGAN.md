<a id="ban-id-mapping"></a>
# Pemetaan ID pelarangan

> **Sumber kanonis bahasa Inggris:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Dokumentasi yang dilokalkan ini mempertahankan perintah, jalur, kunci, nilai status, hash, dan nama file yang tepat. Jika kata-kata teknisnya berbeda, gunakan sumber bahasa Inggris.


Gunakan halaman ini saat mengonversi nama pemain menjadi `Admin.ini` baris larangan yang aman.

<a id="core-rule"></a>
## Aturan inti

Nama tampilan bukan ID larangan.

`Admin.ini` menggunakan:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Hierarki bukti

| Peringkat | Sumber | Gunakan |
|---:|---|---|
| 1 | Log server `Login request` | Pemetaan nama-ke-ID terbaik |
| 2 | `Player_<ID>.sav` | Mengonfirmasi ID ada |
| 3 | Ada `Admin.ini` | Ada bans/moderators |
| 4 | Pemberitahuan eksternal atau aktivitas panel hosting | Time/name hanya dalam konteks; bukan bukti ID |
| 5 | UE4SS focus/player baris | Presence/context saja |
| 6 | Siklus hidup sistem atau log kontainer | Hanya konteks siklus hidup host; bukan bukti ID |

<a id="extract-the-clean-id"></a>
## Ekstrak ID bersih

Contoh mentah:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Nilai bersih `Admin.ini`:

```ini
BannedPlayer=2535422284688820
```

Jangan tempel `_+_|...`.

<a id="verify-with-playerdata"></a>
## Verifikasi dengan PlayerData

Periksa:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Arti:

```text
The ID exists in the world save.
```

Batasan:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Kapan tidak melarang

Jangan menetapkan ID larangan ketika:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Template tabel bukti

```text
display_name:
server_time:
log_file:
line_number:
log_name:
connect_id_raw:
ban_id:
unique_id:
playerdata_file:
decision:
notes:
```

<a id="related-docs"></a>
## Dokumen terkait

* [`ADMIN_INI_ENFORCEMENT.md`](PENEGAKAN_ADMIN_INI.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](ALUR_KERJA_TINJAUAN_PEMAIN.md)
