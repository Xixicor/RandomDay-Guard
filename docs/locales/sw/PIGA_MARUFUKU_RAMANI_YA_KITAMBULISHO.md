<a id="ban-id-mapping"></a>
# Piga marufuku kutengeneza kitambulisho

> **Chanzo cha Kiingereza cha Canonical:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Tumia ukurasa huu unapobadilisha jina la mchezaji kuwa salama `Admin.ini` mstari wa kupiga marufuku.

<a id="core-rule"></a>
## Sheria kuu

Jina la kuonyesha si kitambulisho cha kupiga marufuku.

`Admin.ini` hutumia:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Daraja ya ushahidi

| Cheo | Chanzo | Tumia |
|---:|---|---|
| 1 | Kumbukumbu ya seva `Login request` | Muunganisho bora wa jina kwa kitambulisho |
| 2 | `Player_<ID>.sav` | Inathibitisha kwamba kitambulisho kipo |
| 3 | Iliyopo `Admin.ini` | Iliyopo bans/moderators |
| 4 | Arifa ya nje au shughuli ya paneli ya upangishaji | Time/name muktadha pekee; sio uthibitisho wa kitambulisho |
| 5 | UE4SS focus/player mistari | Presence/context pekee |
| 6 | Mzunguko wa maisha wa mfumo au kumbukumbu za kontena | muktadha wa mzunguko wa maisha mpangishi pekee; sio uthibitisho wa kitambulisho |

<a id="extract-the-clean-id"></a>
## Nyoa kitambulisho safi

Mfano ghafi:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Safi `Admin.ini`thamani:

```ini
BannedPlayer=2535422284688820
```

Usibandike `_+_|...`.

<a id="verify-with-playerdata"></a>
## Thibitisha kwa PlayerData

Angalia:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Maana:

```text
The ID exists in the world save.
```

Kizuizi:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Wakati haupaswi kupiga marufuku

Usikabidhi kitambulisho cha kupiga marufuku wakati:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Kiolezo cha jedwali la ushahidi

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
## Nyaraka zinazohusiana

* [`ADMIN_INI_ENFORCEMENT.md`](UTEKELEZAJI_WA_USIMAMIZI_WA_INI.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](MTIRIRIKO_WA_KAZI_WA_MAONI_YA_MCHEZAJI.md)
