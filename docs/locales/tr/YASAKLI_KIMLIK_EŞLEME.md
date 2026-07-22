<a id="ban-id-mapping"></a>
# Kimlik eşlemeyi yasakla

> **Kanonik İngilizce kaynağı:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bir oyuncu adını güvenli bir `Admin.ini` yasaklama satırına dönüştürürken bu sayfayı kullanın.

<a id="core-rule"></a>
## Temel kural

Görünen ad, yasaklama kimliği değildir.

`Admin.ini` şunu kullanır:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Kanıt hiyerarşisi

| Sıralama | Kaynak | Kullanım |
|---:|---|---|
| 1 | Sunucu günlüğü `Login request` | Addan kimliğe en iyi eşleme |
| 2 | `Player_<ID>.sav` | Kimliğin mevcut olduğunu doğrular |
| 3 | Mevcut `Admin.ini` | Mevcut bans/moderators |
| 4 | Harici bildirim veya barındırma paneli etkinliği | Time/name yalnızca bağlam; kimlik kanıtı değildir |
| 5 | UE4SS focus/player satırlar | Presence/context yalnızca |
| 6 | Sistem yaşam döngüsü veya kapsayıcı günlükleri | Yalnızca ana bilgisayar yaşam döngüsü bağlamı; kimlik kanıtı değil |

<a id="extract-the-clean-id"></a>
## Temiz kimliği çıkarın

Ham örnek:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Temizle `Admin.ini` değeri:

```ini
BannedPlayer=2535422284688820
```

Yapıştırmayın `_+_|...`.

<a id="verify-with-playerdata"></a>
## ile doğrulayın PlayerData

Şunları kontrol edin:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Anlamı:

```text
The ID exists in the world save.
```

Sınırlama:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Ne zaman yasaklanmamalı

Şu durumlarda yasak kimliği atamayın:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Kanıt tablosu şablonu

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
## İlgili belgeler

* [`ADMIN_INI_ENFORCEMENT.md`](Y%C3%96NETICI_INI_UYGULAMASI.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](OYUNCU_%C4%B0NCELEME_%C4%B0%C5%9E_AKI%C5%9EI.md)
